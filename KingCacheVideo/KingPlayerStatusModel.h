//
//  KingPlayerStatusModel.h
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger, KingPlayerState) {
    KingPlayerStateBuffering = 1,    //正在缓存
    KingPlayerStatePlaying,          //正在播放
    KingPlayerStateStopped,          //播放结束
    KingPlayerStatePause,            //暂停播放
    KingPlayerStateFinish,           //播放完成
};
@interface KingPlayerStatusModel : NSObject
+(instancetype)defaultModel;

/**
 视频Player状态
 */
@property (nonatomic, assign,readonly) KingPlayerState state;

/**
 当前播放时间str
 */
@property(nonatomic,copy,readonly)NSString *currentTime;

/**
 当前播放时间
 */
@property (nonatomic, assign,readonly)CGFloat current;
/**
 总时长str
 */
@property(nonatomic,copy,readonly)NSString *totolTime;

/**
 视频总时间
 */
@property (nonatomic, assign,readonly) CGFloat duration;
/**
 缓冲的进度
 */
@property (nonatomic, assign,readonly)CGFloat loadedProgress;

/**
 播放进度0~1之间
 */
@property (nonatomic, assign,readonly)CGFloat playProgress;


@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerCurrent)(CGFloat time);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerDuration)(CGFloat time);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerLoadedProgress)(CGFloat loadedProgress);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerPlayState)(KingPlayerState state);


@end
