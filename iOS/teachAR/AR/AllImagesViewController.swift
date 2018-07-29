//
//  AllImagesViewController.swift
//  teachAR
//
//  Created by Avery on 7/29/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit

protocol AllImagesDelegate {
    func dismissAllImagesVC()
}
class AllImagesViewController: UIViewController {

    var delegate: AllImagesDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var allImages:Array<Image> = Array<Image>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.dismissAllImagesVC()
        }
    }
    
}

extension AllImagesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ImageTCV", for: indexPath) as! ImageTableViewCell
        cell.setupCellWithImage(image: allImages[indexPath.row])
        return cell
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allImages.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}

