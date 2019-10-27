//
//  ZUTransferCell.swift
//  zapui
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import UIKit
import zapwallet

class ZUTransferCell: UITableViewCell {

    @IBOutlet weak var valueDisplay: UILabel!
    
    @IBOutlet weak var nameDisplay: UILabel!
    
    @IBOutlet weak var descriptionDisplay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func display(transfer: ZWTransfer) {
        valueDisplay.text = String(format: "%.2f", transfer.quantity)
        nameDisplay.text = transfer.sender.firstName + " " + transfer.sender.lastName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
