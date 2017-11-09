//
//  KingVideoRequestTask.h
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class KingVideoRequestTask;

@protocol KingVideoRequestTaskDelegate <NSObject>

- (void)task:(KingVideoRequestTask *)task didReciveVideoLength:(NSUInteger)videoLength mimeType:(NSString *)mimeType;
- (void)didReciveVideoDataWithTask:(KingVideoRequestTask *)task;
- (void)didFinishLoadingWithTask:(KingVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(KingVideoRequestTask *)task withError:(NSInteger)errorCode;

@end

@interface KingVideoRequestTask : NSObject
@property (nonatomic, strong, readonly) NSURL         *url;
@property (nonatomic, readonly)         NSUInteger    offset;

@property (nonatomic, readonly)         NSUInteger    videoLength;
@property (nonatomic, readonly)         NSUInteger    downLoadingOffset;
@property (nonatomic, readonly)         NSString      *mimeType;
@property (nonatomic, assign)           BOOL          isFinishLoad;

@property (nonatomic, weak)             id<KingVideoRequestTaskDelegate> delegate;

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

- (void)continueLoading;

- (void)clearData;

@end
