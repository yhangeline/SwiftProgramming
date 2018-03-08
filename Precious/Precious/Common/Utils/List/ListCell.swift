//
//  ListCell.swift
//  
//
//  Created by zhubch on 2017/6/30.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

protocol ListCell {}

extension ListCell {
    @nonobjc static var nib: UINib {
        let bundle = Bundle(for: self as! AnyClass)
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib
    }
}

extension UITableViewCell: ListCell {}

extension UICollectionViewCell: ListCell {}
