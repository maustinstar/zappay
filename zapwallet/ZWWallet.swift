//
//  ZWWallet.swift
//  zapwallet
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import Foundation

public class ZWWallet {
    public var balance: Int
    public var transfers: [Transferable]
    public var accountID: String
    
    init(balance: Int, id: String, transfers: [Transferable] = []) {
        self.balance = balance
        self.transfers = transfers
        self.accountID = id
    }
}
