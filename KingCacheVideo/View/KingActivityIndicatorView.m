//
//  KingActivityIndicatorView.m
//  KingCacheVideo
//
//  Created by J on 2017/11/10.
//

#import "KingActivityIndicatorView.h"

@implementation KingActivityIndicatorView

-(void)startAnimating{
    [super startAnimating];
    self.hidden = NO;
}
-(void)stopAnimating{
    [super stopAnimating];
    self.hidden = YES;
}

@end
