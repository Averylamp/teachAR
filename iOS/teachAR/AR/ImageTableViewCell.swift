//
//  ImageTableViewCell.swift
//  teachAR
//
//  Created by Avery on 7/29/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var targetImageview: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var urlView: UILabel!

    func setupCellWithImage(image:Image){
        if let image = image.imageContent{
            self.targetImageview.image = image
            self.targetImageview.contentMode = .scaleAspectFit
        }
        self.backgroundColor = nil
        self.backgroundView = nil
        self.labelView.backgroundColor = nil
        self.labelView.text = image.title
        self.urlView.text = image.description
        
    }
    
}
