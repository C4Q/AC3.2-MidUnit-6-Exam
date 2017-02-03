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
    //MARK: - Properties
    var titleForCell: String = "Double Video"
    var imagePickerController: UIImagePickerController!
    var videoURL: URL?
    var playerA: AVPlayer?
    var playerB: AVPlayer?
    
    //MARK: - Outlets
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    //    override func viewDidLayoutSubviews() {
    //        // update your layers' frames here
    //        //this isn't actually doing anything
    //    }
    
    func handleVideoPlaying() {
        if let url = self.videoURL {
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: player)
            
            //self.player.rate == 0.0 did not lead to a positive response so I am successfully using self.player == nil
            if self.playerA == nil {
                //bonus
                self.videoContainerTop.layer.sublayers?.forEach { (layer) in
                    if layer == AVPlayerLayer() {
                        layer.removeFromSuperlayer()
                    }
                }
                
                self.playerA = player
                playerLayer.frame = self.videoContainerTop.bounds
                self.videoContainerTop.layer.addSublayer(playerLayer)
                
                self.playerA?.playImmediately(atRate: 1.0)
            }
            else if self.playerB == nil {
                self.videoContainerBottom.layer.sublayers?.forEach { (layer) in
                    if layer == AVPlayerLayer() {
                        layer.removeFromSuperlayer()
                    }
                }
                
                self.playerB = player
                playerLayer.frame = self.videoContainerBottom.bounds
                self.videoContainerBottom.layer.addSublayer(playerLayer)
                
                self.playerB?.playImmediately(atRate: 1.0)
            }
            else {
                //bonus
                let alertController = UIAlertController(title: "Both players are in use.", message: "Wait till one completes.", preferredStyle: .alert)
                let action = UIAlertAction(title: "I understand", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            }
            
            //this is the only reason the view is showing anything
            //playerLayer.frame = self.videoContainerTop.bounds
            //self.videoContainerTop.layer.addSublayer(playerLayer)
        }
        self.videoURL = nil
    }
    
    //MARK: - ImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerReferenceURL] as? URL {
            self.videoURL = url
        }
        else {
            print("Error getting URL from asset")
        }
        
        self.dismiss(animated: true, completion: nil)
        handleVideoPlaying()
    }
    
    //MARK: - Actions
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .popover
        
        //task is only for video so I am not including kuTTypeImage
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        
        self.imagePickerController = imagePickerController; // we need this for later
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
