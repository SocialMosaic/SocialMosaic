//
//  JPMultiScaleZoomThreshold.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 12/5/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "JPMultiScaleZoomThreshold.h"

@implementation JPMultiScaleZoomThreshold
+ (JPMultiScaleZoomThreshold *)thresholdWithObject:(NSObject *)object scaleStart:(CGFloat)scaleStart scaleEnd:(CGFloat)scaleEnd {
    JPMultiScaleZoomThreshold *threshold = [[JPMultiScaleZoomThreshold alloc] init];
    threshold.object = object;
    threshold.scaleEnd = scaleEnd;
    threshold.scaleStart = scaleStart;
    return threshold;
}

- (BOOL)containsZoomLevel:(CGFloat)zoomLevel {
    return self.scaleEnd >= zoomLevel && self.scaleStart <= zoomLevel;
}

- (CGFloat)transformedScaleFromScale:(CGFloat)scale {
    return scale - self.scaleStart;
}
@end
