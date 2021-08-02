//
//  ViewController.swift
//  experiment
//
//  Created by Ramon Yepez on 7/24/21.
//
import UIKit
import AVKit
import MobileCoreServices
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var firstImage: UIButton!
    @IBOutlet weak var secondImage: UIButton!
    @IBOutlet weak var thirdImage: UIButton!
    
    @IBOutlet weak var demoButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var labelFirstImage: UILabel!
    @IBOutlet weak var stackViewButton: UIStackView!
    @IBOutlet weak var stackInfo: UIStackView!
    
    @IBOutlet weak var mergeButton: UIButton!
    
    var loadingAssetOne = false
    var loadingAssetTwo = false
    var loadingAssetThird = false

    var firstAsset: AVAsset?
    var secondAsset: AVAsset?
    var thirdAsset: AVAsset?

    @IBOutlet weak var firstButton: UIStackView!
    
    var mergeVideoURL: URL!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noImageSelected()
        // making the button available
        playButton.isEnabled = false

        // Do any additional setup after loading the view.
        let shareButton = UIButton()
        shareButton.titleLabel?.text = "Share"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(moreInfo))
      
        curveUI(articulo: stackViewButton)
        curveUI(articulo: playButton)
        curveUI(articulo: demoButton)
        curveUI(articulo: stackInfo)
        curveUI(articulo: playButton)
        curveUI(articulo: mergeButton)

    }
    

func noImageSelected() {

        guard let fistA = firstAsset, let secondA = secondAsset, let thirdA = thirdAsset else {
            
            mergeButton.isEnabled = false
            return
        }
        
        mergeButton.isEnabled = true
    
    }
    
 
 
    func curveUI(articulo: UIView) {
        
        articulo.layer.cornerRadius = 10
        articulo.layer.borderWidth = 5.0
        articulo.layer.borderColor = UIColor.white.cgColor
        articulo.clipsToBounds = true
    }
    
    @objc func moreInfo() {
        
        print("share")
        print(mergeVideoURL ?? "")
        
    }

    func videoSnapshot(filePathLocal: String) -> UIImage? {

        let vidURL = URL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    @IBAction func firstVideo(_ sender: UIButton) {
        
        loadingAssetOne = true
        loadingAssetTwo = false
        loadingAssetThird = false
        //cheking if source is available
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
          else { return }

                   // creating an instance of pickercontroller
                   let imagePicker = UIImagePickerController()
                   //setting the delegate for image picker
                   imagePicker.delegate = self
                    // make only video visiables
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    //it possible to edit that video lenght
                    imagePicker.allowsEditing = true
        
                   //present the image picker
                   present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func secondVideo(_ sender: UIButton) {
        
        loadingAssetOne = false
        loadingAssetTwo = true
        loadingAssetThird = false

        //cheking if source is available
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
          else { return }

                   // creating an instance of pickercontroller
                   let imagePicker = UIImagePickerController()
                   //setting the delegate for image picker
                   imagePicker.delegate = self
                    // make only video visiables
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    //it possible to edit that video lenght
                    imagePicker.allowsEditing = true
        
                   //present the image picker
                   present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func thirdVideo(_ sender: UIButton) {
        
        loadingAssetOne = false
        loadingAssetTwo = false
        loadingAssetThird = true

        //cheking if source is available
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
          else { return }

                   // creating an instance of pickercontroller
                   let imagePicker = UIImagePickerController()
                   //setting the delegate for image picker
                   imagePicker.delegate = self
                    // make only video visiables
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    //it possible to edit that video lenght
                    imagePicker.allowsEditing = true
        
                   //present the image picker
                   present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //dismissing the picker
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
          mediaType == (kUTTypeMovie as String),
          let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
          else { return }
        
        let avAsset = AVAsset(url: url)
       //change this to other control flow
        var message = ""
        
        if loadingAssetOne {
          message = "Video one loaded"
            firstImage.setImage(videoSnapshot(filePathLocal: url.absoluteString), for: .normal)
          firstAsset = avAsset
        }
        
        if loadingAssetTwo {
            message = "Video two loaded"
            secondImage.setImage(videoSnapshot(filePathLocal: url.absoluteString), for: .normal)
            secondAsset = avAsset
        }
        if loadingAssetThird {
            message = "Video third loaded"
            thirdImage.setImage(videoSnapshot(filePathLocal: url.absoluteString), for: .normal)
            thirdAsset = avAsset
        
        
        }
        noImageSelected()
        //dismissing the picker
     dismiss(animated: true, completion: nil)

        let alert = UIAlertController(
          title: "Asset Loaded",
          message: message,
          preferredStyle: .alert)
        alert.addAction(UIAlertAction(
          title: "OK",
          style: UIAlertAction.Style.cancel,
          handler: nil))
        present(alert, animated: true, completion: nil)
        
       
       }

      
    
    func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
      // 1
      let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)

      // 2
      let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]

      // 3
      let transform = assetTrack.preferredTransform
      let assetInfo = orientationFromTransform(transform)

      var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
      if assetInfo.isPortrait {
        // 4
        scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
        let scaleFactor = CGAffineTransform(
          scaleX: scaleToFitRatio,
          y: scaleToFitRatio)
        instruction.setTransform(
          assetTrack.preferredTransform.concatenating(scaleFactor),
          at: .zero)
      } else {
        // 5
        let scaleFactor = CGAffineTransform(
          scaleX: scaleToFitRatio,
          y: scaleToFitRatio)
        var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
          .concatenating(CGAffineTransform(
            translationX: 0,
            y: UIScreen.main.bounds.width / 2))
        if assetInfo.orientation == .down {
          let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
          let windowBounds = UIScreen.main.bounds
          let yFix = assetTrack.naturalSize.height + windowBounds.height
          let centerFix = CGAffineTransform(
            translationX: assetTrack.naturalSize.width,
            y: yFix)
          concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
        }
        instruction.setTransform(concat, at: .zero)
      }

      return instruction
    }
    
