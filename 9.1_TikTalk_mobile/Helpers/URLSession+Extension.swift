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
                print("\(request) \(statusCode)")
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let object = try decoder.decode(T.self, from: data)
                        BlockingProgressHUD.dismiss()

                        fulfillCompletion(.success(object))
                    } catch {
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(error))
                        print("failure 1")
                    }
                } else {
                    if statusCode == 401 {
                        TokenStorage.shared.accessToken = ""
                        TokenStorage.shared.refreshToken = ""
                        TokenStorage.shared.id = ""
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(NetworkError.unauthorized("Неавторизован")))
                        print("failure 2")
                    } else {
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                        print("failure 3 \(statusCode)")
                    }
                }
            } else if let error = error {
                BlockingProgressHUD.dismiss()
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                print("failure 4")
            } else {
                BlockingProgressHUD.dismiss()
                fulfillCompletion(.failure(NetworkError.urlSessionError))
                print("failure 5")
            }
        })
        task.resume()
        return task
    }
    
    func uploadTask(for request: URLRequest, fromUrl: URL,
                            completion: @escaping (Result<EmptyResponse, Error>) -> Void
        ) -> URLSessionTask {
            let fulfillCompletion: (Result<EmptyResponse, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            BlockingProgressHUD.show()
        let task = uploadTask(with: request, fromFile: fromUrl, completionHandler: { data, response, error in
            if let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                print("\(request) \(statusCode)")
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let object = try decoder.decode(EmptyResponse.self, from: data)
                        BlockingProgressHUD.dismiss()

                        fulfillCompletion(.success(object))
                    } catch {
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(error))
                        print("failure 1")
                    }
                } else {
                    if statusCode == 401 {
                        TokenStorage.shared.accessToken = ""
                        TokenStorage.shared.refreshToken = ""
                        TokenStorage.shared.id = ""
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(NetworkError.unauthorized("Неавторизован")))
                        print("failure 2")
                    } else {
                        BlockingProgressHUD.dismiss()
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                        print("failure 3 \(statusCode)")
                    }
                }
            } else if let error = error {
                BlockingProgressHUD.dismiss()
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                print("failure 4")
            } else {
                BlockingProgressHUD.dismiss()
                fulfillCompletion(.failure(NetworkError.urlSessionError))
                print("failure 5")
            }
        })
        task.resume()
        return task
    }
}
