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
    UIBezierPath *xPathFrom = [UIBezierPath bezierPath];
    [xPathFrom moveToPoint:CGPointMake(point.x*cubeSize + indent, point.y*cubeSize+ indent)];
    [xPathFrom addLineToPoint:CGPointMake(point.x*cubeSize + indent, point.y*cubeSize+indent)];
    UIBezierPath *xPathTo= [UIBezierPath bezierPath];
    [xPathTo moveToPoint:CGPointMake(point.x*cubeSize + indent, point.y*cubeSize+ indent)];
    [xPathTo addLineToPoint:CGPointMake((point.x+1)*cubeSize - indent, (point.y+1)*cubeSize - indent)];
    [CABasicAnimation morphFromPath:xPathFrom toPath:xPathTo inView:self.view withWidth:5.];
    xPathFrom = [UIBezierPath bezierPath];
    [xPathFrom moveToPoint:CGPointMake((point.x+1)*cubeSize - indent, point.y*cubeSize+ indent)];
    [xPathFrom addLineToPoint:CGPointMake((point.x+1)*cubeSize - indent, point.y*cubeSize+indent)];
    xPathTo= [UIBezierPath bezierPath];
    [xPathTo moveToPoint:CGPointMake(point.x*cubeSize + indent, (point.y+1)*cubeSize - indent)];
    [xPathTo addLineToPoint:CGPointMake((point.x+1)*cubeSize - indent, (point.y)*cubeSize + indent)];
    [CABasicAnimation morphFromPath:xPathFrom toPath:xPathTo inView:self.view withWidth:5.];
}
@end
