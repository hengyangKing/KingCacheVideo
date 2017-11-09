//
//  KingLoaderURLConnection.h
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "KingVideoRequestTask.h"
@protocol KingLoaderURLConnectionDelegate <NSObject>

- (void)didFinishLoadingWithTask:(KingVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(KingVideoRequestTask *)task withError:(NSInteger )errorCode;

@end
@interface KingLoaderURLConnection : NSURLConnection<AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) KingVideoRequestTask *task;
@property (nonatomic, weak  ) id<KingLoaderURLConnectionDelegate> delegate;

- (NSURL *)getSchemeVideoURL:(NSURL *)url;
@end
