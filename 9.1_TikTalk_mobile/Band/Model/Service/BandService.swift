import Foundation


final class BandService {
    
    var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    var podcastService: PodcastService = PodcastService()
    
    func getPodcasts(band: BandType, completion: @escaping (Result<[PodcastModel], Error>) -> Void) {
        lastTask?.cancel()
            let nextPage = lastLoadedPage == nil
            ? 0
            : lastLoadedPage! + 1
            let request = bandRequest(page: nextPage, band: band)
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<[PodcastModelWithoutLike], Error>) in
                guard let self else { return }
                switch result {
                case .success(let podcasts):
                    self.lastLoadedPage = nextPage
                    self.lastTask = nil
                    completion(.success(podcasts.map{ PodcastModel(
                        id: UUID(uuidString: $0.id)!,
                        name: $0.name,
                        authorId: UUID(uuidString: $0.authorId)!,
                        description: $0.description,
                        albumId: UUID(uuidString: $0.albumId)!,
                        logoUrl: $0.logoUrl ??  "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
                        audioUrl: $0.audioUrl ?? "https://www.mfiles.co.uk/mp3-downloads/frederic-chopin-piano-sonata-2-op35-3-funeral-march.mp3",
                        countLike: $0.countLike,
                        isLiked: false
                    ) }.filter { $0.authorId.uuidString.lowercased() != TokenStorage.shared.id.lowercased() }))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
            lastTask = task
            task.resume()
        }
    
}


private extension BandService {
    
    func bandRequest(page: Int, band: BandType) -> URLRequest {
        var url = "/tiktalk/api/podcast/"
        if band == .subscriptions {
            url += "subscribed/"
        }
        var request = URLRequest.makeHTTPRequest(
            path: url + "?page=\(page)&size=10&sortParam=LIKE_DESK",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        
        if band == .subscriptions && TokenStorage.shared.accessToken != "" {
            request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
