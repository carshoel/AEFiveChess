//
//  AEFiveChessboard.m
//  FiveGo2
//
//  Created by carshoel on 16/11/8.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AEFiveChessboard.h"
#import "YWChess.h"
#import "YWUser.h"

@interface AEFiveChessboard ()<YWChessDelegate>

/**
 *  判断棋子是否连胜利的容器缓存
 */
@property (nonatomic, strong)NSMutableArray *winChesses;

/**
 *  所有下过的棋子
 */
@property (nonatomic, strong)NSMutableArray *allChesses;

/**
 *  获胜方
 */
@property (nonatomic, strong)YWUser *winer;

@end

@implementation AEFiveChessboard

-(NSMutableArray *)winChesses{
    if (!_winChesses) {
        _winChesses = [NSMutableArray array];
    }
    return _winChesses;
}

-(NSMutableArray *)allChesses{
    if (!_allChesses) {
        _allChesses = [NSMutableArray array];
    }
    return _allChesses;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _winNumber = 5;
        _line = 5;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _winNumber = 5;
        _line = 5;
        _chessWidth = CGRectGetWidth(frame) / _winNumber;
    }
    return self;
}

-(void)setChessWidth:(CGFloat)chessWidth{
    if(!chessWidth)return;//不能设置为零
    _line = 0;
    _chessWidth = chessWidth;
}

-(void)setLine:(NSInteger)line{
    if(!line)return;
    _chessWidth = 0;
    _line = line;
}

-(void)setFrame:(CGRect)frame{
    //布局棋子
    [self setUpBoardWithFrame:frame];
    
    [super setFrame:frame];
}

- (void)setWinNumber:(NSInteger)winNumber{
    if(winNumber < 5)return;
    _winNumber = winNumber;
}

//悔棋后退
- (void)back{
    self.userInteractionEnabled = YES;
    if (!self.allChesses.count)return;
    YWChess *chess = (YWChess *)self.allChesses.lastObject;
    chess.user = nil;
    [self.allChesses removeObjectAtIndex:self.allChesses.count - 1];
    
    for (YWChess *chess in self.winChesses) {
        chess.winChesser = NO;
    }
    
    self.currentUser = self.currentUser.ID == self.whitUser.ID ? self.blackUser: self.whitUser;
}

//重新开始
- (void)reBegin{
    self.userInteractionEnabled = YES;
    for (YWChess *chess in self.subviews) {
        chess.user = nil;
    }
    self.allChesses = nil;
}


//加载棋盘
- (void)setUpBoardWithFrame:(CGRect)frame{
    
    CGFloat w = CGRectGetWidth(frame);
    CGFloat h = CGRectGetHeight(frame);
    if(!w && !h)return;
    
    if(!_line && !_chessWidth)_line = 5;
    NSInteger lines = _line ? _line : (CGRectGetWidth(frame) / _chessWidth);
    _line = lines;
    
    //棋的宽高
    if(!_line && !_chessWidth)_chessWidth = 20;
    int chessW = _chessWidth ? _chessWidth : (CGRectGetWidth(frame) / _line);
    int chessH = chessW;
    //垂直方向要展示的个数
    int rows = CGRectGetHeight(frame) / chessH;
    
    CGFloat gap = (CGRectGetWidth(frame) - chessW * lines) * 0.5;
    CGFloat topGap =  (CGRectGetHeight(frame) - chessH * rows) * 0.5;
    
    
    for (int i = 0; i < lines * rows; i++) {
        YWChess *chess = [[YWChess alloc] init];
        chess.lineColor = self.lineColor;
        
        //判断行数
        int row = i / lines;
        //列数
        int line = i % lines;
        //判断位置
        if (row == 0) {
            chess.type = YWChessTypeTop;
        }
        if (line == 0) {
            chess.type = chess.type | YWChessTypeLeft;
        }
        if (line == lines - 1 ) {
            chess.type = chess.type | YWChessTypeRight;
        }
        if (row == rows - 1) {
            chess.type = chess.type | YWChessTypeBottom;
        }
        
        chess.frame = CGRectMake(gap + line * chessW, topGap + row * chessH, chessW, chessH);
        chess.backgroundColor = [UIColor clearColor];
        chess.tag = i;
        chess.delegate = self;
        [self addSubview:chess];
        
    }
}

#pragma mark - 点击了棋子
-(void)chessDidClicked:(YWChess *)chess{
    
    //棋盘禁用
    self.userInteractionEnabled = NO;
    
    //把当前棋手赋值给棋子
    chess.user = self.currentUser;

    //切换当前棋手
    self.currentUser = self.currentUser.ID == self.whitUser.ID ? self.blackUser : self.whitUser;
    
    //通知代理
    if([self.delegate respondsToSelector:@selector(fiveChessboard:chessClick:)]){
        [self.delegate fiveChessboard:self chessClick:chess];
    }
    
    //保存已经下过的棋子
    [self.allChesses addObject:chess];
    
    //判断是否有胜出
    if ([self isHorizontalWin:chess]||[self isVerticalWin:chess]||[self isLeftDownToRight:chess]||[self isLeftUpToRight:chess]) {
        
        YWChess *loserChess =  (YWChess *)self.allChesses.lastObject;
        loserChess.user.failNum++;
        
        self.winer = chess.user;
        //保存记录
        self.winer.tempWinNum ++;
        self.currentUser.tempFailNum ++;
        
        
        //显示胜利棋子图
        for (YWChess *chess in self.winChesses) {
            //设置win方棋子的头像
            chess.winChesser = YES;
        }
        
        //通知代理
        if([self.delegate respondsToSelector:@selector(fiveChessboard:winChess:winer:)]){
            [self.delegate fiveChessboard:self winChess:self.winChesses winer:self.winer];
        }
        
    }else{ //没有胜出
        
        //判断是否平局
        if(self.allChesses.count == self.subviews.count){
            if([self.delegate respondsToSelector:@selector(fiveChessboardTie:)]){
                [self.delegate fiveChessboardTie:self];
            }
            return;
        }
        //恢复棋盘交互
        self.userInteractionEnabled = YES;
    }
}

