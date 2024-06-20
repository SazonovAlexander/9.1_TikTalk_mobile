import Foundation


struct ReportModel: Encodable {
    let podcastId: UUID
    let theme: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case podcastId
        case theme
        case message = "description"
    }
}
