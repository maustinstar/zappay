//
//  ZWTransfer.swift
//  zapwallet
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import Foundation

public struct ZWTransfer: Transferable {
    public var receiver: ZWUser
    public var sender: ZWUser
    public var originator: ZWTransferOriginator
    
    public var quantity: Double
    public var status: ZWTransferStatus = .unfulfilled
}
