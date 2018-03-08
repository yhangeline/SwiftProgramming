//
//  Store.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Store: Model {
    
    var id = ""

    var userId = 0
    
    var level = 0
    
    var storeLogo = ""
    
    var storeName = ""
    
    var satisfy = 0
    var dealAcount = 0
    var dealTotal = 0
    var dealRate = 0
    var returnRate = 0
    var goodsCount = 0
    var salesroomCount = 0
    var commentsCount = 0
    
    var daikaishiCount = 0
    var daishenpiCount = 0
    var yijieshuCount = 0
    var shenqingCount = 0
    var zhengjinxingCount = 0

    override func setValue(with json: SwiftyJSON.JSON) {
        id = json["id"].string ?? ""
        dealAcount = json["dealAcount"].int ?? 0
        dealTotal = json["dealTotal"].int ?? 0
        dealRate = json["dealRate"].int ?? 0
        returnRate = json["returnRate"].int ?? 0
        goodsCount = json["goodsCount"].int ?? 0
        salesroomCount = json["salesroomCount"].int ?? 0
        userId = json["userId"].int ?? 0
        level = json["level"].int ?? 0
        satisfy = json["satisfy"].int ?? 0
        storeLogo = json["storeLogo"].string ?? ""
        storeName = json["storeName"].string ?? ""
        
        daikaishiCount = json["daikaishiCount"].int ?? 0
        daishenpiCount = json["daishenpiCount"].int ?? 0
        yijieshuCount = json["yijieshuCount"].int ?? 0
        shenqingCount = json["shenqingCount"].int ?? 0
        zhengjinxingCount = json["zhengjinxingCount"].int ?? 0
    }
    
    func refresh(comlepted:((Store?)->Void)?) {
        API.loadJSON(Router.Store.detail(id: self.id)) { (response) in
            if case .success(let json) = response {
                self.setValue(with: json)
                comlepted?(self)
            } else {
                comlepted?(nil)
            }
        }
    }
    
}
