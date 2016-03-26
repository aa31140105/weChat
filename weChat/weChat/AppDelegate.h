//
//  AppDelegate.h
//  weChat
//
//  Created by 天佑 on 16/3/25.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMPPResultTypeLoginSuccess,//登陆成功的枚举
    XMPPResultTypeLoginFailure//登陆失败的枚举
    
}XMPPResultType;
/** 与服务器交互的block回调结果 */
typedef void (^XMPPResultBlock)(XMPPResultType);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



/** 声明登陆方法 */
- (void)xmppLogin:(XMPPResultBlock )resultBlock;
@end

