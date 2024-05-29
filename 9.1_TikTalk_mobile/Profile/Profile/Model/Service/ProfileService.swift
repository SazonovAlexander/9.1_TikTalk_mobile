import Foundation
import Kingfisher

enum ProfileServiceError: Error {
    case errorParseUrl(message: String)
}

final class ProfileService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func changeProfileWithAvatar(profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try changeProfileRequestWithAvatar(profile: profile)
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
    
    func changeProfileWithoutAvatar(profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try changeProfileRequestWithoutAvatar(profile: profile)
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
    
    func changeProfileRequestWithAvatar(profile: ProfileModel) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/person/",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        //request.setValue("token", forHTTPHeaderField: "Authorization")
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

        if let imageUrl = URL(string: profile.avatarUrl) {
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
    
    func changeProfileRequestWithoutAvatar(profile: ProfileModel) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/person/",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        let profileRequest = ProfileRequest(name: profile.name)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(profileRequest)
        request.httpBody = jsonData
        return request
    }
}
