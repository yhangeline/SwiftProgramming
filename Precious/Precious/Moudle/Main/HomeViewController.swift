//
//  HomeViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/13.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import Hue

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = [C.Color.white, C.Color.background].gradient { gradient in
            gradient.locations = [0, 1]
            return gradient
        }
        gradient.frame = view.layer.bounds
        view.layer.insertSublayer(gradient, at: 0)
        setupViewModel()
        tableView.viewModel = viewModel
    }

    func setupViewModel() {
        viewModel.didSelectModelHandler = { [weak self] model in
            if let auction = model as? Auction {
                self?.performSegue(withIdentifier: "auction", sender: auction)
            }
        }
        viewModel.configureCellHandler = { [weak self] cell, _ in
            if let auctionCell = cell as? AuctionCell {
                auctionCell.statusIcon.isHidden = true
                auctionCell.status.isHidden = true
            }
            if let goodsArrayCell = cell as? GoodsArrayCell {
                goodsArrayCell.didSelectedGoods = { goods in
                    self?.startLoadingAnimation()
                    goods.auction.refresh{
                        guard let auction = $0 else { return }
                        self?.stopLoadingAnimation()
                        self?.performSegue(withIdentifier: "goods", sender: (auction,goods))
                    }
                }
            }
            if let limitsArrayCell = cell as? LimitsArrayCell {
                limitsArrayCell.didSelectedAuction = { auction in
                    self?.performSegue(withIdentifier: "auction", sender: auction)
                }
            }
        }
        viewModel.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AuctionDetailViewController {
            vc.viewModel = AuctionDetailViewModel(auction: sender as! Auction)
        }
        if let vc = segue.destination as? GoodsDetailViewController {
            let params = sender as!(Auction,Goods)
            vc.goods = params.1
            vc.auction = params.0
        }
    }
}
