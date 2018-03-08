//
//  MyGoodsViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/24.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class MyGoodsViewController: BaseViewController,UIScrollViewDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var buttonGroup: ButtonGroup!
    var goodsVc: GoodsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的宝贝"
        buttonGroup = ButtonGroup(buttons: [button1,button2,button3])
        buttonGroup.selectedChanged = {
            self.scrollView.setContentOffset(CGPoint(x:$0.toCGFloat * C.windowWidth,y:0), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isMovingToParentViewController {
            goodsVc.viewModel.loadData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        buttonGroup.selectedIndex = Int((scrollView.contentOffset.x + 1) / C.windowWidth)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GoodsViewController else {
            return
        }
        var status = [Goods.Status.sold]
        switch segue.identifier! {
        case "willSell":
            status = [.toGround]
            goodsVc = vc
        case "selling":
            status = [.grounding]
        default:
            status = [.sold]
        }
        vc.viewModel = GoodsViewModel(status: status)
    }

}
