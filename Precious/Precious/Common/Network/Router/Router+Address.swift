//
//  Router+Address.swift
//  Precious
//
//  Created by zhubch on 2018/1/23.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

extension Router {
    enum Address: Routable {
        
        case list(page: Int)
        case setDefault(id: String)
        case detail(id:String)
        case add(address:[String:Any])
        case edit(address:[String:Any])
        case delete(id:String)

        var method: RequestMethod {
            switch self {
            case .setDefault,
                 .add,
                 .edit,
                 .delete:
                return .post
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .list:
                return "api/v2/user/address/myAddressList"
            case .detail(let id):
                return "api/v2/user/address/getAddress/\(id)"
            case .setDefault(let id):
                return "api/v2/user/address/setDefaultAddress/\(id)"
            case .add:
                return "api/v2/user/address/addAddress"
            case .edit:
                return "api/v2/user/address/editAddress"
            case .delete(let id):
                return "api/v2/user/address/deleteAddress/\(id)"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .list(let page):
                return ["pageNo":page]
            case .add(let address):
                return address
            case .edit(let address):
                return address
            default:
                return nil
            }
        }
    }
}
