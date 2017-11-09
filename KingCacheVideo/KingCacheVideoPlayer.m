//
//  KingCacheVideoPlayer.m
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import "KingCacheVideoPlayer.h"
#import "KingLoaderURLConnection.h"
#import "KingPlayerView.h"
#import "NSString+KingStrTools.h"
#define LeastMoveDistance 15
#define TotalScreenTime 90

NSString *const kKingPlayerStateChangedNotification    = @"KingPlayerStateChangedNotification";
NSString *const kKingPlayerProgressChangedNotification = @"KingPlayerProgressChangedNotification";
NSString *const kKingPlayerLoadProgressChangedNotification = @"KingPlayerLoadProgressChangedNotification";

static NSString *const KingVideoPlayerItemStatusKeyPath = @"status";
static NSString *const KingVideoPlayerItemLoadedTimeRangesKeyPath = @"loadedTimeRanges";
static NSString *const KingVideoPlayerItemPlaybackBufferEmptyKeyPath = @"playbackBufferEmpty";
static NSString *const KingVideoPlayerItemPlaybackLikelyToKeepUpKeyPath = @"playbackLikelyToKeepUp";
static NSString *const KingVideoPlayerItemPresentationSizeKeyPath = @"presentationSize";

@interface KingCacheVideoPlayer()<KingLoaderURLConnectionDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,strong)KingPlayerStatusModel *statusModel;

@property (nonatomic, assign) KingPlayerState state;
@property (nonatomic, assign) CGFloat        loadedProgress;
@property (nonatomic, strong) AVURLAsset     *videoURLAsset;
@property (nonatomic, strong) AVAsset        *videoAsset;
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) NSObject       *playbackTimeObserver;
@property (nonatomic, assign) BOOL           isPauseByUser;           //是否被用户暂停
@property (nonatomic, assign) BOOL           isLocalVideo;            //是否播放本地文件
@property (nonatomic, assign) BOOL           isFinishLoad;            //是否下载完毕

@property (nonatomic, weak  ) UIView         *showView;
@property (nonatomic, assign) CGRect         showViewRect;            //视频展示ViewRect
@property (nonatomic, strong) KingPlayerView  *playerView;

@property (nonatomic, strong) UIActivityIndicatorView *actIndicator;  //加载视频时的旋转菊花

@property (nonatomic, strong) KingLoaderURLConnection *resouerLoader;
@property (nonatomic,copy)void (^playStatusBlock)(KingPlayerStatusModel *statusModel);
@end
@implementation KingCacheVideoPlayer
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static KingCacheVideoPlayer *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isPauseByUser = YES;
        _loadedProgress = 0;
        _state = KingPlayerStateStopped;
        _stopInBackground = YES;
        _playRepatCount = 1;
        _playCount = 1;
        }
    return self;
}
- (KingPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[KingPlayerView alloc]init];
    }
    return _playerView;
}
-(KingPlayerStatusModel *)statusModel
{
    if (!_statusModel) {
        _statusModel = [KingPlayerStatusModel defaultModel];
    }
    return _statusModel;
}
- (UIActivityIndicatorView *)actIndicator {
    if (!_actIndicator) {
        _actIndicator = [[UIActivityIndicatorView alloc]init];
    }
    return _actIndicator;
}
-(void)playStatusObserver:(void (^)(KingPlayerStatusModel *))status
{
    _playStatusBlock =status;
}
#pragma mark play
- (void)playWithUrl:(NSURL *)url withView:(UIView *)showView andNeedCache:(BOOL)needCache {
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    NSURL *playUrl = [components URL];
    NSString *md5File = [NSString stringWithFormat:@"%@.mp4", [[playUrl absoluteString] stringToMD5]];
    
    //这里自己写需要保存数据的路径
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *cachePath =  [document stringByAppendingPathComponent:md5File];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath] && needCache) {
        NSURL *localURL = [NSURL fileURLWithPath:cachePath];
        [self playWithVideoUrl:localURL showView:showView];
    } else {
        [self playWithVideoUrl:url showView:showView];
    }
}
- (void)playWithVideoUrl:(NSURL *)url showView:(UIView *)showView
{
    
    [self.player pause];
    [self releasePlayer];
    
    self.isPauseByUser = NO;
    self.loadedProgress = 0;
    self.statusModel.KingPlayerDuration(0).KingPlayerCurrent(0);
    
    _showView = showView;
    _showViewRect = showView.frame;
    _showView.backgroundColor = [UIColor blackColor];
    
    NSString *str = [url absoluteString];
    //如果是ios  < 7 或者是本地资源，直接播放
    if ([str hasPrefix:@"https"] || [str hasPrefix:@"http"]) {
        
        self.resouerLoader          = [[KingLoaderURLConnection alloc] init];
        self.resouerLoader.delegate = self;
        NSURL *playUrl              = [self.resouerLoader getSchemeVideoURL:url];
        self.videoURLAsset          = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        [_videoURLAsset.resourceLoader setDelegate:self.resouerLoader queue:dispatch_get_main_queue()];
        self.currentPlayerItem      = [AVPlayerItem playerItemWithAsset:_videoURLAsset];
        
        _isLocalVideo = NO;
    } else {
        self.videoAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:_videoAsset];
        _isLocalVideo = YES;
    }
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    }
    [(AVPlayerLayer *)self.playerView.layer setPlayer:self.player];
    
    [self.currentPlayerItem addObserver:self forKeyPath:KingVideoPlayerItemStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:KingVideoPlayerItemLoadedTimeRangesKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:KingVideoPlayerItemPlaybackBufferEmptyKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:KingVideoPlayerItemPlaybackLikelyToKeepUpKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:KingVideoPlayerItemPresentationSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.currentPlayerItem];
    
    if ([url.scheme isEqualToString:@"file"]) {
        // 如果已经在KingPlayerStatePlaying，则直接发通知，否则设置状态
        if (self.state == KingPlayerStatePlaying) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kKingPlayerStateChangedNotification object:nil];
        } else {
            self.state = KingPlayerStatePlaying;
        }
        
    } else {
        // 如果已经在KingPlayerStateBuffering，则直接发通知，否则设置状态
        if (self.state == KingPlayerStateBuffering) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kKingPlayerStateChangedNotification object:nil];
        } else {
            self.state = KingPlayerStateBuffering;
        }
    }
    [self createUI];

}
-(void)createUI{
    _showView.userInteractionEnabled = YES;
    [self.playerView removeFromSuperview];
    self.playerView.frame =CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height);
    [_showView addSubview:self.playerView];
    
    self.actIndicator.frame = CGRectMake((CGRectGetWidth(self.playerView.frame) - 44) / 2, (CGRectGetHeight(self.playerView.frame) - 44) / 2, 44, 44);
    [self.actIndicator removeFromSuperview];
    [_showView addSubview:self.actIndicator];
}
#pragma mark playControl
- (void)seekToTime:(CGFloat)seconds {
    if (self.state == KingPlayerStateStopped) {
        return;
    }
    
    seconds = MAX(0, seconds);
    seconds = MIN(seconds, self.statusModel.duration);
    
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        self.isPauseByUser = NO;
        [self.player play];
        if (!self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
            self.state = KingPlayerStateBuffering;
            self.actIndicator.hidden = NO;
            [self.actIndicator startAnimating];
        }
    }];
}
#pragma mark - observer

