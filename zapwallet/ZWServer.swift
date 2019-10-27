//
//  ZWServer.swift
//  zapwallet
//
//  Created by Michael Verges on 10/26/19.
//  Copyright © 2019 Michael Verges. All rights reserved.
//

import Foundation

public struct ZWServer {
    
    public static let timeOut: TimeInterval = 10000
    
    public static func get(
        url: String,
        parameters: [String: String],
        timeout: TimeInterval = timeOut,
        completion: ((Data?) -> ())? = nil
    ) {
        
        var editedURL = url
        var i = 0
        for (k, v) in parameters {
            if i == 0 { editedURL += "?\(k)=\(v)" }
            else { editedURL += "&\(k)=\(v)" }
            i += 1
        }
        
        guard let urlpath = URL(string: editedURL) else { return }
        
        let request = NSMutableURLRequest(
            url: urlpath,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: timeout
        )
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared

        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                print(error)
            } else {
                completion?(data)
            }
        }
        dataTask.resume()
    }
    
    public static func post(
        url: URL,
        parameters: [String: String],
        timeout: TimeInterval = timeOut,
        completion: ((HTTPURLResponse) -> ())? = nil
    ) {
        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: timeout
        )
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = parameters
        
        let session = URLSession.shared

        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                print(error)
            } else if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async { completion?(httpResponse) }
            }
        }
        dataTask.resume()
    }
    
    private static let domain = "http://128.61.0.248:5000"
    
    private static func getBalance(user: ZWUser, completion: @escaping (Int) -> ()) {
        get(url: domain + "/get_balance", parameters: ["account_id": user.wallet.accountID]) { data in
            guard let data = data else {
                print("no data")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let info = json as? [String: Any], let balance = info["balance"] as? Int
            { completion(balance) }
        }
    }
    
    public static func updateBalance(completion: ((Int) -> ())? = nil) {
        
        guard let user = ZWUser.current else { return }
        
        getBalance(user: user) { (balance) in
            ZWUser.current?.wallet.balance = balance
            completion?(balance)
        }
    }
    
    public static func createUser(
        first: String, last: String, balance: Int,
        completion: @escaping (ZWUser) -> ()) {
        
        get(url: domain + "/create_account", parameters: [
            "first_name": first,
            "last_name": last,
            "balance": "\(balance)"
        ]) { data in
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let info = json as? [String: Any],
                let customerID = info["customer_id"] as? String,
                let accountID = info["account_id"] as? String
            {
                let user = ZWUser(firstName: first, lastName: last, uid: customerID)
                user.wallet.accountID = accountID
                completion(user)
            }
        }
    }
    
    public static func requestTransfer(balance: Int, completion: @escaping (String) -> ()) {
        
        guard let user = ZWUser.current ?? ZWUser.load() else {
            return
        }
        
        get(url: domain + "/generate_transfer", parameters: [
            "account_id": user.wallet.accountID,
            "amount": "\(balance)",
            "first_name": user.firstName,
            "last_name": user.lastName
        ]) { data in
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let info = json as? [String: Any], let uid = info["transfer_id"] as? String {
                completion(uid)
            }
        }
    }
    
    public static func checkTransfer(id: String, completion: @escaping (String, Int) -> ()) {
        get(url: domain + "/check_transfer", parameters: [
            "uid": id
        ]) { data in
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let info = json as? [String: Any],
                let payee = info["payee"] as? String,
                let amount = info["amount"] as? Int
            { completion(payee, amount) }
        }
    }
    
    public static func acceptTransfer(id: String, to accountID: String) {
        get(url: domain + "/accept_transfer", parameters: [
            "uid": id,
            "account_id": accountID
        ])
    }
}
