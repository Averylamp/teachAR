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
    
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var allImagesViewContainer: UIView!
    
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
        
        sceneView.delegate = self
        sceneView.session.delegate = self as? ARSessionDelegate

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        //Add recognizer to sceneview
        sceneView.addGestureRecognizer(tap)

        
        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
        setupChatViewController()
        
        self.view.layoutIfNeeded()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let chatBlurEffectView = UIVisualEffectView(effect: blurEffect)
        
        chatBlurEffectView.layer.cornerRadius = 10
        chatBlurEffectView.clipsToBounds = true
        chatBlurEffectView.frame = self.chatButtonViewContainer.bounds
        
        chatBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chatButtonViewContainer.insertSubview(chatBlurEffectView, at: 0)
        let imagesBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let allImagesBlurEffectView = UIVisualEffectView(effect: imagesBlurEffect)
        
        allImagesBlurEffectView.layer.cornerRadius = 10
        allImagesBlurEffectView.clipsToBounds = true
        allImagesBlurEffectView.frame = self.allImagesViewContainer.bounds
        
        allImagesBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        allImagesViewContainer.insertSubview(allImagesBlurEffectView, at: 0)
    }
    
    var chatViewController:ChatViewController?
    func setupChatViewController(){
        if let chatVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "chatVC") as? ChatViewController{
            self.chatViewController = chatVC
            chatVC.chatId = self.chatroom
            chatVC.accountId = self.username
            chatVC.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(chatVC.view)
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: chatVC.view,  attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: chatVC.view,  attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: chatVC.view,  attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: -40),
                NSLayoutConstraint(item: chatVC.view,  attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: -100)
                ])
            self.addChild(chatVC)
            chatVC.view.alpha = 0.0
            chatVC.didMove(toParent: self)
            chatVC.delegate = self
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
        
        
        let configuration = ARImageTrackingConfiguration()
        if self.allImages.count != self.allImageReferences.count{
            self.instantiateImageReferences()
        }
        configuration.maximumNumberOfTrackedImages = 1
        configuration.trackingImages = self.allImageReferences
        
        statusViewController.scheduleMessage("Looking for \(self.allImageReferences.count) images", inSeconds: 11.5, messageType: .contentPlacement)
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
    }
    
    var avPlayer:AVPlayer? = nil
    
    func removeVideoNode(){
        if let avPlayer = self.avPlayer,  ((avPlayer.rate != 0) && (avPlayer.error == nil)){
            self.avPlayer?.pause()
            self.avPlayer = nil
        }
        if let videoNode = self.videoNode{
            videoNode.removeFromParentNode()
            self.videoNode = nil
        }
        if let imageAnchor = self.imageAnchor{
            session.remove(anchor: imageAnchor)
            self.imageAnchor = nil
        }
    }
    
    var videoNode: SCNNode?
    var imageAnchor: ARImageAnchor?
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
                    self.removeVideoNode()
                    self.imageAnchor = imageAnchor
                    
                    let videoPlane = SCNPlane(width: referenceImage.physicalSize.width,
                                              height: referenceImage.physicalSize.height)
                    let videoPlaneNode = SCNNode(geometry: videoPlane)
                    self.videoNode = videoPlaneNode
                    
                    videoPlaneNode.eulerAngles.x = -.pi / 2
                    print("Adding VIDEO")
                    self.avPlayer = AVPlayer(url: videoURL)
                    videoPlane.firstMaterial?.diffuse.contents = self.avPlayer

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
    
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                if tappedNode == self.videoNode{
                    self.removeVideoNode()
                }
            }
        }
    }

    @IBAction func removeVideoClicked(_ sender: Any) {
        self.removeVideoNode()
    }
    
    @IBAction func chatButtonClicked(_ sender: Any) {
        self.presentChatVC()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var allImagesVC: AllImagesViewController?
    
    @IBAction func allImagesClicked(_ sender: Any) {
        if let allImagesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllImagesVC") as? AllImagesViewController{
            self.allImagesVC = allImagesVC
            allImagesVC.allImages = self.allImages
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.layer.cornerRadius = 10
            blurEffectView.clipsToBounds = true
            blurEffectView.frame = allImagesVC.view.bounds
            
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            allImagesVC.view.insertSubview(blurEffectView, at: 0)
            allImagesVC.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(allImagesVC.view)
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: allImagesVC.view,  attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: allImagesVC.view,  attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: allImagesVC.view,  attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: -40),
                NSLayoutConstraint(item: allImagesVC.view,  attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: -100)
                ])
            self.addChild(allImagesVC)
            allImagesVC.didMove(toParent: self)
            allImagesVC.view.alpha = 0.0
            UIView.animate(withDuration: 0.6) {
                allImagesVC.view.alpha = 1.0
            }
            
            allImagesVC.delegate = self
            
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


extension ARViewController: ChatDelegate {
    func newMessage(message: Message) {
        
    }
    
    func dismissChatVC() {
        UIView.animate(withDuration: 1.0) {
            if let chatView = self.chatViewController?.view{
                chatView.alpha = 0.0
                chatView.isUserInteractionEnabled = false
            }
        }
    }
    
    
    func presentChatVC(){
        UIView.animate(withDuration: 1.0) {
            if let chatView = self.chatViewController?.view{
                chatView.alpha = 1.0
                chatView.isUserInteractionEnabled = true
            }
        }

    }
    
    func onlineNumberChanged(numOnline: Int) {
        self.chatButton.setTitle("Chat - \(numOnline) online", for: .normal)
    }
    
}

extension ARViewController: AllImagesDelegate{
    
    func dismissAllImagesVC() {
        UIView.animate(withDuration: 0.7, animations: {
            self.allImagesVC?.view.alpha = 0.0
        }) { (finished) in
            if let allImagesVC = self.allImagesVC {
                allImagesVC.view.removeFromSuperview()
                allImagesVC.removeFromParent()
                self.allImagesVC  = nil
            }
        }
    }
    
    
    
}
