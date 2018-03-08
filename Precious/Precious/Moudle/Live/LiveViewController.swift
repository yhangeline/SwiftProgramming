//
//  LiveViewController.swift
//  Precious
//
//  Created by zhubch on 2018/1/7.
//  Copyright © 2018年 zhubch. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RxSwift

protocol LiveContent {
    var auction: Auction! { set get }
    func updateCountDown(_ sec: Int)
    func updateLookers(_ count: Int)
    func updateGoods(_ goods: Goods?)
    func appendMessage(_ msg: Message)
}

class LiveViewController: BaseViewController, ImagePicker, UITextFieldDelegate {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    var auction: Auction! {
        didSet {
            videoVC.auction = auction
            textVC.auction = auction
        }
    }
    
    var liveInfo: LiveInfo! {
        didSet {
            videoVC.liveInfo = liveInfo
        }
    }

    var goods: Goods?
    
    var connection: Connection!

    let videoVC = C.Storyboard.Live.instantiateVC(VideoViewController.self)!
    let textVC = C.Storyboard.Live.instantiateVC(TextViewController.self)!
    
    var current: LiveContent?

    override var showNavigationBar: Bool {
        return false
    }
    
    override func loadView() {
        super.loadView()
        
        addAsChildViewController(textVC, toView: containerView)
        addAsChildViewController(videoVC, toView: containerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goods = self.auction.goodsList.first!

        setupRx()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        let url = "ws://39.106.143.142:8080/ws/\(auction.id)?token=\(User.current?.token ?? "")"
        connection = Connection(url: url)
        connection.handler = self
    
        current = videoVC
        
        bidButton.isHidden = auction.isOwn
        startButton.isHidden = !auction.isOwn
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.subviews.first?.frame = containerView.bounds
    }
    
    func setupRx()  {
        commentTextField.rx.text.map{ ($0 ?? "").length > 0 }.bind(to: sendButton.rx.isEnabled).disposed(by: disposeBag)
        commentTextField.delegate = self
    }
    
    func didPickImage(_ image: UIImage) {
        self.startLoadingAnimation()
        API.uploadImage(image) { (response) in
            if case .success(let urls) = response {
                let msg = Message.comment("image", content: urls.first ?? "")
                self.connection.sendMessage(msg)
                self.commentTextField.resignFirstResponder()
            }
            self.stopLoadingAnimation()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (commentTextField.text?.length ?? 0) < 1 {
            return true
        }
        let msg = Message.comment("text", content: commentTextField.text!)
        self.connection.sendMessage(msg)
        commentTextField.text = ""
        return true
    }
    
    @IBAction func focusComment(_ sender: UIButton) {
        commentView.isHidden = false
        commentTextField.becomeFirstResponder()
    }
    
    @IBAction func choosePic(_ sender: UIButton) {
        pickImage()
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        commentTextField.resignFirstResponder()
    }
    
    @IBAction func toggle(_ sender: UIButton) {
        sender.isSelected = sender.isSelected.toggled
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationCurve(.easeIn)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationTransition(.flipFromLeft, for: containerView, cache: true)
        containerView.exchangeSubview(at: 1, withSubviewAt: 0)
        UIView.commitAnimations()
        
        if current is VideoViewController {
            current = textVC
        } else {
            current = videoVC
        }
    }
    
    @IBAction func bid(_ sender: UIButton) {
        let v = BidPriceView.instance()
        v.goods = self.goods
        v.auction = self.auction
        let dismiss = popUp(view: v, postion: .bottom)
        v.completionHandler = { _ in
            dismiss.dismiss()
        }
    }
    
    @IBAction func start(_ sender: UIButton) {

    }
    
    @objc func keyboardChanged(_ notification: Notification)  {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                return
        }
        var hideCommentView = false
        if C.windowHeight - frame.y < 1 {
            self.commentViewBottom.constant = 0
            hideCommentView = true
        } else {
            self.commentViewBottom.constant = -frame.h
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIViewAnimationOptions(rawValue: curve),
            animations: { self.view.layoutIfNeeded() },
            completion: { _ in
                self.commentView.isHidden = hideCommentView
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    deinit {
        connection.disconnect()
    }
}

extension LiveViewController: MessageHandler, LiveContent {
    
    func updateLookers(_ count: Int) {
        videoVC.updateLookers(count)
        textVC.updateLookers(count)
    }
    
    func updateCountDown(_ sec: Int) {
        videoVC.updateCountDown(sec)
        textVC.updateCountDown(sec)
    }
    
    func updateGoods(_ goods: Goods?) {
        self.goods = goods
        videoVC.updateGoods(goods)
        textVC.updateGoods(goods)
    }
    
    func appendMessage(_ msg: Message) {
        videoVC.appendMessage(msg)
        textVC.appendMessage(msg)
    }
    
    func handMessage(_ message: Message) {
        guard let data = message.data else { return }
        switch message.action {
        case .message:
            appendMessage(message)
        case .goods:
            let goods = Goods(json: data)
            updateGoods(goods)
        case .onlookersCount:
            auction.looksCount = data["content"].string?.toInt() ?? 0
            updateLookers(auction.looksCount)
        case .countDown:
            let sec = data.int ?? 0
            updateCountDown(sec)
        case .deal:
            let v = DealView.instance()
            v.name.text = message.user?.userName
            v.avatar.setImageWith(url: message.user?.image)
            v.price.text = data["price"].int?.toShortMoney ?? "￥---"
            popUp(view: v, postion: .center, dismissAfter: 5)
        default:
            break
        }
    }
}

protocol EventHandler: NSObjectProtocol {
    func tapedGoods()
    func tapedUser()
}

extension LiveViewController: EventHandler {
    func tapedUser() {
    
    }
    
    func tapedGoods() {
        
    }
}
