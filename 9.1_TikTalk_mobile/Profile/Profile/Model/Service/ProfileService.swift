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
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func changeProfileName(profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let request = try changeProfileNameRequest(profile: profile)
            let task = urlSession.objectTask(for: request, completion: { (result: Result<EmptyResponse, Error>) in
                switch result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
            task.resume()
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func changeAvatar(profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let request = try changeAvatarRequest(profile: profile)
            let task = urlSession.objectTask(for: request, completion: { (result: Result<EmptyResponse, Error>) in
                switch result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
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
        var mulripartData = MultipartRequest()
        if let imageUrl = URL(string: profile.avatarUrl ?? "") {
            let imageData = try Data(contentsOf: imageUrl)
            mulripartData.add(
                key: "image",
                fileName: "@image.\(imageUrl.pathExtension)",
                fileMimeType: MimeTypeHelper.mimeType(for: imageUrl.pathExtension),
                fileData: imageData
            )
        } else {
            throw ProfileServiceError.errorParseUrl(message: "Ошибка загрузки файла")
        }
        
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/person/upload",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.addValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")

        request.addValue(mulripartData.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = mulripartData.httpBody
        
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
