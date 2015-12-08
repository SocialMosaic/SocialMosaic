//
//  GalleryToTilesSegue.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 12/7/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "GalleryToTilesSegue.h"

@implementation GalleryToTilesSegue
- (void)perform {
    self.destinationViewController.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self.destinationViewController.view];
    self.destinationViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.destinationViewController.view.alpha = 0.0;
    [UIView animateWithDuration:1.35 animations:^{
        self.sourceViewController.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
        self.sourceViewController.view.alpha = 0.0;
        self.destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.destinationViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
    }];
}
@end
