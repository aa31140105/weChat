//
//  Account.m
//  weChat
//
//  Created by 天佑 on 16/3/26.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "Account.h"

#define kUserKey @"user"
#define kPwdKey @"pwd"
#define kLoginKey @"login"

static NSString *domain = @"youge.local";
static NSString *host = @"127.0.0.1";
static int port = 5222;

@implementation Account//

+(instancetype)shareAccount{

    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    NSLog(@"%s",__func__);
    static Account *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (account == nil) {
            
            account = [super allocWithZone:zone];
            
            /** 从沙盒获取上次的用户登陆信息 */
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            account.loginUser = [defaults objectForKey:kUserKey];
            account.loginPwd = [defaults objectForKey:kPwdKey];
            account.login = [defaults boolForKey:kLoginKey];
            
        }
        
    });
    return account;
}

/** 保存数据到沙盒 */
- (void)saveToSandBox{
    
    /** 保存user pwd login */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginUser forKey:kUserKey];
    [defaults setObject:self.loginPwd forKey:kPwdKey];
    [defaults setBool:self.isLogin forKey:kLoginKey];
    [defaults synchronize];

}

-(NSString *)domain{
    return domain;
}

-(NSString *)host{
    return host;
}

-(int)port{
    return port;
}
@end
