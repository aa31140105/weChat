//
//  Account.h
//  weChat
//
//  Created by 天佑 on 16/3/26.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, strong) NSString *loginUser;
@property (nonatomic, strong) NSString *loginPwd;
@property (nonatomic, strong) NSString *registerUser;
@property (nonatomic, strong) NSString *registerPwd;

/** 判断用户是否登陆 */
@property(nonatomic,assign,getter=isLogin)BOOL login;

/** 单例 */
+ (instancetype)shareAccount;

/** 保存最新的登陆用户数据到沙盒 */
- (void)saveToSandBox;

/** 服务器的域名 */
@property(nonatomic,copy,readonly)NSString *domain;

/** 服务器IP */
@property(nonatomic,copy,readonly)NSString *host;

/** 端口号 */
@property(nonatomic,assign,readonly)int port;
@end
