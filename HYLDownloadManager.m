//
//  downloadManager.m
//The MIT License (MIT)
//
//Copyright (c) 2015 Yilei He
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

#import "HYLDownloadManager.h"

@interface HYLDownloadManager ()
@property(nonatomic, strong) NSMutableDictionary *downloadingTasks;
@property(nonatomic, strong) NSURLSession *backgroundSession;
@property(nonatomic, strong) NSMutableDictionary *completionHandlerDictionary;

@end

@implementation HYLDownloadManager

#pragma mark - constructor

- (instancetype)initWithRootPathComponents:(nullable NSArray *)pathComponents identifier:(NSString *)identifier {
    self = [super initWithRootPathComponents:pathComponents];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

-(instancetype)initWithRootPathComponents:(nullable NSArray *)pathComponents{
    return [self initWithRootPathComponents:pathComponents identifier:kBackgroundSessionConfigurationIdentifier];
}


- (instancetype)init {
    self = [self initWithRootPathComponents:@[kDefaultPathComponent] identifier:kBackgroundSessionConfigurationIdentifier];
    return self;
}

#pragma mark - Utility method
+ (NSString *)localPathForFileInDocumentWithFileName:(NSString *)name {
    return [[HYLFileManager defaultManager] pathInDocumentsForFileName:name];
}

- (NSString *)localPathForFileInDocumentWithFileName:(NSString *)name {
    return [self pathInDocumentsForFileName:name];
}

#pragma mark - download tasks
- (NSURLSessionDownloadTask *)downloadingTaskWithURL:(NSString *)urlString {
    NSURLSessionDownloadTask *task = self.downloadingTasks[urlString];
    return task;
}

- (NSURLSessionDownloadTask *)startDownloadTaskWithURL:(NSString *)urlString {
    NSURLSessionDownloadTask *task = self.downloadingTasks[urlString];
    if (task) {
        if (task.state != NSURLSessionTaskStateCompleted) {
            [task resume];
        } else if (task.state == NSURLSessionTaskStateCompleted) {
            //...
        }
    } else {
        task = [self.backgroundSession downloadTaskWithURL:[NSURL URLWithString:urlString]];
        [self.downloadingTasks setObject:task forKey:urlString];
        [task resume];
    }
    return task;
}

- (void)retrievingDownloadingTasks {
    /* adding back backgrond tasks after terminating app */
    [self.backgroundSession
        getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            for (NSURLSessionDownloadTask *task in downloadTasks) {
                if (task.state == NSURLSessionTaskStateRunning) {
                    if (self.downloadingTasks[task.originalRequest.URL.absoluteString]) {
                        continue;
                    }
                    [self.downloadingTasks setObject:task forKey:task.originalRequest.URL.absoluteString];
                }
            }
        }];
}

#pragma mark - getters
- (NSMutableDictionary *)downloadingTasks {
    if (!_downloadingTasks) {
        _downloadingTasks = [NSMutableDictionary dictionary];
    }
    return _downloadingTasks;
}

- (NSURLSession *)backgroundSession {
    if (!_backgroundSession) {
        NSURLSessionConfiguration *config =
            [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:self.identifier];
        _backgroundSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _backgroundSession;
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location {
    /* get destinaion path */
    NSString *filename = downloadTask.originalRequest.URL.lastPathComponent;
    NSString *destinationPath = [self localPathForFileInDocumentWithFileName:filename];
    NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];

    /* move file to destination */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager replaceItemAtURL:destinationURL
                        withItemAtURL:destinationURL
                       backupItemName:nil
                              options:NSFileManagerItemReplacementUsingNewMetadataOnly
                     resultingItemURL:nil
                                error:&error];
    } else {
        if (![fileManager moveItemAtURL:location toURL:destinationURL error:&error]) {
            LOG(@"Move file to %@ error!", destinationURL.absoluteString);
        }
    }
    [self.downloadingTasks removeObjectForKey:downloadTask.originalRequest.URL.absoluteString];
}

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSNumber *progress = [NSNumber numberWithFloat:(double)totalBytesWritten / (double)totalBytesExpectedToWrite];

    /* send notification */
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadManagerProgressDidChangeNotification
                                                        object:downloadTask
                                                      userInfo:@{kDownloadManagerUserInfoProgress : progress}];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    LOG("DownloadTask did resume");
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    /* send notification */
    [[NSNotificationCenter defaultCenter]
        postNotificationName:kDownloadManagerDidCompleteDownloadNotification
                      object:task
                    userInfo:error ? @{kDownloadManagerUserInfoCompleteError : error} : nil];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"Background URL session %@ finished events.\n", session);

    if (session.configuration.identifier)
        [self callCompletionHandlerForSession:session.configuration.identifier];
}

- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier {
    /* this method is called in the UIApplicationDelegate's method
     - (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
     completionHandler:(void (^)())completionHandler
     */
    if ([self.completionHandlerDictionary objectForKey:identifier]) {
        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }

    [self.completionHandlerDictionary setObject:handler forKey:identifier];
}

- (void)callCompletionHandlerForSession:(NSString *)identifier {
    CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey:identifier];

    if (handler) {
        [self.completionHandlerDictionary removeObjectForKey:identifier];
        NSLog(@"Calling completion handler.\n");
        dispatch_async(dispatch_get_main_queue(), ^{
            handler();
        });
    }
}

@end
