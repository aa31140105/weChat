//
//  Account.h
//  weChat
//
//  Created by 天佑 on 16/3/26.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *pwd;

/** 判断用户是否登陆 */
@property(nonatomic,assign,getter=isLogin)BOOL login;

/** 单例 */
+ (instancetype)shareAccount;

/** 保存最新的登陆用户数据到沙盒 */
- (void)saveToSandBox;
@end
