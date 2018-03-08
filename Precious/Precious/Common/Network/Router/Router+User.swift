//
//  Router+User.swift
//  Precious
//
//  Created by zhubch on 2017/12/6.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

extension Router {
    enum User: Routable {
        case getVerifyCodeForRegister(phone:String)
        case getVerifyCode(phone:String)
        case login(phone:String,password:String)
        case wxLogin(code:String)
        case bindPhone(phone:String,code:String)
        case checkVerifyCode(phone:String,code:String)
        case register(phone:String,password:String,code:String)
        case getInfo
        case updateInfo(avatar:String,userName:String,bio:String,gender:Int)
        case resetPassword(phone:String,password: String,code:String)
        case updatePassword(oldPassword:String, password: String)
        case check(userName:String)
        case identity(info:[String:Any])
        
        var method: RequestMethod {
            switch self {
            case .getVerifyCode,
                 .getVerifyCodeForRegister,
                 .getInfo,
                 .check,
                 .checkVerifyCode:
                return .get
            default:
                return .post
            }
        }
        
        var path: String {
            switch self {
            case .check(let userName):
                return "api/v2/user/checkUserName/\(userName)"
            case .getVerifyCodeForRegister(let phone):
                return "api/v2/user/captcha/true/\(phone)"
            case .getVerifyCode(let phone):
                return "api/v2/user/captcha/false/\(phone)"
            case .checkVerifyCode(let phone, let code):
                return "api/v2/user/checkcaptcha/\(phone)/\(code)"
            case .login:
                return "api/v2/user/login"
            case .wxLogin(let code):
                return "api/v2/user/wxLongin/\(code)"
            case .bindPhone(let phone, let code):
                return "api/v2/user/wxPhone/\(phone)/\(code)"
            case .register:
                return "api/v2/user/reg"
            case .getInfo:
                return "api/v2/user/info"
            case .resetPassword:
                return "api/v2/user/passwordReminder"
            case .updatePassword:
                return "api/v2/user/updatePassword"
            case .updateInfo:
                return "api/v2/user/completeInfo"
            case .identity:
                return "api/v2/user/authentication/ident"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .login(let phone, let password):
                return ["phone": phone, "password": password]
            case .register(let phone, let password, let code):
                return ["phone": phone, "password": password, "captchaCode": code]
            case .resetPassword(let phone, let password, let code):
                return ["phone":phone,"captchaCode":code, "password":password]
            case .updatePassword(let oldPassword, let password):
                return ["oldPassword":oldPassword, "password":password]
            case .updateInfo(let avatar, let userName, let bio,let gender):
                return ["image":avatar,"userName":userName,"signature":bio,"gender":gender]
            case .identity(let info):
                return info
            default:
                return nil
            }
        }
    }
}
