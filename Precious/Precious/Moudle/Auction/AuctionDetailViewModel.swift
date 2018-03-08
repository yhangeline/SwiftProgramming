//
//  AuctionDetailViewModel.swift
//  Precious
//
//  Created by zhubch on 2017/12/16.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AuctionDetailViewModel: ViewModel {
    
    let auction: Auction
    
    init(auction: Auction) {
        self.auction = auction
        super.init()
        modelCellType = (Goods.self,SingleGoodsCell.self)
    }
    
    override func loadData() {
        self.loadingStatus = .loading
        let router = Router.Auction.detail(id: auction.id)
        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                self.auction.setValue(with: json)
                self.sections = [self.auction.goodsList]
                self.loadingStatus = .success
                self.listView?.reload()
            } else {
                self.sections = []
                self.loadingStatus = .error
                self.listView?.reload()
            }
        }
    }

    override func configureEmptySettings(settings: EmptySettings) {
        super.configureEmptySettings(settings: settings)
        settings.alwaysHidden = true
    }
}
