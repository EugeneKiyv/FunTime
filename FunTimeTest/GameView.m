//
//  GameView.m
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 11/30/16.
//  Copyright © 2016 home. All rights reserved.
//

#import "GameView.h"
static CGFloat const indent = 15.;

@interface GameView ()
@property (assign, nonatomic) CGFloat cellHeight;
@property (weak, nonatomic) id <GameViewDelegate> delegate;
@property (assign, nonatomic)CGFloat width;
@end

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id <GameViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    _delegate = delegate;
    self.width = CGRectGetWidth(frame);
    self.cellHeight = CGRectGetHeight(frame) / 3.;
    for (int i = 1; i <= 2; i++) {
        CGFloat startPoint = self.cellHeight * i;
        [self drawLineFrom:CGPointMake(indent, startPoint)
                        to:CGPointMake(self.width-indent,startPoint)
                     width:2.];
        
        [self drawLineFrom:CGPointMake(startPoint, indent)
                        to:CGPointMake(startPoint,self.width-indent)
                     width:2.];
    }
    
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [[touches allObjects] firstObject];
    if (touche) {
        CGPoint point = [touche locationInView:self];
        CGPoint cell;
        cell.x = (int)(point.x / self.cellHeight);
        cell.y = (int)(point.y / self.cellHeight);
        [self.delegate didTapOnPoint:cell];
    }
}

- (void)showVerticalLine:(NSInteger)line {
    [self drawLineFrom:CGPointMake(indent, self.cellHeight * (line+0.5))
                    to:CGPointMake(self.width-indent,self.cellHeight * (line+0.5))
                 width:10.];
}

- (void)showHorizontalLine:(NSInteger)line {
    [self drawLineFrom:CGPointMake(self.cellHeight * (line+0.5),indent)
                    to:CGPointMake(self.cellHeight * (line+0.5),self.width-indent)
                 width:10.];
}

- (void)showCrossLine1 {
    [self drawLineFrom:CGPointMake(indent, indent )
                    to:CGPointMake(self.cellHeight * 3-indent,self.width-indent)
                 width:10.];
}

- (void)showCrossLine2 {
    [self drawLineFrom:CGPointMake(self.width-indent, indent)
                    to:CGPointMake(indent,self.width-indent)
                 width:10.];
}

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
