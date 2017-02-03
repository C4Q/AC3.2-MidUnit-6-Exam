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

class DoubleVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CellTitled {
    var titleForCell: String = "Double Video"
    var videoURL: [URL] = []
    var timeObserverToken: Any?
    
    var playerTop: AVPlayer?
    var playerBottom: AVPlayer?
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        if let sublayers = self.videoContainerTop.layer.sublayers {
            for layer in sublayers {
                layer.frame = self.videoContainerTop.bounds
            }
        }
        
        if let sublayers = self.videoContainerBottom.layer.sublayers {
            for layer in sublayers {
                layer.frame = self.videoContainerBottom.bounds
            }
        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        showImagePickerForSourceType(sourceType: .photoLibrary, fromButton: sender)
    }
    
    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType, fromButton button: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .popover
        
        // 3. Allow choice of images and movies
        //    Image only is the default
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func addPlayerToView(myView: UIView, item: AVPlayerItem){
        let player = AVPlayer(playerItem: item)
        let playerLayer = AVPlayerLayer(player: player)
        
        switch myView {
        case videoContainerTop:
            self.playerTop = player
        case videoContainerBottom:
            self.playerBottom = player
        default:
            print("unknow view")
        }
        
        playerLayer.frame = myView.bounds
        
        let _ = self.videoContainerTop.layer.sublayers?.map{ $0.removeFromSuperlayer() }
        myView.layer.addSublayer(playerLayer)
        playerLayer.player?.playImmediately(atRate: 1.0)
    }
    
    private func finishAndUpdate() {
        self.dismiss(animated: true) {
            if let url = self.videoURL.last {
                
                let playerItem = AVPlayerItem(url: url)
                
                if self.playerTop == nil{
                    self.addPlayerToView(myView: self.videoContainerTop, item: playerItem)
                    return
                    
                }
                
                if self.playerBottom == nil{
                    self.addPlayerToView(myView: self.videoContainerBottom, item: playerItem)
                    return
                }
                
                if let item = self.playerTop?.currentItem{
                    if item.currentTime().seconds / item.duration.seconds == 1{
                        self.addPlayerToView(myView: self.videoContainerTop, item: playerItem)
                        return
                    }
                }
                
                if let item = self.playerBottom?.currentItem{
                    if item.currentTime().seconds / item.duration.seconds == 1{
                        self.addPlayerToView(myView: self.videoContainerBottom, item: playerItem)
                        return
                    }
                }
                
                //UIAlertController
                let alert = UIAlertController(title: "Warning", message: "No spot is currently available", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        // 4. Detect different media types
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.videoURL.append(url)
            }
            else {
                print("Error getting url from picked asset")
            }
        default:
            print("Unknown type")
        }
        
        self.finishAndUpdate()
    }
}