- (void)appDidEnterBackground
{
    if (self.stopInBackground) {
        [self pause];
        self.state = KingPlayerStatePause;
        self.isPauseByUser = NO;
    }
}
- (void)appDidEnterPlayGround
{
    if (!self.isPauseByUser) {
        [self resume];
        self.state = KingPlayerStatePlaying;
    }
}
- (void)playerItemDidPlayToEnd:(NSNotification *)notification
{
    //    [self stop];
    
    //如果当前播放次数小于重复播放次数，继续重新播放
    if (self.playCount < self.playRepatCount) {
        self.playCount++;
        [self seekToTime:0];
        self.statusModel.KingPlayerCurrent(0);
    } else {
        //如果有播放下一个的需求就播放下一个
        if (self.playNextBlock) {
            self.playNextBlock();
        } else {
            //重新播放
            self.state = KingPlayerStateFinish;
        }
    }
}
//在监听播放器状态中处理比较准确
- (void)playerItemPlaybackStalled:(NSNotification *)notification
{
    // 这里网络不好的时候，就会进入，不做处理，会在playbackBufferEmpty里面缓存之后重新播放
    NSLog(@"buffing----buffing");
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([KingVideoPlayerItemStatusKeyPath isEqualToString:keyPath]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            [self monitoringPlayback:playerItem];// 给播放器添加计时器
            
        } else if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown) {
            [self stop];
        }
        
    } else if ([KingVideoPlayerItemLoadedTimeRangesKeyPath isEqualToString:keyPath]) {  //监听播放器的下载进度
        
        [self calculateDownloadProgress:playerItem];
        
    } else if ([KingVideoPlayerItemPlaybackBufferEmptyKeyPath isEqualToString:keyPath]) { //监听播放器在缓冲数据的状态
        [self.actIndicator startAnimating];
        self.actIndicator.hidden = NO;
        if (playerItem.isPlaybackBufferEmpty) {
            self.state = KingPlayerStateBuffering;
            [self bufferingSomeSecond];
        }
    } else if ([KingVideoPlayerItemPlaybackLikelyToKeepUpKeyPath isEqualToString:keyPath]) {
        NSLog(@"KingVideoPlayerItemPlaybackLikelyToKeepUpKeyPath");
    } else if ([KingVideoPlayerItemPresentationSizeKeyPath isEqualToString:keyPath]) {
        CGSize size = self.currentPlayerItem.presentationSize;
        static float staticHeight = 0;
        staticHeight = size.height/size.width * [UIScreen mainScreen].bounds.size.width;
        NSLog(@"%f", staticHeight);
    }
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    //视频总时间
    self.statusModel.KingPlayerDuration((playerItem.duration.value / playerItem.duration.timescale));
    [self.player play];
    
    __weak __typeof(self)weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CGFloat current = playerItem.currentTime.value / playerItem.currentTime.timescale;
        strongSelf.statusModel.KingPlayerCurrent(current);
        if (strongSelf.isPauseByUser == NO) {
            strongSelf.state = KingPlayerStatePlaying;
        }
        
        // 不相等的时候才更新，并发通知，否则seek时会继续跳动
        if (strongSelf.statusModel.current != current) {
            strongSelf.statusModel.KingPlayerCurrent(current);
            if (strongSelf.statusModel.current > strongSelf.statusModel.duration) {
                strongSelf.statusModel.KingPlayerDuration(strongSelf.statusModel.current);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kKingPlayerProgressChangedNotification object:nil];
        }
        if (weakSelf.playStatusBlock) {
            weakSelf.playStatusBlock(weakSelf.statusModel);
        }
    }];
}

