//
//  HYLFileManager.m
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

#import "HYLFileManager.h"
NSString *const kDefaultPathComponent = @"UserDocuments";

@interface HYLFileManager()

@end

@implementation HYLFileManager

-(instancetype)initWithDirectory:(NSSearchPathDirectory)directory rootPathComponents:(nullable NSArray *)pathComponents {
    self = [super init];
    if (self) {
        _rootPathComponents = pathComponents;
        _directory = directory;
    }
    return self;
}

-(instancetype)init{
    return [self initWithDirectory:kDefaultDirectory rootPathComponents:@[kDefaultPathComponent]];
}

+(instancetype)defaultManager{
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

-(NSString *)pathForFileName:(NSString *)fileName{
    if (fileName == nil) {
        return nil;
    }
    if ([fileName isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if (fileName.length == 0) {
        return nil;
    }
    NSString *filePath = [self buildPathInSystemDirectory:NSSearchPathForDirectoriesInDomains(self.directory, NSUserDomainMask, YES).firstObject];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

-(NSData *)loadDataWithName:(NSString * __nonnull)fileName{
    return [NSData dataWithContentsOfFile:[self pathForFileName:fileName]];
}

-(void)saveData:(NSData * __nonnull)data withName:(NSString * __nonnull)fileName{
    NSString *path = [self pathForFileName:fileName];
    [self validateDirectoryPath:[path stringByDeletingLastPathComponent]];
    [data writeToFile:path atomically:YES];
}

-(BOOL)deleteFileWithName:(NSString * __nonnull)fileName error:(NSError **)error{
    NSString *filePath = [self pathForFileName:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return YES;
    }
    
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
}

-(BOOL)renameFileFromFileName:(NSString * __nonnull)oldName toNewFileName:(NSString * __nonnull)newName error:(NSError *__autoreleasing  __nullable * __nullable)error{
    NSString *oldPath = [self pathForFileName:oldName];
    NSString *newPath = [self pathForFileName:newName];
    [self validateDirectoryPath:[newPath stringByDeletingLastPathComponent]];
    return [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:error];
}

-(BOOL)fileExistsForFileName:(NSString * __nonnull)fileName{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForFileName:fileName]];
}
#pragma mark - private mathods

-(NSString *)buildPathInSystemDirectory:(NSString *)directoryPath{
    NSString *filePath = directoryPath;
    if (self.rootPathComponents) {
        for (NSString *component in self.rootPathComponents) {
            filePath = [filePath stringByAppendingPathComponent:component];
        }
    }
    
    return filePath;
}

-(void)validateDirectoryPath:(NSString *)path{
    if (!path) {
        return;
    }
    BOOL isDirectory;
    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]&&isDirectory){
        return;
    }
    /* create directory */
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (!isSuccess) {
        NSLog(@"Create directory error: %@", error.localizedDescription);
    }
    
}



@end
