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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCellWithImage(image:Image){
        if let image = image.imageContent{
            self.targetImageview.image = image
            self.targetImageview.contentMode = .scaleAspectFit
        }        
        
    }
    
}
