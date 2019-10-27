//
//  LoginController.swift
//  zappay
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import UIKit
import zapwallet

class LoginController: UIViewController {

    @IBOutlet weak var firstField: UITextField!
    
    @IBOutlet weak var lastField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didEnter(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func submit(_ sender: Any) {
        self.dismiss(animated: true) {
            let balance = Int.random(in: 1000...9000)
            ZWUser.with(first: self.firstField.text!, last: self.lastField.text!, balance: balance)
        }
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
