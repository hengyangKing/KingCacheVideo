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
    KingPlayerStateFinishLoad,       //加载完成
};
typedef NS_ENUM(NSInteger, KingPlayerErrorState) {
    KingPlayerErrorStateIsTimeOut = -1001,    //请求超时
    KingPlayerErrorStateIsServerError  = -1004,//服务器错误
    KingPlayerErrorStateIsNetworkInterruption =-1005,//网络中断
    KingPlayerErrorStateIsconnectionless =-1009,//无网络连接
    KingPlayerErrorStateIsUnknow =-1010,//未知状态
};
@interface KingPlayerStatusModel : NSObject
+(instancetype)defaultModel;

/**
 视频Player状态
 */
@property (nonatomic, assign,readonly)KingPlayerState state;

/**
 视频播放错误状态
 */
@property (nonatomic,assign,readonly)KingPlayerErrorState errorState;
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

/**
 当前播放次数
 */
@property (nonatomic, assign,readonly) NSInteger playCount;
/**
 是否下载完毕
 */
@property (nonatomic, assign,readonly) BOOL  isFinishLoad;

/**
 是否播放本地文件
 */
@property (nonatomic, assign,readonly) BOOL  isLocalVideo;


@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerCurrent)(CGFloat time);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerDuration)(CGFloat time);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerLoadedProgress)(CGFloat loadedProgress);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerPlayState)(KingPlayerState state);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerErrorState)(NSInteger state);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerPlayCount)(NSInteger count);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerPlayLoadingFinish)(BOOL isloadFinish);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerPlayIsLocalVideo)(BOOL isLocalVideo);

@end
