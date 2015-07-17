//
//  ImageManager.h
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
#import "HYLFileManager.h"
NS_ASSUME_NONNULL_BEGIN


@interface HYLImageManager : HYLFileManager
@property(nonatomic, assign, readonly) float compressQuality;

/**
 *  Initialize the image manager with compress quality
 *
 *  @param pathComponents pathComponents An array of strings, each string is a name of folder
 *  @param quality        From 0.0 to 1.0. 0.0 means worst quality, 1.0 means best quality.
 *
 *  @return a HYLImageManager instance
 */
-(instancetype)initWithRootPathComponents:(nullable NSArray *)pathComponents compressQuality:(float)quality;

/**
 *  Get the path of a given image name under /Documents, no matter whether the file exists.
 *  This path could be used to create a image, store a image and fetch a image. However the best practice of manipulate a image is to use other methods using image name.
 *
 *  @param fileName the name of the image
 *
 *  @return the path of the image
 */
-(NSString *)pathForImageName:(NSString *)fileName;

/**
 *  Fetch image using image name, if the image file can't be find or not exists, this method will return nil
 *
 *  @param imageName the name of the image
 *
 *  @return image instance
 */
-(nullable UIImage *)imageWithName:(NSString *)imageName;

/**
 *  Save a image to the local file
 *
 *  @param image     UIImage instance
 *  @param imageName the file name of the saved image
 */
- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName;

/**
 *  Save a image using a generated file name(timestamp).
 *  Note: please keep reference of the returned file name. Othewise, you may not be able to fetch the saved file again.
 *
 *  @param image the image data need to save
 *
 *  @return the generated name
 */
-(NSString *)saveImage:(UIImage *)image;

/**
 *  delete the file by image name
 *
 *  @param imageName name of the image
 *  @param error     On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.

 *
 *  @return YES if the item was removed successfully or if path was nil. Returns NO if an error occurred. If the delegate aborts the operation for a file, this method returns YES. However, if the delegate aborts the operation for a directory, this method returns NO.
 */
- (BOOL)deleteImageWithImageName:(NSString *)imageName error:(NSError * __nullable *)error;

/**
 *  rename a image file
 *
 *  @param oldImageName old name
 *  @param newImageName new name
 *  @param error        On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the item was renamed successfully or the file manager’s delegate aborted the operation deliberately. Returns NO if an error occurred.
 */
- (BOOL)renameImageFromImageName:(NSString *)oldImageName toNewImageName:(NSString *)newImageName error:(NSError * __nullable *)error;

/**
 *  check existence of image file
 *
 *  @param imageName
 *
 *  @return
 */
-(BOOL)imageExistsForImageName:(NSString *)imageName;

/**
 *  Utility method, generate file name based on timestamp
 *
 *  @return timestamp
 */
+ (NSString *)nameFromTimestamp;
@end
NS_ASSUME_NONNULL_END
