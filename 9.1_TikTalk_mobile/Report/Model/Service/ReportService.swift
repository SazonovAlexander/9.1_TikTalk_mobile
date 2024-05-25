import Foundation


final class ReportService {
    
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func report(_ report: ReportModel, completion: @escaping (Result<Void, Error>) -> Void) {
        lastTask?.cancel()
        let request = reportRequest()
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
}

private extension ReportService {
    
    func reportRequest() -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/report",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        
        return request
    }
}
