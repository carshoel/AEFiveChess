//
//  AEFiveChessboard.h
//  FiveGo2
//
//  Created by carshoel on 16/11/8.
//  Copyright © 2016年 carshoel. All rights reserved.
//  五子棋棋盘

#import <UIKit/UIKit.h>

@class YWUser,AEFiveChessboard,YWChess;

@protocol AEFiveChessboardDelegate <NSObject>

@optional
/**棋盘获胜代理*/
- (void)fiveChessboard:(AEFiveChessboard *)chessBoard winChess:(NSMutableArray *)chessArray winer:(YWUser *)winer;
/**平局*/
- (void)fiveChessboardTie:(AEFiveChessboard *)chessBoard;
/**点击了一枚棋子*/
- (void)fiveChessboard:(AEFiveChessboard *)chessBoard chessClick:(YWChess *)chess;

@end


@interface AEFiveChessboard : UIView

@property (nonatomic, strong)YWUser *whitUser;//白方
@property (nonatomic, strong)YWUser *blackUser;//黑方
@property (nonatomic, weak)YWUser *currentUser;//当前棋手
@property (nonatomic, strong)UIColor *lineColor;//棋盘线条颜色

/*line 和 chessWidth互斥，只有一个有效，当都设置了时，最后设置的有效，如果都没设置，将采用默认的line值*/
@property (nonatomic, assign)NSInteger line;//列数  默认有效，值为5
@property (nonatomic, assign)CGFloat chessWidth;//宽度

@property (nonatomic, assign)NSInteger winNumber;//取胜数，默认五子连胜 最小为5

@property (nonatomic, weak)id<AEFiveChessboardDelegate> delegate;//代理

//悔棋后退
- (void)back;

//重新开始
- (void)reBegin;

@end
