//
//  GoodsDetailViewModel.swift
//  Precious
//
//  Created by zhubch on 2017/12/19.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class GoodsDetailViewModel: ViewModel {
    let goods: Goods
    
    init(goods: Goods) {
        self.goods = goods
        super.init()
    }
    
    override func loadData() {
        self.loadingStatus = .loading
        let router = Router.Auction.detail(id: goods.id)
        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                self.goods.setValue(with: json)
                self.loadingStatus = .success
                self.listView?.reload()
            } else {
                self.sections = []
                self.loadingStatus = .error
                self.listView?.reload()
            }
        }
    }
    
    var firstComment: String? {
        return nil
    }
}
