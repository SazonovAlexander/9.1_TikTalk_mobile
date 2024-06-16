import Foundation


final class AuthorService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func getAuthorById(_ id: UUID, completion: @escaping (Result<AuthorModel, Error>) -> Void) {
        let request = authorRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<AuthorModelWithoutSubscribe, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let authorModel):
                isSubscribe(id) { result in
                    switch result {
                    case .success(let isSubscribe):
                        let author = AuthorModel(
                            id: UUID(uuidString: authorModel.id)!,
                            name: authorModel.name,
                            avatarUrl: authorModel.avatarUrl ?? "",
                            isSubscribe: isSubscribe,
                            albums: authorModel.albums.map({UUID(uuidString: $0)!})
                        )
                        completion(.success(author))
                    case .failure(let error):
                        print("failure is subscrive 1")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("failure is subscrive 2")
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
    private func isSubscribe(_ id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = isSubscribeRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<Bool, Error>) in
            switch result {
            case .success(let subscribe):
                completion(.success(subscribe))
            case .failure(let error):
                print("failure is subscrive")
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
        let request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/person/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        
        return request
    }
    
    func isSubscribeRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/person/is-followed/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeSubscribeRequest(id: UUID, isSubscribe: Bool) -> URLRequest {
        var request: URLRequest
        if !isSubscribe {
            request = URLRequest.makeHTTPRequest(
                path: "tiktalk/api/person/unfollow/\(id)",
                httpMethod: "DELETE",
                baseURL: DefaultBaseURL
            )
        } else {
            request = URLRequest.makeHTTPRequest(
                path: "tiktalk/api/person/follow/\(id)",
                httpMethod: "POST",
                baseURL: DefaultBaseURL
            )
        }
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
