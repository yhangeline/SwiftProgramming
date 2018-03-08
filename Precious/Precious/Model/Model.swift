//
//  Model.swift
//  Precious
//
//  Created by zhubch on 2017/12/6.
//  Copyright © 2017年 zhubch. All rights reserved.
//
import SwiftyJSON

extension Encodable {
    func serialize() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    var json: String? {
        guard let data = serialize() else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    var dict: [String:Any]? {
        guard let json = json else { return nil }
        return JSON(parseJSON: json).dictionaryObject
    }
}

class Model: NSObject, ListModel {
    func setValue(with json: SwiftyJSON.JSON) {
        
    }
    
    func gen() {
        
    }
    
    override init() {
        super.init()
        gen()
    }
    
    init(json: SwiftyJSON.JSON) {
        super.init()
        setValue(with: json)
    }
}


