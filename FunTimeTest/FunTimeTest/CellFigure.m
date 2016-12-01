//
//  CellFigure.m
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 11/30/16.
//  Copyright © 2016 home. All rights reserved.
//

#import "CellFigure.h"
static NSUInteger const indent = 10;

@implementation CellFigure

- (void)showRoundInPoint:(CGPoint)point intoCube:(CGFloat)cubeSize {
    
    int radius = cubeSize/2. - indent;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)cornerRadius:radius].CGPath;
    
    circle.position = CGPointMake(point.x * cubeSize+indent, point.y * cubeSize+indent);
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blueColor].CGColor;
    circle.lineWidth = 5;
    
    [self.view.layer addSublayer:circle];
    
    [CABasicAnimation animateCircle:circle];
}

- (void)showCrossInPoint:(CGPoint)point intoCube:(CGFloat)cubeSize  {
    [self.view drawLineFrom:CGPointMake(point.x*cubeSize+indent, point.y*cubeSize+indent)
                         to:CGPointMake((point.x+1)*cubeSize - indent, (point.y+1)*cubeSize - indent)
                      width:5.];
    [self.view drawLineFrom:CGPointMake((point.x+1)*cubeSize-indent, point.y*cubeSize+indent)
                         to:CGPointMake(point.x*cubeSize+indent, (point.y+1)*cubeSize-indent)
                      width:5.];
}
@end