#pragma mark - 胜利计数
//横前
- (void)front:(YWChess *)chess{
    
    if (chess.type & YWChessTypeLeft)return;
    
    //取出上一个棋子
    YWChess *lastOne = self.subviews[chess.tag - 1];
    
    if(lastOne.user.ID == chess.user.ID){
        [self.winChesses addObject:lastOne];
//        if (self.winChesses.count > _winNumber - 1)return;
        [self front:lastOne];
    }
    return ;
}

//横后
- (void)back:(YWChess *)chess{
    
    if (chess.type & YWChessTypeRight)return;
    
    //取出上一个棋子
    YWChess *nextOne = self.subviews[chess.tag + 1];
    
    if(nextOne.user.ID == chess.user.ID) {
        [self.winChesses addObject:nextOne];
//        if (self.winChesses.count > _winNumber - 1)return;
        [self back:nextOne];
    }
    return;
}

- (BOOL)isHorizontalWin:(YWChess *)chess{
    self.winChesses = nil;
    [self.winChesses addObject:chess];
    [self front:chess];
    [self back:chess];
    if (self.winChesses.count < _winNumber)return NO;
    return YES;
}

//垂直向上
- (void)upV:(YWChess *)chess{
    if (chess.type & YWChessTypeTop)return;//第一排的话就不向上判断
    YWChess *upOne = self.subviews[chess.tag - self.line];
    if (upOne.user.ID == chess.user.ID) {
        [self.winChesses addObject:upOne];
//        if (self.winChesses.count > _winNumber - 1) {
//            return;
//        }
        [self upV:upOne];
    }
    return;
}

//垂直向下
- (void)downV:(YWChess *)chess{
    if (chess.type & YWChessTypeBottom)return;
    YWChess *downOne = self.subviews[chess.tag + self.line];
    if (downOne.user.ID == chess.user.ID) {
        [self.winChesses addObject:downOne];
//        if (self.winChesses.count > _winNumber - 1) {
//            return;
//        }
        [self downV:downOne];
    }
    return;
}

/**
 *  垂直判断是否五颗连子
 */
- (BOOL)isVerticalWin:(YWChess *)chess{
    self.winChesses = nil;
    [self.winChesses addObject:chess];
    [self upV:chess];
    [self downV:chess];
    if (self.winChesses.count < _winNumber)return NO;
    return YES;
}

//左上
- (void)leftUp:(YWChess *)chess{
    if (chess.type & YWChessTypeTop || chess.type & YWChessTypeLeft)return;//不能是第一排或者第一列
    YWChess *lastOne = self.subviews[chess.tag - self.line - 1];
    if (lastOne.user.ID == chess.user.ID) {
        [self.winChesses addObject:lastOne];
//        if (self.winChesses.count > _winNumber - 1)return;
        [self leftUp:lastOne];
    }
    return;
}

//右下
- (void)rightDown:(YWChess *)chess{
    if (chess.type & YWChessTypeBottom || chess.type & YWChessTypeRight)return;//不能是第一排或者第一列
    YWChess *lastOne = self.subviews[chess.tag + self.line + 1];
    if (lastOne.user.ID == chess.user.ID) {
        [self.winChesses addObject:lastOne];
//        if (self.winChesses.count > _winNumber - 1)return;
        [self rightDown:lastOne];
    }
    return;
}

- (BOOL)isLeftDownToRight:(YWChess *)chess{
    self.winChesses = nil;
    [self.winChesses addObject:chess];
    [self leftUp:chess];
    [self rightDown:chess];
    if (self.winChesses.count < _winNumber)return NO;
    return YES;
}


//右上
- (void)rightUp:(YWChess *)chess{
    if (chess.type & YWChessTypeTop || chess.type & YWChessTypeRight)return;//不能是第一排或者最后一列
    YWChess *lastOne = self.subviews[chess.tag - self.line + 1];
    if (lastOne.user.ID == chess.user.ID) {
        [self.winChesses addObject:lastOne];
//        if (self.winChesses.count > _winNumber - 1)return;
        [self rightUp:lastOne];
    }
    return;
}

//左下
- (void)leftDown:(YWChess *)chess{
    if (chess.type & YWChessTypeBottom || chess.type & YWChessTypeLeft)return;//不能是最后一排或者第一列
    YWChess *lastOne = self.subviews[chess.tag + self.line - 1];
    if (lastOne.user.ID == chess.user.ID) {
        [self.winChesses addObject:lastOne];
//        if (self.winChesses.count > _winNumber - 1)return;
        [self leftDown:lastOne];
    }
    return;
}

- (BOOL)isLeftUpToRight:(YWChess *)chess{
    self.winChesses = nil;
    [self.winChesses addObject:chess];
    [self leftDown:chess];
    [self rightUp:chess];
    if (self.winChesses.count < _winNumber)return NO;
    return YES;
}


@end
