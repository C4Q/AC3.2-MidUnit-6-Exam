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
    
    var player: AVPlayer!
    
    var firstVideoURL: URL?
    var secondVideoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
    }

    override func viewDidLayoutSubviews() {
        // update your layers' frames here
        guard let sublayersForTop = self.videoContainerTop.layer.sublayers else { return }
        //guard let sublayersForBottom = self.videoContainerBottom.layer.sublayers else { return }
        
        for layers in sublayersForTop {
            layers.frame = self.videoContainerTop.bounds
        }
        let playerLayer = AVPlayerLayer(player: self.player)
        self.videoContainerTop.layer.addSublayer(playerLayer)
        
//        for layers in sublayersForBottom {
//            layers.frame = self.videoContainerBottom.bounds
//        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        //        dismiss(animated: true)
        //        imageView.image = image
        
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeImage): break
            //if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                //self.imageView.image = image
//                dismiss(animated: true, completion: nil)
//            }
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                if self.firstVideoURL == nil {
                    self.firstVideoURL = url
                } else {
                    self.secondVideoURL = url
                }
                dismiss(animated: true) {
//                    let player = AVPlayer(url: url)
                    let playerItem = AVPlayerItem(url: self.firstVideoURL!)
                    self.player = AVPlayer(playerItem: playerItem)
//                    let playerLayer = AVPlayerLayer(player: self.player)
//                    self.videoContainerTop.layer.addSublayer(playerLayer)
                    //let playerController = AVPlayerViewController()
                    //playerController.player = player
//                    self.present(playerController, animated: true, completion:  {
//                        print("I present myself")
//                    })
                    self.player.play()
//                    self.firstVideoURL = nil
//                    self.secondVideoURL = nil
                }
            } else {
                print("Error getting url from picked asset")
            }
        default:
            print("Bad media type")
        }
    }
    
}
