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

FOUNDATION_EXPORT NSString *const kKingPlayerStateChangedNotification;
FOUNDATION_EXPORT NSString *const kKingPlayerProgressChangedNotification;
FOUNDATION_EXPORT NSString *const kKingPlayerLoadProgressChangedNotification;

@interface KingCacheVideoPlayer : NSObject

@property (nonatomic, assign) BOOL  stopInBackground;        //是否在后台播放，默认YES

@property (nonatomic, assign) NSInteger playCount;                    //当前播放次数
@property (nonatomic, assign) NSInteger playRepatCount;               //重复播放次数

@property (nonatomic, copy) void(^playNextBlock)(void);                 //播放下一个block

+ (instancetype)sharedInstance;


/**
 *  播放服务器的视频，先判断本地是否有缓存文件，缓存文件名为连接的url经过md5加密后生成的字符串

 @param url url
 @param showView showview
 @param needCache needCache
 */
- (void)playWithUrl:(NSURL *)url withView:(UIView *)showView andNeedCache:(BOOL)needCache;

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
