import AVFoundation


final class Player {
    
    var playerView: PlayerView
    private var audioUrl: URL?
    
    init(playerView: PlayerView) {
        self.playerView = playerView
    }
    
    func setAudioFromUrl(_ url: URL) {
        guard audioUrl != url else { return }
        audioUrl = url
    }
}
