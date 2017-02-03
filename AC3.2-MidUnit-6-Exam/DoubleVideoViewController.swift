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

private var kvoContext = 0

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
        guard let sublayersForBottom = self.videoContainerBottom.layer.sublayers else { return }
        
        for layers in sublayersForTop {
            layers.frame = self.videoContainerTop.bounds
        }
        for layers in sublayersForBottom {
            layers.frame = self.videoContainerBottom.bounds
        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeImage):
            break
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                if self.firstVideoURL == nil {
                    self.firstVideoURL = url
                    if let url = firstVideoURL {
                        let playerItem = AVPlayerItem(url: url)
                        self.player = AVPlayer(playerItem: playerItem)
                        let playerLayer = AVPlayerLayer(player: self.player)
                        playerLayer.frame = self.videoContainerTop.bounds
                        self.videoContainerTop.layer.addSublayer(playerLayer)
                    }
                } else {
                    self.secondVideoURL = url
                    if let url = secondVideoURL {
                        let playerItem = AVPlayerItem(url: url)
                        self.player = AVPlayer(playerItem: playerItem)
                        let playerLayer = AVPlayerLayer(player: self.player)
                        playerLayer.frame = self.videoContainerBottom.bounds
                        self.videoContainerBottom.layer.addSublayer(playerLayer)
                    }
                }
                dismiss(animated: true) {
                    self.player.play()
                }
            } else {
                print("Error getting url from picked asset")
            }
        default:
            print("Bad media type")
        }
    }
    
}
