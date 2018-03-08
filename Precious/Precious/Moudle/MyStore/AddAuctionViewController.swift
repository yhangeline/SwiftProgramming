//
//  AddAuctionViewController.swift
//  Precious
//
//  Created by zhubch on 2017/12/31.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

class AddAuctionViewController: BaseViewController, ImagePicker {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!

    @IBOutlet weak var imageButton: UIButton!

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var keywordField: UITextField!
    @IBOutlet weak var descField: UITextField!

    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var guaranteeButton: UIButton!
    
    var picker: UIView = UIView()
    
    var auction = Auction()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "申请拍场"
        tableView.register(SimpleGoodsCell.nib, forCellReuseIdentifier: "goods")
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func setupUI() {
        titleField.text = auction.salesName
        descField.text = auction.remark
        keywordField.text = auction.keyWords
        timeButton.setTitle(auction.startTime, for: .normal)
        priceButton.setTitle(auction.estimateAmt, for: .normal)
        guaranteeButton.setTitle(auction.deposit?.toString, for: .normal)
    }
    
    func save() {
        auction.salesName = titleField.text!
        auction.remark = descField.text!
        auction.keyWords = keywordField.text
        auction.startTime = timeButton.currentTitle
        auction.deposit = guaranteeButton.currentTitle?.toInt()
        auction.estimateAmt = priceButton.currentTitle ?? ""
    }
    
    func didPickImage(_ image: UIImage) {
        self.imageButton.startLoadingAnimation()
        API.uploadImage(image) { (response) in
            if case .success(let urls) = response {
                self.imageButton.setImage(url: urls.first, completion: { _ in
                    self.imageButton.imageEdgeInsets = UIEdgeInsets()
                })
                self.auction.image = urls.first
            }
            self.imageButton.stopLoadingAnimation()
        }
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        pickImage()
    }
    
    @IBAction func chooseTime(_ sender: UIButton) {
        focus()
        let v = UIDatePicker()
        popUp(v, cancel: { _ in
            self.unfocus()
        }) { (v) in
            sender.setTitle(v.date.formatDate, for: .normal)
            self.unfocus()
        }
    }
    
    @IBAction func choosePrice(_ sender: UIButton) {
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
    
    @IBAction func chooseGuarantee(_ sender: UIButton) {
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
        self.bottomSpace.constant = 200
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        tableView.scrollToBottom(240)
    }
    
    func unfocus() {
        self.bottomSpace.constant = 8
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        save()
        let dict = auction.dict!
        
        var router = Router.Auction.draft(auction: dict)
        if sender.tag == 1 {
            router = Router.Auction.apply(auction: dict)
        }
        API.loadJSON(router) { (response) in
            if case .success(_) = response {
                self.popVC()
            } else if case .failure(let err) = response {
                showMessage(err)
            }
        }
    }
    
    @IBAction func addGoods(_ sender: UIButton) {
        showActionSheet(actionTitles: ["添加宝贝","从我的宝贝中选择"]) { (index) in
            let segue = index == 0 ? "new_goods" : "choose_goods"
            self.performSegue(withIdentifier: segue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddGoodsViewController {
            vc.completionHandler = { goods in
                self.auction.goodsList.append(goods)
                self.auction.goodsIds.append(goods.id)
                self.tableView.insert(at: IndexPath(row: self.auction.goodsList.count - 1, section: 0))
                self.tableView.scrollToBottom()
            }
        }
        if let vc = segue.destination as? GoodsViewController {
            vc.selectMode = true
            vc.viewModel = GoodsViewModel(status: [Goods.Status.toGround])
            vc.completionHandler = { goods in
                self.auction.goodsList.append(contentsOf: goods)
                self.auction.goodsIds.append(contentsOf: goods.map{$0.id})
                self.tableView.reload()
                self.tableView.scrollToBottom()
            }
        }
    }
}

extension AddAuctionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auction.goodsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goods", for: indexPath)
        let model = auction.goodsList[indexPath.row]
        cell.setValue(model, forKey: "model")
        return cell
    }
}
