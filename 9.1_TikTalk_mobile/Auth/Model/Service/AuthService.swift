import Foundation

final class AuthService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func register(register: Register, completion: @escaping (Result<Void, Error>) -> Void) {
        auth(auth: AuthRequest(username: "superadmin", password: "superadmin")) { result in
            switch result {
            case .success(let auth):
                self.lastTask?.cancel()
                let request = self.registerRequest(register: register, token: auth.accessToken)
                let task = self.urlSession.objectTask(for: request, completion: { (result: Result<EmptyResponse, Error>) in
                    switch result {
                    case .success(_):
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
                self.lastTask = task
                task.resume()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func auth(auth: AuthRequest, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = authRequest(auth: auth)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<AuthResponse, Error>) in
            switch result {
            case .success(let authInfo):
                completion(.success(authInfo))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
}

private extension AuthService {
    
    func registerRequest(register: Register, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/keycloak/register/",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONEncoder().encode(register)
        request.httpBody = jsonData
        print(request)
        return request
    }
    
    func authRequest(auth: AuthRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/realms/tiktalk-realm/protocol/openid-connect/token",
            httpMethod: "POST",
            baseURL: URL(string: "http://localhost:8180")!
        )
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let parameters = [
            "client_id": auth.client_id,
            "client_secret": auth.client_secret,
            "grant_type": auth.grant_type,
            "username": auth.username,
            "password": auth.password
        ]
        
        var components = URLComponents()
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
    
        request.httpBody = components.query?.data(using: .utf8)

        return request
    }
}
