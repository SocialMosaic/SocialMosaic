//
//  GridView.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/19/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "GridView.h"

@interface GridView ()
@property (nonatomic) CGContextRef context;
@end

@implementation GridView
- (void)drawRect:(CGRect)rect {
    self.context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(self.context, 2.0f);
    UIColor *gridColor = [UIColor colorWithWhite:1 alpha:0.2];
    CGContextSetStrokeColorWithColor(self.context, [gridColor CGColor]);
    
    for (int i = 1; i < self.cellsAcross; i++) {
        [self createLineForColumnNumber:i];
    }
    
    for (int i = 1; i < self.cellsAcross; i++) {
        [self createLineForRowNumber:i];
    }

    CGContextStrokePath(self.context);
}

- (void)createLineForColumnNumber:(int)number {
    CGPoint startPoint = CGPointMake([self getCellSize] * number, 0.0f);
    CGPoint endPoint = CGPointMake(startPoint.x, self.frame.size.height);
    [self createLineWithStartPoint:startPoint endPoint:endPoint];
}

- (void)createLineForRowNumber:(int)number {
    CGPoint startPoint = CGPointMake(0.0f, [self getCellSize] * number);
    CGPoint endPoint = CGPointMake(self.frame.size.width, startPoint.y);
    [self createLineWithStartPoint:startPoint endPoint:endPoint];
}

- (CGFloat)getCellSize {
    return self.frame.size.width / self.cellsAcross;
}

- (void)createLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGContextMoveToPoint(self.context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(self.context, endPoint.x, endPoint.y);
}

- (void)setCellsAcross:(int)cellsAcross {
    _cellsAcross = cellsAcross;
    [self setNeedsDisplay];
}
@end
