//
//  chess.h
//  FiveGo2
//
//  Created by carshoel on 16/3/16.
//  Copyright © 2016年 carshoel. All rights reserved.
//  棋子单元格

#import <UIKit/UIKit.h>
@class YWChess,YWUser;

//棋子的位置类型
typedef enum{
    YWChessTypeTop = 1 << 0,
    YWChessTypeLeft = 1 << 1,
    YWChessTypeBottom = 1 << 2,
    YWChessTypeRight = 1 << 3,
}YWChessType;

@protocol YWChessDelegate <NSObject>

- (void)chessDidClicked:(YWChess *)chess;

@end

@interface YWChess : UIView
@property (nonatomic, assign)YWChessType type;
@property (nonatomic, weak)id<YWChessDelegate> delegate;
@property (nonatomic, strong)YWUser *user;
@property (nonatomic, assign, getter=isWinChesser)BOOL winChesser;
@property (nonatomic, strong)UIColor *lineColor;//线条颜色

//以下是机器人将用到的属性
@property (nonatomic, assign)CGFloat winPriorityLevel;//取胜优先级 最高为5
@property (nonatomic, assign)CGFloat losePriorityLevel;//危险优先级最高为5 且同等级的优先级 win > lose
//
@end
