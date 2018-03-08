//
//  Order.swift
//  Precious
//
//  Created by zhubch on 2018/1/21.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Order: Model {

    enum Status: Int, IntConvertible {
        case toPay = 1
        case toSend = 2
        case toRecieve = 3
        case recieved = 4
        case toSurePay = 12
        case done = 1000
        case toReturnGoods  = 2001
        case toReturnMoney  = 2002
        case returnedMoney  = 2003

        case unknown = 0
        
        var intValue: Int {
            return self.rawValue
        }
    }
    
    var address: Address!
    var status = 0
    var price = 0
    var dealTime = ""
    var id = ""
    var goodsId = ""
    var storeId = ""
    var buyerId = ""
    var sellerId = ""
    var salesroomId = ""
    var image = ""
    var name = ""
    
    var _status: Status {
        get {
            return Status(rawValue: status)!
        }
        set {
            status = newValue.rawValue
        }
    }
    
    override func setValue(with json: SwiftyJSON.JSON) {
        id = json["id"].string ?? ""
        storeId = json["storeId"].string ?? ""
        buyerId = json["buyerId"].string ?? ""
        sellerId = json["sellerId"].string ?? ""
        salesroomId = json["salesroomId"].string ?? ""
        goodsId = json["goodsId"].string ?? ""
        dealTime = json["dealTime"].string ?? ""
        name = json["name"].string ?? "接口没有"
        status = json["status"].int ?? 0
        price = json["price"].int ?? 0
        image = json["image"].string ?? ""
        
        if json["address"].exists() {
            address = Address(json: json["address"])
        }
    }
}
