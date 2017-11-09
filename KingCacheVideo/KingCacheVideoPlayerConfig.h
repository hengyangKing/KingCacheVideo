//
//  KingCacheVideoPlayerConfig.h
//  KingCacheVideo
//
//  Created by J on 2017/11/9.
//

#import <Foundation/Foundation.h>

@interface KingCacheVideoPlayerConfig : NSObject
+(instancetype)defaultConfig;
/**
 是否需要缓存
 */
@property (nonatomic, assign,readonly)BOOL  needCache;

/**
 是否在后台播放，默认YES
 */
@property (nonatomic, assign,readonly)BOOL  stopInBackground;
/**
 重复播放次数
 */
@property (nonatomic, assign,readonly) NSInteger playRepatCount;

/**
 播放背景色
 */
@property (nonatomic,strong,readonly)UIColor *playBGColor;

/**
 隐藏菊花
 */
@property (nonatomic,assign,readonly)BOOL hiddenIndicatorView;

/**
 菊花风格
 */
@property (nonatomic,assign,readonly)UIActivityIndicatorViewStyle indicatorViewStyle;
/**
 存储地址
 */
@property (nonatomic,copy,readonly)NSString *cachePath;


@property(nonatomic,copy,readonly)KingCacheVideoPlayerConfig *(^KingCacheVideoPlayerNeedCache)(BOOL needCache);

@property(nonatomic,copy,readonly)KingCacheVideoPlayerConfig* (^KingVideoPlayerConfigINBGStop)(BOOL stopInBackground);


@property(nonatomic,copy,readonly)KingCacheVideoPlayerConfig * (^KingVideoPlayerConfigPlayRepatCount)(NSInteger playRepatCount);

@property(nonatomic,copy,readonly)KingCacheVideoPlayerConfig * (^KingVideoPlayerConfigPlayBGColor)(UIColor *color);

@property(nonatomic,copy,readonly)KingCacheVideoPlayerConfig * (^KingVideoPlayerConfigHiddenIndicatorView)(BOOL hidden);

@property(nonatomic,copy,readonly)KingCacheVideoPlayerConfig * (^KingVideoPlayerConfigIndicatorViewStyle)(UIActivityIndicatorViewStyle indicatorViewStyle);

@property(nonatomic,copy,readonly)KingCacheVideoPlayerConfig *(^KingVideoPlayerConfigCachePath)(NSString *filePath);



@end