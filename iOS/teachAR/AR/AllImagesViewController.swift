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

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AllImagesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTCV") as! ImageTableViewCell
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allImages.count
    }
    
}

