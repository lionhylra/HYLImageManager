//
//  HYLImageManager+Thumbnail+Cache.m
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

#import "HYLImageManager+Thumbnail+Cache.h"
#import "UIImage+Store.h"

@implementation HYLImageManager (ThumbnailAndCache)
- (NSString *__nonnull)pathInCachesForImageName:(NSString *__nonnull)fileName isThumbnail:(BOOL)isThumbnail {
    NSString *path;
    if (isThumbnail) {
        path = [self.thumbnailFileManager pathInCachesForFileName:fileName];
    } else {
        path = [self pathInCachesForFileName:fileName];
    }
    return path;
}

- (nullable UIImage *)imageInCachesWithName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail {
    return [UIImage loadImageFromPath:[self pathInCachesForImageName:imageName isThumbnail:isThumbnail]];
}

- (void)saveImageAndThumbnailToCachesWithImageName:(NSString *__nonnull)imageName forImage:(UIImage *__nonnull)image {
    [image writeImageToFile:[self pathInCachesForImageName:imageName isThumbnail:YES] isThumbnail:YES];
    [image writeImageToFile:[self pathInCachesForImageName:imageName isThumbnail:NO] isThumbnail:NO];
}

- (NSString *__nonnull)saveImageAndThumbnailToCachesForImage:(UIImage *__nonnull)image {
    NSString *imageName = [HYLImageManager nameFromTimestamp];
    [self saveImageAndThumbnailToCachesWithImageName:imageName forImage:image];
    return imageName;
}

- (BOOL)deleteImageAndThumbnailInCachesWithImageName:(NSString *__nonnull)imageName
                                               error:(NSError *__autoreleasing __nullable *__nullable)error {
    return [UIImage deleteImageAtPath:[self pathInCachesForImageName:imageName isThumbnail:YES] error:error] &&
           [UIImage deleteImageAtPath:[self pathInCachesForImageName:imageName isThumbnail:NO] error:error];
}

- (BOOL)renameImageAndThumbnailInCachesFromImageName:(NSString *__nonnull)oldImageName
                                      toNewImageName:(NSString *__nonnull)newImageName
                                               error:(NSError *__autoreleasing __nullable *__nullable)error {
    return [UIImage moveImageAtPath:[self pathInCachesForImageName:oldImageName isThumbnail:YES]
                          toNewPath:[self pathInCachesForImageName:newImageName isThumbnail:YES]
                              error:error] &&
           [UIImage moveImageAtPath:[self pathInCachesForImageName:oldImageName isThumbnail:NO]
                          toNewPath:[self pathInCachesForImageName:newImageName isThumbnail:NO]
                              error:error];
}
#pragma mark - private getter
- (HYLFileManager *)thumbnailFileManager {
    static HYLFileManager *_thumbnailFileManager;
    if (!_thumbnailFileManager) {
        NSArray *thumbnailPathComponents = [self.rootPathComponents arrayByAddingObject:kDirectoryForThumbnail];
        _thumbnailFileManager = [[HYLFileManager alloc] initWithRootPathComponents:thumbnailPathComponents];
    }
    return _thumbnailFileManager;
}

@end
