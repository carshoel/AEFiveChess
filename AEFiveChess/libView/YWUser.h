//
//  YWUser.h
//  FiveGo2
//
//  Created by carshoel on 16/3/16.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWUser : UIView
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, assign)int ID;
@property (nonatomic, strong)UIImage *pkImage;
@property (nonatomic, strong)UIColor *pkColor;
/**
 *  失败总数
 */
@property (nonatomic, assign)NSInteger failNum;
/**
 *  获胜总数
 */
@property (nonatomic, assign)NSInteger winNum;
/**
 *  本场获胜数
 */
@property (nonatomic, assign)NSInteger tempWinNum;
/**
 *  本场失败数
 */
@property (nonatomic, assign)NSInteger tempFailNum;

@end
