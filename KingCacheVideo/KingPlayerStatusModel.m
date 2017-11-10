//
//  KingPlayerStatusModel.m
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import "KingPlayerStatusModel.h"
@interface KingPlayerStatusModel()
@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerCurrentTime)(NSString *time);

@property(nonatomic,copy,readonly)KingPlayerStatusModel *(^KingPlayerTotolTime)(NSString *time);
@end
@implementation KingPlayerStatusModel
+(instancetype)defaultModel{
    KingPlayerStatusModel *model = [[KingPlayerStatusModel alloc]init];
    model.KingPlayerDuration(0).KingPlayerCurrent(0).KingPlayerLoadedProgress(0).KingPlayerPlayCount(1);
    
    return model;
    
}
#pragma mark set
-(void)setCurrentTime:(NSString *)currentTime
{
    _currentTime = currentTime;
}
-(void)setTotolTime:(NSString *)totolTime
{
    _totolTime = totolTime;
}
-(void)setCurrent:(CGFloat)current
{
    _current=current;
    [self updateCurrentTime:_current];
}
-(void)setDuration:(CGFloat)duration
{
    _duration = duration;
    [self updateTotolTime:_duration];
}
-(void)setLoadedProgress:(CGFloat)loadedProgress
{
    _loadedProgress=loadedProgress;
}
-(void)setState:(KingPlayerState)state
{
    _state = state;
}
-(void)setErrorState:(KingPlayerErrorState)errorState
{
    _errorState = errorState;
}
-(void)setPlayCount:(NSInteger)playCount
{
    _playCount=playCount;
}
-(void)setIsFinishLoad:(BOOL)isFinishLoad
{
    _isFinishLoad = isFinishLoad;
}
-(void)setIsLocalVideo:(BOOL)isLocalVideo
{
    _isLocalVideo=isLocalVideo;
}
#pragma get
-(CGFloat)playProgress
{
    return (self.duration > 0 )?(self.current / self.duration):0;
}
-(KingPlayerStatusModel * (^)(NSString *))KingPlayerCurrentTime
{
    return ^(NSString *time){
        self.currentTime = time;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}
-(KingPlayerStatusModel * (^)(NSString *))KingPlayerTotolTime
{
    return ^(NSString *time){
        self.totolTime = time;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(CGFloat))KingPlayerCurrent
{
    return ^(CGFloat time){
        self.current = time;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(CGFloat))KingPlayerDuration{
    return ^(CGFloat time){
        self.duration = time;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(CGFloat))KingPlayerLoadedProgress
{
    return ^(CGFloat progress){
        self.loadedProgress = progress;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(KingPlayerState))KingPlayerPlayState
{
    return ^(KingPlayerState state){
        if (self.state != state) {
            self.state = state;
            if (self.KingPlayerStateChange) {
                self.KingPlayerStateChange(self);
            }
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(NSInteger))KingPlayerErrorState
{
    return ^(NSInteger code){
        switch (code) {
            case -1001:
                self.errorState = KingPlayerErrorStateIsTimeOut;
                break;
            case -1004:
                self.errorState = KingPlayerErrorStateIsServerError;
                break;
            case -1005:
                self.errorState = KingPlayerErrorStateIsNetworkInterruption;
                break;
            case -1009:
                self.errorState = KingPlayerErrorStateIsconnectionless;
                break;
                
            default:
                self.errorState = KingPlayerErrorStateIsUnknow;
                break;
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(NSInteger))KingPlayerPlayCount
{
    return ^(NSInteger count){
        self.playCount = count;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(BOOL))KingPlayerPlayLoadingFinish
{
    return ^(BOOL isloadFinish){
        self.isFinishLoad = isloadFinish;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}
-(KingPlayerStatusModel *(^)(BOOL))KingPlayerPlayIsLocalVideo
{
    return ^(BOOL isLocalVideo){
        self.isLocalVideo = isLocalVideo;
        if (self.KingPlayerStateChange) {
            self.KingPlayerStateChange(self);
        }
        return self;
    };
}

#pragma mark update
/**
 *  更新当前播放时间
 *
 *  @param time 但前播放时间秒数
 */
- (void)updateCurrentTime:(CGFloat)time
{
    long videocurrent = ceil(time);
    
    NSString *str = nil;
    if (videocurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videocurrent/3600.f)),lround(floor(videocurrent%3600)/60.f),lround(floor(videocurrent/1.f))%60];
    }
    self.KingPlayerCurrentTime(str);
}
/**
 *  更新所有时间
 *
 *  @param time 时间（秒）
 */
- (void)updateTotolTime:(CGFloat)time
{
    long videoLenth = ceil(time);
    NSString *strtotol = nil;
    if (videoLenth < 3600) {
        strtotol =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videoLenth/60.f)),lround(floor(videoLenth/1.f))%60];
    } else {
        strtotol =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videoLenth/3600.f)),lround(floor(videoLenth%3600)/60.f),lround(floor(videoLenth/1.f))%60];
    }
    self.KingPlayerTotolTime(strtotol);
}
@end
