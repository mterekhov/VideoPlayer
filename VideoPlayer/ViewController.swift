//
//  ViewController.swift
//  VideoPlayer
//
//  Created by michael on 29.10.2024.
//

import UIKit

class ViewController: UIViewController, VPVideoServiceDelegate {

    func playbackFinished() {

    }
    
    var videoService: VPVideoServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        let newVideoService = VPVideoService(delegate: self)
        let playerLayer = newVideoService.findPlayerLayer()
        playerLayer.frame = view.bounds
        playerLayer.backgroundColor = UIColor.red.cgColor
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        videoService = newVideoService

        let videoFilePath = Bundle.main.path(forResource: "video.mp4", ofType: nil) ?? ""
        videoService?.play(filePath: videoFilePath)
    }


}

