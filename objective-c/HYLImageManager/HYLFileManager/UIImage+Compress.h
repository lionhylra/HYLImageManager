//
//  UIImage+Compress.h
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

#import <UIKit/UIKit.h>

static float const kDefaultCompressQuality = 0.5;

@interface UIImage(Compress)


/**
 *  Write image to file, calls [NSData writeToFile:path atomically:YES]
 *  The image will be resized to not exceed the range 800x600, and compressed by 50%
 *
 *  @param path path of the file
 */
-(void)writeImageToFile:(NSString *)path;

/**
 *  Write image to file, resize the image based on whether it is thumbnail.
 *  If it's thumbnail, the height of the image will be limited to 100 pixels, and the image will be compressed by 50%
 *
 *  @param path        path to write
 *  @param isThumbnail indicate whether it is a thumbnail
 */
-(void)writeImageToFile:(NSString *)path isThumbnail:(BOOL)isThumbnail;

/**
 *  Write image to file, resize the image based on whether it is thumbnail.
 *  If it's thumbnail, the height of the image will be limited to 100 pixels, and the image will be compressed by given number
 *
 *  @param path        path to write
 *  @param isThumbnail indicate whether it is a thumbnail
 *  @param quality     From 0.0 to 1.0. 0.0 means worst quality, 1.0 means best quality.
 */
-(void)writeImageToFile:(NSString *)path isThumbnail:(BOOL)isThumbnail compressQuality:(float)quality;

/**
 *  This mathod is identity to [UIImage imageWithContentOfFile]
 *
 *  @param path file path
 *
 *  @return UIImage instance
 */
+(UIImage *)loadImageFromPath:(NSString *)path;

/**
 *  delete file, calls as [NSFileManager defaultManager] removeItemAtPath:path error:]
 *
 *  @param path file path
 */
+(BOOL)deleteImageAtPath:(NSString *)path error:(NSError **)error;

/**
 *  move image to a new location
 *
 *  @param oldPath old location
 *  @param newPath new location
 *  @param error   On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the item was moved successfully or the file manager’s delegate aborted the operation deliberately. Returns NO if an error occurred.
 */
+(BOOL)moveImageAtPath:(NSString *)oldPath toNewPath:(NSString *)newPath error:(NSError **)error;

/**
 *  Resize image to 800x600(width 800) and compress by 50%
 *
 *  @param image
 *
 *  @return resized and compressed image
 */
+ (UIImage *)compressedImage:(UIImage *)image;

/**
 *  Resize image to the given MaxWith or MaxHeight and compress by 50%
 *  If maxWidth and maxHeight both are 0, then the image will not be resized but only compressed
 *
 *  @param image
 *  @param maxWidth
 *  @param maxHeight
 *
 *  @return resized and compressed image
 */
+ (UIImage *)compressedImage:(UIImage *)image withMaxWidth:(float)maxWidth maxHeight:(float)maxHeight;

/**
 *  Resize image to given MaxWith or MaxHeight and comress image by given rate
 *  If maxWidth and maxHeight both are 0, then the image will not be resized but only compressed
 *
 *  @param image
 *  @param maxWidth
 *  @param maxHeight
 *  @param quality   The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
 *
 *  @return resized and compressed image
 */
+ (UIImage *)compressedImage:(UIImage *)image withMaxWidth:(float)maxWidth maxHeight:(float)maxHeight quality:(float)quality;
@end
