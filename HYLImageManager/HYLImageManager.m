//
//  ImageManager.m
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

#import "HYLImageManager.h"
#import "UIImage+Store.h"
#import "HYLImageManager+Thumbnail.h"

@implementation HYLImageManager
-(instancetype)initWithRootPathComponents:(nullable NSArray *)pathComponents{
    return [super initWithRootPathComponents:pathComponents];
}

#pragma mark - path
- (NSString *__nonnull)pathForImageName:(NSString *__nonnull)fileName {
    return [self pathForImageName:fileName isThumbnail:NO];
}

#pragma mark - load image
- (nullable UIImage *)imageWithName:(NSString *)imageName {
    return [self imageWithName:imageName isThumbnail:NO];
}

#pragma mark - save image
- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName {
    [image writeImageToFile:[self pathForImageName:imageName isThumbnail:NO]];
}

- (NSString *)saveImage:(UIImage *)image {
    NSString *imageName = [HYLImageManager nameFromTimestamp];
    [self saveImage:image withImageName:imageName];
    return imageName;
}

#pragma mark - delete
- (BOOL)deleteImageWithImageName:(NSString *__nonnull)imageName
                           error:(NSError *__autoreleasing __nullable *__nullable)error {
    return [self deleteFileInDocumentsWithName:imageName error:error];
}

#pragma mark - rename
- (BOOL)renameImageFromImageName:(NSString *__nonnull)oldImageName
                  toNewImageName:(NSString *__nonnull)newImageName
                           error:(NSError *__autoreleasing __nullable *__nullable)error {
    return [self renameFileInDocumentsFromFileName:oldImageName toNewFileName:newImageName error:error];
}

#pragma mark - private method
+ (NSString *)nameFromTimestamp {
    // Get time stamp as file name
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000000];

    // Get the integer part to use as file name
    NSString *fileName = [[timestamp componentsSeparatedByString:@"."] firstObject];
    return fileName;
}

@end
