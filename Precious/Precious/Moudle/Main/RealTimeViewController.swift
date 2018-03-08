//
//  RealTimeViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/19.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class RealTimeViewController: BaseViewController, UIScrollViewDelegate {
    @IBOutlet weak var appointmentButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    let enableFont = C.Font.medium.M
    let disableFont = C.Font.medium.XXL

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = [C.Color.white, C.Color.background].gradient { gradient in
            gradient.locations = [0, 1]
            return gradient
        }
        gradient.frame = view.layer.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        selectButton(appointmentButton)
        disSelectButton(historyButton)
    }
    
    @IBAction func appointment(_ sender: UIButton) {
        selectButton(appointmentButton)
        disSelectButton(historyButton)
        scrollView.setContentOffset(CGPoint(), animated: true)
    }
    
    @IBAction func history(_ sender: UIButton) {
        disSelectButton(appointmentButton)
        selectButton(historyButton)
        scrollView.setContentOffset(CGPoint(x:scrollView.w, y:0), animated: true)
    }
    
    func selectButton(_ button: UIButton) {
        button.isEnabled = false
        button.titleLabel?.font = disableFont
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func disSelectButton(_ button: UIButton) {
        button.isEnabled = true
        button.titleLabel?.font = enableFont
        button.contentEdgeInsets = UIEdgeInsetsMake(3, 0, -3, 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x + 1 > scrollView.w {
            disSelectButton(appointmentButton)
            selectButton(historyButton)
        } else {
            selectButton(appointmentButton)
            disSelectButton(historyButton)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AuctionsViewController
        var status = [Auction.Status.sold]
        if segue.identifier! == "appointment" {
            status = [.selling,.toSell]
        }
        vc.viewModel = AuctionsViewModel(status: status ,all: true)
    }
}
