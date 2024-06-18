import Foundation

enum PodcastServiceError: Error {
    case errorParseUrl(message: String)
}

final class MyPodcastService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func deletePodcast(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        let request = deletePodcastRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<EmptyResponse, Error>) in
            guard let self = self else { return }
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
    
    func changePodcastWithoutLogo(podcast: PodcastModelWithoutLike, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try changePodcastRequestWithoutLogo(podcast: podcast)
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<EmptyResponse, Error>) in
                guard let self = self else { return }
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
    
    func changePodcastWithLogo(podcast: PodcastModelWithoutLike, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try changePodcastLogoAudioRequest(podcast: podcast)
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<EmptyResponse, Error>) in
                guard let self = self else { return }
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
    
    func createPodcast(podcast: PodcastModelWithoutLike, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try createPodcastRequest(podcast: podcast)
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<EmptyResponse, Error>) in
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

private extension MyPodcastService {
    
    func deletePodcastRequest(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/\(id)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changePodcastLogoAudioRequest(podcast: PodcastModelWithoutLike) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/upload/podcast/",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        let podcastRequest = PodcastRequest(name: podcast.name, description: podcast.description, albumId: UUID(uuidString: podcast.albumId)!)
        let jsonData = try JSONEncoder().encode(podcastRequest)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"json\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        body.append(jsonData)
        body.append("\r\n".data(using: .utf8)!)

        if let image = podcast.logoUrl, let imageUrl = URL(string: image) {
            let imageData = try Data(contentsOf: imageUrl)
            let filename = "\(podcast.name)\(Date().timeIntervalSince1970).\(imageUrl.pathExtension)"
            let mimeType = MimeTypeHelper.mimeType(for: imageUrl.pathExtension)
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        } else {
            throw PodcastServiceError.errorParseUrl(message: "Ошибка загрузки файла")
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        
        return request
    }
    
    func changePodcastRequestWithoutLogo(podcast: PodcastModelWithoutLike) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        let podcastRequest = PodcastRequest(name: podcast.name, description: podcast.description, albumId: UUID(uuidString: podcast.albumId)!)
        let jsonData = try JSONEncoder().encode(podcastRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        return request
    }
    
    func createPodcastRequest(podcast: PodcastModelWithoutLike) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        let podcastRequest = PodcastRequest(name: podcast.name, description: podcast.description, albumId: UUID(uuidString: podcast.albumId)!)
        let jsonData = try JSONEncoder().encode(podcastRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return request
    }
}

