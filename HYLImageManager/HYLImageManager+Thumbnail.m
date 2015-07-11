//
//  HYLImageManager+Thumbnail.m
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

#import "HYLImageManager+Thumbnail.h"
#import "UIImage+Store.h"

@implementation HYLImageManager (Thumbnail)

- (NSString *__nonnull)pathForImageName:(NSString *__nonnull)fileName isThumbnail:(BOOL)isThumbnail {
    NSString *path;
    if (isThumbnail) {
        path = [self.thumbnailFileManager pathInDocumentsForFileName:fileName];
    } else {
        path = [self pathInDocumentsForFileName:fileName];
    }
    return path;
}

- (nullable UIImage *)imageWithName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail {
    return [UIImage loadImageFromPath:[self pathForImageName:imageName isThumbnail:isThumbnail]];
}
- (void)saveImageAndThumbnailWithImageName:(NSString *__nonnull)imageName
                                             forImage:(UIImage *__nonnull)image {
    [image writeImageToFile:[self pathForImageName:imageName isThumbnail:YES] isThumbnail:YES];
    [image writeImageToFile:[self pathForImageName:imageName isThumbnail:NO] isThumbnail:NO];
}

- (NSString *__nonnull)saveImageAndThumbnailForImage:(UIImage *__nonnull)image {
    NSString *imageName = [HYLImageManager nameFromTimestamp];
    [self saveImageAndThumbnailWithImageName:imageName forImage:image];
    return imageName;
}

- (BOOL)deleteImageAndThumbnailWithImageName:(NSString *__nonnull)imageName
                                       error:(NSError *__autoreleasing __nullable *__nullable)error {

    return [UIImage deleteImageAtPath:[self pathForImageName:imageName isThumbnail:YES] error:error] &&
           [UIImage deleteImageAtPath:[self pathForImageName:imageName isThumbnail:NO] error:error];
}

- (BOOL)renameImageAndThumbnailFromImageName:(NSString *__nonnull)oldImageName
                              toNewImageName:(NSString *__nonnull)newImageName
                                       error:(NSError *__autoreleasing __nullable *__nullable)error {
    return [UIImage moveImageAtPath:[self pathForImageName:oldImageName isThumbnail:YES]
                          toNewPath:[self pathForImageName:newImageName isThumbnail:YES]
                              error:error] &&
           [UIImage moveImageAtPath:[self pathForImageName:oldImageName isThumbnail:NO]
                          toNewPath:[self pathForImageName:newImageName isThumbnail:NO]
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
