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
    var movieSwitcher = MovieSwitcher.mananger
    var container: UIView?
    
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
            
            movieSwitcher.add(newMovie: playerLayer)
            
            if movieSwitcher.top == playerLayer {
                container = videoContainerTop
            } else if movieSwitcher.bottom == playerLayer {
                container = videoContainerBottom
            } else {
                dismiss(animated: true) {
                    if let url = self.movieURL {
                        let player = AVPlayer(url: url)
                        let playerController = AVPlayerViewController()
                        playerController.player = player
                    }
                }
                
                let alertController = UIAlertController(title: "You can't watch a video right now.", message: "Wait until one ends first!", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                print("you can't watch more than two videos")
                return
                // alert
            }
            
            if let currentContainer = self.container {
                currentContainer.layer.addSublayer(playerLayer)
                playerLayer.frame = currentContainer.bounds
                player.play()
            }
        }
        
        // dismissing imagePickerController
        dismiss(animated: true) {
            if let url = self.movieURL {
                let player = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                playerController.player = player
            }
        }
    }
}

/*
 The singleton below is functionally identical to the array I was using on the
 version I submitted on exam day. So why bother?
 
 1. It reduces duplication in my code
 2. Better naming -- don't have to memorize that index 0 is for the top 
 container and index 1 is for the bottom container
 3. Logic for switching is streamlined and is easier to read
 4. With a singleton, we have one place in both our code and in the actively 
 running app handling which movie goes where.
 5. Fool-proofing -- can't accidently code our way into more instances even if 
 we wanted to (having multiple instances of our tracker would be at 
 cross-purposes to knowing which movie is in which container, which movie is 
 currently playing, and which container has a movie currently inside it).
 */
class MovieSwitcher {
    var top: AVPlayerLayer?
    var bottom: AVPlayerLayer?
    
    static let mananger: MovieSwitcher = MovieSwitcher(top: nil, bottom: nil)
    
    private init(top: AVPlayerLayer?, bottom: AVPlayerLayer?) {
        self.top = top
        self.bottom = bottom
    }
    
    func add(newMovie: AVPlayerLayer) {
        if top == nil {
            top = newMovie
        } else {
            replace(newMovie: newMovie)
        }
    }
    
    func replace(newMovie: AVPlayerLayer) {
        if top?.player?.rate == 0 {
            top?.removeFromSuperlayer()
            top = newMovie
        } else {
            if bottom == nil {
                bottom = newMovie
            } else if bottom?.player?.rate == 0 {
                bottom?.removeFromSuperlayer()
                bottom = newMovie
            }
        }
    }
}