func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
      var assetOrientation = UIImage.Orientation.up
      var isPortrait = false
      let tfA = transform.a
      let tfB = transform.b
      let tfC = transform.c
      let tfD = transform.d

      if tfA == 0 && tfB == 1.0 && tfC == -1.0 && tfD == 0 {
        assetOrientation = .right
        isPortrait = true
      } else if tfA == 0 && tfB == -1.0 && tfC == 1.0 && tfD == 0 {
        assetOrientation = .left
        isPortrait = true
      } else if tfA == 1.0 && tfB == 0 && tfC == 0 && tfD == 1.0 {
        assetOrientation = .up
      } else if tfA == -1.0 && tfB == 0 && tfC == 0 && tfD == -1.0 {
        assetOrientation = .down
      }
      return (assetOrientation, isPortrait)
    }
    
    
func merge() {
    
    guard let firstAsset = firstAsset, let secondAsset = secondAsset, let thirdAsset = thirdAsset
      else { print("please select video")
            return }

    // 1
    let mixComposition = AVMutableComposition()

    // 2
    guard let firstTrack = mixComposition.addMutableTrack(
        withMediaType: .video,
        preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
      else { return }
        
    // 3
    do {
      try firstTrack.insertTimeRange(
        CMTimeRangeMake(start: .zero, duration: firstAsset.duration),
        of: firstAsset.tracks(withMediaType: .video)[0],
        at: .zero)
    } catch {
      print("Failed to load first track")
      return
    }

    // second video
    guard let secondTrack = mixComposition.addMutableTrack(
        withMediaType: .video,
        preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
      else { return }
        
    do {
      try secondTrack.insertTimeRange(
        CMTimeRangeMake(start: .zero, duration: secondAsset.duration),
        of: secondAsset.tracks(withMediaType: .video)[0],
        at: firstAsset.duration)
    } catch {
      print("Failed to load second track")
      return
    }
    //third video
    guard let thirdTrack = mixComposition.addMutableTrack(
        withMediaType: .video,
        preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
      else { return }
        
    do {
      try thirdTrack.insertTimeRange(
        CMTimeRangeMake(start: .zero, duration: thirdAsset.duration),
        of: thirdAsset.tracks(withMediaType: .video)[0],
        at: CMTimeAdd(firstAsset.duration, secondAsset.duration))
    } catch {
      print("Failed to load third track")
      return
    }
    
    let durationFirstSecondThird = firstAsset.duration + secondAsset.duration +  secondAsset.duration
    // 6
    let mainInstruction = AVMutableVideoCompositionInstruction()
    mainInstruction.timeRange = CMTimeRangeMake(
      start: .zero,
        duration: durationFirstSecondThird)

    // 7
    let firstInstruction = videoCompositionInstruction(
      firstTrack,
      asset: firstAsset)
    
    firstInstruction.setOpacity(0.0, at: firstAsset.duration)
    
    let secondInstruction = videoCompositionInstruction(
       secondTrack,
       asset: secondAsset)
    
    
    secondInstruction.setOpacity(0.0, at: CMTimeAdd(firstAsset.duration, secondAsset.duration))

    let thirdInstruction = videoCompositionInstruction(
        thirdTrack,
       asset: thirdAsset)
    


    // 8
    mainInstruction.layerInstructions = [firstInstruction, secondInstruction, thirdInstruction]
    let mainComposition = AVMutableVideoComposition()
    mainComposition.instructions = [mainInstruction]
    mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
    mainComposition.renderSize = CGSize(
      width: UIScreen.main.bounds.width,
      height: UIScreen.main.bounds.height)

    
guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    let date = dateFormatter.string(from: Date())
    let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")

    // 12
    guard let exporter = AVAssetExportSession(
      asset: mixComposition,
      presetName: AVAssetExportPresetHighestQuality)
      else { return }
    exporter.outputURL = url
    exporter.outputFileType = AVFileType.mov
    exporter.shouldOptimizeForNetworkUse = true
    exporter.videoComposition = mainComposition

    // 13
    print("step 13")
    exporter.exportAsynchronously {
        print("exportAsynchronously")
      DispatchQueue.main.async {
        self.exportDidFinish(exporter, completion: self.playMerge(outputURL:))
      }
    }

}

    func exportDidFinish(_ session: AVAssetExportSession, completion: @escaping (URL?) -> Void) {
        //
        
        // 1
        print("step 1 on exportDidFinish")
        firstAsset = nil
        secondAsset = nil
        thirdAsset = nil

        // 2
     
        guard session.status == AVAssetExportSession.Status.completed,
              let outputURL = session.outputURL else {
            print("it fails here!")
            
            return }
        
        print(outputURL.absoluteString)
        // 3
        let saveVideoToPhotos = {
          // 4
          let changes: () -> Void = {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
          }
          PHPhotoLibrary.shared().performChanges(changes) { saved, error in
            DispatchQueue.main.async {
                
            print(saved.description)
                
                if saved {
                    completion(outputURL)
                    self.playButton.isEnabled = true
                    
                } else {
                    print(error?.localizedDescription as Any)
                }
                
                
            }
          }
        }
          
        // 5
        if PHPhotoLibrary.authorizationStatus() != .authorized {
          PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
              saveVideoToPhotos()
        
            }
          }
        } else {
          saveVideoToPhotos()
        }
        
        
      }
    
    
    
    @IBAction func mergeVideo(_ sender: UIButton) {
        
        merge()

        firstImage.setImage(UIImage(named: "film"), for: .normal)
        secondImage.setImage(UIImage(named: "film"), for: .normal)
        thirdImage.setImage(UIImage(named: "film"), for: .normal)
        
        mergeButton.isEnabled = false
    }
    func playMerge(outputURL: URL?) {
        
        //play video
           // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        guard let outputURL = outputURL else {
            return
        }
            mergeVideoURL = outputURL
        

    }
 

    @IBAction func playVideo(_ sender: UIButton) {
      
        
           let player = AVPlayer(url: mergeVideoURL)

           // Create a new AVPlayerViewController and pass it a reference to the player.
           let controller = AVPlayerViewController()
           controller.player = player

           // Modally present the player and call the player's play() method when complete.
           present(controller, animated: true) {
               player.play()
           }
        
    }
 
    
}


