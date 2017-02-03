//
//  DoubleVideoViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Jason Gresh on 2/3/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var titleForCell: String = "Double Video"
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    var imagePickerController: UIImagePickerController!
    var playerTop: AVPlayer!
    var playerBottom: AVPlayer!
    var videoUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)

    }
    
    override func viewDidLayoutSubviews() {
        
        guard let sublayersTop = self.videoContainerTop.layer.sublayers, let sublayersBottom = self.videoContainerBottom.layer.sublayers
            
            else {
                return
        }
        
        for layer in sublayersTop {
            layer.frame = self.videoContainerTop.bounds
        }
        
        for layer in sublayersBottom {
            layer.frame = self.videoContainerBottom.bounds
        }
        
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        
        presentImagePicker()
        
    }
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        
        self.imagePickerController = imagePickerController
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.videoUrl = url
                
            }
            else {
                print("Error getting url from picked asset")
            }
        default:
            print("Unknown type")
        }
        
        self.finishAndUpdate()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func playVideo() {
        
        if let url = self.videoUrl {
            let playerItem = AVPlayerItem(url: url)
            if self.playerTop == nil || self.playerTop.rate == 0  {
                self.playerTop = AVPlayer(playerItem: playerItem)
                let playerLayer = AVPlayerLayer(player: self.playerTop)
                playerLayer.frame = videoContainerTop.bounds
                self.videoContainerTop.layer.addSublayer(playerLayer)
                playerTop.play()
            }
            else if self.playerBottom == nil || self.playerBottom.rate == 0  {
                self.playerBottom = AVPlayer(playerItem: playerItem)
                let playerLayer = AVPlayerLayer(player: self.playerBottom)
                playerLayer.frame = videoContainerBottom.bounds
                self.videoContainerBottom.layer.addSublayer(playerLayer)
                playerBottom.play()
            }
        }
    }
    
    private func finishAndUpdate() {
        self.dismiss(animated: true) {
            
        }
        playVideo()
    }
    
}
