import Foundation


final class BandFactory {
    
    private let bandService: BandService
    
    var bandType: BandType {
        didSet {
            guard oldValue != bandType else { return }
            
            index = -1
            podcasts.removeAll()
        }
    }
    private var index = -1
    private var podcasts: [PodcastModel] = []
    
    init(bandType: BandType, bandService: BandService = BandService()) {
        self.bandType = bandType
        self.bandService = bandService
    }
    
    func getNextPodcast() -> PodcastModel? {
        index += 1
        
        if index == podcasts.count {
            let newPodcasts = bandService.getPodcasts()
            if newPodcasts.isEmpty {
                index -= 1
                return nil
            } else {
                podcasts += bandService.getPodcasts()
            }
        }
        
        let podcastModel = podcasts[index]
        return podcastModel
    }
    
    func getPrevPodcast() -> PodcastModel? {
        index -= 1
        
        if index == -1 {
            index += 1
            return nil
        }
        
        let podcastModel = podcasts[index]
        return podcastModel
    }
}
