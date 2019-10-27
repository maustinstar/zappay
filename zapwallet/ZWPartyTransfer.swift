//
//  ZWPartyTransfer.swift
//  zapwallet
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import Foundation

public class ZWPartyTransfer: Transferable {
    
    public var status: ZWTransferStatus = .unfulfilled
    public var transfers: [ZWTransfer]
    
    init(_ transfers: [ZWTransfer]) {
        self.transfers = transfers
    }
}
