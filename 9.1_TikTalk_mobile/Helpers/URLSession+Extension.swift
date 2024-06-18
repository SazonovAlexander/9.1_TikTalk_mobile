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
            BlockingProgressHUD.show()
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let object = try decoder.decode(T.self, from: data)
                        BlockingProgressHUD.dismiss()

                        fulfillCompletion(.success(object))
                    } catch {
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(error))
                    }
                } else {
                    if statusCode == 401 {
                        TokenStorage.shared.accessToken = ""
                        TokenStorage.shared.refreshToken = ""
                        TokenStorage.shared.id = ""
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(NetworkError.unauthorized("Неавторизован")))
                    }
                    BlockingProgressHUD.dismiss()
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                BlockingProgressHUD.dismiss()
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                BlockingProgressHUD.dismiss()
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
