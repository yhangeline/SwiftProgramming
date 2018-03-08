//
//  OrdersViewModel.swift
//  Precious
//
//  Created by zhubch on 2018/1/21.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class OrdersViewModel: ViewModel {
    var router: Routable {
        if seller {
            return Router.Order.sellerOrders(status: status, page: page)
        }
        return Router.Order.sellerOrders(status: status, page: page)
    }
    let status: IntArray
    let seller: Bool
    var page = 0
    
    init(status: IntArray, seller: Bool = false) {

        self.status = status
        self.seller = seller
        super.init()
        modelCellType = (Order.self,OrderCell.self)
    }
    
    override func loadData() {
        self.loadingStatus = .loading
        
        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                if let arr = json["list"].array {
                    self.sections = [arr.map{ Order(json:$0) }]
                }
                self.loadingStatus = .success
            } else {
                self.sections = []
                self.loadingStatus = .error
            }
            self.listView?.reload()
        }
    }
}
