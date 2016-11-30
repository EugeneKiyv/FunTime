//
//  CellFigure.h
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 11/30/16.
//  Copyright © 2016 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellFigure : NSObject
@property (weak, nonatomic) UIView *view;

- (void)showRoundInPoint:(CGPoint)point intoCube:(CGFloat)cubeSize;
- (void)showCrossInPoint:(CGPoint)point intoCube:(CGFloat)cubeSize;
@end
