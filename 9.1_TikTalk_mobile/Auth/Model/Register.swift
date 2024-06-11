import Foundation


struct Register {
    let client_id: String
    let client_secret: String
    let grant_type: String
    let username: String
    let password: String
    let email: String
    
    init(client_id: String = AuthConstants.clientId,
         client_secret: String = AuthConstants.clientSecret,
         grant_type: String = AuthConstants.grantType,
         username: String,
         password: String,
         email: String
    ) {
        self.client_id = client_id
        self.client_secret = client_secret
        self.grant_type = grant_type
        self.username = username
        self.password = password
        self.email = email
    }
}
