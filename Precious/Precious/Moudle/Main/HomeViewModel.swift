//
//  HomeViewModel.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class HomeViewModel: ViewModel {
    
    var sectionTitle = [String]()
    
    override init() {
        super.init()
        reuseCell = false
        modelCellTypes = [
            (BannerArray.self,BannersCell.self),
            (Auction.self,AuctionCell.self),
            (LimitArray.self,LimitsArrayCell.self),
            (GoodsArray.self,GoodsArrayCell.self),
        ]
        
        viewForHeaderHandler = { section in
            if section == 0 {
                return nil
            }
            let header = HomeHeader.instance()
            header.title.text = self.sectionTitle[section]
            return header
        }
        
        heightForHeaderHandler = { section in
            return section == 0 ? 0.01 : 52
        }
        
        heightForFooterHandler = { _ in
            return 0.01
        }
    }
    
    override func loadData() {
        self.loadingStatus = .loading

        let router = Router.Home.list
        API.loadJSON(router) { (response) in
            if case .success(let json) = response {
                self.sections = self.parseJson(json: json)
                self.loadingStatus = .success
            } else if case .failure = response{
                self.sections = []
                self.loadingStatus = .error
            }
            self.listView?.endRefreshing()
            self.listView?.reload()
        }
    }
    
    func parseJson(json: JSONType) -> [[ListModel]] {
        var array = [[ListModel]]()
        sectionTitle.removeAll()
        if let bannerJson = json["eventList"].array {
            let banners = bannerJson.map{Banner(json:$0)}
            array.append([BannerArray(banners: banners)])
            sectionTitle.append("")
        }
        if let auctionJson = json["auctionList"].array {
            let auctions = auctionJson.map{Auction(json:$0)}
            array.append(auctions)
            sectionTitle.append("精品拍场")
        }
        if let limitAuctionJson = json["limitTimeAuctionList"].array {
            let auctions = limitAuctionJson.map{Auction(json:$0)}
            array.append([LimitArray(limits:auctions)])
            sectionTitle.append("限时拍卖")
        }
        if let goodsJson = json["auctionGoodList"].array {
            let goods = goodsJson.map{Goods(json:$0)}
            array.append([GoodsArray(goods:goods)])
            sectionTitle.append("精选拍品")
        }
        return array
    }

}
