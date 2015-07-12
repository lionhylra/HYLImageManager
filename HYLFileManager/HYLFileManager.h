//
//  HYLFileManager.h
//The MIT License (MIT)
//
//Copyright (c) 2015 Yilei He
//https://github.com/lionhylra/HYLImageManager
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.


#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

static NSString *const kDefaultPathComponent = @"UserDocuments";

@interface HYLFileManager : NSObject
@property (nonatomic, strong, readonly, nullable) NSArray *rootPathComponents;

/**
 *  Returns the shared file manager object for the process.
 *  This method always returns the same file manager object. If you plan to use the file manager manipulate files in a custome folder, you should create a new instance of HYLFileManager (using the initWithRootPathComponents: method) rather than using the shared object.
 *  @return default instance with pathComponent @[@"UserDocuments"], The default HYLFileManager object for the file system.
 */
+(instancetype)defaultManager;

/**
 *  init a customized file manager
 *
 *  @param pathComponents An array of strings, each string is a name of folder
 *
 *  @return
 */
-(instancetype)initWithRootPathComponents:(nullable NSArray *)pathComponents NS_DESIGNATED_INITIALIZER;

/**
 *  get the path of file based on file name and path components used to construct file manager
 *  e.g. If the path components is @[@"folderA",@"folderB",@"folderC"], and the file name is myPhoto.png, then the path is [sandbox path]/Documents/folderA/folderB/folderC/myPhoto.png
 *
 *  @param fileName the name of the file
 *
 *  @return a complete path for a file gived with name
 */
-(NSString *)pathInDocumentsForFileName:(NSString *)fileName;

/**
 *  get the path of file based on file name and path components used to construct file manager
 *  e.g. If the path components is @[@"folderA",@"folderB",@"folderC"], and the file name is myPhoto.png, then the path is [sandbox path]/Library/Caches/folderA/folderB/folderC/myPhoto.png
 *
 *  @param fileName the name of the file
 *
 *  @return a complete path for a file gived with name
 */
-(NSString *)pathInCachesForFileName:(NSString *)fileName;

/**
 *  delete a file with name in both /Documents and /Library/Caches
 *
 *  @param fileName name of the file need to be deleted
 *  @return YES if the item was removed successfully or if path was nil. Returns NO if an error occurred. If the delegate aborts the operation for a file, this method returns YES. However, if the delegate aborts the operation for a directory, this method returns NO.
 */
- (BOOL)deleteFileWithName:(NSString *)fileName error:( NSError * __nullable *)error;

/**
 *  delete a file in the /Documents
 *
 *  @param fileName the name of the file need to be deleted
 *  @param error    On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the item was removed successfully or if path was nil. Returns NO if an error occurred. If the delegate aborts the operation for a file, this method returns YES. However, if the delegate aborts the operation for a directory, this method returns NO.
 */
-(BOOL)deleteFileInDocumentsWithName:(NSString *)fileName error:( NSError * __nullable *)error;

/**
 *  delete a file in the /Library/Caches
 *
 *  @param fileName the name of the file need to be deleted
 *  @param error    On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the item was removed successfully or if path was nil. Returns NO if an error occurred. If the delegate aborts the operation for a file, this method returns YES. However, if the delegate aborts the operation for a directory, this method returns NO.
 */
-(BOOL)deleteFileInCachesWithName:(NSString *)fileName error:( NSError * __nullable *)error;

/**
 *  rename a file in the /Documents
 *
 *  @param oldName
 *  @param newName
 *  @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *  @return YES if the item was renamed successfully or the file manager’s delegate aborted the operation deliberately. Returns NO if an error occurred.
 */
- (BOOL)renameFileInDocumentsFromFileName:(NSString *)oldName toNewFileName:(NSString *)newName error:( NSError * __nullable *)error;

/**
 *  rename file in /Library/Caches
 *
 *  @param oldName
 *  @param newName
 *  @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.  
 *  @return YES if the item was renamed successfully or the file manager’s delegate aborted the operation deliberately. Returns NO if an error occurred.
 */
- (BOOL)renameFileInCachesFromFileName:(NSString *)oldName toNewFileName:(NSString *)newName error:( NSError * __nullable *)error;

/**
 *  rename file in both /Documents and /Library/Caches
 *
 *  @param oldName
 *  @param newName
 *  @return YES if the item was renamed successfully or the file manager’s delegate aborted the operation deliberately. Returns NO if an error occurred.
 */
- (BOOL)renameFileFromFileName:(NSString *)oldName toNewFileName:(NSString *)newName error:( NSError * __nullable *)error;

@end
NS_ASSUME_NONNULL_END