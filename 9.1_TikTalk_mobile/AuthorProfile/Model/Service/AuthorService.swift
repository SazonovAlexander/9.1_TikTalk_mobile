import Foundation


final class AuthorService {
    
    func getAuthorById(_ id: UUID) -> AuthorModel {
        AuthorModel(id: UUID(), name: "Алексей Петрович")
    }
}
