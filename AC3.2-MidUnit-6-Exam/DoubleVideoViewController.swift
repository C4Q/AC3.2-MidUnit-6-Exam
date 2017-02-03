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

class DoubleVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVPlayerViewControllerDelegate, CellTitled {
    var titleForCell: String = "Double Video"

    var playerTop: AVPlayer!
    var playerLayerTop: AVPlayerLayer!
    var playerTopPlaying = false
    
    var playerBottom: AVPlayer!
    var playerLayerBottom: AVPlayerLayer!
    var playerBottomPlaying = false
    
    var videoURL: URL?
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        guard let sublayersTop = self.videoContainerTop.layer.sublayers else { return }
        
        for layer in sublayersTop {
            layer.frame = self.videoContainerTop.bounds
        }
        
        guard let sublayersBottom = self.videoContainerBottom.layer.sublayers else { return }
        
        for layer in sublayersBottom {
            layer.frame = self.videoContainerBottom.bounds
        }
    }
    
    // MARK: - Video funcs
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerMediaURL] as? URL {
                if playerTopPlaying == false || playerBottomPlaying == false  {
                    self.videoURL = url
                }
                else {
                    noMoreSpots()
                    break
                }
            }
        default:
            noMoreSpots()
            break
        }
        
        // MARK: Picker Dismissal
        picker.dismiss(animated: true) {
            if self.playerTopPlaying == false {
                let playerItem = AVPlayerItem(url: self.videoURL!)
                self.videoURL = nil
                
                self.playerTop = AVPlayer(playerItem: playerItem)
                self.playerLayerTop = AVPlayerLayer(player: self.playerTop)
                
                self.videoContainerTop.layer.addSublayer(self.playerLayerTop)
                self.playerLayerTop.frame = self.videoContainerTop.bounds
                self.playerTop.play()
                self.playerTopPlaying = true
                DispatchQueue.main.async {
                    if self.playerTop.rate == 0.0 {
                        self.playerTopPlaying = false
                    }
                }
            }
                
            else if self.playerBottomPlaying == false {
                let playerItem = AVPlayerItem(url: self.videoURL!)
                self.videoURL = nil
                
                self.playerBottom = AVPlayer(playerItem: playerItem)
                self.playerLayerBottom = AVPlayerLayer(player: self.playerBottom)
                
                self.videoContainerBottom.layer.addSublayer(self.playerLayerBottom)
                self.playerLayerBottom.frame = self.videoContainerBottom.bounds
                self.playerBottom.play()
                self.playerBottomPlaying = true
                DispatchQueue.main.async {
                    if self.playerBottom.rate == 0.0 {
                        self.playerBottomPlaying = false
                    }
                }
            }
            else {
                self.noMoreSpots()
            }
        }
    }
    
    func noMoreSpots() {
        let alertThis = UIAlertController(title: "You dun goofed", message: "Consequences will never be the same", preferredStyle: .alert)
        let ouch = UIAlertAction(title: "Never Again", style: .default, handler: nil)
        let oops = UIAlertAction(title: "Oops", style: .cancel, handler: nil)
        alertThis.addAction(ouch)
        alertThis.addAction(oops)
        self.present(alertThis, animated: true, completion: nil)
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
