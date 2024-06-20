import Foundation


struct Register: Encodable {
    let username: String
    let password: String
    let firstName: String
    let email: String
    let role = "USER"
}
