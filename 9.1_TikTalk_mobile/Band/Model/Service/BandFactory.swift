import Foundation


final class BandFactory {
    
    private let bandService: BandService
    
    var bandType: BandType {
        didSet {
            guard oldValue != bandType else { return }
            
            index = -1
            podcasts.removeAll()
            bandService.lastLoadedPage = nil
        }
    }
    private var index = -1
    private var podcasts: [PodcastModel] = []
    private var inProgress = false
    
    init(bandType: BandType, bandService: BandService = BandService()) {
        self.bandType = bandType
        self.bandService = bandService
    }
    
    func updateLike() {
        if index >= 0 {
            podcasts[index].isLiked.toggle()
        }
    }
    
    private func getPodcasts() {
        bandService.getPodcasts(band: bandType) { result in
            switch result {
            case .success(let podcast):
                self.podcasts += podcast
            case .failure(let error):
                print("Проверьте соединение")
            }
        }
    }
    
    func getNextPodcast(completion: @escaping (PodcastModel?) -> Void) {
        guard !inProgress else { return }
        
        index += 1
        let group = DispatchGroup()
        if index >= podcasts.count - 2 {
            group.enter()
            inProgress = true
            bandService.getPodcasts(band: bandType) { result in
                switch result {
                case .success(let podcast):
                    self.podcasts += podcast
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main, execute: {
            self.inProgress = false
            if self.index == self.podcasts.count {
                self.index -= 1
                completion(nil)
            } else {
                let podcastModel = self.podcasts[self.index]
                completion(podcastModel)
            }
        })
    }
    
    func getPrevPodcast() -> PodcastModel? {
        index -= 1
        
        if index < 0 {
            index = -1
            return nil
        }
        print(index)
        let podcastModel = podcasts[index]
        return podcastModel
    }
}
