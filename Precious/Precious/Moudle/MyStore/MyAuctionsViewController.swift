//
//  MyAuctionsViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/24.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class MyAuctionsViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var buttonGroup: ButtonGroup!
    
    var auctionVc: AuctionsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的拍场"
        buttonGroup = ButtonGroup(buttons: [button1,button2,button3,button4])
        buttonGroup.selectedChanged = {
            self.scrollView.setContentOffset(CGPoint(x:$0.toCGFloat * C.windowWidth,y:0), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isMovingToParentViewController {
            auctionVc.viewModel.loadData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        buttonGroup.selectedIndex = Int((scrollView.contentOffset.x + 1) / C.windowWidth)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AuctionsViewController else {
            return
        }
        
        var status = [Auction.Status]()
    
        switch segue.identifier! {
        case "draft":
            status = [.draft,.rejected]
        case "review":
            status = [.reviewing]
            auctionVc = vc
        case "appointment":
            status = [.toSell]
        case "current":
            status = [.selling]
        default:
            status = [.sold]
        }
        vc.viewModel = AuctionsViewModel(status: status)
    }

}
