//
//  KingCacheVideoPlayerConfig.m
//  KingCacheVideo
//
//  Created by J on 2017/11/9.
//

#import "KingCacheVideoPlayerConfig.h"
#import "NSString+KingStrTools.h"
@implementation KingCacheVideoPlayerConfig
+(instancetype)defaultConfig {
    KingCacheVideoPlayerConfig *config= [[KingCacheVideoPlayerConfig alloc]init];
    config.KingVideoPlayerConfigINBGStop(YES).KingVideoPlayerConfigPlayRepatCount(1).KingVideoPlayerConfigPlayBGColor([UIColor blackColor]).KingVideoPlayerIndicatorStyle(hidden).KingCacheVideoPlayerNeedCache(YES).KingVideoPlayerConfigFeedbackTime(CMTimeMake(1, 2)).KingVideoPlayerConfigCachePath(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject);
    return config;
}
#pragma mark set
-(void)setNeedCache:(BOOL)needCache {
    _needCache = needCache;
}
-(void)setStopInBackground:(BOOL)stopInBackground {
    _stopInBackground=stopInBackground;
}
-(void)setPlayRepatCount:(NSInteger)playRepatCount {
    _playRepatCount=playRepatCount;
}
-(void)setPlayBGColor:(UIColor *)playBGColor {
    _playBGColor=playBGColor;
}
-(void)setIndicatorStyle:(VideoPlayerIndicatorStyle)indicatorStyle {
    _indicatorStyle = indicatorStyle;
}
-(void)setCachePath:(NSString *)cachePath {
    _cachePath=cachePath;
}
-(void)setFeedbackTime:(CMTime)feedbackTime {
    _feedbackTime = feedbackTime;
}
#pragma get
-(KingCacheVideoPlayerConfig *(^)(BOOL))KingVideoPlayerConfigINBGStop {
    return ^(BOOL stopInBackground){
        self.stopInBackground = stopInBackground;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(NSInteger))KingVideoPlayerConfigPlayRepatCount {
    return ^(NSInteger repatCount){
        self.playRepatCount = repatCount;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(UIColor *))KingVideoPlayerConfigPlayBGColor {
    return ^(UIColor *color){
        self.playBGColor = color;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(VideoPlayerIndicatorStyle))KingVideoPlayerIndicatorStyle {
    return ^(VideoPlayerIndicatorStyle style){
        self.indicatorStyle = style;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(NSString *))KingVideoPlayerConfigCachePath {
    return ^(NSString *path){
        self.cachePath =path;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(BOOL))KingCacheVideoPlayerNeedCache {
    return ^(BOOL needCache){
        self.needCache = needCache;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(CMTime))KingVideoPlayerConfigFeedbackTime {
    return ^(CMTime time){
        self.feedbackTime = time;
        return self;
    };
}
@end
