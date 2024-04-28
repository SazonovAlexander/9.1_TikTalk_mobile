import AVFoundation


final class Player {
    
    weak var playerView: PlayerView?
    private var audioUrl: URL?
    private var avPlayer: AVPlayer?
    
    func setAudioFromUrl(_ url: URL) {
        guard audioUrl != url else { return }
        audioUrl = url
        reset()
    }
    
    func play() {
        avPlayer?.play()
    }
    
    func stop() {
        avPlayer?.pause()
    }
    
    func updateValue(_ value: Float) {
        avPlayer?.seek(to: CMTime(seconds: Double(value), preferredTimescale: 1000), toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    private func reset() {
        if let audioUrl {
            avPlayer = AVPlayer(url: audioUrl)
            avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1000), queue: .main) { time in
                self.updateTime(currentTime: time)
            }
        }
    }
    
    private func updateTime(currentTime: CMTime) {
        if let total = avPlayer?.currentItem?.duration.seconds {
            let current = "\(Int(currentTime.seconds) / 60):\(Int(currentTime.seconds) % 60)"
            let totalTime = "\(Int(total) / 60):\(Int(total) % 60)"
            playerView?.updateTime(currentTime: current, totalTime: totalTime, sliderValue: currentTime.seconds, maxValue: total)
        }
    }
}
