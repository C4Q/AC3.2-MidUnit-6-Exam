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
    
    var myURL: URL?
    var avplayer: AVPlayer!
    var userPlayRate: Float = 1.0
    var userPlaying: Bool = true
    var titleForCell: String = "Double Video"
    
    @IBOutlet var doubleVideoOverLay: UIView!
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        guard let sublayers = self.videoContainerTop.layer.sublayers else { return }
        for layer in sublayers {
            layer.frame = self.videoContainerTop.bounds
        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - ImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenMovie = info[UIImagePickerControllerReferenceURL] as? URL {
            self.myURL = chosenMovie
            dump(chosenMovie)
        }
        dismiss(animated: true) {
            if let url = self.myURL {
                let playerItem = AVPlayerItem(url: url)
                self.avplayer = AVPlayer(playerItem: playerItem)
                let playerLayer = AVPlayerLayer(player: self.avplayer)
                
                if !self.videoContainerTop.bounds.isEmpty {
                playerLayer.frame = self.videoContainerTop.bounds
                self.videoContainerTop.layer.addSublayer(playerLayer)
                self.avplayer.play()
                }
                else {
                    playerLayer.frame = self.videoContainerBottom.bounds
                    self.videoContainerBottom.layer.addSublayer(playerLayer)
                    self.avplayer.play()
                }
                
                if self.userPlaying {
                    self.avplayer.rate = self.userPlayRate
                    dump(self.userPlayRate)
                }
            }
        }
    }
}
