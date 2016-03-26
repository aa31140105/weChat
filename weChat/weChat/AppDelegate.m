//
//  AppDelegate.m
//  weChat
//
//  Created by 天佑 on 16/3/25.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

@interface AppDelegate ()<XMPPStreamDelegate>

/** 与服务器交互的核心类 */
@property (nonatomic, strong) XMPPStream *xmppStream;

/** 登陆的回调结果 */
@property (nonatomic, strong) XMPPResultBlock resultBlock;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
/** 判断用户是否登陆 */
    if ([Account shareAccount].isLogin) {
        NSString *str = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSLog(@"%@",str);
        /** 来到主界面 */
        id mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
        self.window.rootViewController = mainVc;
        
    }
    return YES;
}


/** 初始化XMPPStream */
- (void)setupStream{

    /** 创建XMPPStream对象 */
    _xmppStream = [[XMPPStream alloc]init];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
}

/** 链接服务器,传JID */
- (void)connectToHost{
    NSLog(@"%@",_xmppStream);
    if (_xmppStream == nil) {
        [self setupStream];
    }
    
    /** 设置登陆用户的jid */
//    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *user = [Account shareAccount].user;
    XMPPJID *myJid = [XMPPJID jidWithUser:user domain:@"youge.local" resource:@"iphone"];
    _xmppStream.myJID = myJid;
    
    /** 设置主机地址 */
    _xmppStream.hostName = @"127.0.0.1";
    
    /** 设置主机端口号 */
    _xmppStream.hostPort = 5222;
    
    /** 发起链接 */
    NSError *error = nil;
    /** 缺少必要的参数时会发起链接失败?比如没设置jid */
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"发起连接成功");
    }
    
}


/** 发送密码到主机 */
- (void)sendPwdToHost{
    
    NSError *error = nil;
//    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *password = [Account shareAccount].pwd;
    [_xmppStream authenticateWithPassword:password error:&error];
    if (error) {
        NSLog(@"账号密码有误,%@",error);
    }
}

/** 发送一个消息给服务器,告诉服务器用户已经处于登陆状态 */
- (void)sendOnLine{
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}

/** 连接发起成功或失败由代理方法确定 */
/** 连接建立成功的方法 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSLog(@"连接发起成功");
    /** 连接发起成功后发送密码给服务器 */
    [self sendPwdToHost];
    
}

/** 登陆成功调用的方法 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    /** 用户登陆成功后告诉系统用户处于在线状态 */
    [self sendOnLine];
    NSLog(@"登陆成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
}

/** 登陆失败调用的方法 */
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    NSLog(@"登陆失败");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

/** 登陆方法 */
- (void)xmppLogin:(XMPPResultBlock)resultBlock{
    /** 不管什么情况都把以前的连接断开 */
    [_xmppStream disconnect];
    
    /** 保存回调结果 */
    _resultBlock = resultBlock;
    /** 链接服务器开始登陆操作 */
    [self connectToHost];
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
