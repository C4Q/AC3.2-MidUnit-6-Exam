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
    
    var videoURL: URL?
    var playerOne: AVPlayer?
    var playerTwo: AVPlayer?
    var playerLayerOne: AVPlayerLayer!
    var playerLayerTwo: AVPlayerLayer!
    var videoIsPlaying = false
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    //MARK: - ImageProtocol Delegat Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerReferenceURL] as? URL {
            self.videoURL = url
        }
        else {
            print("Error getting url from picked asset")
        }
        dismiss(animated: true) {
            if let url = self.videoURL {
                if self.playerOne == nil {
                    let playerItem = AVPlayerItem(url: url)
                    self.playerOne = AVPlayer(playerItem: playerItem)
                    let playerLayer = AVPlayerLayer(player: self.playerOne)
                    playerLayer.frame = self.videoContainerTop.bounds
                    self.videoContainerTop.layer.addSublayer(playerLayer)
                    self.playerOne?.play()
                    //self.videoURL = nil
                }
                else {
                    let playerItem2 = AVPlayerItem(url: url)
                    self.playerTwo  = AVPlayer(playerItem: playerItem2)
                    let playerLayer2 = AVPlayerLayer(player: self.playerTwo)
                    playerLayer2.frame = self.videoContainerBottom.bounds
                    self.videoContainerBottom.layer.addSublayer(playerLayer2)
                    self.playerTwo?.play()
                    self.videoURL = nil
                }
            }
            else {
                self.videoContainerTop.layer.sublayers = nil
                self.videoContainerBottom.layer.sublayers = nil
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        guard let topSublayers = self.videoContainerTop.layer.sublayers,
            let bottomSublayers = self.videoContainerBottom.layer.sublayers
            else {
                return
        }
        for layer in topSublayers {
            layer.frame = self.videoContainerTop.bounds
        }
        
        for layer in bottomSublayers {
            layer.frame = self.videoContainerTop.bounds
        }
    }
    @IBAction func loadVideo(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeMovie), String(kUTTypeImage)]
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
}
