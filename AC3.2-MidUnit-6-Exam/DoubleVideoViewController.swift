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

class DoubleVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CellTitled {
    
    var titleForCell: String = "Double Video"

    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    var movieURLOne: URL?
    var movieURLTwo: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
 
    /*
    override func viewWillLayoutSubviews() {
        if let url = movieURLOne{
        
            
            let playerItem = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: player)
            player.play()
            self.videoContainerTop.layer.addSublayer(playerLayer)
            
            
        }
    }*/

    override func viewDidLayoutSubviews() {
         //update your layers' frames here
        
        if let url = movieURLOne{
            
            
            let playerItem = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem: playerItem)
            player.play()
            let playerLayer = AVPlayerLayer(player: player)
            if player.rate > 0{
            self.videoContainerBottom.layer.addSublayer(playerLayer)
            }else{
                self.videoContainerTop.layer.addSublayer(playerLayer)
            }
            
            
        }
        
      

    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = false
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.mediaTypes = [String(kUTTypeMovie)]
                imagePickerController.delegate  = self
                self.present(imagePickerController, animated: true, completion: nil)
   
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //if (info[UIImagePickerControllerReferenceURL] as? URL) != nil{
       
            if let url = info[UIImagePickerControllerReferenceURL] as? URL{
            self.movieURLOne = url
            dismiss(animated: true) {
                if let url = self.movieURLOne{
                    
                    let playerItem = AVPlayerItem(url: url)
                    let player = AVPlayer(playerItem: playerItem)
                    let playerLayer = AVPlayerLayer(player: player)
                    self.videoContainerTop.layer.addSublayer(playerLayer)
                    player.play()

                }
            }

            }
            
        
        }


    
}
