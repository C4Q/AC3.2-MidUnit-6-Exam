//
//  DoubleVideoViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Jason Gresh on 2/3/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation

class DoubleVideoViewController: UIViewController, CellTitled, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var movieURL: URL?
    
    var titleForCell: String = "Double Video"
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var videoContainerTop: UIView!
    @IBOutlet weak var videoContainerBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        // don't f with this line
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // update your layers' frames here
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }

    
    
    //MARK: - Delegates
    private func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        switch info[UIImagePickerControllerMediaType] as! String {
        case String(kUTTypeMovie):
            if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.movieURL = url
            }
        default:
            print("bad media")
        }
        
        // dismissing imagePickerController
        dismiss(animated: true) {
            if let url = self.movieURL {
                let player = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true, completion: {
                    self.movieURL = nil
                })
            }
        }
        
        
    }
    

    
    
}
