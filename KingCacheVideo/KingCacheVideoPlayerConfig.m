//
//  KingCacheVideoPlayerConfig.m
//  KingCacheVideo
//
//  Created by J on 2017/11/9.
//

#import "KingCacheVideoPlayerConfig.h"
#import "NSString+KingStrTools.h"
@implementation KingCacheVideoPlayerConfig
+(instancetype)defaultConfig
{
    KingCacheVideoPlayerConfig *config= [[KingCacheVideoPlayerConfig alloc]init];
    config.KingVideoPlayerConfigINBGStop(YES).KingVideoPlayerConfigPlayRepatCount(1).KingVideoPlayerConfigPlayBGColor([UIColor blackColor]).KingVideoPlayerConfigHiddenIndicatorView(NO).KingVideoPlayerConfigIndicatorViewStyle(UIActivityIndicatorViewStyleWhite).KingCacheVideoPlayerNeedCache(YES);
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    config.KingVideoPlayerConfigCachePath(document);
    return config;
    
}
#pragma mark set
-(void)setNeedCache:(BOOL)needCache
{
    _needCache = needCache;
}
-(void)setStopInBackground:(BOOL)stopInBackground
{
    _stopInBackground=stopInBackground;
}
-(void)setPlayRepatCount:(NSInteger)playRepatCount
{
    _playRepatCount=playRepatCount;
}
-(void)setPlayBGColor:(UIColor *)playBGColor
{
    _playBGColor=playBGColor;
}
-(void)setHiddenIndicatorView:(BOOL)hiddenIndicatorView
{
    _hiddenIndicatorView=hiddenIndicatorView;
}
-(void)setIndicatorViewStyle:(UIActivityIndicatorViewStyle)indicatorViewStyle
{
    _indicatorViewStyle=indicatorViewStyle;
}
-(void)setCachePath:(NSString *)cachePath
{
    _cachePath=cachePath;
}
#pragma get
-(KingCacheVideoPlayerConfig *(^)(BOOL))KingVideoPlayerConfigINBGStop
{
    return ^(BOOL stopInBackground){
        self.stopInBackground = stopInBackground;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(NSInteger))KingVideoPlayerConfigPlayRepatCount
{
    return ^(NSInteger repatCount){
        self.playRepatCount = repatCount;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(UIColor *))KingVideoPlayerConfigPlayBGColor{
    return ^(UIColor *color){
        self.playBGColor = color;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(BOOL))KingVideoPlayerConfigHiddenIndicatorView{
    return ^(BOOL hidden){
        self.hiddenIndicatorView = hidden;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(UIActivityIndicatorViewStyle))KingVideoPlayerConfigIndicatorViewStyle{
    
    return ^(UIActivityIndicatorViewStyle style){
        self.indicatorViewStyle = style;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(NSString *))KingVideoPlayerConfigCachePath{
    return ^(NSString *path){
        self.cachePath =path;
        return self;
    };
}
-(KingCacheVideoPlayerConfig *(^)(BOOL))KingCacheVideoPlayerNeedCache
{
    return ^(BOOL needCache){
        self.needCache = needCache;
        return self;
    };
}

@end
