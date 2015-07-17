# What is it?

HYLImageManager is a convenience CRUD tool for image files in iOS file system. It is a simplified version of NSFileManager providing only simple CRUD methods with using a file name. This module is suitable for foundamental objective-c programmers who needs to save image or other file to persistent store. 

For example, when you finish downloading a image, you may need to cache or store in local file system for later use. So you can just call <code>[[HYLImageManager defaultManager] saveImage:image withImageName:@"demoImage.png"</code>. When you want to get it back, just call <code>UIImage* image = [[HYLImageManager defaultManager] imageWithName:@"demoImage.png"</code>.


# How to use?
## 1. Choose one class to import according to your needs.
- <code>#import "HYLImageManager.h"</code> Choose this if you don't need to specify the directory of image file and don't need thumbnail.
- <code>#import "HYLImageManager+Thumbnail.h"</code> Choose this if you want keep a thumbnail copy of the image. The thumbnail is resized to 100 pixels height and 133 width
- <code>#import "HYLImageManager+Cache.h"</code> Choose this if you don't need to save image to a persistent location. For example, you want to save images from posts of social networking app.
- <code>#import "HYLIMageManager+Thumbnail+Cache.h"</code> Choose this if you want to save image into cache and meanwhile keep thumbnail.

## 2. Initialize a instance of HYLImageManager. There are three ways to initialize a HYLImageManager instance. 

1) If you don't care where the image is stored, just use the singleton instance.
<pre><code>
HYLImageManager *manager = [HYLImageManager defaultManager];
</code></pre>
In this case all the image file will be stored into a default folder "UserDocuments" under /Documents. Or you can specify the directory path by initialize a instance.

2) If you want to specify the location of file, use this:
<pre><code>
HYLImageManager *manager = [[HYLImageManager alloc] initWithRootPathComponents:@[@"folderA",@"folderB"];
</code></pre>
In this case, the target path of operation will be <code>/Documents/folderA/folderB</code>

3) In above HYLImageManager, every time you save a image, it will be compressed by 50% by default. Alternatively you can create a HYLImageManager of your own compression quality;
<pre><code>
-(instancetype)initWithRootPathComponents:(NSArray *)pathComponents compressQuality:(float)quality;
</code></pre>
The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).

## 3. Then use other methods as-is. 

### HYLImageManager

##### fetch image
<pre><code>
-(UIImage *)imageWithName:(NSString *)imageName;
</code></pre>
##### save image 
<pre><code>
- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName;
</code></pre>
##### save image using a generated name(timestamp). The image name will be returned.
**Note, store the name or keep a reference of the name. You need use this name to fetch image again.**
<pre><code>
-(NSString *)saveImage:(UIImage *)image;
</code></pre>
##### delete image
<pre><code>
- (BOOL)deleteImageWithImageName:(NSString *)imageName error:(NSError **)error;
</code></pre>
##### rename image
<pre><code>
- (BOOL)renameImageFromImageName:(NSString *)oldImageName toNewImageName:(NSString *)newImageName error:(NSError **)error;
</code></pre>
##### get the path of an image
<pre><code>
-(NSString *)pathForImageName:(NSString *)fileName;
</code></pre>
##### check image existence
<pre><code>
-(BOOL)imageExistsForImageName:(NSString *)imageName;
</code></pre>

### HYLImageManager+Thumbnail
This is a thumbnail version of HYLImageManager. All READ operation in this version has a flag for thumbnail. For save, delete and rename operations, they apply to both big image and thumnail. All thumbnails are saved into a directory called thumbnail. If your image file path is /Documents/folderA/folderB/aImage.png the path of the thumbnail will be in /Documents/folderA/folderB/thumbnail/aImage.png

### HYLImageManager+Cache
This is a similar version of HYLImageManager. The only difference is this image manager save image to /Library/Caches, and it is possible that images may be removed by system under some circumstance.

### HYLImageManager+Thumbnail+Cache
This is a cache version of HYLImageManager+Thumbnail. Similar to HYLImageManager+Cache, it save image files to /Library/Caches.

### Note
All non-thumbnail images will be resized to maximum width 800 and maximum height 600 while keeping the original ratio and will be compressed by 50%. If you want to change this setting, look at UIImage+Store.m and modify
<pre><code>
static float const kDefaultMaxWidth = 800.0;
static float const kDefaultMaxHeight = 600.0;
</code></pre>
If you don't want resize, change kDefaultMaxWidth and kDefaultMaxHeight to 0.

# Utility Classes

### UIImage+Store
This UIImage Category is used in all HYLImageManager. If you want to specify your own path instead of image name in operation, just use this Category.

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

