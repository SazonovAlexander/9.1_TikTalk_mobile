import Foundation


final class AuthorService {
    
    func getAuthorById(_ id: UUID) -> AuthorModel {
        Mocks.author
    }
}
