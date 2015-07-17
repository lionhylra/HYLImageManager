//
//  HYLImageManger+Cache.m
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

#import "HYLImageManager+Cache.h"
#import "HYLImageManager+Thumbnail+Cache.h"
#import "UIImage+Store.h"

@implementation HYLImageManager (Cache)
- (NSString *__nonnull)pathInCachesForImageName:(NSString *)imageName {
    return [self pathInCachesForImageName:imageName isThumbnail:NO];
}
- (nullable UIImage *)imageInCachesWithName:(NSString *)imageName {
    return [self imageInCachesWithName:imageName isThumbnail:NO];
}
- (void)saveImageToCachesWithImageName:(NSString * __nonnull)imageName forImage:(UIImage * __nonnull)image {
    [image writeImageToFile:[self pathInCachesForImageName:imageName isThumbnail:NO] isThumbnail:NO compressQuality:self.compressQuality];
}
- (NSString *)saveImageToCachesForImage:(UIImage *)image {
    NSString *imageName = [HYLImageManager nameFromTimestamp];
    [self saveImageToCachesWithImageName:imageName forImage:image];
    return imageName;
}
- (BOOL)deleteImageInCachesWithImageName:(NSString *__nonnull)imageName
                                   error:(NSError *__autoreleasing __nullable *__nullable)error {
    return [self deleteFileInCachesWithName:imageName error:error];
}
- (BOOL)renameImageInCachesFromImageName:(NSString *__nonnull)oldImageName
                          toNewImageName:(NSString *__nonnull)newImageName
                                   error:(NSError *__autoreleasing __nullable *__nullable)error {
    return [self renameFileInCachesFromFileName:oldImageName toNewFileName:newImageName error:error];
}

-(BOOL)imageExistsInCachesForImageName:(NSString *)imageName{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathInCachesForImageName:imageName]];
}

@end
