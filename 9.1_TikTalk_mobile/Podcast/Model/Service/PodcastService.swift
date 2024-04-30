import Foundation


final class PodcastService {
    
    func getPodcastById(_ id: UUID) -> PodcastModel {
        Mocks.podcast
    }
    
    func search(_ text: String) -> [PodcastModel] {
        [Mocks.podcast, Mocks.podcast1]
    }
    
    func delete(_ podcast: PodcastModel) {
        
    }
}
