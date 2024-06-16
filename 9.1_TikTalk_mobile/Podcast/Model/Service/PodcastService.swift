import Foundation


final class PodcastService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func getPodcastById(_ id: UUID, completion: @escaping (Result<PodcastModel, Error>) -> Void) {
        let request = podcastRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<PodcastModelWithoutLike, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                self.getIsLiked(id) { result in
                    switch result {
                    case .success(let liked):
                        let podcast = PodcastModel(
                            id: UUID(uuidString: profileResult.id)!,
                            name: profileResult.name,
                            authorId: UUID(uuidString: profileResult.authorId)!,
                            description: profileResult.description,
                            albumId: UUID(uuidString: profileResult.albumId)!,
                            logoUrl: profileResult.logoUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
                            audioUrl: profileResult.audioUrl ?? "https://drive.usercontent.google.com/u/0/uc?id=1H6WBaOQLgQsrYrWazeCAcypHBu6aFiVb&export=download",
                            countLike: profileResult.countLike,
                            isLiked: liked
                        )
                        completion(.success(podcast))
                    case .failure(let error):
                        print("error 5")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("error 6")
                completion(.failure(error))
            }
        })
        
        task.resume()
    }
    
    private func getIsLiked(_ id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = isLikedRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<Bool, Error>) in
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
    
    func changeLike(_ id: UUID, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        let request = changeLikeRequest(id: id, isLiked: isLiked)
        let task = urlSession.objectTask(for: request, completion: {(result: Result<EmptyResponse, Error>) in
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
    
    func getPodcastByIdWithoutLike(_ id: UUID, completion: @escaping (Result<PodcastModel, Error>) -> Void) {
        let request = podcastRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<PodcastModelWithoutLike, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
               
                let podcast = PodcastModel(
                    id: UUID(uuidString: profileResult.id)!,
                    name: profileResult.name,
                    authorId: UUID(uuidString: profileResult.authorId)!,
                    description: profileResult.description,
                    albumId: UUID(uuidString: profileResult.albumId)!,
                    logoUrl: profileResult.logoUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
                    audioUrl: profileResult.audioUrl ?? "https://drive.usercontent.google.com/u/0/uc?id=1H6WBaOQLgQsrYrWazeCAcypHBu6aFiVb&export=download",
                    countLike: profileResult.countLike,
                    isLiked: true
                )
                completion(.success(podcast))
            case .failure(let error):
                print("error 6")
                completion(.failure(error))
            }
        })
        
        task.resume()
    }
}

private extension PodcastService {
  
    func podcastRequest(id: UUID) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        return request
    }
    
    func isLikedRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/person/is-liked/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLikeRequest(id: UUID, isLiked: Bool) -> URLRequest {
        var request: URLRequest
        if isLiked {
            request = URLRequest.makeHTTPRequest(
                path: "tiktalk/api/person/unlike/\(id)",
                httpMethod: "DELETE",
                baseURL: DefaultBaseURL
            )
        } else {
            request = URLRequest.makeHTTPRequest(
                path: "tiktalk/api/person/like/\(id)",
                httpMethod: "POST",
                baseURL: DefaultBaseURL
            )
        }
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
