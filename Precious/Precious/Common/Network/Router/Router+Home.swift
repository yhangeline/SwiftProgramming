
//
//  Router+Home.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

extension Router {
    enum Home: Routable {
        case list
        
        var method: RequestMethod {
            switch self {
            default:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .list:
                return "api/v2/entity/firstpage"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            default:
                return nil
            }
        }
    }
}
