//
//  User.swift
//  Precious
//
//  Created by zhubch on 2017/12/6.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: Model, Codable {
    fileprivate static let url = URL(fileURLWithPath: C.docPath + "/user_data")

    fileprivate static var currentUser: User?
    
    static let system = System()
    
    static var current: User? {
        let decoder = JSONDecoder()
        if currentUser != nil {
            return currentUser
        }
        if let data = try? Data(contentsOf: url) {
            currentUser = try? decoder.decode(self, from: data)
        }
        return currentUser
    }
        
    var image: String?
    
    var realName: String?
    
    var gender: Int?
    
    var id = ""
    
    var level = 0
    
    var email: String?
    
    var phone: String?
    
    var token: String?
    
    var userName = ""
    
    var signature = ""
    
    var password = ""
    
    var followCount = 0
    
    var followerCount = 0
    
    var idPass = 0
    
    var isTemp: Bool {
        return id == "tempUser" || id.count < 1
    }
    
    var isLogin: Bool {
        return (token?.length ?? 0) > 0
    }
    
    override func setValue(with json: SwiftyJSON.JSON) {
        id = (json["id"].string ?? json["userd"].string) ?? ""
        idPass = json["idPass"].int ?? 0
        image = json["image"].string ?? json["userImage"].string
        realName = json["realName"].string
        level = json["level"].int ?? 0
        userName = (json["userName"].string ?? json["name"].string) ?? ""
        signature = json["signature"].string ?? ""
        email = json["email"].string
        token = json["token"].string
        phone = json["phone"].string
        gender = json["gender"].int
        password = json["password"].string ?? ""
        followCount = json["followCount"].int ?? 0
        followerCount = json["followerCount"].int ?? 0
    }
    
    func save() {
        User.currentUser = self
        let encoder = JSONEncoder()
        let data = try? encoder.encode(self)
        try? data?.write(to: User.url)
    }
    
    func refresh(comlepted:((User)->Void)?) {
        API.loadJSON(Router.User.getInfo) { (response) in
            if case .success(let json) = response {
                self.setValue(with: json)
            }
            comlepted?(self)
        }
    }
    
    func clear() {
        User.currentUser = nil
        try? FileManager.default.removeItem(at: User.url)
    }
    
    var genderString: String {
        if let gender = gender {
            return gender == 1 ? "男" : "女"
        }
        return ""
    }
}

extension User: TextConvertible {
    var color: UIColor {
        return C.Color.yellow
    }
    
    var string: String {
        return userName + ":"
    }
    
    var enableTap: Bool {
        return true
    }
}

class System: TextConvertible {
    var enableTap: Bool {
        return false
    }
    
    var string: String {
        return "系统消息:"
    }
    
    var color: UIColor {
        return C.Color.yellow
    }
}

