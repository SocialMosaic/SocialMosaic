//
//  GridView.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/19/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "GridView.h"

@implementation GridView
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    UIColor *gridColor = [UIColor colorWithWhite:0.0 alpha:0.15];
    CGContextSetStrokeColorWithColor(context, [gridColor CGColor]);
    
    for (int i = 1; i < self.cellsAcross; i++) {
        [self drawColumnNumber:i context:context];
    }
    
    for (int i = 1; i < self.cellsAcross; i++) {
        [self drawRowNumber:i context:context];
    }
}

- (void)drawColumnNumber:(int)number context:(CGContextRef)context {
    CGPoint startPoint = CGPointMake([self getCellSize] * number, 0.0f);
    CGPoint endPoint = CGPointMake(startPoint.x, self.frame.size.height);
    [self drawLineWithContext:context startPoint:startPoint endPoint:endPoint];
}

- (void)drawRowNumber:(int)number context:(CGContextRef)context {
    CGPoint startPoint = CGPointMake(0.0f, [self getCellSize] * number);
    CGPoint endPoint = CGPointMake(self.frame.size.width, startPoint.y);
    [self drawLineWithContext:context startPoint:startPoint endPoint:endPoint];
}

- (CGFloat)getCellSize {
    return self.frame.size.width / self.cellsAcross;
}

- (void)drawLineWithContext:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

- (void)setCellsAcross:(int)cellsAcross {
    _cellsAcross = cellsAcross;
    [self setNeedsDisplay];
}
@end
