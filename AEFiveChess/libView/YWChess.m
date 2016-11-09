//
//  chess.m
//  FiveGo2
//
//  Created by carshoel on 16/3/16.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "YWChess.h"
#import "YWUser.h"

@interface YWChess ()
@property (nonatomic, assign)CGPoint topPoint;
@property (nonatomic, assign)CGPoint leftPoint;
@property (nonatomic, assign)CGPoint bottomPoint;
@property (nonatomic, assign)CGPoint rightPoint;
@property (nonatomic, weak)UIImageView *iconView;
@end

@implementation YWChess

-(UIImageView *)iconView{
    if (!_iconView) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:self.bounds];
        iconView.layer.cornerRadius = CGRectGetWidth(self.bounds) * 0.5;
        iconView.layer.masksToBounds = YES;
        [self addSubview:iconView];
        _iconView =  iconView;
    }
    return _iconView;
}

- (void)setWinChesser:(BOOL)winChesser{
    if (winChesser) {
        self.iconView.image = [UIImage imageNamed:self.user.icon];//[UIImage circleImageWithName:self.user.icon borderWidth:2 borderColor:[UIColor whiteColor]];
    }else{
        self.iconView.image = nil;
    }
}

- (void)setUser:(YWUser *)user{
    _user = user;
    if (!user){
        self.userInteractionEnabled = YES;
        self.iconView.image = nil;
        self.iconView.backgroundColor = [UIColor clearColor];
        self.winChesser = NO;
        return;
    }
    
    self.userInteractionEnabled = NO;
    if(user.pkImage){
        self.iconView.image = user.pkImage;
    }
    if(user.pkColor){
        self.iconView.backgroundColor = user.pkColor;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.topPoint = CGPointMake(self.bounds.size.width * 0.5, 0);
    self.leftPoint = CGPointMake(0, self.bounds.size.height * 0.5);
    self.bottomPoint = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height);
    self.rightPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height * 0.5);
    
}

- (void)drawRect:(CGRect)rect{
    

    //划线
    if (!(self.type & YWChessTypeTop)) {
        [self drawToPoint:self.topPoint];
//        NSLog(@"%d上",self.tag);
    }
    if (!(self.type & YWChessTypeLeft)) {
        [self drawToPoint:self.leftPoint];
//        NSLog(@"%d左",self.tag);
    }
    if (!(self.type & YWChessTypeBottom)) {
        [self drawToPoint:self.bottomPoint];
//        NSLog(@"%d下",self.tag);
    }
    if (!(self.type & YWChessTypeRight)) {
        [self drawToPoint:self.rightPoint];
//        NSLog(@"%d右",self.tag);
    }
   
}


/**
 *  划线方法
 */
- (void)drawToPoint:(CGPoint)point{

    CGContextRef context = UIGraphicsGetCurrentContext();
    if(self.lineColor)[self.lineColor set];
    CGContextMoveToPoint(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGContextAddLineToPoint(context, point.x, point.y);
    
    CGContextStrokePath(context);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if ([self.delegate respondsToSelector:@selector(chessDidClicked:)]) {
        [self.delegate chessDidClicked:self];
    }
}

@end






