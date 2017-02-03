//
//  DoubleVideoViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Jason Gresh on 2/3/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AVKit
import MobileCoreServices

class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var titleForCell: String = "Double Video"

    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    var movieURLTop: URL?
    var movieURLBottom: URL?
    var movieURLTopJustUpdated: Bool = false
    var movieURLBottonJustUpdated: Bool = false
    
    var timeObserverToken: Any?
    var imagePickerController: UIImagePickerController!
    
    var player1: AVPlayer!
    
    var player2: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoContainerTop.accessibilityIdentifier = "videoContainerTop"
        self.videoContainerBottom.accessibilityIdentifier = "videoContainerBottom"
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    override func viewDidLayoutSubviews() {
        // update your layers' frames here
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        showImagePickerForSourceType(sourceType: .photoLibrary, fromButton: sender)
    }
    
    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType, fromButton button: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover
        imagePickerController.videoMaximumDuration = 60
        
        self.imagePickerController = imagePickerController
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: - UIImagePickerControllerDelegateMethod
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                if self.movieURLTop == nil {
                    self.movieURLTop = url
                    self.movieURLTopJustUpdated = true
                    finishAndUpdate()
                } else if self.movieURLBottom == nil {
                    self.movieURLBottom = url
                    self.movieURLBottonJustUpdated = true
                    finishAndUpdate()
                } else if player1.rate == 0 {
                    self.movieURLTop = url
                    self.movieURLTopJustUpdated = true
                    finishAndUpdate()
                } else if player2.rate == 0 {
                    self.movieURLBottom = url
                    self.movieURLBottonJustUpdated = true
                    finishAndUpdate()
                } else {
                    self.dismiss(animated: true, completion: nil)
                    let alertController = UIAlertController(title: "Failed to play current video because not spot is available", message: nil , preferredStyle: UIAlertControllerStyle.alert)
                    let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alertController.addAction(okay)
                    present(alertController, animated: true, completion: nil)
                }
            }
        default:
            print("bad media")
        }
    }
    
    private func finishAndUpdate() {
        // dismissing imagePickerController
        dismiss(animated: true) {
            if let url = self.movieURLTop, self.movieURLTopJustUpdated {
                self.player1 = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                playerController.player = self.player1
                
                let playerLayer = AVPlayerLayer(player: self.player1)
                DispatchQueue.main.async {
                    self.videoContainerTop.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                    self.videoContainerTop.layer.addSublayer(playerLayer)
                    guard let sublayers = self.videoContainerTop.layer.sublayers
                        else {
                            return
                    }
                    for layer in sublayers {
                        layer.frame = self.videoContainerTop.bounds
                    }
                    self.player1.play()
                    self.view.reloadInputViews()
                }
                self.movieURLTopJustUpdated = false
            }
            if let url = self.movieURLBottom, self.movieURLBottonJustUpdated {
                self.player2 = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                playerController.player = self.player2
                
                let playerLayer = AVPlayerLayer(player: self.player2)
                DispatchQueue.main.async {
                    self.videoContainerBottom.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                    self.videoContainerBottom.layer.addSublayer(playerLayer)
                    guard let sublayers = self.videoContainerBottom.layer.sublayers
                        else {
                            return
                    }
                    for layer in sublayers {
                        layer.frame = self.videoContainerBottom.bounds
                    }
                    self.player2.play()
                    self.view.reloadInputViews()
                }
                self.movieURLBottonJustUpdated = false
            }
        }
    }

}
