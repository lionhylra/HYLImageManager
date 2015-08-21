//
//  HYLImageManager.m
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

#import "HYLImageManager.h"
#import "HYLFileManager.h"
#import "UIImage+Compress.h"

@interface HYLImageManager ()
@property(nonatomic, strong) HYLFileManager *fileManager;
@property(nonatomic, strong) HYLFileManager *thumbnailFileManager;
- (NSString *)nameFromTimestamp;
@end

@implementation HYLImageManager

-(instancetype)init{
    return [self initWithDirectory:kDefaultDirectory pathComponents:@[kDefaultPathComponent] maxSize:CGSizeZero thumbnailMaxSize:CGSizeZero compressionQuality:1.0 ignoreThumbnail:YES];
}

-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory{
    return [self initWithDirectory:directory pathComponents:@[kDefaultPathComponent]];
}

-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents{
    return [self initWithDirectory:directory pathComponents:pathComponents maxSize:CGSizeZero];
}

-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(NSArray *)pathComponents maxSize:(CGSize)maxSize{
    return [self initWithDirectory:directory pathComponents:pathComponents maxSize:maxSize thumbnailMaxSize:CGSizeZero compressionQuality:1.0 ignoreThumbnail:YES];
}

-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(NSArray *)pathComponents maxSize:(CGSize)maxSize thumbnailMaxSize:(CGSize)thumbnailMaxSize compressionQuality:(float)quality ignoreThumbnail:(BOOL)flag{
    self = [super init];
    if (self) {
        _fileManager = [[HYLFileManager alloc]initWithDirectory:directory rootPathComponents:pathComponents];
        _thumbnailFileManager = [[HYLFileManager alloc]initWithDirectory:directory rootPathComponents:[pathComponents arrayByAddingObject:@"thumbnail"]];
        _maxSize = maxSize;
        _compressionQuality = quality;
        _thumbnailMaxSize = thumbnailMaxSize;
        _ignoreThumbnail = flag;
    }
    return self;
}


+(instancetype)defaultManager{
    /* Singleton */
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

-(NSSearchPathDirectory)directory{
    return self.fileManager.directory;
}

-(NSArray * __nullable)rootPathComponents{
    return self.fileManager.rootPathComponents;
}

-(NSString * __nonnull)pathForImageName:(NSString * __nonnull)imageName{
    return [self pathForImageName:imageName isThumbnail:NO];
}

-(NSString * __nonnull)pathForImageName:(NSString * __nonnull)imageName isThumbnail:(BOOL)isThumbnail{
    if (isThumbnail&&!self.ignoreThumbnail) {
        return [self.thumbnailFileManager pathForFileName:imageName];
    }else{
        return [self.fileManager pathForFileName:imageName];
    }
}

-(BOOL)imageExistsForImageName:(NSString * __nonnull)imageName{
    return [self.fileManager fileExistsForFileName:imageName];
}

-(nullable UIImage *)imageWithName:(NSString * __nonnull)imageName{
    return [self imageWithName:imageName isThumbnail:NO];
}

-(nullable UIImage *)imageWithName:(NSString * __nonnull)imageName isThumbnail:(BOOL)isThumbnail{
    return [UIImage imageWithContentsOfFile:[self pathForImageName:imageName isThumbnail:isThumbnail]];
}

-(NSString * __nonnull)saveImage:(UIImage * __nonnull)image{
    NSString *name = [self nameFromTimestamp];
    [self saveImage:image withImageName:name];
    return name;
}

-(void)saveImage:(UIImage * __nonnull)image withImageName:(NSString * __nonnull)imageName{
    /* resize and compress image */
    UIImage *resizedImage = [UIImage compressedImage:image withMaxWidth:self.maxSize.width maxHeight:self.maxSize.height quality:self.compressionQuality];
    /* write to file */
    NSData *data = UIImageJPEGRepresentation(resizedImage, 1.0);
    [self.fileManager saveData:data withName:imageName];
    if (self.ignoreThumbnail) {
        return;
    }
    /* handle thumbnail */
    UIImage *thumbnailImage = [UIImage compressedImage:image withMaxWidth:self.thumbnailMaxSize.width maxHeight:self.thumbnailMaxSize.width quality:self.compressionQuality*0.9];
    NSData *thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 1.0);
    [self.thumbnailFileManager saveData:thumbnailData withName:imageName];
}

-(BOOL)deleteImageWithImageName:(NSString * __nonnull)imageName error:(NSError *__autoreleasing  __nullable * __nullable)error{
    
    BOOL deleteOriginalSuccess = [self.fileManager deleteFileWithName:imageName error:error];
    if (self.ignoreThumbnail) {
        return deleteOriginalSuccess;
    }
    /* thumbnail */
    BOOL deleteThumbnailSuccess = [self.thumbnailFileManager deleteFileWithName:imageName error:error];
    return deleteOriginalSuccess&&deleteThumbnailSuccess;
}

-(BOOL)renameImageFromImageName:(NSString * __nonnull)oldImageName toNewImageName:(NSString * __nonnull)newImageName error:(NSError *__autoreleasing  __nullable * __nullable)error{
    BOOL renameOriginalSuccess = [self.fileManager renameFileFromFileName:oldImageName toNewFileName:newImageName error:error];
    if (self.ignoreThumbnail) {
        return renameOriginalSuccess;
    }
    /* thumbnail */
    BOOL renameThumbnailSuccess= [self.thumbnailFileManager renameFileFromFileName:oldImageName toNewFileName:newImageName error:error];
    return renameOriginalSuccess && renameThumbnailSuccess;
}

#pragma mark - private methods

- (NSString *)nameFromTimestamp {
    // Get time stamp as file name
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000000];
    
    // Get the integer part to use as file name
    NSString *fileName = [[timestamp componentsSeparatedByString:@"."] firstObject];
    fileName = [fileName stringByAppendingString:@".jpg"];
    return fileName;
}



@end
