//
//  ZWUser.swift
//  zapwallet
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import Foundation

public class ZWUser {
    
    public var firstName: String
    public var lastName: String
    public var wallet: ZWWallet = ZWWallet(balance: 0, id: "", transfers: [])
    public var customerID: String
    
    init(firstName: String, lastName: String, uid: String, acctID: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.customerID = uid
        if let acct = acctID { wallet.accountID = acct }
    }
    
    public static var current: ZWUser? = { return load() }() {
        didSet {
            ZWUser.current?.save()
        }
    }
    
    public static func load() -> ZWUser? {
        let defaults = UserDefaults(suiteName: "group.mozzpoppers.zappay")!
        
        if let first = defaults.string(forKey: "firstName"),
            let last = defaults.string(forKey: "lastName"),
            let id = defaults.string(forKey: "customerID"),
            let acct = defaults.string(forKey: "accountID") {
            return ZWUser(firstName: first, lastName: last, uid: id, acctID: acct)
        }
        return nil
    }
    
    public static func clear() {
        let defaults = UserDefaults(suiteName: "group.mozzpoppers.zappay")!
        defaults.removeObject(forKey: "firstName")
        defaults.removeObject(forKey: "lastName")
        defaults.removeObject(forKey: "customerID")
        defaults.removeObject(forKey: "accountID")
    }
    
    public func save() {
        let defaults = UserDefaults(suiteName: "group.mozzpoppers.zappay")!
        defaults.set(firstName, forKey: "firstName")
        defaults.set(lastName, forKey: "lastName")
        defaults.set(customerID, forKey: "customerID")
        defaults.set(wallet.accountID, forKey: "accountID")
    }
    
    public static func with(first: String, last: String, balance: Int) {
        if current?.firstName == first && current?.lastName == last { return }
        ZWServer.createUser(first: first, last: last, balance: balance) { user in
            ZWUser.current = user
        }
    }
}
