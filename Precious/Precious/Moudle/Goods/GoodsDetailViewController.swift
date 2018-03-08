//
//  GoodsDetailViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/19.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

class GoodsDetailViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarScrollView: UIScrollView!
    @IBOutlet weak var goodListView: GoodsListView!
    @IBOutlet weak var statusView: UIView!

    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var looksLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var initPrice: UILabel!
    @IBOutlet weak var deposit: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var priceStep: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var bidContainer: UIView!
    @IBOutlet weak var bidContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var bidHistoryButton: UIButton!
    @IBOutlet weak var goodsPannelHeight: NSLayoutConstraint!

    let bidView = BidPriceView.instance()

    let videoView = UIView(x: 0, y: 0, w: C.windowWidth, h: C.windowHeight)
    
    var auction: Auction!
    var goods: Goods!
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        if goods.imageList.count > 0 {
            self.setupView()
            return
        }
        startLoadingAnimation()
        goods.refresh { _ in
            self.setupView()
            self.stopLoadingAnimation()
        }
    }
    
    override func navigationBarDidLoad() {
        super.navigationBarDidLoad()
        
        navigationBar.rightButtonConfigure1 = NavButtonConfigure(darkImage: #imageLiteral(resourceName: "icon_common_nav_share"), lightImage: #imageLiteral(resourceName: "icon_common_nav_share")) { _ in
            let share = Share()
            self.showShare(share: share)
        }
        
        scrollView.rx.contentOffset.map {
            let offset = $0.y > 0 ? $0.y : 0
            return offset / (C.windowWidth - C.statusBarHeight - 44)
            }.bind(to: navigationBar.rx.alpha).disposed(by: disposeBag)
    }

    func setupView() {
        bag = DisposeBag()
        
        if goods.imageList.count == 0 {
            goods.imageList.append("")
        }
        
        let count = goods.imageList.count
        
        avatarScrollView.removeSubviews()
        for i in 0..<count {
            let imgView = UIImageView(frame: CGRect(x: C.windowWidth * i.toCGFloat, y: 0, w: C.windowWidth, h: C.windowWidth))
            imgView.setImageWith(url: goods.imageList[i])
            avatarScrollView.addSubview(imgView)
        }
        
        avatarScrollView.contentSize = CGSize(width: count.toCGFloat*C.windowWidth, height: 0)
        
        avatarScrollView.rx.contentOffset.map{
            ("\(Int(($0.x + 1) / C.windowWidth) + 1)".whole.setFont(C.Font.normal.XL) + "/\(count)".whole.setFont(C.Font.normal.S)).toAttributedString
        }.bind(to: indicatorLabel.rx.attributedText).disposed(by: bag)
        
        title = goods.name
        name.text = goods.name
        initPrice.text = goods.initPrice.toShort
        deposit.text = auction.deposit?.toShortMoney
        marketPrice.text = goods.marketPrice.toShortMoney
        priceStep.text = goods.priceStep.toShortMoney
        detail.text = goods.remark
        looksLabel.text = "\(goods.looksCount)人围观"
        userName.text = goods.userName
        userAvatar.setImageWith(url: goods.userImage)
        time.text = auction.startTime?.toDate?.readableString() ?? "--"

        statusView.subviews.forEach { $0.isHidden = $0.tag != goods._status.intValue }
        
        goodListView.didSelectedGoods = { [unowned self] in
            self.goods = $0
            self.setupView()
        }
        
        if auction._type == .limit {
            goodsPannelHeight.constant = 0
            bidView.auction = self.auction
            bidView.goods = self.goods
            bidContainer.addSubview(bidView)
        } else {
            bidContainerHeight.constant = 0
            bidHistoryButton.isHidden = true
            goodListView.goods = auction.goodsList
            goodsPannelHeight.constant = (C.windowWidth - 40) * 174 / 360 + 80
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bidView.frame = bidContainer.bounds
    }
    
    @IBAction func toggleFold(_ sender: UIButton) {
        sender.isSelected = sender.isSelected.toggled
        detail.numberOfLines = sender.isSelected ? 0 : 5
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func entryStore(_ sender: UIButton) {
        sender.startLoadingAnimation()
        let store = Store()
        store.id = goods.storeId
        store.refresh { store in
            let vc = C.Storyboard.Store.instantiateVC(StoreViewController.self)!
            vc.store = store
            self.pushVC(vc)
            sender.stopLoadingAnimation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PriceRecordViewController {
            vc.auction = self.auction
            vc.goods = self.goods
        }
    }
}
