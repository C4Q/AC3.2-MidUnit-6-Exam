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
    var videoUrl: URL?
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagepickerController = UIImagePickerController()
        imagepickerController.sourceType = .photoLibrary
        imagepickerController.delegate = self
        imagepickerController.mediaTypes = [String(kUTTypeMovie)]
        self.present(imagepickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerMediaURL] as? URL {
                self.videoUrl = url
            }
        default:
            print("INVALID MEDIA TYPE")
        }
        
        dismiss(animated: true) {
            if let url = self.videoUrl {
                let playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
                let playerLayer =  AVPlayerLayer(player: self.player)
                if self.videoContainerTop.layer.sublayers != nil {
                    
                    if playerLayer.player?.rate != 0 {
                        self.videoContainerTop.layer.addSublayer(playerLayer)
                        self.player.playImmediately(atRate: 1.0)
                        
                        guard let sublayers = self.videoContainerTop.layer.sublayers else { return }
                        
                        for layer in sublayers {
                            
                            layer.frame = self.videoContainerTop.bounds
                        }
                    } else {
                        
                        self.videoContainerBottom.layer.addSublayer(playerLayer)
                        self.player.playImmediately(atRate: 1.0)
                        
                        guard let sublayers = self.videoContainerBottom.layer.sublayers else { return }
                        
                        for layer in sublayers {
                            layer.frame = self.videoContainerBottom.bounds
                        }
                    }
                } else {
                    self.videoContainerTop.layer.addSublayer(playerLayer)
                    self.player.playImmediately(atRate: 1.0)
                    
                    guard let sublayers = self.videoContainerTop.layer.sublayers else { return }
                    
                    for layer in sublayers {
                        
                        layer.frame = self.videoContainerTop.bounds
                    }
                    
                }
            }
        }
    }
        
}
