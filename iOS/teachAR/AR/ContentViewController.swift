//
//  ContentViewController.swift
//  teachAR
//
//  Created by Pramoda Karnati on 7/29/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    
    var image : Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.layer.cornerRadius = 50
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        loadData()
    }
    
    func loadData() {
        titleLabel.text = image.title
        contentLabel.text = image.description
    }
    
    @IBAction func onButtonClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: image.targetImageURL)!, options: [:], completionHandler: {(status) in })
    }

}
