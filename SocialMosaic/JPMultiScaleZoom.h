//
//  JPMultiScaleZoom.h
//  SocialMosaic
//
//  Created by Jesse Pinho on 12/5/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@class JPMultiScaleZoom;

@protocol JPMultiScaleZoomDelegate <NSObject>
- (void)multiScaleZoom:(JPMultiScaleZoom *)multiScaleZoom didUpdateZoomTo:(CGFloat)zoomLevel forObject:(NSObject *)object;
@end

@interface JPMultiScaleZoom : NSObject
@property (weak, nonatomic) NSObject<JPMultiScaleZoomDelegate> *delegate;
@property (nonatomic) CGFloat scale;

- (void)addThresholdWithObject:(NSObject *)object scaleStart:(CGFloat)scaleStart scaleEnd:(CGFloat)scaleEnd;
@end
