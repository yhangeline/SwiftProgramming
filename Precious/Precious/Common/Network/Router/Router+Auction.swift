//
//  Router+Sales.swift
//  Precious
//
//  Created by zhubch on 2017/12/16.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

extension Router {
    enum Auction: Routable {
        case detail(id:String)
        case draft(auction:[String: Any]?)
        case apply(auction:[String: Any]?)
        case realTime(status: IntArray, page: Int)
        case limitTime(status: IntArray, page: Int)
        case dispose(id:String)
        case liveInfo(id:String)
        
        var method: RequestMethod {
            switch self {
            case .draft,
                 .apply:
                return .post
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .draft:
                return "api/v2/entity/newsalesroom/true"
            case .apply:
                return "api/v2/entity/newsalesroom/false"
            case .detail(let id):
                return "api/v2/entity/salesroom/\(id)"
            case .dispose(let id):
                return "api/v2/account/deposit/\(id)"
            case .realTime,
                .limitTime:
                return "api/v2/entity/allSalesroomList"
            case .liveInfo(let id):
                return "api/v2/entity/liveInfo/\(id)"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .draft(let auction):
                return auction
            case .apply(let auction):
                return auction
            case .realTime(let status, let page):
                return ["saleroomTypes":2,"status":status.toString, "pageNo":page]
            case .limitTime(let status, let page):
                return ["saleroomTypes":1,"status":status.toString, "pageNo":page]
            default:
                return nil
            }
        }
    }
}

