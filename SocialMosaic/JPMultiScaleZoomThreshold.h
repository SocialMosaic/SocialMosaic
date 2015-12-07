//
//  JPMultiScaleZoomThreshold.h
//  SocialMosaic
//
//  Created by Jesse Pinho on 12/5/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface JPMultiScaleZoomThreshold : NSObject
@property (strong, nonatomic) NSObject *object;
@property (nonatomic) CGFloat scaleEnd;
@property (nonatomic) CGFloat scaleStart;

+ (JPMultiScaleZoomThreshold *)thresholdWithObject:(NSObject *)object scaleStart:(CGFloat)scaleStart scaleEnd:(CGFloat)scaleEnd;
- (BOOL)containsZoomLevel:(CGFloat)zoomLevel;
- (CGFloat)transformedScaleFromScale:(CGFloat)scale;
@end
