//
//  Address.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import SwiftyJSON

class Address: Model, Codable {
    
    var isDefault = ""
    
    var userName = ""
    
    var phone = ""
    
    var userAdress = ""
    
    var id = ""
    
    var distruct = ""
    
    var postCode = ""
    
    var province = ""
    
    var city = ""
    
    var sex = ""
    
    var readableAddress: String {
        return province + city + distruct + userAdress
    }
    
    override func setValue(with json: JSON) {
        id = json["id"].string ?? ""
        distruct = json["distruct"].string ?? ""
        postCode = json["postCode"].string ?? ""
        city = json["city"].string ?? ""
        userName = (json["userName"].string ?? json["name"].string) ?? ""
        province = json["province"].string ?? ""
        userAdress = json["userAdress"].string ?? ""
        phone = json["phone"].string ?? ""
        sex = json["sex"].string ?? ""
        isDefault = json["isDefault"].string ?? ""
    }

}
