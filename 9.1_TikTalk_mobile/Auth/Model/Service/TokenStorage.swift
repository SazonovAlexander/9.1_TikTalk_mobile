import Foundation
import SwiftKeychainWrapper

final class TokenStorage {
    
    static let shared = TokenStorage()
    
    private static let accessTokenKey = "access_token"
    private static let refreshTokenKey = "refresh_token"
    private static let idKey = "person_id"
    
    private init() {}
     
    var accessToken: String {
        get {
            return KeychainWrapper.standard.string(forKey: TokenStorage.accessTokenKey) ?? ""
        }
        set (newToken) {
            let isSuccess = KeychainWrapper.standard.set(newToken, forKey: TokenStorage.accessTokenKey)
            guard isSuccess else {
                return
            }
        }
    }
    
    var refreshToken: String {
        get {
            return KeychainWrapper.standard.string(forKey: TokenStorage.refreshTokenKey) ?? ""
        }
        set (newToken) {
            let isSuccess = KeychainWrapper.standard.set(newToken, forKey: TokenStorage.refreshTokenKey)
            guard isSuccess else {
                return
            }
        }
    }
    
    var id: String {
        get {
            return KeychainWrapper.standard.string(forKey: TokenStorage.idKey) ?? ""
        }
        set (newId) {
            let isSuccess = KeychainWrapper.standard.set(newId, forKey: TokenStorage.idKey)
            guard isSuccess else {
                return
            }
        }
    }
}
