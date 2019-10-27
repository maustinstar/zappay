//
//  Transferable.swift
//  zapwallet
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import Foundation

public protocol Transferable {
    var status: ZWTransferStatus { get set }
}
