//
//  QRGeneratorController.swift
//  zappay
//
//  Created by Michael Verges on 10/27/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import UIKit
import zapui
import zapwallet

class QRGeneratorController: UIViewController {

    @IBOutlet weak var qrView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        qrView.layer.magnificationFilter = CALayerContentsFilter(rawValue: kCISamplerFilterNearest)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        (parent as? ViewController)?.updateBalance()
    }
    
    var requestAmount: String = "" { didSet {
        if Int(requestAmount) ?? 0 > 99999 { requestAmount = "100000" }
        displayRequestText()
    } }
    
    @IBOutlet weak var requestLabel: UILabel!
    
    @IBAction func addDigit(_ sender: Any) {
        if let digit = (sender as? UIButton)?.titleLabel?.text {
            requestAmount += digit
        }
    }
    
    @IBAction func removeDigit(_ sender: Any) {
        if requestAmount.count > 0 { requestAmount.removeLast() }
    }
    
    @IBAction func clearDigits(_ sender: Any) {
        requestAmount = ""
    }
    @IBAction func decrement(_ sender: Any) {
        if let value = Int(requestAmount) {
            if value > 100 {
                requestAmount = String(value - 100)
            } else {
                requestAmount = ""
            }
        }
    }
    
    @IBAction func increment(_ sender: Any) {
        if let value = Int(requestAmount) {
            requestAmount = String(value + 100)
        }
    
        if requestAmount == "" {
            requestAmount = "100"
        }
    }
    
    func displayRequestText() {
        requestLabel.text = format(number: requestAmount)
    }
    
    func format(number: String) -> String {
        var displayText = number
        while displayText.count < 3 { displayText = "0" + displayText }
        displayText.insert(".", at: displayText.index(displayText.endIndex, offsetBy: -2))
        return displayText
    }
    
    @IBAction func request(_ sender: Any) {
        let amount = (Int(self.requestAmount) ?? 0)
        guard let user = ZWUser.current?.wallet.accountID else { return }
        ZWServer.requestTransfer(balance: amount) { (tid) in
            DispatchQueue.main.sync {
                self.qrView.image = ZWQRImage.from(tid)
            }
        }
    }

}
