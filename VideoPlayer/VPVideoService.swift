//
//  VPVideoService.swift
//  VideoPlayer
//
//  Created by michael on 29.10.2024.
//

import AVFoundation

protocol VPVideoServiceDelegate: AnyObject {

    func playbackFinished()
    
}

protocol VPVideoServiceProtocol {

    func findPlayerLayer() -> AVPlayerLayer
    func play(filePath: String)
    func stop()
    
}

class VPVideoService: VPVideoServiceProtocol {
    
    private weak var delegate: VPVideoServiceDelegate?
    private let player: AVPlayer
    private let playerLayer: AVPlayerLayer
    var imageGenerator: AVAssetImageGenerator?
    
    init(delegate: VPVideoServiceDelegate?) {
        self.delegate = delegate
        self.player = AVPlayer()
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30),
                                       queue: .main) { currentTime in
            debugPrint("observer")
            let times = [NSValue(time: self.player.currentTime())]
            self.imageGenerator?.generateCGImagesAsynchronously(forTimes: times) { [weak self] requestedTime, cgImage, actualTime, result, error in
                debugPrint("qwertt")
            }
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidPlayToEndTime(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemTimeJumped(_:)),
                                               name: .AVPlayerItemTimeJumped,
                                               object: player.currentItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemPlaybackStalled(_:)),
                                               name: .AVPlayerItemPlaybackStalled,
                                               object: player.currentItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemNewErrorLogEntry(_:)),
                                               name: .AVPlayerItemNewErrorLogEntry,
                                               object: player.currentItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemAccessLogEntry(_:)),
                                               name: .AVPlayerItemNewAccessLogEntry,
                                               object: player.currentItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemFailedToPlayToEndTime(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: player.currentItem)
    }
    
    //  MARK: - Notifications -
    
    @objc
    func playerItemFailedToPlayToEndTime(_ notification: Notification) {
        debugPrint("VPVideoService >> playerItemFailedToPlayToEndTime")
    }
    
    @objc
    func playerItemAccessLogEntry(_ notification: Notification) {
        debugPrint("VPVideoService >> playerItemAccessLogEntry")
    }
    
    @objc
    func playerItemNewErrorLogEntry(_ notification: Notification) {
        debugPrint("VPVideoService >> playerItemNewErrorLogEntry")
    }
    
    @objc
    func playerItemPlaybackStalled(_ notification: Notification) {
        debugPrint("VPVideoService >> playerItemPlaybackStalled")
    }
    
    @objc
    func playerItemTimeJumped(_ notification: Notification) {
        debugPrint("VPVideoService >> playerItemTimeJumped")
    }

    @objc
    func playerItemDidPlayToEndTime(_ notification: Notification) {
        debugPrint("VPVideoService >> playerItemDidPlayToEndTime")
    }

    //  MARK: - VPVideoServiceProtocol -

    func findPlayerLayer() -> AVPlayerLayer {
        return playerLayer
    }

    func play(filePath: String) {
        let filePathURL = URL(fileURLWithPath: filePath)
        
        player.pause()
        player.replaceCurrentItem(with: AVPlayerItem(url: filePathURL))
        player.play()

        let asset = AVAsset(url: filePathURL)
        imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator?.appliesPreferredTrackTransform = true
        imageGenerator?.requestedTimeToleranceBefore = .zero
        imageGenerator?.requestedTimeToleranceAfter = .zero
    }
    
    func stop() {
        player.pause()
    }
    
}
