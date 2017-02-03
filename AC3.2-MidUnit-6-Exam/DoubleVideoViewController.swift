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


class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var titleForCell: String = "Double Video"
    var movieURL: URL?
    
   
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    var player: AVPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        guard let sublayerTop = self.videoContainerTop.layer.sublayers,
            let sublayerBottom = self.videoContainerBottom.layer.sublayers
            else {
                return
        }
        
        for layerTop in sublayerTop {
            layerTop.frame = self.videoContainerTop.bounds
        }
        
        for layerBottom in sublayerBottom {
            layerBottom.frame = self.videoContainerBottom.bounds
        }
    }

    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        let view = UIImagePickerController()
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        switch info[UIImagePickerControllerMediaType] as! String {
    
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.movieURL = url
                self.videoContainerTop.isHidden = false
                self.videoContainerBottom.isHidden = false
                
            }
            
        default:
            print("bad media")
        }
        
        
        
        dismiss(animated: true) {
            if let url = self.movieURL {
                self.player = AVPlayer(url: url)
                let playerItem = AVPlayerItem(url: url)
                
                
                self.player = AVPlayer(playerItem: playerItem)
                
                let playerLayer = AVPlayerLayer(player: self.player)
                playerLayer.frame = self.videoContainerTop.bounds
                self.videoContainerTop.layer.addSublayer(playerLayer)
                self.player?.play()
                
                
                
               // self.videoContainerBottom.layer.addSublayer(playerLayer)
                
            }
            
            
            
        }
    }
}


