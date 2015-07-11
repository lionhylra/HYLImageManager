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

Then use other methods as-is.

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


### HYLImageManager+Cache


### HYLImageManager+Thumbnail+Cache



# Utility Classes

### HYLFileManager

### UIImage+Store
