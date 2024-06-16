import Foundation


final class ReportService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func report(_ report: ReportModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            lastTask?.cancel()
            let request = try reportRequest(report: report)
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

private extension ReportService {
    
    func reportRequest(report: ReportModel) throws -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "tiktalk/api/podcast/report/",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("Bearer \(TokenStorage.shared.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(report)
        request.httpBody = jsonData
        
        return request
    }
}
