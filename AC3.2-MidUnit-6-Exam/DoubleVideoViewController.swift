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

class DoubleVideoViewController: UIViewController, CellTitled,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var titleForCell: String = "Double Video"
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    var topPlayer: AVPlayer = AVPlayer()
    var bottomPlayer: AVPlayer = AVPlayer()

    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
    }

    override func viewDidLayoutSubviews() {
        // update your layers' frames here
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK:- ImagePicker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let url = info[UIImagePickerControllerMediaURL] as? URL{
            self.dismiss(animated: true){
                self.playSelectedVideo(url: url)
            }
        }
    }
    
    //MARK:- Utilities
    func playSelectedVideo(url: URL){
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        let playerLayer: AVPlayerLayer = AVPlayerLayer()
        
        if videoContainerTop.layer.sublayers == nil || topPlayer.rate == 0.0 {
            videoContainerTop.layer.sublayers = nil
            topPlayer = AVPlayer(playerItem: playerItem)
            playerLayer.player = topPlayer
            playerLayer.frame = videoContainerTop.bounds
            topPlayer.play()
            videoContainerTop.layer.addSublayer(playerLayer)
        }else if bottomPlayer.rate != 0.0{
            showAlert(with: "Both slots are current playing videos")
        }else{
            videoContainerBottom.layer.sublayers = nil
            bottomPlayer = AVPlayer(playerItem: playerItem)
            playerLayer.player = bottomPlayer
            playerLayer.frame = videoContainerBottom.bounds
            bottomPlayer.play()
            videoContainerBottom.layer.addSublayer(playerLayer)
        }
    }
    
    func showAlert(with message:String){
        let alert: UIAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
