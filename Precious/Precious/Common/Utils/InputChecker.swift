//
//  InputChecker.swift
//  WePost
//
//  Created by zhubch on 2017/6/15.
//  Copyright © 2017年 Happy Iterating Inc. All rights reserved.
//

import UIKit

enum InputType {
    case userName
    case userBio
    case feedName
    case feedDesc
    case comment
    case recommend
    case tag
    
    var displayName: String {
        switch self {
        case .userName:
            return "用户姓名"
        case .userBio:
            return "个人签名"
        case .feedName:
            return "订阅号名"
        case .feedDesc:
            return "订阅号简介"
        case .comment:
            return "评论"
        case .recommend:
            return "推荐语"
        case .tag:
            return "标签"
        }
    }
    
    var cjkLengthRange: (Int,Int) {
        switch self {
        case .userName:
            return (2,8)
        case .userBio:
            return (0,20)
        case .feedName:
            return (2,15)
        case .feedDesc:
            return (0,40)
        case .comment:
            return (0,250)
        case .recommend:
            return (0,250)
        case .tag:
            return (2,15)
        }
    }
    
    var lengthRange: (Int,Int) {
        if self == .userName {
            return (10,70)
        }
        return (cjkLengthRange.0 * 2, cjkLengthRange.1 * 2)
    }
    
    var regexPattern: (String,String)? {
        switch self {
        case .userName:
            return ("[a-zA-Z0-9\\u4e00-\\u9fa5 -]+","用户姓名只允许文字字符、空格、减号，不包含标点符号等")
        case .feedName:
            return ("[a-zA-Z0-9\\u4e00-\\u9fa5]+","订阅号名只允许文字，不包含空格、标点符号等")
        default:
            return nil
        }
    }
    
    func check(_ string: String) -> Bool {
        let length = string.containsCJK ? cjkLengthRange : lengthRange
        if string.length < length.0 {
            showError("\(displayName)最少需要\(length.0)个字符")
            return false
        }
        if string.length > length.1 {
            showError("\(displayName)最多不超过\(length.1)个字符")
            return false
        }
        guard let regexPatern = self.regexPattern else {
            return true
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexPatern.0)
        if !predicate.evaluate(with: string) {
            showError(regexPatern.1)
            return false
        }
        return true
    }
}

extension String {
    
    func isValid(_ type: InputType) -> Bool {
        return type.check(self)
    }
    
    var containsCJK: Bool {
        guard characters.count > 0 else {return false}
        
        for i in 0..<characters.count {
            let c: unichar = (self as NSString).character(at: i)
            
            if (c >= 0x4E00) {
                return true
            }
        }
        return false
    }
}
