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
    var movieSwitcher = MovieSwitcher.shared
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

class MovieSwitcher {
    var top: AVPlayerLayer?
    var bottom: AVPlayerLayer?
    
    static let shared: MovieSwitcher = MovieSwitcher(top: nil, bottom: nil)
    
    private init(top: AVPlayerLayer?, bottom: AVPlayerLayer?) {
        self.top = top
        self.bottom = bottom
    }
    
    func add(newMovie: AVPlayerLayer) {
        if top == nil {
            top = newMovie
        } else if bottom == nil {
            bottom = newMovie
        } else {
            replace(newMovie: newMovie)
        }
    }
    
    func replace(newMovie: AVPlayerLayer) {
        if top?.player?.rate == 0 {
            top?.removeFromSuperlayer()
            top = newMovie
        } else if bottom?.player?.rate == 0 {
            bottom?.removeFromSuperlayer()
            bottom = newMovie
        }
    }
}
