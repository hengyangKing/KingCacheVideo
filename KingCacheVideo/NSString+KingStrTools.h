//
//  NSString+KingStrTools.h
//  Pods-KingCacheVideoDemo
//
//  Created by J on 2017/11/9.
//

#import <Foundation/Foundation.h>

@interface NSString (KingStrTools)
- (NSString *)stringToMD5;
+ (NSString *)calculateTimeWithTimeFormatter:(long long)timeSecond;
@end
