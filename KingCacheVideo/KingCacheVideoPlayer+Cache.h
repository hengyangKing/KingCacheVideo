//
//  KingCacheVideoPlayer+Cache.h
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import "KingCacheVideoPlayer.h"

@interface KingCacheVideoPlayer (Cache)
/**
 *  清除所有本地缓存视频文件
 */
- (void)clearAllVideoCache;

/**
 *  计算所有视频缓存大小
 *
 *  @return 视频缓存大小
 */
- (double)allVideoCacheSize;
@end
