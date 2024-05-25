import Foundation


final class PodcastService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func getPodcastById(_ id: UUID, completion: @escaping (Result<PodcastModel, Error>) -> Void) {
        lastTask?.cancel()
        let request = podcastRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<PodcastModelWithoutLike, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                self.getIsLiked(id) { result in
                    switch result {
                    case .success(let liked):
                        let podcast = PodcastModel(
                            id: profileResult.id,
                            name: profileResult.name,
                            authorId: profileResult.authorId,
                            description: profileResult.description,
                            albumId: profileResult.albumId,
                            logoUrl: profileResult.logoUrl,
                            audioUrl: profileResult.audioUrl,
                            countLike: profileResult.countLike,
                            isLiked: liked.isLiked
                        )
                        completion(.success(podcast))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    private func getIsLiked(_ id: UUID, completion: @escaping (Result<Liked, Error>) -> Void) {
        lastTask?.cancel()
        let request = isLikedRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<Liked, Error>) in
            switch result {
            case .success(let liked):
                completion(.success(liked))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func deletePodcast(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        let request = deletePodcastRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<EmptyResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func changeLike(_ id: UUID, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        let request = changeLikeRequest(id: id, isLiked: isLiked)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<EmptyResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
}

private extension PodcastService {
  
    func podcastRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/podcast/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        //request.setValue("token", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func isLikedRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/podcast/liked/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        //request.setValue("token", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func deletePodcastRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/podcast/\(id)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        //request.setValue("token", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLikeRequest(id: UUID, isLiked: Bool) -> URLRequest {
        var request: URLRequest
        if isLiked {
            request = URLRequest.makeHTTPRequest(
                path: "/api/person/unlike/\(id)",
                httpMethod: "DELETE",
                baseURL: DefaultBaseURL
            )
        } else {
            request = URLRequest.makeHTTPRequest(
                path: "/api/person/like/\(id)",
                httpMethod: "POST",
                baseURL: DefaultBaseURL
            )
        }
        //request.setValue("token", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
