//
//  LoadMoreControl.swift
//  
//
//  Created by zhubch on 2017/6/30.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit
import RxSwift

class LoadMoreControl: UIView {
    
    var nextURL: URL?
    
    var dispose: Disposable?
    
    static var defaultControl: LoadMoreControl {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: C.windowWidth,
                           height: 1)
        
        let loadMoreControl = LoadMoreControl()
        loadMoreControl.frame = frame
        
        return loadMoreControl
    }
}
