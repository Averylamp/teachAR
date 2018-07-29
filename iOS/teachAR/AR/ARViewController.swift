//
//  ViewController.swift
//  leARn
//
//  Created by Avery on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import Foundation

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var chatButtonViewContainer: UIView!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var username: String = ""
    var chatroom: String = ""
    
    var allImages:Array<Image> = Array<Image>()
    
    var allImageReferences: Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.layer.cornerRadius = 50
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chatButtonViewContainer.insertSubview(blurEffectView, at: 0)

        
        
        sceneView.delegate = self
        sceneView.session.delegate = self as? ARSessionDelegate
        
        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
        setupChatViewController()
    }
    
    var chatViewController:ChatViewController?
    func setupChatViewController(){
        if let chatVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "chatVC") as? ChatViewController{
            chatVC.chatId = self.chatroom
            chatVC.accountId = self.username
            chatVC.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(chatVC.view)
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: chatVC.view,  attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: chatVC.view,  attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: chatVC.view,  attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: -40),
                NSLayoutConstraint(item: chatVC.view,  attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: -40)
                ])
//
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the AR experience
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    // MARK: - Session management (Image detection setup)
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    func instantiateImageReferences(){
        self.allImageReferences = Set<ARReferenceImage>()
        
        for image in self.allImages{
            if let imageContent = image.imageContent, let imageContentCG = imageContent.cgImage{
                let imageReference = ARReferenceImage(imageContentCG, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(image.width / 39.0))
                imageReference.name = image.imageID
                self.allImageReferences.insert(imageReference)
            }
        }
    }
    
    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
    func resetTracking() {
        
        
        let configuration = ARWorldTrackingConfiguration()
        if self.allImages.count != self.allImageReferences.count{
            self.instantiateImageReferences()
        }
        configuration.detectionImages = self.allImageReferences
        statusViewController.scheduleMessage("Looking for \(self.allImageReferences.count) images", inSeconds: 11.5, messageType: .contentPlacement)
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
    }
    
    var avPlayer:AVPlayer?
    
    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        updateQueue.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25

            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2

            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            planeNode.runAction(self.imageHighlightAction)

            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
            
            if let imageName = referenceImage.name{
                var imageObj: Image? = nil
                for image in self.allImages{
                    if image.imageID == imageName{
                        imageObj = image
                        break
                    }
                }
                if let imageObj = imageObj, let videoURL = URL(string: imageObj.videoURL) {
                    
                    let videoPlane = SCNPlane(width: referenceImage.physicalSize.width,
                                              height: referenceImage.physicalSize.height)
                    let videoPlaneNode = SCNNode(geometry: videoPlane)
                    videoPlaneNode.eulerAngles.x = -.pi / 2
                    print("Adding VIDEO")
                    self.avPlayer = AVPlayer(url: videoURL)
                    videoPlane.firstMaterial?.diffuse.contents = self.avPlayer
//                    let playerLayerAV = AVPlayerLayer(player: self.avPlayer)
//                    playerLayerAV.frame = self.view.bounds
//                    self.view.layer.addSublayer(playerLayerAV)

                    self.avPlayer!.play()
                    node.addChildNode(videoPlaneNode)
                }
            }
        }
        
        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
}
