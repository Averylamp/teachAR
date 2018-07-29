//
//  AllImagesViewController.swift
//  teachAR
//
//  Created by Avery on 7/29/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit

class AllImagesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allImages:Array<Image> = Array<Image>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.populateTableView()
    }
    
    
    func populateTableView() {
        for image in allImages {
            self.updateTableView(self.tableView, with: image)
        }
    }
    
    func updateTableView(_ tableView: UITableView, with image: Image) {
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

}

extension AllImagesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTCV") as! ImageTableViewCell
        cell.setupCellWithImage(image: allImages[indexPath.row])
        return cell
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allImages.count
    }
    
}

