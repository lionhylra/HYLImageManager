//
//  HYLImageManager.swift
//  HYLMultiImagesViewControllerDemo
//
//  Created by HeYilei on 21/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit

public class HYLImageManager: NSObject {
    // MARK: - Public Properties
    public let maxSize:CGSize
    public let thumbnailMaxSize:CGSize
    public let compressionQuality:CGFloat
    public var rootPathComponents:[String]?{
        return self.fileManager.rootPathComponents
    }
    public var directory:NSSearchPathDirectory{
        return self.fileManager.directory
    }
    public var ignoreThumbnail:Bool = true
    public static let defaultManager = HYLImageManager()
    // MARK: - Private Properties
    private let fileManager:HYLFileManager
    private let thumbnailFileManager:HYLFileManager
    
    // MARK: - Initializers
    convenience override init() {
        self.init(directory: kDefaultDirectory)
    }
    
    convenience init(directory:NSSearchPathDirectory){
        self.init(directory:directory, pathComponents: [kDefaultPathComponent])
    }
    
    convenience init(directory:NSSearchPathDirectory, pathComponents:[String]?){
        self.init(directory:directory, pathComponents: pathComponents, maxSize: CGSizeZero)
    }
    
    convenience init(directory: NSSearchPathDirectory, pathComponents:[String]?, maxSize:CGSize) {
        self.init(directory: directory, pathComponents: pathComponents, maxSize: maxSize, thumbnailMaxSize: CGSizeZero, compressionQuality:1.0, ignoreThumbnail:true)
    }
    
    init(directory: NSSearchPathDirectory, pathComponents: [String]?, maxSize: CGSize, thumbnailMaxSize: CGSize, compressionQuality quality: CGFloat, ignoreThumbnail flag: Bool) {
        self.fileManager = HYLFileManager(directory: directory, rootPathComponents: pathComponents)
        var thumbnailPathComponents = pathComponents
        thumbnailPathComponents?.append("thumbnail")
        self.thumbnailFileManager = HYLFileManager(directory: directory, rootPathComponents:thumbnailPathComponents)
        self.maxSize = maxSize
        self.thumbnailMaxSize = thumbnailMaxSize
        self.compressionQuality = quality
        self.ignoreThumbnail = flag
        super.init()
    }
    
    // MARK: - Image Operation Methods
    public func pathForImageName(imageName:String) -> String? {
        return self.pathForImageName(imageName, isThumbnail: false)
    }
    
    public func pathForImageName(imageName:String, isThumbnail:Bool) -> String?{
        if !self.ignoreThumbnail && isThumbnail {
            return self.thumbnailFileManager.pathForFileName(imageName)
        }else{
            return self.fileManager.pathForFileName(imageName)
        }
    }
    
    public func imageExistsForImageName(imageName:String) -> Bool{
        return self.fileManager.fileExistsForFileName(imageName)
    }
    
    public func imageWithName(imageName:String) -> UIImage? {
        return self.imageWithName(imageName, isThumbnail: false)
    }
    
    public func imageWithName(imageName:String, isThumbnail:Bool) -> UIImage?{
        if let path = self.pathForImageName(imageName, isThumbnail: isThumbnail) {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
    
    public func saveImage(image:UIImage) -> String{
        let name = self.nameFromTimestamp()
        self.saveImage(image, withImageName: name)
        return name
    }
    
    public func saveImage(image:UIImage, withImageName imageName:String){
        /* resize and compress image */
        let resizedImage = UIImage.compressImage(image, withMaxWidth: self.maxSize.width, maxHeight: self.maxSize.height, quality: self.compressionQuality)
        /* write to file */
        let data = UIImageJPEGRepresentation(image, 1.0)
        self.fileManager.saveData(data, withName: imageName)
        if self.ignoreThumbnail {
            return
        }
        
        /* thumbnail */
        let thumbnailImage = UIImage.compressImage(image, withMaxWidth: self.thumbnailMaxSize.width, maxHeight: self.thumbnailMaxSize.height, quality: self.compressionQuality * CGFloat(0.9))
        let thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 1.0)
        self.thumbnailFileManager.saveData(thumbnailData, withName: imageName)
    }
    
    public func deleteImageWithImageName(imageName:String, error:NSErrorPointer) -> Bool{
        let didDeleteOriginal = self.fileManager.deleteFileWithName(imageName, error: error)
        if self.ignoreThumbnail {
            return didDeleteOriginal
        }
        let didDeleteThumbnail = self.thumbnailFileManager.deleteFileWithName(imageName, error: error)
        return didDeleteOriginal && didDeleteThumbnail
    }
    
    public func renameImageFromImageName(imageName:String, toNewImageName newName:String, error:NSErrorPointer) -> Bool {
        let didRenameOriginal = self.fileManager.renameFileFrom(imageName, toNewFileName: newName, error: error)
        if self.ignoreThumbnail {
            return didRenameOriginal
        }
        
        let didRenameThumbnail = self.thumbnailFileManager.renameFileFrom(imageName, toNewFileName: newName, error: error)
        return didRenameOriginal && didRenameThumbnail
    }
    
    private func nameFromTimestamp() -> String{
        let timestamp = NSString(format: "%f", NSDate().timeIntervalSince1970 * 1000000)
        
        var fileName = timestamp.componentsSeparatedByString(".")[0] as! String
        fileName = fileName.stringByAppendingPathExtension("jpg")!
        return fileName
    }
}
