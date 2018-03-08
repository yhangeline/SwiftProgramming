//
//  AuctionsViewModel.swift
//  Precious
//
//  Created by zhubch on 2017/12/20.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AuctionsViewModel: ViewModel {
        
    let router: Routable
    
    let realTime: Bool
    
    let showStatus: Bool

    init(status: IntArray, realTime: Bool = true , all: Bool = false, userId: String? = nil) {
        if all {
            if realTime {
                router = Router.Auction.realTime(status: status, page: 0)
            } else {
                router = Router.Auction.limitTime(status: status, page: 0)
            }
        } else {
            if realTime {
                router = Router.Store.realTime(userId: userId, status: status, page: 0)
            } else {
                router = Router.Store.limitTime(userId: userId, status: status, page: 0)
            }
        }
        self.realTime = realTime
        self.showStatus = all == false && userId == nil
        super.init()
        
        if realTime {
            modelCellType = (Auction.self,AuctionCell.self)
        } else {
            modelCellType = (Auction.self,LimitTimeCell.self)
            cellWidth = (C.windowWidth - 42) / 2
            cellHeight = cellWidth * 1.373
            cellInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }
    }
    

    override func loadData() {
        self.loadingStatus = .loading
        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                if let arr = json["list"].array {
                    self.sections = [arr.map{ Auction(json:$0) }]
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
