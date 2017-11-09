//
//  ViewController.m
//  KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import "KingCacheVideoPlayer.h"
#import "KingCacheVideoPlayer+Cache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.5625)];
    [self.view addSubview:videoView];
    [[KingCacheVideoPlayer sharedInstance]playWithUrl:[NSURL URLWithString:@"http://cdn.xinchao.mobi/imgs/201711/5a02be4dbd7a5.mp4"] withView:videoView andConfig:^void (KingCacheVideoPlayerConfig *config) {
        config.KingVideoPlayerConfigPlayRepatCount(3);
    }];
    [[KingCacheVideoPlayer sharedInstance]playStatusObserver:^(KingPlayerStatusModel *model){
        NSLog(@"%f",model.current);
        NSLog(@"%ld",(long)model.playCount);

        
    }];
    NSLog(@"%f", [[KingCacheVideoPlayer sharedInstance] allVideoCacheSize:nil]);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
