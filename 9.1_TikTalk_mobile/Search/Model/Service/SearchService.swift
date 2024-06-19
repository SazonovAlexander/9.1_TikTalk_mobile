import Foundation


final class SearchService {
    
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    private var lastText: String?
    
    func search(_ text: String, completion: @escaping (Result<[PodcastModel], Error>) -> Void) {
        lastTask?.cancel()
            if lastText != nil && lastText! != text {
                lastLoadedPage = nil
            }
            var nextPage = lastLoadedPage == nil
            ? 0
            : lastLoadedPage! + 1
            let request = searchRequest(name: text, page: nextPage)
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<[PodcastModelWithoutLike], Error>) in
                guard let self else { return }
                switch result {
                case .success(let podcasts):
                    self.lastText = text
                    self.lastLoadedPage = nextPage
                    self.lastTask = nil
                    completion(.success(podcasts.map{ PodcastModel(
                        id: UUID(uuidString: $0.id)!,
                        name: $0.name,
                        authorId: UUID(uuidString: $0.authorId)!,
                        description: $0.description,
                        albumId: UUID(uuidString: $0.albumId)!,
                        logoUrl: $0.logoUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
                        audioUrl: $0.audioUrl ?? "https://drive.usercontent.google.com/u/0/uc?id=1H6WBaOQLgQsrYrWazeCAcypHBu6aFiVb&export=download",
                        countLike: $0.countLike,
                        isLiked: false
                    ) }.filter{ $0.authorId.uuidString.lowercased() != TokenStorage.shared.id.lowercased() }))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
            lastTask = task
            task.resume()
        }
    }



private extension SearchService {
    func searchRequest(name: String, page: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/search/\(name.isEmpty ? "123`" : name)?page=\(page)&size=10&sortParam=ID_ASC",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        print(name)
        return request
    }
}
