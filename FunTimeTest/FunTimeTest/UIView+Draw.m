//
//  UIView+Draw.m
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 12/1/16.
//  Copyright © 2016 home. All rights reserved.
//

#import "UIView+Draw.h"

@implementation UIView(Draw)

- (void)drawLineFrom:(CGPoint)pointStart to:(CGPoint)pointEnd width:(CGFloat)width {
    UIBezierPath *xPathFrom = [UIBezierPath bezierPath];
    [xPathFrom moveToPoint:pointStart];
    [xPathFrom addLineToPoint:pointStart];
    UIBezierPath *xPathTo= [UIBezierPath bezierPath];
    [xPathTo moveToPoint:pointStart];
    [xPathTo addLineToPoint:pointEnd];
    [CABasicAnimation morphFromPath:xPathFrom toPath:xPathTo inView:self withWidth:width];
}

@end
