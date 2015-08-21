//
//  HYLFileManager.swift
//  HYLMultiImagesViewControllerDemo
//
//  Created by HeYilei on 21/08/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

import UIKit

public let kDefaultPathComponent = "UserDocuments"
public let kDefaultDirectory = NSSearchPathDirectory.DocumentDirectory

public class HYLFileManager: NSObject {
    // MARK: - Public Properties
    public let rootPathComponents:[String]?
    public let directory:NSSearchPathDirectory
    public static let defaultManager = HYLFileManager()
    
    // MARK: - Initializers
    init(directory:NSSearchPathDirectory, rootPathComponents:[String]?){
        self.rootPathComponents = rootPathComponents
        self.directory = directory
        super.init()
    }
    
    convenience override init() {
        self.init(directory: kDefaultDirectory, rootPathComponents: [kDefaultPathComponent])
    }
    
    // MARK: - File Operation Methods
    public func pathForFileName(fileName:String) -> String?{
        if fileName.isEmpty {
            return nil
        }
        let filePath = buildPathInSystemDirectory(NSSearchPathForDirectoriesInDomains(self.directory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String)
        return filePath.stringByAppendingPathComponent(fileName)
    }
    
    public func loadDataWithName(fileName:String) -> NSData? {
        if let filePath = pathForFileName(fileName) {
            return NSData(contentsOfFile: filePath)
        }
        return nil
    }
    
    public func saveData(data:NSData, withName fileName:String){
        if let path = pathForFileName(fileName) {
            validateDirectoryPath(path.stringByDeletingLastPathComponent)
            data.writeToFile(path, atomically: true)
        }
    }
    
    public func deleteFileWithName(fileName:String, error:NSErrorPointer) -> Bool{
        if let path = pathForFileName(fileName) {
            if !NSFileManager.defaultManager().fileExistsAtPath(path) {
                return true
            }
            
            return NSFileManager.defaultManager().removeItemAtPath(path, error: error)
        }
        return false
    }
    
    public func renameFileFrom(oldName:String, toNewFileName newName:String, error:NSErrorPointer) -> Bool{
        if let oldPath = pathForFileName(oldName), newPath = pathForFileName(newName) {
            validateDirectoryPath(newPath.stringByDeletingLastPathComponent)
            return NSFileManager.defaultManager().moveItemAtPath(oldPath, toPath: newPath, error: error)
        }
        return false
    }
    
    public func fileExistsForFileName(fileName:String) -> Bool {
        if let path = pathForFileName(fileName){
            return NSFileManager.defaultManager().fileExistsAtPath(path)
        }
        return false
    }
    
    // MARK: - Private Methods
    private func buildPathInSystemDirectory(directoryPath:String) -> String{
        var filePath = directoryPath
        if let pathComponents = self.rootPathComponents {
            for component in pathComponents{
                filePath = filePath.stringByAppendingPathComponent(component)
            }
        }
        return filePath
    }
    
    private func validateDirectoryPath(path:String){
        var isDirectory = ObjCBool(false)
        if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory) && isDirectory {
            return
        }
        
        var error:NSError?
        if !NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error) {
            println("Create directory for HYLFileManager failed with error: \(error!.localizedDescription)")
        }
    }
}
