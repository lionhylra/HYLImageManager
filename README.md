# What is it?

HYLImageManager is a convenience CRUD tool for image files in iOS file system. It is a simplified version of NSFileManager providing only simple CRUD methods with using a file name. This module is suitable for foundamental objective-c programmers who needs to save image or other file to persistent store. 

For example, when you finish downloading a image, you may need to cache or store in local file system for later use. So you can just call <code>[[HYLImageManager defaultManager] saveImage:image withImageName:@"demoImage.png"</code>. When you want to get it back, just call <code>UIImage* image = [[HYLImageManager defaultManager] imageWithName:@"demoImage.png"</code>.


# How to use?

Using it is quite simple.

### HYLImageManager


### HYLImageManager+Thumbnail


### HYLImageManager+Cache


### HYLImageManager+Thumbnail+Cache



# Utility Classes

### HYLFileManager

### UIImage+Store
