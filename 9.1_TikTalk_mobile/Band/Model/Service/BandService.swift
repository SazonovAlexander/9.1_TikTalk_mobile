import Foundation


final class BandService {
    
    private var count = 0
    
    func getPodcasts() -> [PodcastModel] {
        count += 1;
        if count <= 10 {
            return [Mocks.podcast, Mocks.podcast1, Mocks.podcast, Mocks.podcast1, Mocks.podcast, Mocks.podcast1, Mocks.podcast]
        } else {
            return []
        }
    }
}
