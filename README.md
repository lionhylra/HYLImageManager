# What is it?

HYLImageManager is a convenience CRUD tool for image files in iOS file system. It is a simplified version of NSFileManager providing only simple CRUD methods with using a file name. This module is suitable for foundamental objective-c programmers who needs to save image or other file to persistent store. 

For example, when you finish downloading a image, you may need to cache or store in local file system for later use. So you can just call <code>[[HYLImageManager defaultManager] saveImage:image withImageName:@"demoImage.png"</code>. When you want to get it back, just call <code>UIImage* image = [[HYLImageManager defaultManager] imageWithName:@"demoImage.png"</code>.


# How to use?
Firstly, initialize a instance of HYLImageManager. If you don't care where the image is stored, just use the singleton instance.
Using it is quite simple.

<pre><code>
HYLImageManager *manager = [HYLImageManager defaultManager];
</code></pre>
In this case all the image file will be stored into a default folder "UserDocuments" under /Documents. Or you can specify the directory path by initialize a instance.

<pre><code>
HYLImageManager *manager = [[HYLImageManager alloc] initWithRootPathComponents:@[@"folderA",@"folderB"];
</code></pre>
In this case, the target path of operation will be <code>/Documents/folderA/folderB</code>

Then use other methods as-is. Choose one class according to your needs.
- HYLImageManager.h Choose this if you don't need to specify the directory of image file and don't need thumbnail.
- HYLImageManager+Thumbnail.h Choose this if you want keep a thumbnail copy of the image. The thumbnail is resized to 100 pixels height and 133 width
- HYLImageManager+Cache.h Choose this if you don't need to save image to a persistent location. For example, you want to save images from posts of social networking app.
- HYLIMageManager+Thumbnail+Cache.h Choose this if you want to save image into cache and meanwhile keep thumbnail.

### HYLImageManager

####### fetch image
<pre><code>
-(UIImage *)imageWithName:(NSString *)imageName;
</code></pre>
####### save image 
<pre><code>
- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName;
</code></pre>
####### save image using a generated name(timestamp). The image name will be returned.
**Note, store the name or keep a reference of the name. You need use this name to fetch image again.**
<pre><code>
-(NSString *)saveImage:(UIImage *)image;
</code></pre>
####### delete image
<pre><code>
- (BOOL)deleteImageWithImageName:(NSString *)imageName error:(NSError **)error;
</code></pre>
####### rename image
<pre><code>
- (BOOL)renameImageFromImageName:(NSString *)oldImageName toNewImageName:(NSString *)newImageName error:(NSError **)error;
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
static float const kDefaultCompressQuality = 0.5;
</code></pre>
If you don't want resize and compress, change kDefaultMaxWidth and kDefaultMaxHeight to 0 and kDefaultCompressQuality to 1.0 .

# Utility Classes

### UIImage+Store
This UIImage Category is used in all HYLImageManager. If you want to specify your own path instead of image name in operation, just use this Category.

# Bonus

### HYLDownloadManager
This is a class used to handle concurrent downloading tasks and download file to yor desinated path. Initialize it like a HYLImageManager and use <code>- (NSURLSessionDownloadTask *)startDownloadTaskWithURL:(NSString *)urlString;</code> to create and start background downloading tasks. Use <code>- (NSURLSessionDownloadTask *)downloadingTaskWithURL:(NSString *)urlString;</code> to keep track of existing tasks. No matter your app enters background or terminated by system, these downloading tasks will keep going util finish as long as the network is available. 

Call <code>- (void)retrievingDownloadingTasks;</code> in UIApplicationDelegate when app become active to ensure the manager keep tracks of all ongoing download tasks. Use <code>- (NSURLSessionDownloadTask *)downloadingTaskWithURL:(NSString *)urlString;</code> to check if a task is ongoing.

If you want to monitor the progresses of all downloading tasks, just register your tableViewController to <code>kDownloadManagerProgressDidChangeNotification</code> notification. The notification.object is a instance of NSURLSessionDownloadTask, and notification.userinfo[kDownloadManagerUserInfoProgress] returns a float number between 0.0 and 1.0 indicate the progress of that task. Each time the progress changes, the task will send this notification.

![Alt downloading](/downloading.gif)
