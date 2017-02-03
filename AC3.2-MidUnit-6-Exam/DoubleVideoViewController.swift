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

//struct Players {
//    var player: AVPlayer?
//    var secondPLayer: AVPlayer?
//    
//    init(player: AVPlayer) {
//        self.player = player
//    }
//    
//    init(secondPlayer: AVPlayer) {
//        self.secondPLayer = secondPlayer
//    }
//}

class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var titleForCell: String = "Double Video"

    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    var player: AVPlayer?
    var secondPlayer: AVPlayer?
    var movieUrl: URL?
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    override func viewDidLayoutSubviews() {
//        guard let sublayers = self.videoContainerTop.layer.sublayers
//            else { return }
//        
//        for layer in sublayers {
//            layer.frame = self.videoContainerTop.bounds
//        }

        // update your layers' frames here
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.movieUrl = url
                
            }
        case String(kUTTypeImage):
            
            if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
                dismiss(animated: true, completion: nil)
                
                let alertController = UIAlertController(title: "No Images", message: "Select a Video", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                present(alertController, animated: true)
                
            }
        default:
            print("Not Complatable Media")
        }
        
        dismiss(animated: true, completion: nil)
        
        if let url = self.movieUrl {
            if player?.rate == nil || player?.rate == 0.0 {
            
            let item = AVPlayerItem(url: url)
             player = AVPlayer(playerItem: item)
            
            let playerLayer = AVPlayerLayer(player: player)
        
                self.videoContainerTop.layer.addSublayer(playerLayer)
                player?.playImmediately(atRate: 1.0)
                playerLayer.frame = self.videoContainerTop.bounds
               
            } else if secondPlayer?.rate == nil || secondPlayer?.rate == 0.0 {
                
                let item = AVPlayerItem(url: url)
                secondPlayer = AVPlayer(playerItem: item)
                
                let playerLayer = AVPlayerLayer(player: secondPlayer)
                
                self.videoContainerBottom.layer.addSublayer(playerLayer)
                secondPlayer?.playImmediately(atRate: 1.0)
                playerLayer.frame = self.videoContainerBottom.bounds
                
            } else {
             
                let alertController = UIAlertController(title: "Both Positions are playing Videos", message: "Cant play another video at this moment", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                present(alertController, animated: true)
            }
            
            
        }
        
    }

    
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [ String(kUTTypeMovie), String(kUTTypeImage) ]
        imagePickerController.delegate = self
        
        
        self.present(imagePickerController, animated: true, completion:  nil)

    }
    
    
    
}
