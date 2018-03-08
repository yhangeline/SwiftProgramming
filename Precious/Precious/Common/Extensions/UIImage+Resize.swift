//
//  UIImage+Resize.swift
//  Precious
//
//  Created by zhubch on 2017/12/23.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit

extension UIImage {
    enum UIImageResizeOption {
        case scaleAspectFit
        case scaleAspectFill
    }
    
    // 保持比例调整，调整方式 option参数: scaleAspectFit 调整后的图片大小刚好能包裹住size
    //                               scaleAspectFill 调整后的图片大小刚好能被size包裹
    func resize(_ size: CGSize, option: UIImageResizeOption) -> UIImage? {
        var newSize = self.size
        
        let w = newSize.width / size.width
        let h = newSize.height / size.height
        
        if (w > h && option == .scaleAspectFit) || (w < h && option == .scaleAspectFill)  {
            newSize = CGSize(width: size.width, height: size.width / newSize.width * newSize.height)
        } else {
            newSize = CGSize(width: size.height / newSize.height * newSize.width, height: size.height)
        }
        
        return scale(to: newSize)
    }
    
    // 不保持比例，直接调整到newSize大小
    func scale(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: CGPoint(), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func crop(bounds: CGRect) -> UIImage? {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }
    
    // 裁成正方形
    func cropToSquare() -> UIImage? {
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        
        let left: CGFloat = (size.width > shortest) ? (size.width - shortest) / 2 : 0
        let top: CGFloat = (size.height > shortest) ? (size.height - shortest) / 2 : 0
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = rect.insetBy(dx: left, dy: top)
        
        return crop(bounds: insetRect)
    }
    
    func imageByAdd(leftPadding: CGFloat) -> UIImage {
        let adjustSizeForBetterHorizontalAlignment: CGSize = CGSize(
            width: size.width + leftPadding,
            height: size.height
        )
        
        let image: UIImage
        
        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0)
        draw(at: CGPoint(x: leftPadding, y: 0))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    var origin: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
    
}
