//
//  UIImage+Compress.m
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

#import "UIImage+Compress.h"

static float const kDefaultMaxWidth = 0.0;
static float const kDefaultMaxHeight = 0.0;

//static float const kDefaultThumbnailMaxWidth = 100.0;
static float const kDefaultThumbnailMaxHeight = 100.0;

@implementation UIImage(Compress)

- (void)writeImageToFile:(NSString *)path{
    [self writeImageToFile:path isThumbnail:NO];
}

-(void)writeImageToFile:(NSString *)path isThumbnail:(BOOL)isThumbnail{
    [self writeImageToFile:path isThumbnail:NO compressQuality:kDefaultCompressQuality];
}

-(void)writeImageToFile:(NSString *)path isThumbnail:(BOOL)isThumbnail compressQuality:(float)quality{
    UIImage *resizedImage;
    if (isThumbnail) {
        resizedImage = [UIImage compressedImage:self withMaxWidth:0 maxHeight:kDefaultThumbnailMaxHeight quality:quality];
    }else{
        resizedImage = [UIImage compressedImage:self withMaxWidth:kDefaultMaxWidth maxHeight:kDefaultMaxHeight quality:quality];
    }
    NSData *dataResized = UIImageJPEGRepresentation(resizedImage, 1.0);
    [dataResized writeToFile:path atomically:YES];
}

+(UIImage *)loadImageFromPath:(NSString *)path{
    return [UIImage imageWithContentsOfFile:path];
}

+(BOOL)deleteImageAtPath:(NSString *)path error:(NSError *__autoreleasing *)error{
   return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

+(BOOL)moveImageAtPath:(NSString *)oldPath toNewPath:(NSString *)newPath error:(NSError *__autoreleasing *)error{
    return [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:error];
}
#pragma mark - compression
+ (UIImage *)compressedImage:(UIImage *)image
{
    return [self compressedImage:image withMaxWidth:kDefaultMaxWidth maxHeight:kDefaultMaxHeight];
}

+ (UIImage *)compressedImage:(UIImage *)image withMaxWidth:(float)maxWidth maxHeight:(float)maxHeight
{
    return [self compressedImage:image withMaxWidth:maxWidth maxHeight:maxHeight quality:kDefaultCompressQuality];
}

+ (UIImage *)compressedImage:(UIImage *)image withMaxWidth:(float)maxWidth maxHeight:(float)maxHeight quality:(float)quality{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    if (maxHeight == 0 && maxWidth == 0)
    {
        maxHeight = actualHeight;
        maxWidth = actualWidth;
    }
    else if (maxHeight == 0)
    {
        maxHeight = maxWidth * actualHeight / actualWidth;
    }
    else if (maxWidth == 0)
    {
        maxWidth = maxHeight * actualWidth / actualHeight;
    }
    float imgRatio = actualWidth / actualHeight;
    float maxRatio = maxWidth / maxHeight;
    
    if (quality>1.0) {
        quality = 1.0;
    }
    if (quality<0.0) {
        quality = 0.0;
    }
    float compressionQuality = quality;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if (imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if (imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}


@end
