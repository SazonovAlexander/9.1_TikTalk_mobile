import Foundation


struct AuthRequest: Encodable {
    let client_id: String
    let client_secret: String
    let grant_type: String
    let username: String
    let password: String
    
    init(client_id: String = AuthConstants.clientId,
         client_secret: String = AuthConstants.clientSecret,
         grant_type: String = AuthConstants.grantType,
         username: String,
         password: String
    ) {
        self.client_id = client_id
        self.client_secret = client_secret
        self.grant_type = grant_type
        self.username = username
        self.password = password
    }
}

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
