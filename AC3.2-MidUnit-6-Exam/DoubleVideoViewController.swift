//
//  DoubleVideoViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Jason Gresh on 2/3/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices


class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var titleForCell: String = "Double Video"

    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    var videoURL: URL?
    
    var topPlayer: AVPlayer?
    var bottomPlayer: AVPlayer?
    
    var players: [AVPlayer?]!
    var containers: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        self.players = [topPlayer, bottomPlayer]
        self.containers = [videoContainerTop, videoContainerBottom]
    }

    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        // why?
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if info[UIImagePickerControllerMediaType] as! String == String(kUTTypeMovie) {
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.videoURL = url
            }
        }
        self.dismiss(animated: true, completion: nil)
        
        if let url = self.videoURL {
            let playerItem: AVPlayerItem = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: player)
            
            for i in 0..<self.players.count where (players[i] == nil || players[i]?.rate == 0.0) {
                containers[i].layer.sublayers = nil
                players[i] = player
                playerLayer.frame = containers[i].bounds
                containers[i].layer.addSublayer(playerLayer)
                players[i]?.play()
                self.videoURL = nil
                return
            }
            showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No Free Video Slots Availible", message: "Please wait until one of the videos on screen has finished before selecting another.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [String(kUTTypeMovie), String(kUTTypeImage)]
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
