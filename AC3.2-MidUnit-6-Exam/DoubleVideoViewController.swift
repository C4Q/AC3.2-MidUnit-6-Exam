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

class DoubleVideoViewController: UIViewController, CellTitled, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var titleForCell: String = "Double Video"
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var topPlayer: AVPlayer!
    var bottomPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.videoContainerBottom.backgroundColor = .red
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
    }

    override func viewDidLayoutSubviews() {
//        guard let sublayersTop = self.videoContainerTop.layer.sublayers
//            else {
//                return
//        }
//        for layer in sublayersTop {
//            layer.frame = self.videoContainerTop.bounds
//        }
// 
//        guard let sublayersbottom = self.videoContainerBottom.layer.sublayers
//            else {
//                return
//        }
//        for layer in sublayersbottom {
//            layer.frame = self.videoContainerBottom.bounds
//        }
        let topContainer = videoContainerTop.layer.sublayers
        let bottomContainer = videoContainerBottom.layer.sublayers
        
        if topContainer != nil && bottomContainer != nil {
            topContainer?[0].frame = self.videoContainerTop.bounds
        }
        
        if topContainer != nil && bottomContainer == nil {
            topContainer?[0].frame = self.videoContainerTop.bounds
        } else {
            bottomContainer?[0].frame = self.videoContainerBottom.bounds
        }
        
    }

    @IBAction func loadVideo(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerReferenceURL] as? URL {
            self.videoURL = url
        }
        self.dismiss(animated: true) {
//            if self.topPlayer.rate != 0.0 && self.bottomPlayer.rate != 0.0 {
//                let alert = UIAlertController(title: "Error", message: "Videos are playing on both", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
//
//            }
            switch self.videoContainerTop.layer.sublayers?.count {
            case nil:
            if let url = self.videoURL {
                let playerItem = AVPlayerItem(url: url)
                self.topPlayer = AVPlayer(playerItem: playerItem)
                let playerLayer = AVPlayerLayer(player: self.topPlayer)
                self.videoContainerTop.layer.sublayers = nil
                self.videoContainerTop.layer.addSublayer(playerLayer)
                self.viewDidLayoutSubviews()
                self.topPlayer?.play()
            }
                
            case 1?:
                if self.topPlayer.rate == 1.0 && self.bottomPlayer?.rate == 1.0 {
                    let alert = UIAlertController(title: "Error", message: "Both players have a video playing", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)

                }
                if let url = self.videoURL {
                    let playerItem = AVPlayerItem(url: url)
                    self.bottomPlayer = AVPlayer(playerItem: playerItem)
                    let playerLayer = AVPlayerLayer(player: self.bottomPlayer)
                    self.videoContainerBottom.layer.sublayers = nil
                    self.videoContainerBottom.layer.addSublayer(playerLayer)
                    self.viewDidLayoutSubviews()
                    self.bottomPlayer?.play()
                }
                default:
                break
        }

    }
}

}




