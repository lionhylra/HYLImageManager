//
//  UIImage+Compress.swift
//  HYLMultiImagesViewControllerDemo
//
//  Created by HeYilei on 21/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit

extension UIImage{
    static public func compressImage(image:UIImage, withMaxWidth maxWidth:CGFloat, maxHeight:CGFloat, quality:CGFloat) -> UIImage!{
        var actualHeight = image.size.height
        var actualWidth = image.size.width
        var _maxWidth = maxWidth
        var _maxHeight = maxHeight
        var _quality = quality
        if _maxWidth == 0.0 && _maxHeight == 0.0 {
            _maxHeight = actualHeight
            _maxWidth = actualWidth
        }else if _maxHeight == 0 {
            _maxHeight = _maxWidth * actualHeight / actualWidth
        }else if _maxWidth == 0 {
            _maxWidth = _maxHeight * actualWidth / actualHeight
        }
        
        var imgRatio = actualWidth / actualHeight
        let maxRatio = _maxWidth / _maxHeight
        
        if _quality > 1.0 {
            _quality = 1.0
        }
        if _quality < 0 {
            _quality = 0.0
        }
        
        if (actualHeight > _maxHeight || actualWidth > _maxWidth)
        {
            if (imgRatio < maxRatio)
            {
                //adjust width according to maxHeight
                imgRatio = _maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = _maxHeight
            }
            else if (imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = _maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = _maxWidth
            }
            else
            {
                actualHeight = _maxHeight
                actualWidth = _maxWidth
            }
        }
        
        let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.drawInRect(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img, _quality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)
    }
    
}