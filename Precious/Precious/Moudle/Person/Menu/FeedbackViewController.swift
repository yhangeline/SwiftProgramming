//
//  FeedbackViewController.swift
//  Precious
//
//  Created by zhubch on 2018/3/2.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "意见反馈"
        textView.rx.text.map{($0 ?? "").length > 0}.bind(to: placeholderLabel.rx.isHidden).disposed(by: disposeBag)
    }

    @IBAction func commit(_ sender: UIButton) {
        
    }
}
