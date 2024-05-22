import Foundation


extension URLSession {
    
    func objectTask<T: Decodable>(
                            for request: URLRequest,
                            completion: @escaping (Result<T, Error>) -> Void
        ) -> URLSessionTask {
            let fulfillCompletion: (Result<T, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
    }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let object = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(object))
                    } catch {
                        fulfillCompletion(.failure(error))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
