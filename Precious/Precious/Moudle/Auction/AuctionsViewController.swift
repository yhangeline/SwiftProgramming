//
//  AuctionsViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/20.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AuctionsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: AuctionsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.realTime {
            tableView.viewModel = viewModel
            collectionView.removeFromSuperview()
        } else {
            collectionView.viewModel = viewModel
            tableView.removeFromSuperview()
        }

        setupViewModel()
    }
    
    func setupViewModel() {
        viewModel.loadData()
        viewModel.didSelectModelHandler = { model in
            let auction = model as! Auction
            if self.viewModel.realTime {
                let vm = AuctionDetailViewModel(auction:auction)
                self.performSegue(withIdentifier: "detail", sender: vm)
            } else {
                self.performSegue(withIdentifier: "goods", sender: auction)
            }
        }
        viewModel.configureCellHandler = { cell, _ in
            if let auctionCell = cell as? AuctionCell {
                auctionCell.statusIcon.isHidden = !self.viewModel.showStatus
                auctionCell.status.isHidden = !self.viewModel.showStatus
            }
        }
        tableView.tableHeaderView = UIView(x: 0, y: 0, w: 0, h: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AuctionDetailViewController {
            vc.viewModel = sender as? AuctionDetailViewModel
        } else if let vc = segue.destination as? GoodsDetailViewController  {
            let auction = sender as! Auction
            vc.auction = auction
            vc.goods = auction.goodsList.first!
        }
    }
}
