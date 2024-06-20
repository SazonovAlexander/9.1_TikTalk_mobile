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
    
    func changePodcast(podcast: PodcastModelWithoutLike, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let request = try changePodcastRequest(podcast: podcast)
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
    
    func createPodcast(podcast: PodcastModelWithoutLike, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try createPodcastRequest(podcast: podcast)
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<String, Error>) in
                switch result {
                case .success(let id):
                    completion(.success(id))
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
    
    func changeAvatar(podcast: PodcastModelWithoutLike, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let request = try changeAvatarRequest(podcast: podcast, id: podcast.id)
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
    
    func changeAudio(podcast: PodcastModelWithoutLike, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let request = try changeAudioRequest(podcast: podcast, id: podcast.id)
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
    
    func changeAvatarRequest(podcast: PodcastModelWithoutLike, id: String) throws -> URLRequest {
        var mulripartData = MultipartRequest()
        if let imageUrl = URL(string: podcast.logoUrl ?? "") {
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
            path: "tiktalk/api/podcast/upload-image/\(id)",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.addValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")

        request.addValue(mulripartData.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = mulripartData.httpBody

        return request
    }
    
    func changeAudioRequest(podcast: PodcastModelWithoutLike, id: String) throws -> URLRequest {
        var mulripartData = MultipartRequest()
        if let imageUrl = URL(string: podcast.audioUrl ?? "") {
            let imageData = try Data(contentsOf: imageUrl)
            mulripartData.add(
                key: "audio",
                fileName: "@image.\(imageUrl.pathExtension)",
                fileMimeType: MimeTypeHelper.mimeType(for: imageUrl.pathExtension),
                fileData: imageData
            )
        } else {
            throw ProfileServiceError.errorParseUrl(message: "Ошибка загрузки файла")
        }
        
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/upload-audio/\(id)",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.addValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")

        request.addValue(mulripartData.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = mulripartData.httpBody
        
        return request
    }
    
    func changePodcastRequest(podcast: PodcastModelWithoutLike) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/\(podcast.id)",
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
}

