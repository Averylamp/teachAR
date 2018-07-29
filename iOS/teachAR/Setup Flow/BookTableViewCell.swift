//
//  BookTableViewCell.swift
//  leARn
//
//  Created by Avery on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit
import SDWebImage

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var onlineLabel: UILabel!
    
    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    
    @IBOutlet weak var containingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithBook(book:Book){
        self.containingView.layer.shadowRadius = 4
        self.containingView.layer.cornerRadius = 7
        self.containingView.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        self.containingView.layer.shadowOpacity = 0.4
        self.containingView.layer.shadowOffset = CGSize(width: 2, height: 1)
        
        
        self.titleLabel.text = book.name
        self.authorLabel.text = book.author
        self.onlineLabel.text = "\(0) online now"
        
        if let url = URL(string: book.coverURL){
            self.bookCoverImageView.contentMode = .scaleAspectFit
            self.bookCoverImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                if (error != nil){
                    print(error)
                }else{
                    print("Image downloaded propertly")
                }
            }
        }
    }

}
