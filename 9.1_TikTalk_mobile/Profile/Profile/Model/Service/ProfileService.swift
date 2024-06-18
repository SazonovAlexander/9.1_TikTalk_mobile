import Foundation
import Kingfisher

enum ProfileServiceError: Error {
    case errorParseUrl(message: String)
}

final class ProfileService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func getProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        lastTask?.cancel()
        let request = getProfile()
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ProfileModel, Error>) in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func changeProfileName(profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try changeProfileNameRequest(profile: profile)
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
    
    func changeAvatar(profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try changeAvatarRequest(profile: profile)
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
}

private extension ProfileService {
    
    func getProfile() -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/person/me",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeAvatarRequest(profile: ProfileModel) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/person/upload",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        let profileRequest = ProfileRequest(name: profile.name)
        let jsonData = try JSONEncoder().encode(profileRequest)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"json\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        body.append(jsonData)
        body.append("\r\n".data(using: .utf8)!)

        if let imageUrl = URL(string: profile.avatarUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060") {
            let imageData = try Data(contentsOf: imageUrl)
            let filename = "\(profile.name)\(Date().timeIntervalSince1970).\(imageUrl.pathExtension)"
            let mimeType = MimeTypeHelper.mimeType(for: imageUrl.pathExtension)
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        } else {
            throw ProfileServiceError.errorParseUrl(message: "Ошибка загрузки файла")
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        
        return request
    }
    
    func changeProfileNameRequest(profile: ProfileModel) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/person/update",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        let profileRequest = ProfileRequest(name: profile.name)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(profileRequest)
        request.httpBody = jsonData
        return request
    }
}
