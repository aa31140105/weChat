//
//  AppDelegate.m
//  weChat
//
//  Created by 天佑 on 16/3/25.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "AppDelegate.h"
#import "DDTTYLogger.h"
#import "DDLog.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /** 配置XMPP的日志的启动 */
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    /** 判断用户是否登陆 */
    if ([Account shareAccount].isLogin) {

        /** 来到主界面 */
        id mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
        self.window.rootViewController = mainVc;
        
        //刚进程序的时候自动登陆选择yes
        [XMPPTool shareXMPPTool].loginSuccess = YES;
        /** 自动登陆 */
        [[XMPPTool shareXMPPTool] xmppLogin:nil];
    }
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
