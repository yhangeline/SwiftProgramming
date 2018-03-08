//
//  AddGoodsViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/31.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class AddGoodsViewController: BaseViewController, ImagePicker {
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var initPriceField: UITextField!
    @IBOutlet weak var marketPriceButton: UIButton!
    @IBOutlet weak var sellTimeButton: UIButton!
    @IBOutlet weak var priceStepButton: UIButton!
    @IBOutlet weak var goodsTypeButton: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var completionHandler: ((Goods)->Void)?

    override var shouldBack: Bool {
        doAfterUserSure(title: "还没有添加完成，确定要退出编辑？") {
            self.popVC()
        }
        return false
    }
    
    var goods = Goods()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加宝贝"
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        descTextView.rx.text.map{ ($0 ?? "").length > 0 }.bind(to: placeholderLabel.rx.isHidden).disposed(by: disposeBag)
    }
    
    func setupUI() {
        descTextView.text = goods.remark
        nameTextField.text = goods.name
        initPriceField.text = goods.initPrice.toString
        sellTimeButton.setTitle(goods.sellTime == nil ? "" : "\(goods.sellTime! / 60) 分钟", for: .normal)
        priceStepButton.setTitle(goods.priceStep.toString, for: .normal)
        goodsTypeButton.setTitle(goods.goodsTypeString, for: .normal)
        marketPriceButton.setTitle(goods.marketPrice.toString, for: .normal)
        reloadScrollView()
    }
    
    func save() {
        goods.remark = descTextView.text
        goods.name = nameTextField.text ?? ""
        goods.initPrice = initPriceField.text?.toInt() ?? 0
        goods.priceStep = priceStepButton.currentTitle?.toInt() ?? 0
        goods.marketPrice = marketPriceButton.currentTitle?.toInt() ?? 0
    }
    
    func didPickImage(_ image: UIImage) {
        scrollView.startLoadingAnimation()
        API.uploadImage(image) { (response) in
            self.scrollView.stopLoadingAnimation()
            if case .success(let urls) = response {
                self.goods.imageList.insertFirst(urls.first ?? "")
                self.reloadScrollView()
            }
        }
    }
    
    func reloadScrollView() {
        scrollView.removeSubviews()
        goods.imageList.forEachEnumerated { (i, url) in
            let imgView = UIImageView(frame: CGRect(x: CGFloat(i * 86), y: 0, w: 82, h: 82))
            imgView.cornerRadius = 4
            imgView.setImageWith(url: url)
            self.scrollView.addSubview(imgView)
        }
        let n = goods.imageList.count
        let button = BlockButton(x:CGFloat(n * 86), y: 0, w: 82, h: 82) { _ in
            self.pickImage()
        }
        let addIcon = UIImageView(image: #imageLiteral(resourceName: "icon_profile_addproduct"))
        addIcon.frame = CGRect(x: 30, y: 16, w: 20, h: 20)
        let addTip = UILabel(x: 0, y: 36, w: 82, h: 44)
        addTip.isUserInteractionEnabled = false
        addTip.text = "添加图片\n或视频"
        addTip.textColor = C.Color.gray
        addTip.font = C.Font.normal.SS
        addTip.textAlignment = .center
        addTip.numberOfLines = 0
        button.addSubviews([addIcon,addTip])
        button.cornerRadius = 4
        button.backgroundColor = C.Color.lightGray

        self.scrollView.addSubview(button)
        self.scrollView.contentSize = CGSize(width: n * 86 + 86, height: 0)
    }
    
    @IBAction func chooseTime(_ sender: UIButton) {
        focus()
        let items = ["1分钟","2分钟","3分钟","4分钟","5分钟"]
        let v = SimplePickerView(dataArray: items)
        
        popUp(v, cancel: { _ in
            self.unfocus()
        }) { (v) in
            sender.setTitle(v.selectedTitle, for: .normal)
            self.goods.sellTime = (v.selectedIndex + 1) * 60
            self.unfocus()
        }
    }
    
    @IBAction func chooseMarketPrice(_ sender: UIButton) {
        focus()
        let prices = ["10000","50000","100000","500000","1000000"]
        let v = SimplePickerView(dataArray: prices)
        popUp(v, cancel: { _ in
            self.unfocus()
        }) { (v) in
            sender.setTitle(v.selectedTitle, for: .normal)
            self.unfocus()
        }
    }
    
    @IBAction func chooseStepper(_ sender: UIButton) {
        focus()
        let prices = ["1000","2000","10000","50000","100000"]
        let v = SimplePickerView(dataArray: prices)
        popUp(v, cancel: { _ in
            self.unfocus()
        }) { (v) in
            sender.setTitle(v.selectedTitle, for: .normal)
            self.unfocus()
        }
    }
    
    @IBAction func chooseType(_ sender: UIButton) {
        focus()
        let v = SimplePickerView(dataArray: Goods.typeNames)
        popUp(v, cancel: { _ in
            self.unfocus()
        }) { (v) in
            sender.setTitle(v.selectedTitle, for: .normal)
            self.goods.goodsType = v.selectedIndex
            self.unfocus()
        }
    }
    
    @objc func keyboardChanged(_ notification: Notification)  {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                return
        }
        if C.windowHeight - frame.y < 1 {
            self.bottomSpace.constant = 8
        } else {
            self.bottomSpace.constant = frame.h - 48
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIViewAnimationOptions(rawValue: curve),
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
    
    func focus() {
        view.endEditing(true)
        self.bottomSpace.constant = 256
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        tableView.scrollToBottom()
    }
    
    func unfocus() {
        self.bottomSpace.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func addGoods(_ sender: UIButton) {
        save()
        sender.startLoadingAnimation()
        let router = Router.Goods.add(goods: goods.dict)
        API.loadJSON(router) { (response) in
            sender.stopLoadingAnimation()
            if case .success(let json) = response {
                self.completionHandler?(self.goods)
                self.popVC()
            } else if case .failure(let msg) = response {
                showMessage(msg)
            }
        }
    }
}
