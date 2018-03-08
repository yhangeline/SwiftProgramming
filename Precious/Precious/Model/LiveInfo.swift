//
//  LiveInfo.swift
//  Precious
//
//  Created by zhubch on 2018/3/6.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class LiveInfo: Model {
    
    var salesroomDeposit = 2000
    var depositBalance = 0
    var pullStreamUrl: String?
    var pushStreamUrl: String?
    var depositCover = true
    var whiteUser = false
    
    override func setValue(with json: SwiftyJSON.JSON) {
        salesroomDeposit = json["salesroomDeposit"].int ?? 0
        depositBalance = json["dePositBalance"].int ?? 0
        pushStreamUrl = json["pushStreamUrl"].string
        pullStreamUrl = json["pullStreamUrl"].string
        depositCover = json["depositCover"].bool ?? true
        whiteUser = json["whiteUser"].bool ?? false
    }
}
