import Foundation

final class AuthService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func register(register: Register, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            var token: String = ""
            auth(auth: AuthRequest(username: "superadmin", password: "superadmin")) { result in
                switch result {
                case .success(let auth):
                    token = auth.accessToken
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            let request = try registerRequest(register: register, token: token)
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
            
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func auth(auth: AuthRequest, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try authRequest(auth: auth)
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
        } catch (let error) {
            completion(.failure(error))
        }
    }
}

private extension AuthService {
    
    func registerRequest(register: Register, token: String) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/keycloak/register/",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(register)
        request.httpBody = jsonData
        return request
    }
    
    func authRequest(auth: AuthRequest) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/realms/tiktalk-realm/protocol/openid-connect/token",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(auth)
        request.httpBody = jsonData
        return request
    }
}
