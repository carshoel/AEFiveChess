//
//  ViewController.m
//  AEFiveChess
//
//  Created by carshoel on 16/11/8.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "ViewController.h"
#import "AEFiveChessboard.h"
#import "YWUser.h"

@interface ViewController ()<AEFiveChessboardDelegate>
@property (nonatomic, weak)UIView *lastView;
@property (nonatomic, weak) AEFiveChessboard *board;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 设置控制器背景色
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    //2 设置操作显示盘
    [self setUpOperationView];
    
    
    //3 设置棋盘 (使用方法看这里)
    [self setUpChessBoard];
    
    
    
}

//设置操作显示盘
- (void)setUpOperationView{
    
    CGFloat w = 150;
    CGFloat h = 60;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - w * 2 - 5) * 0.5;
    CGFloat y = 20;
    
    UIButton *backBtn = [self btnWithTitle:@"悔棋" frame:CGRectMake(x, y, w, h) action:@selector(backBtnClick)];
    backBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:backBtn];
    
    x = CGRectGetMaxX(backBtn.frame) + 5;
    UIButton *reBeginBtn = [self btnWithTitle:@"重新开始" frame:CGRectMake(x, y, w, h) action:@selector(reBeginBtnClick)];
    reBeginBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:reBeginBtn];
    
    w = 300;
    x = ([UIScreen mainScreen].bounds.size.width - w) * 0.5;
    y = CGRectGetMaxY(reBeginBtn.frame) + 10;
    UIButton *style1Btn = [self btnWithTitle:@"示例样式1" frame:CGRectMake(x, y, w, h) action:@selector(boardStyle1)];
    style1Btn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:style1Btn];
    
    y = CGRectGetMaxY(style1Btn.frame) + 10;
    UIButton *style2Btn = [self btnWithTitle:@"示例样式2" frame:CGRectMake(x, y, w, h) action:@selector(boardStyle2)];
    style2Btn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:style2Btn];
    
    
    y = CGRectGetMaxY(style2Btn.frame) + 10;
    w = CGRectGetWidth(self.view.frame) - 40;
    x = 20;
    UILabel *showL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    showL.numberOfLines = 0;
    showL.font = [UIFont boldSystemFontOfSize:20];
    showL.backgroundColor = [UIColor blackColor];
    showL.textColor = [UIColor whiteColor];
    YWUser *u = self.board.currentUser;
    showL.text = [NSString stringWithFormat:@"当前棋手:name:%@, win:-->%l,fail:-->%l,temWin:-->%l,temFail:-->%l",u.name,u.winNum,u.failNum,u.tempWinNum,u.tempFailNum];
    [self.view addSubview:showL];
    self.lastView = showL;
}

//创建一个按钮
- (UIButton *)btnWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;
    
    return btn;
}

//设置棋盘
- (void)setUpChessBoard{
    
    [self boardStyle1];
}

//棋盘样式1
- (void)boardStyle1{
    
    [_board removeFromSuperview];
    
    AEFiveChessboard *board = [[AEFiveChessboard alloc] init];
    //    board.chessWidth = 50.0;
    board.line = 20;
    board.winNumber = 4;
    board.delegate = self;
    //    board.lineColor = [UIColor orangeColor];
    _board = board;
    //设置黑白用户
    //白棋
    YWUser *whiter = [[YWUser alloc] init];
    whiter.name = @"鱼尾";
    whiter.icon = @"awei.jpg";
    whiter.ID = 1;
    whiter.pkColor = [UIColor whiteColor];
    board.whitUser = whiter;

    
    //黑棋
    YWUser *blacker = [[YWUser alloc] init];
    blacker.name = @"祁芳";
    blacker.icon = @"qifang.jpg";
    blacker.ID = 2;
    blacker.pkColor = [UIColor blackColor];
    board.blackUser = blacker;
    
    board.currentUser = whiter;
    
    board.frame = CGRectMake(10, CGRectGetMaxY(self.lastView.frame), CGRectGetWidth(self.view.frame), 700);
    board.backgroundColor = [UIColor greenColor];
    [self.view addSubview:board];
    
    UILabel *showL = (UILabel *)self.lastView;
    YWUser *u = self.board.currentUser;
    showL.text = [NSString stringWithFormat:@"当前棋手:name:%@, win:-->%ld,fail:-->%ld,temWin:-->%ld,temFail:-->%ld",u.name,u.winNum,u.failNum,u.tempWinNum,u.tempFailNum];
}


