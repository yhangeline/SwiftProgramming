//
//  AuctionDetailViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/16.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AuctionDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var salesName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var goodsCount: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var tableHeader: UIView!

    var viewModel: AuctionDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }

    func setupViewModel() {
                
        viewModel.willReloadListHandler = { [weak self] _ in
            guard let this = self else { return }
            this.setupViews()
        }
        viewModel.didSelectModelHandler = { [weak self] model in
            guard let this = self else { return }
            this.performSegue(withIdentifier: "goods_detail", sender: model)
        }
        viewModel.didScrollHandler = { [weak self] scrollView in
            guard let this = self else { return }
            let offset = max(scrollView.contentOffset.y , 0)
            this.navigationBar.alpha =  offset / (this.avatar.h - C.statusBarHeight)
        }
        tableView.viewModel = viewModel
        viewModel.loadData()
    }
    
    func setupViews() {
        let auction = viewModel.auction
        title = auction.salesName
        avatar.setImageWith(url: auction.image)
        userAvatar.setImageWith(url: auction.userImage, placeholder: #imageLiteral(resourceName: "img_default_head"))
        salesName.text = auction.salesName
        userName.text = auction.userName
        time.text = auction.startTime?.toDate?.readableString() ?? "--"
        detail.text = auction.remark
        goodsCount.text = auction.goodsList.count.toString
        money.text = auction.deposit?.toShortMoney ?? "--"
        liveButton.setTitle(auction.isOwn ? "开始直播" : "进入直播间", for: .normal)
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        
        navigationBar.alpha = 0
        
        navigationBar.rightButtonConfigure1 = NavButtonConfigure(darkImage: #imageLiteral(resourceName: "icon_common_nav_share"), lightImage: #imageLiteral(resourceName: "icon_common_nav_share")) { _ in
            let share = Share()
            share.title = self.viewModel.auction.salesName
            share.url = URL(string:"https://www.baidu.com/")
            share.image = self.avatar.image
            share.content = self.viewModel.auction.remark
            self.showShare(share: share)
        }
        
        navigationBar.rightButtonConfigure2 = NavButtonConfigure(darkImage:#imageLiteral(resourceName: "icon_common_nav_collect"), lightImage: #imageLiteral(resourceName: "icon_common_nav_collect")) { _ in
            print("collect")
        }
    }
    
    @IBAction func entryStore(_ sender: UIButton) {
        sender.startLoadingAnimation()
        let store = Store()
        store.id = viewModel.auction.storeId
        store.refresh { store in
            let vc = C.Storyboard.Store.instantiateVC(StoreViewController.self)!
            vc.store = store
            self.pushVC(vc)
            sender.stopLoadingAnimation()
        }
    }
    
    @IBAction func entryLive(_ sender: UIButton) {
        func segueToLive() {
            sender.startLoadingAnimation()
            API.loadJSON(Router.Auction.liveInfo(id: self.viewModel.auction.id)) { (response) in
                if case .success(let json) = response {
                    let live = LiveInfo(json: json)
                    if live.pullStreamUrl == nil && !self.viewModel.auction.isOwn {
                        showMessage("直播未开始")
                        return
                    }
                    if live.pushStreamUrl == nil && self.viewModel.auction.isOwn {
                        showMessage("暂时无法开始直播")
                        return
                    }
                    self.performSegue(withIdentifier: "live", sender: live)
                } else if case .failure(let err) = response {
                    showMessage(err)
                }
                sender.stopLoadingAnimation()
            }
        }
        if viewModel.auction.isOwn {
            segueToLive()
            return
        }
        
        showActionSheet(title: "请选择参拍身份", message: nil, actionTitles: ["匿名参拍","实名参拍"]) { index in
            segueToLive()
        }
    }
    
    @IBAction func toggleFold(_ sender: UIButton) {
        sender.isSelected = sender.isSelected.toggled
        detail.numberOfLines = sender.isSelected ? 0 : 2
        self.tableHeader.h = 180 + C.windowWidth * 0.64 + detail.sizeThatFits(CGSize(width: detail.w, height: 1000)).height
        self.tableView.reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LiveViewController {
            vc.auction = viewModel.auction
            vc.liveInfo = sender as! LiveInfo
        }
        if let vc = segue.destination as? GoodsDetailViewController, let goods = sender as? Goods{
            vc.auction = viewModel.auction
            vc.goods = goods
        }
    }
    
}