- (void)unmonitoringPlayback:(AVPlayerItem *)playerItem {
    if (self.playbackTimeObserver != nil) {
        [self.player removeTimeObserver:self.playbackTimeObserver];
        self.playbackTimeObserver = nil;
    }
}

- (void)calculateDownloadProgress:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
    CMTime duration = playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    self.loadedProgress = timeInterval / totalDuration;
}

- (void)bufferingSomeSecond
{
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self.player play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}

- (void)setLoadedProgress:(CGFloat)loadedProgress
{
    if (_loadedProgress == loadedProgress) {
        return;
    }
    
    _loadedProgress = loadedProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName:kKingPlayerLoadProgressChangedNotification object:nil];
    self.statusModel.KingPlayerLoadedProgress(_loadedProgress);
}

- (void)setState:(KingPlayerState)state
{
    if (state != KingPlayerStateBuffering) {
        //        [[XCHudHelper sharedInstance] hideHud];
        [self.actIndicator stopAnimating];
        self.actIndicator.hidden = YES;
    }
    
    if (_state == state) {
        return;
    }
    
    _state = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:kKingPlayerStateChangedNotification object:nil];
    self.statusModel.KingPlayerPlayState(_state);
}
#pragma mark  - playcontrol
/**
 *  重新播放
 */
- (void)resume
{
    if (!self.currentPlayerItem) {
        return;
    }
    self.isPauseByUser = NO;
    [self.player play];
}
/**
 *  暂停播放
 */
- (void)pause
{
    if (!self.currentPlayerItem) {
        return;
    }
    self.isPauseByUser = YES;
    self.state = KingPlayerStatePause;
    [self.player pause];
}
/**
 *  停止播放
 */
- (void)stop
{
    self.isPauseByUser = YES;
    self.loadedProgress = 0;
    self.statusModel.KingPlayerDuration(0).KingPlayerCurrent(0);
    self.state = KingPlayerStateStopped;
    [self.player pause];
    [self releasePlayer];
    [[NSNotificationCenter defaultCenter] postNotificationName:kKingPlayerProgressChangedNotification object:nil];
}

#pragma mark - KingLoaderURLConnectionDelegate

- (void)didFinishLoadingWithTask:(KingVideoRequestTask *)task
{
    _isFinishLoad = task.isFinishLoad;
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003

- (void)didFailLoadingWithTask:(KingVideoRequestTask *)task withError:(NSInteger )errorCode
{
    NSString *str = nil;
    switch (errorCode) {
        case -1001:
            str = @"请求超时";
            break;
        case -1003:
        case -1004:
            str = @"服务器错误";
            break;
        case -1005:
            str = @"网络中断";
            break;
        case -1009:
            str = @"无网络连接";
            break;
            
        default:
            str = [NSString stringWithFormat:@"%@", @"(_errorCode)"];
            break;
    }
    NSLog(@"%@", str);
}
- (void)releasePlayer {
    if (!self.currentPlayerItem) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.currentPlayerItem removeObserver:self forKeyPath:KingVideoPlayerItemStatusKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:KingVideoPlayerItemLoadedTimeRangesKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:KingVideoPlayerItemPlaybackBufferEmptyKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:KingVideoPlayerItemPlaybackLikelyToKeepUpKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:KingVideoPlayerItemPresentationSizeKeyPath];
    [self.player removeTimeObserver:self.playbackTimeObserver];
    self.playbackTimeObserver = nil;
    self.currentPlayerItem = nil;
    
    if (self.resouerLoader.task) {
        [self.resouerLoader.task cancel];
        self.resouerLoader.task = nil;
        self.resouerLoader = nil;
    }
}

- (void)dealloc
{
    [self releasePlayer];
}
@end
