//
//  HYLImageManager.h
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
NS_ASSUME_NONNULL_BEGIN
extern NSString *const kDefaultPathComponent;

@interface HYLImageManager : NSObject
@property(nonatomic, assign, readonly) CGSize maxSize;
@property(nonatomic, assign, readonly) CGSize thumbnailMaxSize;
@property(nonatomic, assign, readonly) float compressionQuality;
@property (nonatomic, strong, readonly, nullable) NSArray *rootPathComponents;
@property (nonatomic, assign, readonly) NSSearchPathDirectory directory;
@property(nonatomic, assign)BOOL ignoreThumbnail;

/**
 *  Init the manager instance with the system directiory.
 *  All images stored will be stored in a folder called "UserDocuments", to its original size without thumbnail. It will not be compressed.
 *  The path will be /<NSSearchPathDirectory>/UserDocuments/xxx.jpg
 *
 *  @param directory NSSearchPathDirectory constant. NSDocumentDirectory is NSCachesDirectory is recommended.
 *
 *  @return HYLImageManager instance
 */
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory;

/**
 *  Init the manager with the system directory and folder name.
 *  All images stored will be stored in the path specified in the pathComponents, to its original size without thumbnail. It will not be compressed.
 *  The path will be /<NSSearchPathDirectory>/pathComponents[0]/pathComponents[1]/pathComponents[2]/.../xxx.jpg
 *
 *  @param directory      NSSearchPathDirectory constant. NSDocumentDirectory is NSCachesDirectory is recommended.
 *  @param pathComponents The folder names. If the pathComponents is @[@"folderA",@"folderB"], the directory of the image will be /<NSSearchPathDirectory>/folderA/folderB/. If the array is empty, the image will be saved to the /<NSSearchPathDirectory> directory.
 *
 *  @return HYLImageManager instance
 */
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents;

/**
 *  Init the manager with the system directory, folder name and the maximum size of the image you want it be. When the image is saved to the disk, it will be resized to the maximum size you specify while keeping its ratio. If it's original size is smaller than the maximum size, it will not be resized.
 *  e.g. if you specify the maximum size to be (800, 600) (800 is width), and image's original size is (1000,1000), it will be resized to (600,600)
 *
 *  @param directory      NSSearchPathDirectory constant. NSDocumentDirectory is NSCachesDirectory is recommended.
 *  @param pathComponents The folder names. If the pathComponents is @[@"folderA",@"folderB"], the directory of the image will be /<NSSearchPathDirectory>/folderA/folderB/. If the array is empty, the image will be saved to the /<NSSearchPathDirectory> directory.
 *  @param maxSize        A CGSize type struct
 *
 *  @return HYLImageManager instance
 */
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents maxSize:(CGSize)maxSize;

/**
 *  Init a image manager with most customization
 *
 *  @param directory        NSSearchPathDirectory constant. NSDocumentDirectory is NSCachesDirectory is recommended.
 *  @param pathComponents   The folder names. If the pathComponents is @[@"folderA",@"folderB"], the directory of the image will be /<NSSearchPathDirectory>/folderA/folderB/. If the array is empty, the image will be saved to the /<NSSearchPathDirectory> directory.
 *  @param maxSize          A CGSize type struct. If you pass CGSizeMakeZero, the image will not be resized. If you pass 0 to one of width or height, that means the width or height will not be limited.
 *  @param thumbnailMaxSize A CGSize type struct
 *  @param quality          The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
 *  @param flag             A flag to indicate whether a thumbnail is generated when image is saved. If the flag is YES, all thumbnail related parameters in other methods of the class will be ignored. And the thumbnailMaxSize above will be ignored as well.
 *
 *  @return HYLImageManager instance
 */
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents maxSize:(CGSize)maxSize thumbnailMaxSize:(CGSize)thumbnailMaxSize compressionQuality:(float)quality ignoreThumbnail:(BOOL)flag NS_DESIGNATED_INITIALIZER;

/**
 *  Init a shared instance with all customization set to default.
 *  Directory: /Documents/UserDocuments
 *  Resize: no risize. keep original size.
 *  Compress: no compress
 *  Thumbnail: no thumbnail. and all thumbnail related parameters in other methods of the class will be ignored.
 *
 *  @return shared instance
 */
+(instancetype)defaultManager;

/**
 *  The path of the file for given image name. The path may not exist.
 *
 *  @param imageName the name of the image file
 *
 *  @return path string
 */
-(NSString *)pathForImageName:(NSString *)imageName;

/**
 *  Get the path of the original image or the thumbnail. The path mey not exist.
 *
 *  @param imageName   name of the file
 *  @param isThumbnail specify the path is for original image or the thumbnail
 *
 *  @return path string
 */
-(NSString *)pathForImageName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail;

/**
 *  Get the image for the image name. If the image doesn't exist, it will return nil.
 *
 *  @param imageName image name
 *
 *  @return UIImage instace or nil
 */
-(nullable UIImage *)imageWithName:(NSString *)imageName;

/**
 *  Get the image or the thumbnail. If the image doesn't exist, it will return nil.
 *  If the ignoreThumbnail of the manager is set to YES, no matter isThumbnail is YES or NO, it will always return original image.
 *
 *  @param imageName   image name
 *  @param isThumbnail specify if the image is original or thubnail
 *
 *  @return UIImage instance or nil
 */
-(nullable UIImage *)imageWithName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail;

/**
 *  Save image to disk and return the auto generated image name. When the image is saved, the image will be resized according to the maximum size specified maxSize property. If the property ignoreThumbnail is YES, thumbnail will not be saved, otherwise, a thumbnail will be saved for the image.
 *
 *  @param image UIImage object
 *
 *  @return The name of the image that generated from timestamp automatically
 */
-(NSString *)saveImage:(UIImage *)image;

/**
 *  Save image with the name you specify. When the image is saved, the image will be resized according to the maximum size specified maxSize property. If the property ignoreThumbnail is YES, thumbnail will not be saved, otherwise, a thumbnail will be saved for the image.

 *
 *  @param image     UIImage object
 *  @param imageName The image name
 */
- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName;

/**
 *  Delete the image file on the disk. If ignoreThumbnail is NO, it will delete both original image and thumbnail.
 *
 *  @param imageName The name of the file you want to delete.
 *  @param error     On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the item was removed successfully or the file does not exist. Returns NO if an error occurred.
 */
- (BOOL)deleteImageWithImageName:(NSString *)imageName error:(NSError * __nullable *)error;

/**
 *  Rename the image file on the disk.
 *
 *  @param oldImageName old name
 *  @param newImageName new name
 *  @param error        On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the item was renamed successfully. Returns NO if an error occurred.
 */
- (BOOL)renameImageFromImageName:(NSString *)oldImageName toNewImageName:(NSString *)newImageName error:(NSError * __nullable *)error;

/**
 *  Check if a image file with the given name exists in the disk
 *
 *  @param imageName name of the image
 *
 *  @return YES or NO
 */
-(BOOL)imageExistsForImageName:(NSString *)imageName;

@end
NS_ASSUME_NONNULL_END