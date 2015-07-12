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

@interface HYLFileManager()

@end

@implementation HYLFileManager

-(instancetype)initWithRootPathComponents:(NSArray *)pathComponents {
    self = [super init];
    if (self) {
        _rootPathComponents = pathComponents;
    }
    return self;
}

-(instancetype)init{
    return [self initWithRootPathComponents:@[kDefaultPathComponent]];
}

+(instancetype)defaultManager{
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

-(NSString *)pathInDocumentsForFileName:(NSString *)fileName{
    NSString *filePath = [self buildPathInSystemDirectory:[self pathForDocuments]];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

-(NSString *)pathInCachesForFileName:(NSString *)fileName{
    NSString *filePath = [self buildPathInSystemDirectory:[self pathForCaches]];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

-(NSData *)loadDataInDocumentsWithName:(NSString * __nonnull)fileName{
    return [NSData dataWithContentsOfFile:[self pathInDocumentsForFileName:fileName]];
}

-(nullable NSData *)loadDataInCachesWithName:(NSString * __nonnull)fileName{
    return [NSData dataWithContentsOfFile:[self pathInCachesForFileName:fileName]];
}

-(void)saveDataInDocumentsForData:(NSData * __nonnull)data withName:(NSString * __nonnull)fileName{
    [data writeToFile:[self pathInDocumentsForFileName:fileName] atomically:YES];
}

-(void)saveDataInCachesForData:(NSData * __nonnull)data withName:(NSString * __nonnull)fileName{
    [data writeToFile:[self pathInCachesForFileName:fileName] atomically:YES];
}

-(BOOL)deleteFileInDocumentsWithName:(NSString * __nonnull)fileName error:(NSError **)error{
    NSString *filePath = [self pathInDocumentsForFileName:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return NO;
    }
    
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
}

-(BOOL)deleteFileInCachesWithName:(NSString * __nonnull)fileName error:(NSError **)error{
    NSString *filePath = [self pathInCachesForFileName:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return NO;
    }
    
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
}

-(BOOL)deleteFileWithName:(NSString * __nonnull)fileName error:(NSError *__autoreleasing  __nullable * __nullable)error{
    
  return [self deleteFileInDocumentsWithName:fileName error:error]&&[self deleteFileInCachesWithName:fileName error:error];
}

-(BOOL)renameFileInDocumentsFromFileName:(NSString * __nonnull)oldName toNewFileName:(NSString * __nonnull)newName error:(NSError *__autoreleasing  __nullable * __nullable)error{
    return [[NSFileManager defaultManager] moveItemAtPath:[self pathInDocumentsForFileName:oldName] toPath:[self pathInDocumentsForFileName:newName] error:error];
}

-(BOOL)renameFileInCachesFromFileName:(NSString * __nonnull)oldName toNewFileName:(NSString * __nonnull)newName error:(NSError *__autoreleasing  __nullable * __nullable)error{
    return [[NSFileManager defaultManager] moveItemAtPath:[self pathInCachesForFileName:oldName] toPath:[self pathInCachesForFileName:newName] error:error];
}

-(BOOL)renameFileFromFileName:(NSString * __nonnull)oldName toNewFileName:(NSString * __nonnull)newName error:(NSError *__autoreleasing  __nullable * __nullable)error{
    return [self renameFileInDocumentsFromFileName:oldName toNewFileName:newName error:error]&&[self renameFileInCachesFromFileName:oldName toNewFileName:newName error:error];
}
#pragma mark - private mathods

-(NSString *)buildPathInSystemDirectory:(NSString *)directoryPath{
    NSString *filePath = directoryPath;
    if (self.rootPathComponents) {
        for (NSString *component in self.rootPathComponents) {
            filePath = [filePath stringByAppendingPathComponent:component];
        }
    }
    [self validatePath:filePath];
    return filePath;
}

-(NSString *)pathForDocuments{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

-(NSString *)pathForCaches{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

-(void)validatePath:(NSString *)path{
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
