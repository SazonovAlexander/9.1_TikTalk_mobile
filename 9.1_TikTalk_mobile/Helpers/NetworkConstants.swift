import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

let DefaultBaseURL = URL(string: "https://vk.com")!
