//
//  Pay.swift
//  Precious
//
//  Created by zhubch on 2018/1/16.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Pay: Model, Codable {
    var userId = ""
    var userName = ""
    var payCount = 0
    var price = 0
    var payTime = ""
    
    override func setValue(with json: SwiftyJSON.JSON) {
        userId = json["userId"].string ?? ""
        userName = json["userName"].string ?? ""
        payTime = json["payTime"].string ?? ""
        price = json["price"].int ?? 0
        payCount = json["payCount"].int ?? 0
    }
}
