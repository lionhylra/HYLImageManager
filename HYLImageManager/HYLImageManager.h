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

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface HYLImageManager : NSObject
@property(nonatomic, assign, readonly) CGSize maxSize;
@property(nonatomic, assign, readonly) CGSize thumbnailMaxSize;
@property(nonatomic, assign, readonly) float compressionQuality;
@property (nonatomic, strong, readonly, nullable) NSArray *rootPathComponents;
@property (nonatomic, assign, readonly) NSSearchPathDirectory directory;
@property(nonatomic, assign)BOOL ignoreThumbnail;

-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory;
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents;
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(NSArray *)pathComponents maxSize:(CGSize)maxSize;
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents maxSize:(CGSize)maxSize thumbnailMaxSize:(CGSize)thumbnailMaxSize compressionQuality:(float)quality ignoreThumbnail:(BOOL)flag NS_DESIGNATED_INITIALIZER;
+(instancetype)defaultManager;

-(NSString *)pathForImageName:(NSString *)imageName;

-(NSString *)pathForImageName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail;

-(nullable UIImage *)imageWithName:(NSString *)imageName;

-(nullable UIImage *)imageWithName:(NSString *)imageName isThumbnail:(BOOL)isThumbnail;

-(NSString *)saveImage:(UIImage *)image;

- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName;

- (BOOL)deleteImageWithImageName:(NSString *)imageName error:(NSError * __nullable *)error;

- (BOOL)renameImageFromImageName:(NSString *)oldImageName toNewImageName:(NSString *)newImageName error:(NSError * __nullable *)error;

-(BOOL)imageExistsForImageName:(NSString *)imageName;

@end
NS_ASSUME_NONNULL_END