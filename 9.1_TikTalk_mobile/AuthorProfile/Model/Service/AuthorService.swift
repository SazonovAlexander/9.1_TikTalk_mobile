import Foundation


final class AuthorService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func getAuthorById(_ id: UUID, completion: @escaping (Result<AuthorModel, Error>) -> Void) {
        lastTask?.cancel()
        let request = authorRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<AuthorModelWithoutSubscribe, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let authorModel):
                isSubscribe(id) { result in
                    switch result {
                    case .success(let isSubscribe):
                        let author = AuthorModel(
                            id: authorModel.id,
                            name: authorModel.name,
                            avatarUrl: authorModel.avatarUrl,
                            isSubscribe: isSubscribe.isSubscribe,
                            albums: authorModel.albums
                        )
                        completion(.success(author))
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
    
    private func isSubscribe(_ id: UUID, completion: @escaping (Result<IsSubscribe, Error>) -> Void) {
        lastTask?.cancel()
        let request = isSubscribeRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<IsSubscribe, Error>) in
            switch result {
            case .success(let subscribe):
                completion(.success(subscribe))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func changeSubscribe(_ id: UUID, isSubscribe: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        let request = changeSubscribeRequest(id: id, isSubscribe: isSubscribe)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<EmptyResponse, Error>) in
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

private extension AuthorService {
    
    func authorRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/person/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        
        return request
    }
    
    func isSubscribeRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/person/subscribe/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        //request.setValue("token", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeSubscribeRequest(id: UUID, isSubscribe: Bool) -> URLRequest {
        var request: URLRequest
        if isSubscribe {
            request = URLRequest.makeHTTPRequest(
                path: "/api/person/unfollow/\(id)",
                httpMethod: "DELETE",
                baseURL: DefaultBaseURL
            )
        } else {
            request = URLRequest.makeHTTPRequest(
                path: "/api/person/follow/\(id)",
                httpMethod: "POST",
                baseURL: DefaultBaseURL
            )
        }
        //request.setValue("token", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
