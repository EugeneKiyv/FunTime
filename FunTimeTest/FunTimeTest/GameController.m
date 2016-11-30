
//
//  GameController.m
//  FunTimeTest
//
//  Created by Eugene Kuropatenko on 11/30/16.
//  Copyright © 2016 home. All rights reserved.
//

#import "GameController.h"
#import "GameView.h"
#import "CellFigure.h"

typedef enum {
    CellStateEmpty = 0,
    CellStateCross = 1,
    CellStateZero
} CellState;

@interface GameController () <GameViewDelegate>
@property (weak, nonatomic) GameView *gameView;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *gameCells;
@property (assign, nonatomic) BOOL isCroosQueue;
@end

@implementation GameController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGameTapped:(id)sender {
    [self startGame];
}

- (void)startGame {
    CGRect frame;
    CGFloat width = CGRectGetWidth(self.view.frame);
    if (self.gameView) {
        frame = self.gameView.frame;
        [self.gameView removeFromSuperview];
    } else {
        frame = self.view.bounds;
        frame.origin.y = (CGRectGetHeight(frame) - width) / 2.;
        frame.size.height = width;
    }
    
    GameView *gameView = [[GameView alloc] initWithFrame:frame andDelegate:self];
    [self.view addSubview:gameView];
    self.gameView = gameView;
    self.gameCells = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@(CellStateEmpty),@(CellStateEmpty),@(CellStateEmpty), nil],
                      [NSMutableArray arrayWithObjects:@(CellStateEmpty),@(CellStateEmpty),@(CellStateEmpty), nil],
                      [NSMutableArray arrayWithObjects:@(CellStateEmpty),@(CellStateEmpty),@(CellStateEmpty), nil],nil];
    
    self.isCroosQueue = YES;
    
    

}
- (void)didTapOnPoint:(CGPoint)point {
    if ([self.gameCells[(int)point.x][(int)point.y] integerValue] == CellStateEmpty) {
        CellFigure *figure = [CellFigure new];
        figure.view = self.gameView;
        if (self.isCroosQueue) {
            self.gameCells[(int)point.x][(int)point.y] = @(CellStateCross);
            [figure showCrossInPoint:point intoCube:CGRectGetWidth(self.gameView.bounds)/3.];
        } else {
            self.gameCells[(int)point.x][(int)point.y] = @(CellStateZero);
            [figure showRoundInPoint:point intoCube:CGRectGetWidth(self.gameView.bounds)/3.];
        }
        self.isCroosQueue = !self.isCroosQueue;
        [self checkPoint:point];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.gameView.backgroundColor = [UIColor redColor];
        } completion:^(BOOL finished) {
            self.gameView.backgroundColor = [UIColor clearColor];
        }];
    }
}

- (void)checkPoint:(CGPoint)point {
    NSNumber *currentFigure = self.gameCells[(int)point.x][(int)point.y];
    BOOL vertical = YES;
    for (int x = 0; x <= 2; x++) {
        if (![self.gameCells[x][(int)point.y] isEqualToNumber:currentFigure]) {
            vertical = NO;
        }
    }
    BOOL horizontal = YES;
    for (int y = 0; y <= 2; y++) {
        if (![self.gameCells[(int)point.x][y] isEqualToNumber:currentFigure]) {
            horizontal = NO;
        }
    }
    if (vertical) {
        [self.gameView showVerticalLine:(int)point.y];
        [self gameOver];
    } else if (horizontal) {
        [self.gameView showHorizontalLine:(int)point.x];
        [self gameOver];
    } else {
        BOOL centre1 = YES;
        BOOL centre2 = YES;
        for (int z = 0; z <= 2; z++) {
            if (![self.gameCells[z][z] isEqualToNumber:currentFigure]) {
                centre1 = NO;
            }
            if (![self.gameCells[z][2-z] isEqualToNumber:currentFigure]) {
                centre2 = NO;
            }
        }
        if (centre1 || centre2) {
            if (centre1) {
                [self.gameView showCrossLine1];
            } else {
                [self.gameView showCrossLine2];
            }
            [self gameOver];
        } else {
            [self checkCells];
        }
    }
}

- (void)checkCells {
    BOOL isPresentEmtyCell = NO;
    for (int x = 0; x <= 2; x++) {
        for (int y = 0; y <= 2; y++) {
            if ([self.gameCells[x][y] integerValue] == CellStateEmpty) {
                isPresentEmtyCell = YES;
            }
        }
    }
    if (!isPresentEmtyCell) {
        [self gameOver];
    }
}

- (void)gameOver {
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startGame];
    }];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"GAME OVER" message:@"Start new game" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:actionOk];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
