 
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
#import "BluetoothConnector.h"

typedef enum {
    CellStateEmpty = 0,
    CellStateCross = 1,
    CellStateZero
} CellState;

@interface GameController () <GameViewDelegate,BluetoothConnectorDelegate>
@property (weak, nonatomic) GameView *gameView;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *gameCells;
@property (assign, nonatomic) BOOL isCroosQueue;
@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;
@property (strong, nonatomic) BluetoothConnector *btConnector;
@property (assign, nonatomic, getter=isPresentOtherPlayer) BOOL presentOtherPlayer;
@property (assign, nonatomic) CellState mineFigure;
@property (assign, nonatomic) BOOL mineTurn;
@end

@implementation GameController

static const NSString *newGameMessage = @"new game";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btConnector = [[BluetoothConnector alloc] initWithDelegate:self];
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
    [self.btConnector sendMessage:@{newGameMessage:@(YES)}];
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
    self.mineFigure = CellStateEmpty;
    self.mineTurn = YES;
}

#pragma mark - GameViewDelegate
- (void)didTapOnPoint:(CGPoint)point sender:(id)sender {
    if (self.isPresentOtherPlayer && !self.mineTurn && ![sender isEqual:self]) {
        [self showError];
        return;
    }
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
        if (self.mineTurn) {
            [self.btConnector sendMessage:@{@"X":@((int)point.x),@"Y":@((int)point.y)}];
            self.mineTurn = NO;
        }
        [self checkPoint:point];
    } else {
        [self showError];
    }
}

- (void)showError {
    [UIView animateWithDuration:0.2 animations:^{
        self.gameView.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished) {
        self.gameView.backgroundColor = [UIColor clearColor];
    }];
}

#pragma mark -
- (void)checkPoint:(CGPoint)point {
    if (self.isPresentOtherPlayer && self.mineFigure == CellStateEmpty) {
        self.mineFigure = CellStateCross;
    }
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

#pragma mark - BluetoothConnectorDelegate
- (void)recivedMessage:(NSDictionary *)message {
    if (message[@"X"]) {
        self.mineTurn = NO;
        CGPoint point = {.x = [message[@"X"] integerValue], .y = [message[@"Y"] integerValue]};
        if (self.mineFigure == CellStateEmpty) {
            self.mineFigure = CellStateZero;
        }
        [self didTapOnPoint:point sender:self];
        self.mineTurn = YES;
    } else if ([message[newGameMessage] boolValue]) {
        [self startGame];
    }
}

- (void)didConnect {
    self.presentOtherPlayer = YES;
}

- (void)didDisconnect {
    self.presentOtherPlayer = NO;
}

- (void)didChangeBluetoothAvailable:(BOOL)available {
    self.bluetoothButton.hidden = available;
}

- (IBAction)turnOnBluetooth:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
}
@end
