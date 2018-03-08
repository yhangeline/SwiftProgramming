//
//  EmptyView.swift
//  
//
//  Created by zhubch on 2017/6/30.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

class EmptySettings {
    var errorImage: UIImage? = nil
    var emptyImage: UIImage? = nil
    var errorTitle: String? = nil
    var emptyTitle: String? = nil
    var errorDesc: String? = nil
    var emptyDesc: String? = nil
    var errorButtonTitle: String? = nil
    var emptyButtonTitle: String? = nil
    var offset: CGFloat = 0
    var reloadHandler: (() -> Void)? = nil
    
    var alwaysHidden = false {
        didSet {
            emptyView?.alpha = alwaysHidden ? 0 : 1
        }
    }
    
    fileprivate var emptyView: EmptyView?
}

class EmptyView: UIView {

    enum EmptyStatus {
        case loading
        case error
        case success
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var verticalOffset: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIImageView! {
        didSet {
            loadingView.animationImages = [#imageLiteral(resourceName: "icon_common_loading1"),#imageLiteral(resourceName: "icon_common_loading2"),#imageLiteral(resourceName: "icon_common_loading3")]
            loadingView.animationDuration = 0.5
        }
    }
    @IBOutlet weak var contentView: UIView!

    var status: EmptyStatus = .loading {
        didSet {
            if self.settings.alwaysHidden {
                return
            }
            switch status {
            case .loading:
                contentView.isHidden = true
                loadingView.isHidden = false
                loadingView.startAnimating()
            case .error:
                contentView.isHidden = false
                loadingView.isHidden = true
                loadingView.stopAnimating()
                reset()
            case .success:
                contentView.isHidden = false
                loadingView.isHidden = true
                loadingView.stopAnimating()
                reset()
            }
        }
    }
    
    let settings = EmptySettings()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settings.emptyView = self
        self.status = .loading
        
        addTapGesture { [unowned self] _ in
            self.settings.reloadHandler?()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func reset() {
        imageView.image = status == .success ? settings.emptyImage : settings.errorImage
        titleLabel.text = status == .success ? settings.emptyTitle : settings.errorTitle
        descLabel.text = status == .success ? settings.emptyDesc : settings.errorDesc
        verticalOffset.constant = settings.offset
    }
    
}
