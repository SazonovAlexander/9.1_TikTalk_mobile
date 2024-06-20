import Foundation


final class AlbumService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func getAlbumById(_ id: UUID, completion: @escaping (Result<AlbumModel, Error>) -> Void) {
        let request = albumByIdRequest(id: id)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<AlbumModel, Error>) in
            switch result {
            case .success(let album):
                completion(.success(album))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
    func deleteAlbum(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        let request = deleteAlbum(id: id)
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
    
    func changeAlbum(album: AlbumModel, completion: @escaping (Result<AlbumModel, Error>) -> Void) {
        lastTask?.cancel()
        do {
            let request = try changeAlbum(id: album.id, album: album)
            lastTask?.cancel()
            let task = urlSession.objectTask(for: request, completion: { (result: Result<AlbumModel, Error>) in
                switch result {
                case .success(let album):
                    completion(.success(album))
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
    
    func addAlbum(album: AlbumRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        do {
            let request = try addAlbumRequest(albumRequest: album)
            lastTask?.cancel()
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
    
    func getAlbums(completion: @escaping (Result<[AlbumModel], Error>) -> Void) {
        lastTask?.cancel()
        let request = allAlbumsRequest()
        let task = urlSession.objectTask(for: request, completion: { (result: Result<[AlbumModel], Error>) in
            switch result {
            case .success(let albums):
                completion(.success(albums))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
}

private extension AlbumService {
    
    func albumByIdRequest(id: UUID) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/album/\(id)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )

        return request
    }
    
    func deleteAlbum(id: UUID) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/album/\(id)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeAlbum(id: UUID, album: AlbumModel) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/album/\(id)",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        let albumRequest = AlbumRequest(name: album.name, description: album.description)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(albumRequest)
        request.httpBody = jsonData
        return request
    }
    
    func addAlbumRequest(albumRequest: AlbumRequest) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/album/",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(albumRequest)
        request.httpBody = jsonData
        return request
    }
    
    func allAlbumsRequest() -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/album/my",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
