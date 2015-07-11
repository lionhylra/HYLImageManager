//
//  HYLImageManager+Thumbnail.h
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
#import "HYLImageManager.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const kDirectoryForThumbnail = @"thumbnail";
/**
 *  This is a thumbnail version of HYLImageManager. All READ operation in this version has a flag for thumbnail. For save, delete and rename operations, they apply to both big image and thumnail. All thumbnails are saved into a directory called thumbnail. If your image file path is /Documents/folderA/folderB/aImage.png the path of the thumbnail will be in /Documents/folderA/folderB/thumbnail/aImage.png
 */
@interface HYLImageManager(Thumbnail)

/**
 *  Get the path of a image based on the flage. If isThubnail is YES, it will return the path of thumbnail image, if NO, it returns big size image
 *
 *  @param imageName    name of the image
 *  @param isThumbnail flag
 *
 *  @return return the path of the file
 */
-(NSString *)pathForImageName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail;

/**
 *  Returns a UIImage instance for the given name. If the image does not exist, it will return nil
 *
 *  @param imageName   the name of image
 *  @param isThumbnail flag
 *
 *  @return UIImage instance
 */
-(nullable UIImage *)imageWithName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail;

/**
 *  Save both big size image version and thumbnail version of the image to local file.
 *  The big size is a resized and compressed version(800x600, 50% compressed). The thumbnail is resized to 100x100
 *
 *  @param image the image object
 *
 *  @return the generated name of the image
 */
-(NSString *)saveImageAndThumbnailForImage:(UIImage *)image;

/**
 *  Save the image to a given name
 *
 *  @param imageName the name used to save the image
 *  @param image     the image object
 */
- (void)saveImageAndThumbnailWithImageName:(NSString *)imageName forImage:(UIImage *)image;

/**
 *  delete image and it's thumbnail
 *
 *  @param imageName the name of the image
 *  @param error     NSError pointer
 *
 *  @return if success return YES, otherwise, NO
 */
- (BOOL)deleteImageAndThumbnailWithImageName:(NSString *)imageName error:(NSError * __nullable *)error;

/**
 *  rename the image and it's thumbnail
 *
 *  @param oldImageName old name
 *  @param newImageName new name
 *  @param error        NSError pointer
 *
 *  @return if success return YES, otherwise, NO
 */
- (BOOL)renameImageAndThumbnailFromImageName:(NSString *)oldImageName toNewImageName:(NSString *)newImageName error:(NSError * __nullable *)error;

@end
NS_ASSUME_NONNULL_END
