//
//  Message.swift
//  Precious
//
//  Created by zhubch on 2018/1/14.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Message: Model {
    enum `Type`: String {
        case message
        case bid
        case deal
        case goods
        case onlookersCount
        case changeName
        case countDown
        case unknown
    }
    
    var action = Type.unknown
    
    var data: JSON?
    
    var user: User?
    
    var fromSystem = false
    
    override func setValue(with json: JSON) {
        data = json["data"]
        if json["user"].exists() && json["user"] != JSON.null {
            user = User(json: json["user"])
        }
        fromSystem = json["fromSystem"].bool ?? true
        action = Type(rawValue: json["action"].string ?? "") ?? .unknown
    }
    
    class func comment(_ type: String, content: String) -> Message {
        let data = JSON(rawValue: ["type":type, "content":content])
        let msg = Message()
        msg.action = .message
        msg.data = data
        return msg
    }
    
    class func bid(price: Int, goodsID: String) -> Message {
        let data = JSON(rawValue: ["price":price, "id":goodsID])
        let msg = Message()
        msg.action = .bid
        msg.data = data
        return msg
    }
    var jsonString: String {
        let dic: [String:Any] = [
                    "action":action.rawValue,
                    "data":data?.dictionaryObject ?? [:],
                    "user": User.current.dict ?? [:]
                   ]
        return "\(JSON(rawValue: dic) ?? JSON.null)"
    }
}
