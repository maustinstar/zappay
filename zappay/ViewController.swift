//
//  ViewController.swift
//  zappay
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import UIKit
import zapwallet

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var balanceDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = ZWUser.current{
            titleLabel.text = user.firstName + "'s Wallet"
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
        updateTimer.fire()
        // Do any additional setup after loading the view.
    }
    
    lazy var updateTimer: Timer = {
        return Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            ZWServer.updateBalance { balance in
                DispatchQueue.main.sync {
                    self?.balanceDisplay.text = String(format: "%.2f", Double(balance) / 100)
                }
            }
        }
    }()
    
    func updateBalance() {
        ZWServer.updateBalance { balance in
            DispatchQueue.main.sync {
                self.balanceDisplay.text = String(format: "%.2f", Double(balance) / 100)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ZWServer.updateBalance { balance in
            DispatchQueue.main.sync {
                self.balanceDisplay.text = String(format: "%.2f", Double(balance) / 100)
            }
        }
    }

    @IBAction func account(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Account", message: "Manage account.", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            ZWUser.current = nil
            ZWUser.clear()
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet, animated: true, completion: nil)
    }
    
}

