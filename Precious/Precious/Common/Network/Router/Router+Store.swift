//
//  Router+Store.swift
//  Precious
//
//  Created by zhubch on 2018/1/1.
//  Copyright © 2018年 zhubch. All rights reserved.
//

extension Router {
    enum Store: Routable {
        case myStore
        case detail(id: String)
        case realTime(userId:String?, status: IntArray, page: Int)
        case limitTime(userId:String?, status: IntArray, page: Int)
        case goods(userId:String?, status: IntArray, page: Int)
        
        var method: RequestMethod {
            switch self {
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .myStore:
                return "api/v2/entity/mystore"
            case .detail(let id):
                return "api/v2/entity/store/\(id)"
            case .goods:
                return "api/v2/entity/goodslist"
            case .realTime,
                 .limitTime:
                return "api/v2/entity/salesroomlist"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .goods(let userId,let status, let page):
                if let id = userId {
                    return ["userId":id, "status":status.toString, "pageNo":page]
                }
                return ["status":status.toString, "pageNo":page]
            case .realTime(let userId,let status, let page):
                if let id = userId {
                    return ["userId":id, "status":status.toString, "pageNo":page, "saleroomTypes":"2,3"]
                }
                return ["status":status.toString, "pageNo":page,"saleroomTypes":"2,3"]
            case .limitTime(let userId,let status, let page):
                if let id = userId {
                    return ["userId":id, "status":status.toString, "pageNo":page, "saleroomTypes":"1"]
                }
                return ["status":status.toString, "pageNo":page, "saleroomTypes":"1"]
            default:
                return nil
            }
        }
    }
}


