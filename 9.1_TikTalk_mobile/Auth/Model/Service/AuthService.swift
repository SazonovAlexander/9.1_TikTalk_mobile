import Foundation

final class AuthService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func register(register: Register, completion: @escaping (Result<Void, Error>) -> Void) {
        auth(auth: AuthRequest(username: "superadmin", password: "fc9767b6-e62b-4583-97bd-cb17690ccd29")) { result in
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
                self.introspect(introspect: IntrospectRequest(token: authInfo.accessToken)) { result in
                    switch result {
                    case .success(let introspect):
                        TokenStorage.shared.id = introspect.sub
                        completion(.success(authInfo))
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
    
    private func introspect(introspect: IntrospectRequest, completion: @escaping (Result<IntrospectResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = introspectRequest(introspect)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<IntrospectResponse, Error>) in
            switch result {
            case .success(let introspectInfo):
                completion(.success(introspectInfo))
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
        return request
    }
    
    func authRequest(auth: AuthRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/realms/tiktalk-realm/protocol/openid-connect/token",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
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
    
    func introspectRequest(_ introscpectRequest: IntrospectRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "realms/tiktalk-realm/protocol/openid-connect/token/introspect",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let parameters = [
            "client_id": introscpectRequest.client_id,
            "client_secret": introscpectRequest.client_secret,
            "token": introscpectRequest.token
        ]
        
        var components = URLComponents()
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
    
        request.httpBody = components.query?.data(using: .utf8)

        return request
    }
}
