    /*
 
 Use UIImagePickerController to pick the video from the library.
 Use the AVPlayerItem, AVPlayer, and AVPlayerLayer objects to take the chosen video and display it. Remember,imagePickerController(_:didFinishPickingMediaWithInfo:) will give you a URL for Movies and that can be used to construct an AVPlayerItem.
 You can determine whether a video is currently playing by checking the rate property of the AVPlayer object. No keys or values need be harmed (or even observed) during the making of this app. (Plain English: No KVO needed).
 */

import UIKit
import AVKit
import MobileCoreServices
import AVFoundation

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
        guard let sublayers = self.videoContainerTop.layer.sublayers
            else {
                return
        }
        
        for layer in sublayers {
            layer.frame = self.videoContainerTop.bounds
        }
    }
    
    @IBAction func loadVideo(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeMovie)]
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                self.movieURL = url
            print(url.absoluteString)
        }
        dismiss(animated: true) {
            if let url = self.movieURL {
                let playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
                let playerLayer = AVPlayerLayer(player: self.player)
        
            
                self.videoContainerTop.layer.addSublayer(playerLayer)
                
                playerLayer.frame = self.videoContainerTop.bounds
                self.player?.playImmediately(atRate: 1.0)
                
            }
        }
        
        
    }

}
