//
//  CABasicAnimation+FunTime.m
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 11/30/16.
//  Copyright © 2016 home. All rights reserved.
//

#import "CABasicAnimation+FunTime.h"

@implementation CABasicAnimation(FunTime)

+ (void)morphFromPath:(UIBezierPath *)pathFrom toPath:(UIBezierPath *)pathTo inView:(UIView *)view withWidth:(CGFloat)width {
    CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.5;
    morph.fromValue = (id)pathFrom.CGPath;
    morph.toValue = (id)pathTo.CGPath;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [pathFrom CGPath];
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.lineWidth = width;
    shapeLayer.fillColor = [[UIColor redColor] CGColor];
    [shapeLayer addAnimation:morph forKey:nil];
    [view.layer addSublayer:shapeLayer];
    
    shapeLayer.path = pathTo.CGPath;
}

+ (void)morphFromPath:(UIBezierPath *)pathFrom toPath:(UIBezierPath *)pathTo inView:(UIView *)view{
    [self morphFromPath:pathFrom toPath:pathTo inView:view withWidth:1.5];
}

+ (void)animateCircle:(CAShapeLayer *)circle {
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 0.5;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [circle addAnimation:drawAnimation forKey:@"drawCircle"];

}
@end
