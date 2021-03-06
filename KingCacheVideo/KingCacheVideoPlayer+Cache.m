//
//  KingCacheVideoPlayer+Cache.m
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import "KingCacheVideoPlayer+Cache.h"

@implementation KingCacheVideoPlayer (Cache)
#pragma mark clear cache
- (void)clearAllVideoCache:(NSString *)cachePath
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(!cachePath.length){
        cachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    }
    NSArray *childFiles = [fileManager subpathsAtPath:cachePath];
    for (NSString *fileName in childFiles) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSLog(@"%@", fileName);
        if ([fileName.pathExtension isEqualToString:@"mp4"]) {
            NSString *absolutePath=[cachePath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
-(double)allVideoCacheSize:(NSString *)cachePath {
    
    double cacheVideoSize = 0.0f;
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(!cachePath.length){
        cachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    }
    NSArray *childFiles = [fileManager subpathsAtPath:cachePath];
    for (NSString *fileName in childFiles) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSLog(@"%@", fileName);
        if ([fileName.pathExtension isEqualToString:@"mp4"]) {
            NSString *path = [cachePath stringByAppendingPathComponent: fileName];
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath: path error: nil ];
            cacheVideoSize += ((double)([fileAttributes fileSize ]) / 1024.0 / 1024.0);
        }
    }
    
    return cacheVideoSize;
}
@end
