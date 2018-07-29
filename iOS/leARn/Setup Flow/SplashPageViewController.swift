//
//  SplashPageViewController.swift
//  leARn
//
//  Created by Avery on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit

class SplashPageViewController: UIViewController {

    @IBOutlet weak var chatIDTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func continueButtonClicked(_ sender: Any) {
        
        if let chatText = chatIDTextField.text, let bookListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookListVC") as? BookListViewController{
            self.navigationController?.pushViewController(bookListVC, animated: true)
        }
        
    }
    
}
