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
    var movieURL: URL?
    var player: AVPlayer?
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //guard let type = info[UIImagePickerControllerMediaType] as? String else { return }
        //dump("TYPE>> \(type)")
        
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeImage):
            print("Image!")
        case String(kUTTypeMovie):
            print("Movie!")
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.movieURL = url
            }
        default:
            print("bad media")
        }
        
        // dismissing imagePickerController
        dismiss(animated: true ) {
            if let url = self.movieURL {
                let playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
                let playerLayer = AVPlayerLayer(player: self.player)
                if self.videoContainerTop != nil {
                    playerLayer.frame = self.videoContainerTop.bounds
                    self.videoContainerTop.layer.addSublayer(playerLayer)
                } else {
                    playerLayer.frame = self.videoContainerBottom.bounds
                    self.videoContainerBottom.layer.addSublayer(playerLayer)
                }
                self.movieURL = nil
                
            } else {
                self.videoContainerTop.layer.sublayers = nil
            }
        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie), String(kUTTypeImage)]
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
