//
//  StoreViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class StoreViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var bigAvatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    let auctions = C.Storyboard.Auction.instantiateVC(AuctionsViewController.self)!
    let goods = C.Storyboard.Goods.instantiateVC(GoodsViewController.self)!
    
    var store: Store!

    let scrollView = UIScrollView()
    
    var auctionListView: UIScrollView {
        return auctions.tableView
    }
    
    var goodsListView: UIScrollView {
        return goods.tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        let contentH = C.windowHeight - 48 - navigationBar.h
        scrollView.frame = CGRect(x: 0, y: 0, w: C.windowWidth, h: contentH)
        
        auctions.viewModel = AuctionsViewModel(status: [Auction.Status.toSell], userId: User.current?.id)
        auctions.viewModel.didScrollHandler = configure(_:)

        goods.viewModel = GoodsViewModel(status: [Goods.Status.selling], userId: User.current?.id)
        goods.viewModel.didScrollHandler = configure(_:)

        let vcArray = [auctions,goods]
        vcArray.forEachEnumerated { (i, vc) in
            vc.view.frame = CGRect(x: i.toCGFloat * C.windowWidth,
                                   y: 0,
                                   w: C.windowWidth,
                                   h: contentH)
            self.addAsChildViewController(vc, toView: self.scrollView)
        }

        scrollView.contentSize = CGSize(width: C.windowWidth * vcArray.count.toCGFloat, height: 0)
        scrollView.isPagingEnabled = true
        
        auctionListView.isScrollEnabled = false
        goodsListView.isScrollEnabled = false
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        self.navigationBar.alpha = 0
        tableView.rx.contentOffset.map {
            let offset = max($0.y , 0)
            return offset / (200 - C.statusBarHeight - 44)
            }.bind(to: navigationBar.rx.alpha).disposed(by: disposeBag)
    }
    
    func configure(_ scrollView: UIScrollView) {
        if !self.tableView.isReachedBottom {
            scrollView.contentOffset = CGPoint()
            scrollView.isScrollEnabled = false
        } else if scrollView.isReachedTop && scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.contentOffset = CGPoint()
        }
    }
    
    func loadData() {
        startLoadingAnimation()
        let router = Router.Store.detail(id: "")
        API.loadJSON(router) { (response) in
            self.stopLoadingAnimation()
            if case .success(let json) = response {
                self.store = Store(json: json)
                self.setupUI()
            } else if case .failure(let err) = response{
                showMessage(err)
            }
        }
    }
    
    func setupUI() {
        avatarView.setImageWith(url: store.storeLogo, placeholder: #imageLiteral(resourceName: "img_default_head"))
        bigAvatarView.setImageWith(url: store.storeLogo, placeholder: #imageLiteral(resourceName: "img_default_head"))
        nameLabel.text = "从夸克到宇宙"
        followCountLabel.text = "关注 \(User.current?.followCount ?? 0)"
        followerCountLabel.text = "粉丝 \(User.current?.followerCount ?? 0)"
        title = "从夸克到宇宙"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.addSubview(scrollView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 + 52.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let segment = StoreSegment.instance()
        segment.buttonGroup.selectedChanged = {
            self.scrollView.setContentOffset(CGPoint(x:$0.toCGFloat * C.windowWidth,y:0), animated: true)
        }
        return segment
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return C.windowHeight - 52 - navigationBar.h
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = max(scrollView.contentOffset.y , 0)
        navigationBar.alpha = offset / (200 - C.statusBarHeight - 44)
        auctionListView.isScrollEnabled = scrollView.isReachedBottom
    }
}

