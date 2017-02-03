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
    
    private var topKvoContext = 0
    private var bottomKvoContext = 0
    var topTimeObserverToken: Any?
    var bottomTimeObserverToken: Any?
    
    var topURL: URL? = nil
    var bottomURL: URL? = nil
    var topPlayer: AVPlayer! {
        willSet {
            if topPlayer != nil {
                if let item = self.topPlayer.currentItem {
                    item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &topKvoContext)
                    item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), context: &topKvoContext)
                }
                
                if let token = self.topTimeObserverToken {
                    topPlayer.removeTimeObserver(token)
                }
            }
            
            if let item = newValue.currentItem {
                item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: &topKvoContext)
                item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: &topKvoContext)            }
            
            let timeInterval = CMTime(value: 1, timescale: 2)
            self.topTimeObserverToken = newValue.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { (time: CMTime) in
                print(time)
            })
        }
    }
    var bottomPlayer: AVPlayer! {
        willSet {
            if bottomPlayer != nil {
                if let item = self.bottomPlayer.currentItem {
                    item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &bottomKvoContext)
                    item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), context: &bottomKvoContext)
                }
                
                if let token = self.bottomTimeObserverToken {
                    bottomPlayer.removeTimeObserver(token)
                }
            }
            
            if let item = newValue.currentItem {
                item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: &bottomKvoContext)
                item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: &bottomKvoContext)            }
            
            let timeInterval = CMTime(value: 1, timescale: 2)
            self.bottomTimeObserverToken = newValue.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { (time: CMTime) in
                print(time)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        guard let topSublayers = self.videoContainerTop.layer.sublayers else {
            return
        }
        
        for layer in topSublayers {
            layer.frame = self.videoContainerTop.bounds
        }
        
        guard let bottomSublayers = self.videoContainerBottom.layer.sublayers else {
            return
        }
        
        for layer in bottomSublayers {
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
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard info[UIImagePickerControllerMediaType] as! String == String(kUTTypeMovie) else { return }
        
        guard let url = info[UIImagePickerControllerReferenceURL] as? URL else { return }

        dismiss(animated: true) {
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            self.topPlayer = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: self.topPlayer)
            self.videoContainerTop.layer.addSublayer(playerLayer)
            self.topPlayer.play()
        }
        
        
/* Choosing which container to play the video
        if let topPlayer = topPlayer {
            if topPlayer.currentItem?.currentTime() == topPlayer.currentItem?.duration {
                self.topURL = url
            } else if bottomPlayer.currentItem?.currentTime() == bottomPlayer.currentItem?.duration {
                self.bottomURL = url
            }
        }
 */
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            return
        }
        if context == &topKvoContext {
            if let item = object as? AVPlayerItem {
                switch keyPath {
                case #keyPath(AVPlayerItem.status):
                    if item.status == .readyToPlay {
                        //topPlayer.play()
                    }
                case #keyPath(AVPlayerItem.loadedTimeRanges):
                    for range in item.loadedTimeRanges {
                        print()
                        //print(range.timeRangeValue)
                    }
                default:
                    break
                }
            }
        } else if context == &bottomKvoContext {
            if let item = object as? AVPlayerItem {
                switch keyPath {
                case #keyPath(AVPlayerItem.status):
                    if item.status == .readyToPlay {
                        //bottomPlayer.play()
                    }
                case #keyPath(AVPlayerItem.loadedTimeRanges):
                    for range in item.loadedTimeRanges {
                        print()
                        //print(range.timeRangeValue)
                    }
                default:
                    break
                }
            }
        }
    }
}
