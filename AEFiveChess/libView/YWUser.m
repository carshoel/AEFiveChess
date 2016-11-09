//
//  YWUser.m
//  FiveGo2
//
//  Created by carshoel on 16/3/16.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "YWUser.h"

#define kDefault [NSUserDefaults standardUserDefaults]

@implementation YWUser

-(NSInteger)winNum{
    return [kDefault integerForKey:[NSString stringWithFormat:@"winNum_%d",self.ID]];
}

-(NSInteger)failNum{
    return [kDefault integerForKey:[NSString stringWithFormat:@"failNum_%d",self.ID]];
}

- (void)setTempWinNum:(NSInteger)tempWinNum{
    _tempWinNum = tempWinNum;

    [kDefault setInteger:self.winNum + 1 forKey:[NSString stringWithFormat:@"winNum_%d",self.ID]];
    [kDefault synchronize];
}
- (void)setTempFailNum:(NSInteger)tempFailNum{
    _tempFailNum = tempFailNum;
    
    [kDefault setInteger:self.failNum + 1 forKey:[NSString stringWithFormat:@"failNum_%d",self.ID]];
    [kDefault synchronize];
}
@end
