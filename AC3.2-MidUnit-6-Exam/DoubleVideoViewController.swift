//
//  DoubleVideoViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Jason Gresh on 2/3/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVPlayerViewControllerDelegate {
    var titleForCell: String = "Double Video"

    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    var movieURL: URL?
    var playerTop = AVPlayer()
    var playerLayerTop: AVPlayerLayer!
    var playerBottom = AVPlayer()
    var playerLayerBottom: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // don't f with this 👇 comment
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    override func viewDidLayoutSubviews() {
        guard let sublayersTop = self.videoContainerTop.layer.sublayers else { return }
        
        for layer in sublayersTop {
            layer.frame = self.videoContainerTop.bounds
        }
        
        guard let sublayersBottom = self.videoContainerBottom.layer.sublayers else { return }
        
        for layer in sublayersBottom {
            layer.frame = self.videoContainerBottom.bounds
        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeImage):
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                print("BAKANAAAA!!!: \(image)")
            }
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerMediaURL] as? URL {
                self.movieURL = url
            }
        default:
            print("muzukashi na~")
        }
        
        // dismissing imagePickerController
        dismiss(animated: true) {
//            if let url = self.movieURL {
//                let player = AVPlayer(url: url)
//                let playerController = AVPlayerViewController()
//                playerController.player = player
//                self.present(playerController, animated: true, completion: {
//                    self.movieURL = nil
//                })
//            }
            if self.playerTop.rate == 0.0 {
                let playerItem = AVPlayerItem(url: self.movieURL!)
                self.movieURL = nil
                self.playerTop = AVPlayer(playerItem: playerItem)
                self.playerLayerTop = AVPlayerLayer(player: self.playerTop)
                
                self.videoContainerTop.layer.sublayers?.removeAll()
                self.videoContainerTop.layer.addSublayer(self.playerLayerTop)
                self.playerLayerTop.frame = self.videoContainerTop.bounds
                self.playerTop.play()
            }
            else if self.playerBottom.rate == 0.0 {
                let playerItem = AVPlayerItem(url: self.movieURL!)
                self.movieURL = nil
                self.playerBottom = AVPlayer(playerItem: playerItem)
                self.playerLayerBottom = AVPlayerLayer(player: self.playerBottom)
                
                self.videoContainerBottom.layer.sublayers?.removeAll()
                self.videoContainerBottom.layer.addSublayer(self.playerLayerBottom)
                self.playerLayerBottom.frame = self.videoContainerBottom.bounds
                self.playerBottom.play()
            }
            else { self.bothPlayersPlaying() }
        }
    }
    
    func bothPlayersPlaying() {
        let alertThis = UIAlertController(title: "IRASHAII", message: "Turn off all devices as videos are in progress. Recording is prohibited", preferredStyle: .alert)
        self.present(alertThis, animated: true, completion: nil)
    }
}
