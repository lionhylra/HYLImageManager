//
//  UIImage+Compress.swift
//  HYLMultiImagesViewControllerDemo
//
//  Created by HeYilei on 21/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit

extension UIImage{
    static public func compressImage(image:UIImage, var withMaxWidth maxWidth:CGFloat, var maxHeight:CGFloat, var quality:CGFloat) -> UIImage!{
        var actualHeight = image.size.height
        var actualWidth = image.size.width
        
        if maxWidth == 0.0 && maxHeight == 0.0 {
            maxHeight = actualHeight
            maxWidth = actualWidth
        }else if maxHeight == 0 {
            maxHeight = maxWidth * actualHeight / actualWidth
        }else if maxWidth == 0 {
            maxWidth = maxHeight * actualWidth / actualHeight
        }
        
        var imgRatio = actualWidth / actualHeight
        let maxRatio = maxWidth / maxHeight
        
        if quality > 1.0 {
            quality = 1.0
        }
        if quality < 0 {
            quality = 0.0
        }
        
        if (actualHeight > maxHeight || actualWidth > maxWidth)
        {
            if (imgRatio < maxRatio)
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if (imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else
            {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.drawInRect(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img, quality)
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)
    }
    
}