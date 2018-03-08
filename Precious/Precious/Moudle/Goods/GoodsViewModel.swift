//
//  GoodsViewModel.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class GoodsViewModel: ViewModel {
    
    let router: Routable
    
    init(status: IntArray, all: Bool = false, userId: String? = nil) {
        if all {
            router = Router.Store.goods(userId: userId, status: status, page: 0)
        } else {
            router = Router.Store.goods(userId: userId, status: status, page: 0)
        }
        
        super.init()
        modelCellType = (Goods.self,SimpleGoodsCell.self)
    }
    
    override func loadData() {
        self.loadingStatus = .loading

        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                if let arr = json["list"].array {
                    self.sections = [arr.map{ Goods(json:$0) }]
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
