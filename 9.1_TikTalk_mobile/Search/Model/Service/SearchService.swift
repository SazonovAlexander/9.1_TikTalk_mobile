import Foundation


final class SearchService {
    
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    private var lastText: String?
    
    func search(_ text: String, completion: @escaping (Result<[PodcastModel], Error>) -> Void) {
        if lastTask == nil {
            if lastText != nil && lastText! == text {
                lastLoadedPage = nil
            }
            let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1
            let request = searchRequest(name: text, page: nextPage)
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<[PodcastModelWithoutLike], Error>) in
                guard let self else { return }
                switch result {
                case .success(let podcasts):
                    self.lastText = lastText
                    self.lastLoadedPage = nextPage
                    self.lastTask = nil
                    completion(.success(podcasts.map{ PodcastModel(
                        id: $0.id,
                        name: $0.name,
                        authorId: $0.authorId,
                        description: $0.description,
                        albumId: $0.albumId,
                        logoUrl: $0.logoUrl,
                        audioUrl: $0.audioUrl,
                        countLike: $0.countLike,
                        isLiked: false
                    ) }))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
            lastTask = task
            task.resume()
        }
    }
}


private extension SearchService {
    func searchRequest(name: String, page: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "podcast/search/\(name)?page=\(page)&size=10",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        //request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
