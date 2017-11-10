//
//  KingCacheVideoPlayer.h
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "KingPlayerStatusModel.h"
#import "KingCacheVideoPlayerConfig.h"

FOUNDATION_EXPORT NSString *const kKingPlayerStateChangedNotification;
FOUNDATION_EXPORT NSString *const kKingPlayerProgressChangedNotification;
FOUNDATION_EXPORT NSString *const kKingPlayerLoadProgressChangedNotification;

@interface KingCacheVideoPlayer : NSObject

+ (instancetype)sharedInstance;
/**
  播放服务器的视频，先判断本地是否有缓存文件，缓存文件名为连接的url经过md5加密后生成的字符串

 @param url url
 @param showView showview
 @param config config
 */
- (void)playWithUrl:(NSURL *)url withView:(UIView *)showView andConfig:(void(^)(KingCacheVideoPlayerConfig *config))config;

/**
 *  指定到某一事件点开始播放
 *
 *  @param seconds 时间点
 */
- (void)seekToTime:(CGFloat)seconds;

/**
 * 恢复播放
 */
- (void)resume;

/**
 *  暂停播放
 */
- (void)pause;

/**
 *  停止播放
 */
- (void)stop;


/**
 播放状态实时回调

 @param status 状态模型
 */
-(void)playStatusObserver:(void(^)(KingPlayerStatusModel *statusModel))status;
@end
