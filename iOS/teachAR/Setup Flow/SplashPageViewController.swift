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
        
        chatIDTextField.delegate = self
    }
    

    @IBAction func continueButtonClicked(_ sender: Any) {
        
        if let chatText = chatIDTextField.text, chatText.count > 0, let bookListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookListVC") as? BookListViewController{
            bookListVC.username = chatText
            self.navigationController?.pushViewController(bookListVC, animated: true)
        }
        
    }
    
}

extension SplashPageViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.continueButtonClicked(UIButton())
        return true
    }
}
