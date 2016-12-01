//
//  GameView.h
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 11/30/16.
//  Copyright © 2016 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameViewDelegate <NSObject>

- (void)didTapOnPoint:(CGPoint)point sender:(id)sender;

@end

@interface GameView : UIView

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id <GameViewDelegate>)delegate;
- (instancetype)init __attribute__((unavailable("init not available, call initWithFrame:andDelegate: instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call initWithFrame:andDelegate: instead")));

- (void)showVerticalLine:(NSInteger)line;
- (void)showHorizontalLine:(NSInteger)line;
- (void)showCrossLine1;
- (void)showCrossLine2;
@end
