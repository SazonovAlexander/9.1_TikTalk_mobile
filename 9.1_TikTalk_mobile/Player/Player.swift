import AVFoundation


final class Player {
    
    weak var playerView: PlayerView?
    var endHandler: (() -> Void)?
    private var audioUrl: URL?
    private lazy var avPlayer: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1000), queue: .main) {time in
            self.updateTime(currentTime: time)
        }
        return player
    }()
    
    func setAudioFromUrl(_ url: URL) {
        playerView?.updateTime(currentTime: "0:0", totalTime: "0:0", sliderValue: 0, maxValue: 1)
        audioUrl = url
        if let audioUrl {
            avPlayer.replaceCurrentItem(with: AVPlayerItem(url: audioUrl))
        }
    }
    
    func play(changeIcon: Bool = false) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Ошибка настройки аудиосессии: \(error.localizedDescription)")
        }
        avPlayer.play()
        if changeIcon {
            playerView?.isPlayed = true
        }
    }
    
    func stop(changeIcon: Bool = false) {
        avPlayer.pause()
        if changeIcon {
            playerView?.isPlayed = false
        }
    }
    
    func updateValue(_ value: Float) {
        avPlayer.seek(to: CMTime(seconds: Double(value), preferredTimescale: 1000), toleranceBefore: .zero, toleranceAfter: .zero)
    }
  
    private func updateTime(currentTime: CMTime) {
        if let total = avPlayer.currentItem?.duration.seconds,
           total.isNormal {
            if (total - currentTime.seconds < 0.1) {
                    endHandler?()
                    stop(changeIcon: true)
                    updateValue(0)
                }
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
