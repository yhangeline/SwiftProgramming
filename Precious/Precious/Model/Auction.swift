//
//  Auction.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Auction: Model, Codable {
//    1:草稿 2：待审批 3：待拍卖 10：拍卖中 100：已成交 101：审批不通过
    enum Status: Int, IntConvertible {
        case draft = 1
        case reviewing = 2
        case toSell = 3
        case selling = 10
        case sold = 100
        case rejected = 101
        
        var intValue: Int {
            return self.rawValue
        }
        
        var icon: UIImage? {
            switch self {
            case .rejected:
                return #imageLiteral(resourceName: "img_profile_tag01")
            case .reviewing:
                return #imageLiteral(resourceName: "img_profile_tag03")
            case .toSell:
                return #imageLiteral(resourceName: "img_profile_tag02")
            default:
                return nil
            }
        }
        
        var string: String? {
            switch self {
            case .rejected:
                return "未通过"
            case .reviewing:
                return "审核中"
            case .toSell:
                return "已通过"
            default:
                return nil
            }
        }
    }
    
// 1 计时拍 2 实时拍（直播） 3 实时拍（图文
    enum `Type`:Int, IntConvertible {
        case limit = 1
        case video = 2
        case text = 3
        
        var intValue: Int {
            return self.rawValue
        }
    }

    var id = ""
    
    var storeId = ""
    
    var userId = ""
    
    var userImage = ""
    
    var userName = ""
    
    var looksCount = 0
    
    var biddingCount = 0
    
    var status = 0
    
    var type = 2
    
    var salesName = ""
    
    var remark = ""

    var currentPrice: Int?
    
    var deposit: Int?
    
    var startTime: String?

    var endTime: String?

    var estimateAmt = ""
    
    var keyWords: String?

    var image: String?

    var goodsList: [Goods] = []
    
    var goodsIds: [String] = []
    
    var isOwn: Bool {
        return userId == User.current?.id
    }

    var _status: Status {
        get {
            return Status(rawValue: status)!
        }
        set {
            status = newValue.rawValue
        }
    }
    
    var _type: Type {
        get {
            return Type(rawValue: type)!
        }
        set {
            type = newValue.rawValue
        }
    }
    
    override func setValue(with json: SwiftyJSON.JSON) {
        id = json["id"].string ?? ""
        storeId = json["storeId"].string ?? ""
        startTime = json["startTime"].string
        endTime = json["endTime"].string
        keyWords = json["keyWords"].string
        status = json["status"].int ?? 0
        looksCount = json["looksCount"].int ?? 0
        biddingCount = json["biddingCount"].int ?? 0
        image = json["image"].string
        salesName = json["salesName"].string ?? "--"
        type = json["type"].int ?? 2
        currentPrice = json["currentPrice"].int
        deposit = json["deposit"].int
        remark = json["remark"].string ?? ""
        estimateAmt = json["estimateAmt"].string ?? ""
        userId = json["userId"].string ?? ""
        userName = json["userName"].string ?? ""
        userImage = json["userImage"].string ?? "--"
        
        if let goodsJson = json["goodsList"].array {
            goodsList = goodsJson.map{Goods(json:$0)}
        }
    }
    
    func refresh(comlepted:((Auction?)->Void)?) {
        API.loadJSON(Router.Auction.detail(id: self.id)) { (response) in
            if case .success(let json) = response {
                self.setValue(with: json)
                comlepted?(self)
            } else {
                comlepted?(nil)
            }
        }
    }
    
}
