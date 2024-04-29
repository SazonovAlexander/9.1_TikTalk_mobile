import AVFoundation


final class Player {
    
    weak var playerView: PlayerView?
    private var audioUrl: URL?
    private var avPlayer: AVPlayer?
    
    func setAudioFromUrl(_ url: URL) {
        guard audioUrl != url else { return }
        audioUrl = url
        if let audioUrl {
            avPlayer = AVPlayer(url: audioUrl)
            avPlayer?.automaticallyWaitsToMinimizeStalling = false
            avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1000), queue: .main) { time in
                self.updateTime(currentTime: time)
            }
        }
    }
    
    func play() {
        avPlayer?.play()
        playerView?.isPlayed = true
    }
    
    func stop() {
        avPlayer?.pause()
        playerView?.isPlayed = false
    }
    
    func updateValue(_ value: Float) {
        avPlayer?.seek(to: CMTime(seconds: Double(value), preferredTimescale: 1000), toleranceBefore: .zero, toleranceAfter: .zero)
    }
  
    private func updateTime(currentTime: CMTime) {
        if let total = avPlayer?.currentItem?.duration.seconds,
           total.isNormal {
            let seconds = Int(currentTime.seconds) % 60
            let current: String
            if seconds < 10 {
                current = "\(Int(currentTime.seconds) / 60):0\(seconds)"
            } else {
                current = "\(Int(currentTime.seconds) / 60):\(seconds)"
            }
            let totalTime = "\(Int(total) / 60):\(Int(total) % 60)"
            playerView?.updateTime(currentTime: current, totalTime: totalTime, sliderValue: currentTime.seconds, maxValue: total)
        }
    }
}
