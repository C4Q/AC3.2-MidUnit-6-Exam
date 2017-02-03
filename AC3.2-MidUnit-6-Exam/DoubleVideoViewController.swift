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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    override func viewDidLayoutSubviews() {
        
        // update your layers' frames here
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
            
            if self.topPlayer == nil || self.topPlayer?.rate == 0.0 {
                videoContainerTop.layer.sublayers = nil
                self.topPlayer = player
                playerLayer.frame = self.videoContainerTop.bounds
                videoContainerTop.layer.addSublayer(playerLayer)
                self.topPlayer?.play()
            }
            else if self.bottomPlayer == nil || self.bottomPlayer?.rate == 0.0 {
                videoContainerBottom.layer.sublayers = nil
                self.bottomPlayer = player
                playerLayer.frame = self.videoContainerBottom.bounds
                videoContainerBottom.layer.addSublayer(playerLayer)
                self.bottomPlayer?.play()                
            }
            else {
                let alert = UIAlertController(title: "No Free Video Slots Availible", message: "Please wait until one of the videos on screen has finished before selecting another.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okayAction)
                present(alert, animated: true, completion: nil)
            }
            self.videoURL = nil
        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [String(kUTTypeMovie), String(kUTTypeImage)]
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}
