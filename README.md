# What is it?

HYLImageManager is a convenience CRUD tool for image files in iOS file system. It is a simplified version of NSFileManager providing only simple CRUD methods with using a file name. This module is suitable for foundamental objective-c programmers who needs to save image or other file to persistent store. 

It is simple enough to use, and also it is flexible enough to costomize.

For example, when you finish downloading a image, you may need to cache or store in local file system for later use. So you can just call <code>[[HYLImageManager defaultManager] saveImage:image withImageName:@"demoImage.png"</code>. When you want to get it back, just call <code>UIImage* image = [[HYLImageManager defaultManager] imageWithName:@"demoImage.png"</code>.

#Install
##1. CocoaPods
(coming soon...)
##2. Drop-in
Just Drop the "HYLImageManager" folder in you project.

# How to use?
## 1. Initialize a instance of HYLImageManager. 
Select one of the ninitializer below to get a HYLImageManager instance.
```objective-c
//Init the manager instance with the system directiory.
//All images stored will be stored in a folder called "UserDocuments", to its original size without thumbnail. It will not be compressed.
//The path will be "/<NSSearchPathDirectory>/UserDocuments/xxx.jpg"
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory;

//Init the manager with the system directory and folder name.
//All images stored will be stored in the path specified in the pathComponents, to its original size without thumbnail. It will not be compressed.
//The path will be "/<NSSearchPathDirectory>/pathComponents[0]/pathComponents[1]/pathComponents[2]/.../xxx.jpg"
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents;

//Init the manager with the system directory, folder name and the maximum size of the image you want it be. When the image is saved to the disk, it will be resized to the maximum size you specify while keeping its ratio. If it's original size is smaller than the maximum size, it will not be resized.
//e.g. if you specify the maximum size to be (800, 600) (800 is width), and image's original size is (1000,1000), it will be resized to (600,600)
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(NSArray *)pathComponents maxSize:(CGSize)maxSize;

//Init a image manager with most customization
-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory pathComponents:(nullable NSArray *)pathComponents maxSize:(CGSize)maxSize thumbnailMaxSize:(CGSize)thumbnailMaxSize compressionQuality:(float)quality ignoreThumbnail:(BOOL)flag NS_DESIGNATED_INITIALIZER;

//Init a shared instance with default configuration.
+(instancetype)defaultManager;
```
## 2. Then use other methods as-is. 

##### fetch image
```objective-c
-(UIImage *)imageWithName:(NSString *)imageName;
```
##### save image 
```objective-c
- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName;
```
##### save image using a generated name(timestamp). The image name will be returned.
**Note, store the name or keep a reference of the name. You need use this name to fetch image again.**
```objective-c
-(NSString *)saveImage:(UIImage *)image;
```
##### delete image
```objective-c
- (BOOL)deleteImageWithImageName:(NSString *)imageName error:(NSError **)error;
```
##### rename image
```objective-c
- (BOOL)renameImageFromImageName:(NSString *)oldImageName toNewImageName:(NSString *)newImageName error:(NSError **)error;
```
##### get the path of an image
```objective-c
-(NSString *)pathForImageName:(NSString *)fileName;
```
##### check image existence
```objective-c
-(BOOL)imageExistsForImageName:(NSString *)imageName;
```

### Note
For more details about how to use these methods,  please refer to the header file.

# Utility Classes

### UIImage+Compress
This UIImage Category is used in all HYLImageManager to compress the image when the image is saved to disk. You can call the methods in this category whenever you like.

### HYLFileManager
This is a more generic version of CRUD convenient tool targeting at NSData.

# Bonus

### HYLDownloadManager
This is a class used to handle concurrent downloading tasks and download file to yor desinated path. Initialize it like a HYLImageManager and use <code>- (NSURLSessionDownloadTask *)startDownloadTaskWithURL:(NSString *)urlString;</code> to create and start background downloading tasks. Use <code>- (NSURLSessionDownloadTask *)downloadingTaskWithURL:(NSString *)urlString;</code> to keep track of existing tasks. No matter your app enters background or terminated by system, these downloading tasks will keep going util finish as long as the network is available. 

Call <code>- (void)retrievingDownloadingTasks;</code> in UIApplicationDelegate when app become active to ensure the manager keep tracks of all ongoing download tasks. Use <code>- (NSURLSessionDownloadTask *)downloadingTaskWithURL:(NSString *)urlString;</code> to check if a task is ongoing.

If you want to monitor the progresses of all downloading tasks, just register your tableViewController to <code>kDownloadManagerProgressDidChangeNotification</code> notification. The notification.object is a instance of NSURLSessionDownloadTask, and notification.userinfo[kDownloadManagerUserInfoProgress] returns a float number between 0.0 and 1.0 indicate the progress of that task. Each time the progress changes, the task will send this notification.

![Alt downloading](/downloading.gif)

# Contact Author
lionhylra@gmail.com

#Your Support
![Alt donate](/donate.jpg)