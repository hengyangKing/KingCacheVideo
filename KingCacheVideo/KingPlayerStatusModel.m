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
    model.KingPlayerDuration(0).KingPlayerCurrent(0).KingPlayerLoadedProgress(0);
    
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
#pragma get
-(CGFloat)playProgress
{
    return (self.duration > 0 )?(self.current / self.duration):0;
}
-(KingPlayerStatusModel * (^)(NSString *))KingPlayerCurrentTime
{
    return ^(NSString *time){
        self.currentTime = time;
        return self;
    };
}
-(KingPlayerStatusModel * (^)(NSString *))KingPlayerTotolTime
{
    return ^(NSString *time){
        self.totolTime = time;
        return self;
    };
}
-(KingPlayerStatusModel *(^)(CGFloat))KingPlayerCurrent
{
    return ^(CGFloat time){
        self.current = time;
        return self;
    };
}
-(KingPlayerStatusModel *(^)(CGFloat))KingPlayerDuration{
    return ^(CGFloat time){
        self.duration = time;
        return self;
    };
}
-(KingPlayerStatusModel *(^)(CGFloat))KingPlayerLoadedProgress
{
    return ^(CGFloat progress){
        self.loadedProgress = progress;
        return self;
    };
}
-(KingPlayerStatusModel *(^)(KingPlayerState))KingPlayerPlayState
{
    return ^(KingPlayerState state){
        self.state = state;
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
