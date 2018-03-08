//
//  Account.swift
//  Precious
//
//  Created by zhubch on 2018/1/22.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Account: Model {

    var id = ""
    
    var total: Double = 0
    var admitted: Double = 0
    var balanceUsable: Double = 0
    var deposit: Double = 0
    var freeze: Double = 0

    static let shared = Account()
    
    override func setValue(with json: SwiftyJSON.JSON) {
        id = json["id"].string ?? ""
        total = json["total"].double ?? 0
        admitted = json["admitted"].double ?? 0
        balanceUsable = json["balanceUsable"].double ?? 0
        deposit = json["deposit"].double ?? 0
        freeze = json["freeze"].double ?? 0
    }
    
    func refresh(comlepted:((Account)->Void)?) {
        API.loadJSON(Router.Wallet.detail) { (response) in
            if case .success(let json) = response {
                self.setValue(with: json)
            }
            comlepted?(self)
        }
    }

}
