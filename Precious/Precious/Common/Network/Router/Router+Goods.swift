//
//  Router+Goods.swift
//  Precious
//
//  Created by zhubch on 2018/1/2.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

extension Router {
    enum Goods: Routable {
        case detail(id:String)
        case add(goods:[String: Any]?)

        var method: RequestMethod {
            switch self {
            case .add:
                return .post
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .add:
                return "api/v2/entity/newgoods"
            case .detail(let id):
                return "api/v2/entity/goods/\(id)"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .add(let goods):
                return goods
            default:
                return nil
            }
        }
    }
}


