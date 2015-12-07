//
//  JPMultiScaleZoom.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 12/5/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "JPMultiScaleZoom.h"
#import "JPMultiScaleZoomThreshold.h"
#import <CoreGraphics/CoreGraphics.h>

@interface JPMultiScaleZoom ()
@property (readonly, nonatomic) CGFloat maximumZoom;
@property (readonly, nonatomic) CGFloat minimumZoom;
@property (strong, nonatomic) NSMutableArray<JPMultiScaleZoomThreshold *> *thresholds;
@end

@implementation JPMultiScaleZoom
- (void)addThresholdWithObject:(NSObject *)object scaleStart:(CGFloat)scaleStart scaleEnd:(CGFloat)scaleEnd {
    [self.thresholds addObject:[JPMultiScaleZoomThreshold thresholdWithObject:object scaleStart:scaleStart scaleEnd:scaleEnd]];
}

- (void)setScale:(CGFloat)scale {
    if (![self containsZoomLevel:scale]) {
        return;
    }

    _scale = scale;

    [self.thresholds enumerateObjectsUsingBlock:^(JPMultiScaleZoomThreshold * _Nonnull threshold, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([threshold containsZoomLevel:scale]) {
            [self.delegate multiScaleZoom:self didUpdateZoomTo:[threshold transformedScaleFromScale:scale] forObject:threshold.object];
        }
    }];
}

- (CGFloat)maximumZoom {
    CGFloat maximumZoom = 0.0;
    for (JPMultiScaleZoomThreshold *threshold in self.thresholds) {
        if (threshold.scaleEnd > maximumZoom) {
            maximumZoom = threshold.scaleEnd;
        }
    }
    return maximumZoom;
}

- (CGFloat)minimumZoom {
    CGFloat minimumZoom = 0.0;
    for (JPMultiScaleZoomThreshold *threshold in self.thresholds) {
        if (threshold.scaleStart > minimumZoom) {
            minimumZoom = threshold.scaleStart;
        }
    }
    return minimumZoom;
}

- (BOOL)containsZoomLevel:(CGFloat)zoomLevel {
    return self.maximumZoom >= zoomLevel && self.minimumZoom <= zoomLevel;
}
@end
