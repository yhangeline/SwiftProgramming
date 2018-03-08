//
//  TakePartedViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class TakePartedViewController: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    var buttonGroup: ButtonGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我参与的"
        buttonGroup = ButtonGroup(buttons: [button1,button2,button3])
        buttonGroup.selectedChanged = {
            self.scrollView.setContentOffset(CGPoint(x:$0.toCGFloat * C.windowWidth,y:0), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        buttonGroup.selectedIndex = Int((scrollView.contentOffset.x + 1) / C.windowWidth)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GoodsViewController
        switch segue.identifier! {
        case "liked":
            vc.viewModel = GoodsViewModel(status: [Goods.Status.sold])
        case "comment":
            vc.viewModel = GoodsViewModel(status: [Goods.Status.sold])
        default:
            vc.viewModel = GoodsViewModel(status: [Goods.Status.sold])
        }
    }

}
