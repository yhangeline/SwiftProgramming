//
//  URLNavigation.swift
//  Precious
//
//  Created by zhubch on 2018/3/7.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import URLNavigator

struct URLNavigation {
    static let navigator = Navigator()

    static func register() {
        navigator.register("zhenbao://auction/<id>") { url, values, context in
            guard let id = values["id"] as? String else { return nil }
            let vc = C.Storyboard.Auction.instantiateVC(AuctionDetailViewController.self)!
            let auction = Auction()
            auction.id = id
            vc.viewModel = AuctionDetailViewModel(auction: auction)
            return vc
        }
    }
}





