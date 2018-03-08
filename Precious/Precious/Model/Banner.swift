//
//  Banner.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Banner: Model {
    
    var id = ""

    var remark = ""
    
    var bannerUrl = ""
    
    var isExpired = false
    
    var bannerImg: String?
    
    var bannerType = ""
    
    override func setValue(with json: SwiftyJSON.JSON) {
        id = json["id"].string ?? ""
        isExpired = (json["isExpired"].int ?? 0) == 1
        bannerImg = json["bannerImg"].string
        bannerUrl = json["bannerUrl"].string ?? ""
        remark = json["remark"].string ?? ""
        bannerType = json["bannerType"].string ?? ""
    }
}
