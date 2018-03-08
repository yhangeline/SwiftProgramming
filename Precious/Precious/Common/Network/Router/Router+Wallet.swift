//
//  Router+Wallet.swift
//  Precious
//
//  Created by zhubch on 2018/2/23.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

extension Router {
    enum Wallet: Routable {
        case detail
        case wxPay(dest:Int, amount:Double)
        case aliPay(dest:Int, amount:Double)
        case depositDraw(amount:Double)
        
        var method: RequestMethod {
            switch self {
            case .wxPay,
                 .aliPay,
                 .depositDraw:
                return .post
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .detail:
                return "api/v2/account/myAccount"
            case .wxPay:
                return "api/v2/account/pay"
            case .aliPay:
                return "api/v2/account/pay"
            case .depositDraw:
                return "api/v2/account/depositDraw"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .aliPay(let dest, let amount):
                return ["discAccount": dest,"payAmt": amount,"payType": 3]
            case .wxPay(let dest, let amount):
                return ["discAccount": dest,"payAmt": amount,"payType": 2]
            case .depositDraw(let amount):
                return ["amt":amount]
            default:
                return nil
            }
        }
    }
}
