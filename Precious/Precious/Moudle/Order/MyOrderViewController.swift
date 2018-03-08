
//
//  MyOrderViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/21.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class MyOrderViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var buttonGroup: ButtonGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "订单管理"
        buttonGroup = ButtonGroup(buttons: [button1,button2,button3,button4,button5])
        buttonGroup.selectedChanged = {
            self.scrollView.setContentOffset(CGPoint(x:$0.toCGFloat * C.windowWidth,y:0), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        buttonGroup.selectedIndex = Int((scrollView.contentOffset.x + 1) / C.windowWidth)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let vc = segue.destination as! OrdersViewController
        var status = [Auction.Status]()
        
        switch segue.identifier! {
        case "draft":
            status = [.draft,.rejected]
        case "review":
            status = [.reviewing]
        case "appointment":
            status = [.toSell]
        case "current":
            status = [.selling]
        default:
            status = [.sold]
        }
        vc.viewModel = OrdersViewModel(status: [1])
    }
}