//棋盘样式2
- (void)boardStyle2{
    
    [_board removeFromSuperview];
    
    AEFiveChessboard *board = [[AEFiveChessboard alloc] init];
    board.chessWidth = 50.0;
    board.winNumber = 6;
    board.delegate = self;
    board.lineColor = [UIColor whiteColor];
    _board = board;
    //设置黑白用户
    //白棋
    YWUser *whiter = [[YWUser alloc] init];
    whiter.name = @"鱼尾";
    whiter.icon = @"awei.jpg";
    whiter.ID = 1;
    whiter.pkColor = [UIColor whiteColor];
    board.whitUser = whiter;
    
    
    //黑棋
    YWUser *blacker = [[YWUser alloc] init];
    blacker.name = @"祁芳";
    blacker.icon = @"qifang.jpg";
    blacker.ID = 2;
    blacker.pkColor = [UIColor blackColor];
    board.blackUser = blacker;
    
    board.currentUser = whiter;
    
    board.frame = CGRectMake(10, CGRectGetMaxY(self.lastView.frame), CGRectGetWidth(self.view.frame), 300);
    board.backgroundColor = [UIColor redColor];
    [self.view addSubview:board];
    
    
    UILabel *showL = (UILabel *)self.lastView;
    YWUser *u = self.board.currentUser;
    showL.text = [NSString stringWithFormat:@"当前棋手:name:%@, win:-->%ld,fail:-->%ld,temWin:-->%ld,temFail:-->%ld",u.name,u.winNum,u.failNum,u.tempWinNum,u.tempFailNum];
}


#pragma mark - 棋盘操作
//重新开始
- (void)reBeginBtnClick{
    
    [self.board reBegin];
    UILabel *showL = (UILabel *)self.lastView;
    YWUser *u = self.board.currentUser;
    showL.text = [NSString stringWithFormat:@"当前棋手:name:%@, win:-->%ld,fail:-->%ld,temWin:-->%ld,temFail:-->%ld",u.name,u.winNum,u.failNum,u.tempWinNum,u.tempFailNum];
}
//悔棋
- (void)backBtnClick{
    [self.board back];
    UILabel *showL = (UILabel *)self.lastView;
    YWUser *u = self.board.currentUser;
    showL.text = [NSString stringWithFormat:@"当前棋手:name:%@, win:-->%ld,fail:-->%ld,temWin:-->%ld,temFail:-->%ld",u.name,u.winNum,u.failNum,u.tempWinNum,u.tempFailNum];
}

#pragma mark - 棋盘代理
- (void)fiveChessboard:(AEFiveChessboard *)chessBoard chessClick:(YWChess *)chess{
    UILabel *showL = (UILabel *)self.lastView;
    YWUser *u = self.board.currentUser;
    showL.text = [NSString stringWithFormat:@"当前棋手:name:%@, win:-->%ld,fail:-->%ld,temWin:-->%ld,temFail:-->%ld",u.name,u.winNum,u.failNum,u.tempWinNum,u.tempFailNum];
}

-(void)fiveChessboardTie:(AEFiveChessboard *)chessBoard{

    UILabel *showL = (UILabel *)self.lastView;
    showL.text = @"平局";
}

- (void)fiveChessboard:(AEFiveChessboard *)chessBoard winChess:(NSMutableArray *)chessArray winer:(YWUser *)winer{
    UILabel *showL = (UILabel *)self.lastView;
    YWUser *u = winer;
    showL.text = [NSString stringWithFormat:@"获胜棋手:name:%@, win:-->%ld,fail:-->%ld,temWin:-->%ld,temFail:-->%ld",u.name,u.winNum,u.failNum,u.tempWinNum,u.tempFailNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
