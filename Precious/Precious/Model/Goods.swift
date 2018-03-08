//
//  Good.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON



class Goods: Model, Codable {
    //1：未上架 2：已上架 3：待拍卖 10：正在拍卖 100：已卖出 101：流拍
    enum Status: Int, IntConvertible {
        case toGround = 1
        case grounding = 2
        case toSell = 3
        case selling = 10
        case sold = 100
        case failed = 101

        case unknown = 0
        
        var intValue: Int {
            return self.rawValue
        }
    }
    
    static let typeNames = ["字画","玉器","青铜","金银","珠宝"]
    
    var id = ""
    
    var storeId = ""
    
    var userId = ""
    
    var auctionId = ""
    
    var sellTime: Int?
    
    var startTime: String?
        
    var initPrice = 0
    
    var currentPrice = 0
    
    var marketPrice = 0
    
    var priceStep = 0
    
    var image = ""
    
    var name = ""
    
    var userImage = ""
    
    var userName = ""

    var goodsType = 0
    
    var remark = ""
    
    var status = 0
    
    var commentCount = 0

    var agreeCount = 0

    var looksCount = 0

    var collectionCount = 0
    
    var payCount = 0

    var imageList: [String] = []
    
    var agreeList: [User] = []
    
    var commentList: [Comment] = []
    
    var payList: [Pay] = []

    var selected = false

    var _status: Status {
        get {
            return Status(rawValue: status)!
        }
        set {
            status = newValue.rawValue
        }
    }
    
    var goodsTypeString: String? {
        return Goods.typeNames[goodsType]
    }
    
    var auction: Auction {
        get {
            let a = Auction()
            a.id = auctionId
            return a
        }
    }
    
    override func setValue(with json: SwiftyJSON.JSON) {
        id = json["id"].string ?? ""
        storeId = json["storeId"].string ?? ""
        userId = json["userId"].string ?? ""
        auctionId = (json["salesroomId"].string ?? json["bidroomid"].string) ?? ""
        sellTime = json["sellTime"].int
        startTime = json["startTime"].string
        initPrice = json["initPrice"].int ?? 0
        currentPrice = json["currentPrice"].int ?? 0
        marketPrice = json["marketPrice"].int ?? 0
        priceStep = json["priceStep"].int ?? 0
        commentCount = json["commentCount"].int ?? 0
        agreeCount = json["agreeCount"].int ?? 0
        looksCount = json["looksCount"].int ?? 0
        payCount = json["payCount"].int ?? 0
        collectionCount = json["collectionCount"].int ?? 0

        if let images = json["imageList"].array {
            imageList = images.map{$0["path"].string ?? ""}
        }
        if let pays = json["payList"].array {
            payList = pays.map{Pay(json: $0)}
        }
        if let comments = json["commentList"].array {
            commentList = comments.map{Comment(json: $0)}
        }
        if let agrees = json["agreeList"].array {
            agreeList = agrees.map{User(json: $0)}
        }
        image = json["image"].string ?? ""
        name = json["name"].string ?? ""
        userName = json["userName"].string ?? ""
        userImage = json["userImage"].string ?? ""
        remark = json["remark"].string ?? ""
        goodsType = json["goodsType"].int ?? 0
        status = json["status"].int ?? 0
    }
    
    func refresh(comlepted:((Goods)->Void)?) {
        API.loadJSON(Router.Goods.detail(id: self.id)) { (response) in
            if case .success(let json) = response {
                self.setValue(with: json)
            }
            comlepted?(self)
        }
    }
}
