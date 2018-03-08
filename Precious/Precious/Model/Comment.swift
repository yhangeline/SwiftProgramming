//
//  Comment.swift
//  Precious
//
//  Created by zhubch on 2018/1/28.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Comment: Model, Codable {
    var id = ""
    var userName = ""
    var userImage = ""
    var userId = ""
    var comment = ""
    var commentTime = ""
    
    override func setValue(with json: SwiftyJSON.JSON) {
        userId = json["userId"].string ?? ""
        userName = json["userName"].string ?? ""
        userImage = json["userImage"].string ?? ""
        id = json["id"].string ?? ""
        comment = json["comment"].string ?? ""
        commentTime = json["commentTime"].string ?? ""
    }
}
