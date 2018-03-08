//
//  Router+Order.swift
//  Precious
//
//  Created by zhubch on 2018/1/21.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

extension Router {
    enum Order: Routable {

        case buyerOrders(status:IntArray, page:Int)
        case sellerOrders(status:IntArray,page:Int)
        case detail(id:String)
        case bid(goodsId:String,price:Int,auctionId:String)
        
        var method: RequestMethod {
            switch self {
            case .bid:
                return .post
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .buyerOrders:
                return "api/v2/order/buyer"
            case .sellerOrders:
                return "api/v2/order/seller"
            case .detail(let id):
                return "api/v2/order/order/\(id)"
            case .bid:
                return "api/v2/order/bid"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .buyerOrders(let status, let page):
                return ["status":status.toString, "pageNo":page]
            case .sellerOrders(let status, let page):
                return ["status":status.toString, "pageNo":page]
            case .bid(let goodsId, let price, let auctionId):
                return ["goodsId": goodsId,"price": price,"salesroomId": auctionId]
            default:
                return nil
            }
        }
    }
}

