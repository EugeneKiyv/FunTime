//
//  CABasicAnimation+FunTime.h
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 11/30/16.
//  Copyright © 2016 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CABasicAnimation(FunTime)

+ (void)morphFromPath:(UIBezierPath *)pathFrom toPath:(UIBezierPath *)pathTo inView:(UIView *)view;
+ (void)morphFromPath:(UIBezierPath *)pathFrom toPath:(UIBezierPath *)pathTo inView:(UIView *)view withWidth:(CGFloat)width;
+ (void)animateCircle:(CAShapeLayer *)circle;
@end
