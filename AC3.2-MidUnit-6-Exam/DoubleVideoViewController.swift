//
//  DoubleVideoViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Jason Gresh on 2/3/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation

class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var titleForCell: String = "Double Video"
    var movieURL: URL?
    var movies: [AVPlayerLayer] = [AVPlayerLayer]()
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        
        /*
         Thi stuff is partially from https://github.com/martyav/AC3.2-AVPlayerKVO/blob/master/AVPlayerKVO/ViewController.swift but altered to fit the part
         */
        
        guard let topSubLayer = self.videoContainerTop.layer.sublayers,
            let bottomSubLayer = self.videoContainerBottom.layer.sublayers
            else {
                return
        }
        
        for layer in topSubLayer {
            layer.frame = self.videoContainerTop.bounds
        }
        
        for layer in bottomSubLayer {
            layer.frame = self.videoContainerBottom.bounds
        }
        
        view.layoutIfNeeded()
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        // recall that, by default, this array only contains static pix...
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerReferenceURL] as? URL {
            self.movieURL = url
            
            let playerItem = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: player)
            
            // looking at http://stackoverflow.com/questions/29000251/swift-resize-an-avplayerlayer-to-match-the-bounds-of-its-parent-container
            
            //            self.videoContainerTop.layer.addSublayer(playerLayer)
            //            playerLayer.frame = videoContainerTop.bounds
            //
            //            player.play()
            
            movies.append(playerLayer)
            
            if self.videoContainerTop.layer.sublayers == nil && self.videoContainerBottom.layer.sublayers == nil {
                self.videoContainerTop.layer.addSublayer(playerLayer)
                playerLayer.frame = videoContainerTop.bounds
                player.play()
            } else if videoContainerBottom.layer.sublayers == nil {
                self.videoContainerBottom.layer.addSublayer(playerLayer)
                playerLayer.frame = videoContainerBottom.bounds
                player.play()
            } else {
                let top = movies[0]
                let bottom = movies[1]
                if top.player?.rate != 0 && bottom.player?.rate == 0 {
                    bottom.removeFromSuperlayer()
                    movies[1] = playerLayer
                    self.videoContainerBottom.layer.addSublayer(playerLayer)
                    playerLayer.frame = videoContainerBottom.bounds
                    player.play()
                } else if top.player?.rate == 0 && bottom.player?.rate != 0 {
                    top.removeFromSuperlayer()
                    movies[0] = playerLayer
                    self.videoContainerTop.layer.addSublayer(playerLayer)
                    playerLayer.frame = videoContainerTop.bounds
                    player.play()
                } else {
                
                //                note: i know we can use the player's rate to check if something is playing, but how do we keep track of which player is playing in which container view?
                
                //                pseudo code nonsense -- if the player in the top is playing and the player in the bottom is not playing, do this {
                //
                //                } else if the player in the top is not playing, and the bottom player is playing, do that {
                //
                //                } else {
                
                dismiss(animated: true) {
                    if let url = self.movieURL {
                        let player = AVPlayer(url: url)
                        let playerController = AVPlayerViewController()
                        playerController.player = player
                    }
                }
                
                // taken from my emojiCard project: https://github.com/martyav/EmojiDeck/blob/master/EmojiDeck/EmojiCardViewController.swift
                
                let alertController = UIAlertController(title: "Hey there, pal!", message: "You can't watch a video right now. Wait until one ends first!", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                print("you can't watch more than two videos")
                return
            }
        }
            
            if player.rate == 0 {
                playerLayer.removeFromSuperlayer()
            }
        }
        
        // dismissing imagePickerController
        dismiss(animated: true) {
            if let url = self.movieURL {
                let player = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                playerController.player = player
                //self.present(playerController, animated: true, completion: {
                //    self.movieURL = nil
                //})
            }
        }
    }
    
    /* From my copy of yesterday's coding practice...
     @IBAction func pickImage(_ sender: UIButton) {
     let imagePickerController = UIImagePickerController()
     imagePickerController.sourceType = .photoLibrary
     imagePickerController.mediaTypes = [String(kUTTypeMovie), String(kUTTypeImage)]
     imagePickerController.delegate = self
     self.present(imagePickerController, animated: true, completion: nil)
     }
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
     switch info[UIImagePickerControllerMediaType] as! String {
     case String(kUTTypeImage):
     if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
     self.imageView.image = image
     }
     case String(kUTTypeMovie):
     if let url = info[UIImagePickerControllerReferenceURL] as? URL {
     self.movieURL = url
     }
     default:
     print("bad media")
     }
     
     // dismissing imagePickerController
     dismiss(animated: true) {
     if let url = self.movieURL {
     let player = AVPlayer(url: url)
     let playerController = AVPlayerViewController()
     playerController.player = player
     self.present(playerController, animated: true, completion: {
     self.movieURL = nil
     })
     }
     }
     }
     
     */
}
