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
                if TokenStorage.shared.accessToken != "" {
                    isSubscribe(id) { result in
                        switch result {
                        case .success(let isSubscribe):
                            let author = AuthorModel(
                                id: UUID(uuidString: authorModel.id)!,
                                name: authorModel.name,
                                avatarUrl: authorModel.avatarUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
                                isSubscribe: isSubscribe,
                                albums: authorModel.albums.map({UUID(uuidString: $0)!})
                            )
                            completion(.success(author))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    let author = AuthorModel(
                        id: UUID(uuidString: authorModel.id)!,
                        name: authorModel.name,
                        avatarUrl: authorModel.avatarUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
                        isSubscribe: false,
                        albums: authorModel.albums.map({UUID(uuidString: $0)!})
                    )
                    completion(.success(author))
                }
            case .failure(let error):
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
