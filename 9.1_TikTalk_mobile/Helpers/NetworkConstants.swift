import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case unauthorized(String)
}

let DefaultBaseURL = URL(string: "http://localhost:8089/")!
