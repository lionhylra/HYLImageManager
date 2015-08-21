//
//  downloadManager.h

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
#import "HYLFileManager.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const kBackgroundSessionConfigurationIdentifier = @"DownloadManagerBackgroundDownload";

static NSString *const kDownloadManagerProgressDidChangeNotification = @"DownloadProgressNotification";
static NSString *const kDownloadManagerDidCompleteDownloadNotification = @"DownloadDidComplete";
static NSString *const kDownloadManagerUserInfoProgress = @"progress";
static NSString *const kDownloadManagerUserInfoCompleteError = @"CompleteError";

typedef void (^CompletionHandlerType)(void);


@interface HYLDownloadManager : NSObject <NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate>

@property (nonatomic, copy) NSString *identifier;

/**
 *  init the DownloadManager instance with the default identifier
 *
 *  @param folderName folder name
 *
 *  @return instance
 */
-(instancetype)initWithRootPathComponents:(nullable NSArray *)pathComponents;

- (instancetype)initWithRootPathComponents:(nullable NSArray *)pathComponents identifier:(NSString *)identifier;

+(instancetype)defaultManager;

/**
 *  Get the local file path of a file based on the file name in the default folder.
 *  This method always return the filepath in the default folder.
 *  It is equivalent to [[DownloadManager manager] localPathForFileInDocumentWithFileName:name]
 *
 *  @param name file name
 *
 *  @return file path
 */
+ (NSString *)localPathForFileInDocumentWithFileName:(NSString *)name;

/**
 *  get the local file path of a file based on the file name in the customized folder
 *
 *  @param name file name
 *
 *  @return file path
 */
- (NSString *)localPathForFileInDocumentWithFileName:(NSString *)name;


#pragma mark - DownloadManager methods
/**
 *  get the downloading task using the url
 *
 *  @param urlString the url that is used in the download task
 *
 *  @return task
 */
- (NSURLSessionDownloadTask *)downloadingTaskWithURL:(NSString *)urlString;

/**
 *  add a new download task to the manager
 *
 *  @param urlString the url that used to create the download task
 *
 *  @return task
 */
- (NSURLSessionDownloadTask *)startDownloadTaskWithURL:(NSString *)urlString;

#pragma mark - delegate methods
/**
 *  This method is called after app is teminated. When the background NSURLSession downloading finishes,
 *UIApplicationDelegate will call this method to update UI.
 *
 *  @param handler
 *  @param identifier the background NSURLSession identifier
 */
- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier;

/**
 *  This method is called by UIApplicationDelegate instance to retrieve background downloading tasks and store them into
 * the dictionary property of DownloadManager.
 */
- (void)retrievingDownloadingTasks;

- (BOOL)fileExistsInDocumentsForFileName:(NSString *)fileName;

-(BOOL)deleteFileInDocumentsWithName:(NSString *)filename error:(NSError *__nullable *)error;
@end
NS_ASSUME_NONNULL_END
