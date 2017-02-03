//
//  DoubleVideoViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Jason Gresh on 2/3/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import AVFoundation

var kvoContext = 0

class DoubleVideoViewController: UIViewController, CellTitled, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var titleForCell: String = "Double Video"
    
    
    //MARK: - Declarations
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    var playerOne: AVPlayer? {
        willSet {
            if let oldValue = playerOne {
                self.removeObservers(in: oldValue)
            }
            self.addobservers(to: newValue)
        }
    }
    
    var playerTwo: AVPlayer? {
        willSet {
            if let oldValue = playerTwo {
                self.removeObservers(in: oldValue)
            }
            self.addobservers(to: newValue)
        }
    }
    
    var videoURLOne: URL? = nil
    var videoURLTwo: URL? = nil
    var queueURL: URL? = nil
    let videoQueue = PlayerQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        if let sublayersTop = self.videoContainerTop.layer.sublayers {
            for layer in sublayersTop {
                layer.frame = self.videoContainerTop.bounds
            }
            
        }
        if let sublayersBottom = self.videoContainerBottom.layer.sublayers {
            for layer in sublayersBottom {
                layer.frame = self.videoContainerBottom.bounds
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func loadVideo(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - ImagePickerController Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if info[UIImagePickerControllerMediaType] as! String == kUTTypeMovie as String {
            guard let url = info[UIImagePickerControllerMediaURL] as? URL else { return }
            if playerOne?.rate == 0.0 || self.playerOne == nil {
                self.videoURLOne = url
            } else if playerTwo?.rate == 0 || self.playerTwo == nil {
                self.videoURLTwo = url
            } else {
                self.queueURL = url
            }
            
        }
        self.dismiss(animated: true) {
            
            if let p1 = self.playerOne, let p2 = self.playerTwo, p1.rate != 0, p2.rate != 0, let url = self.queueURL {
                let alert = UIAlertController(title: "FULL", message: "The video players are currently in use, added to queue", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                self.queueURL = nil
                
                self.videoQueue.enQueue(url)
            }
            
            if let urlOne = self.videoURLOne {
                self.videoURLOne = nil
                self.playerOne = self.addPlayerAndLayers(for: urlOne, in: self.videoContainerTop)
            }
            if let urlTwo = self.videoURLTwo {
                self.videoURLTwo = nil
                self.playerTwo = self.addPlayerAndLayers(for: urlTwo, in: self.videoContainerBottom)
            }
        }
    }
    
    //MARK: - Observer Method
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kvoContext, keyPath == #keyPath(AVPlayerItem.status), let item = object as? AVPlayerItem {
            if item.status == .readyToPlay {
                if let p1 = self.playerOne {
                    p1.play()
                }
                if let p2 = self.playerTwo {
                    p2.play()
                }
            }
        }
        if context == &kvoContext, keyPath == #keyPath(AVPlayer.rate), let item = object as? AVPlayer {
            if item.rate == 0, let url = videoQueue.deQueue() {
                if playerOne?.rate == 0 {
                    playerOne = self.addPlayerAndLayers(for: url, in: self.videoContainerTop)
                } else if playerTwo?.rate == 0{
                    playerTwo = self.addPlayerAndLayers(for: url, in: self.videoContainerBottom)
                }
            }
        }
    }
    
    //MARK: - Helper Functions
    
    func addPlayerAndLayers(for url: URL, in view: UIView) -> AVPlayer {
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        view.layer.sublayers?.removeAll()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoContainerBottom.bounds
        view.layer.addSublayer(playerLayer)
        return player
    }
    
    func addobservers(to player: AVPlayer?) {
        guard let player = player else { return }
        if let item = player.currentItem {
            item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: &kvoContext)
            player.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: &kvoContext)
        }
    }

    
    func removeObservers(in player: AVPlayer) {
        if let item = player.currentItem {
            item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &kvoContext)
        }
        player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate), context: &kvoContext)
    }
}


class PlayerQueue {
    private var queue = [URL]()
    init() {
        queue = []
    }
    
    func enQueue(_ url: URL) {
        queue.append(url)
    }
    
    func deQueue() -> URL? {
        guard queue.count > 0 else { return nil }
        return queue.removeFirst()
    }
}
