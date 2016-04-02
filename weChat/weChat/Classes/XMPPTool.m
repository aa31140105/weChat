//
//  XMPPTool.m
//  weChat
//
//  Created by 天佑 on 16/3/28.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "XMPPTool.h"

@interface XMPPTool ()<XMPPStreamDelegate>

/** 与服务器交互的核心类 */
@property (nonatomic, strong) XMPPStream *xmppStream;

/** 登陆的回调结果 */
@property (nonatomic, strong) XMPPResultBlock resultBlock;



/** 电子头像模块 */
@property (nonatomic, strong) XMPPvCardAvatarModule *vavatar;



@end

@implementation XMPPTool
SingleM(XMPPTool)

/** 释放资源 */
- (void)teardownStream{
    
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //取消模块
    [_vavatar deactivate];
    [_vCard deactivate];
    [_roster deactivate];
    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _vCardStorage = nil;
    _vCard = nil;
    _vavatar = nil;
    _xmppStream = nil;
    _roster = nil;
    _rosterStorage = nil;
}

/** 初始化XMPPStream */
- (void)setupStream{
    
    NSString *str = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",str);
    /** 创建XMPPStream对象 */
    _xmppStream = [[XMPPStream alloc]init];
    
    /** 添加XMPP模块 */
//    1.添加电子名片模板
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:self.vCardStorage];
    
    /** 激活 */
    [self.vCard activate:_xmppStream]; 
    
    //添加的模块的sqlite数据在这个路径下
//    /Users/tianyou/Library/Developer/CoreSimulator/Devices/6528499D-20CE-444D-8B51-DE897541E9E0/data/Containers/Data/Application/D12D2697-6712-4B2C-A86A-F290168EE2AA/Library/Application Support
    /** 电子头像模块 */
    _vavatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.vCard];
    [_vavatar activate:_xmppStream] ;
    
    /** 添加花名册模块 */
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _roster = [[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
}

/** 链接服务器,传JID */
- (void)connectToHost{
    if (_xmppStream == nil) {
        [self setupStream];
    }
    
    /** 设置登陆用户的jid */
    //    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    XMPPJID *myJid = nil;
    
    Account *account = [Account shareAccount];
    if (self.loginSuccess == YES) {
        /** 登陆操作 */
        NSString *user = account.loginUser;
        myJid = [XMPPJID jidWithUser:user domain:account.domain resource:@"iphone"];
        
    }else{
        /** 注册操作 */
        NSString *registerUser = [Account shareAccount].registerUser;
        myJid = [XMPPJID jidWithUser:registerUser domain:account.domain resource:@"iphone"];
    }
    _xmppStream.myJID = myJid;
    
    /** 设置主机地址 */
    _xmppStream.hostName = account.host;
    
    /** 设置主机端口号 */
    _xmppStream.hostPort = account.port;
    
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
    NSString *password = [Account shareAccount].loginPwd;
    
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
    /** 判断用户是注册还是登陆操作 */
    if (self.loginSuccess == YES) {
        
        /** 连接发起成功后发送密码给服务器 */
        [self sendPwdToHost];
    }else{
        /** 注册操作 */
        NSError *error = nil;
        NSString *password = [Account shareAccount].registerPwd;
        [_xmppStream registerWithPassword:password error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    
    
}

#pragma mark -注册成功调用的方法
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    /** 注册成功与失败的回调 */
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeResultSuccess);
    }
}

#pragma mark -注册失败调用的方法
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败,%@",error);
    if (_xmppStream) {
        _resultBlock(XMPPResultTypeResultFailure);
    }
}

/** 断开连接调用的方法 */
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"断开了连接");
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

/** 注册方法 */
- (void)xmppRegister:(XMPPResultBlock)resultBlock{
    NSLog(@"%@",resultBlock);
    [_xmppStream disconnect];
    /** 保存回调结果 */
    _resultBlock = resultBlock;
    /** 连接服务器 */
    [self connectToHost];
}

/** 用户注销方法 */
- (void)xmpplogout{
    
    /** 发送离线消息 */
    [self sendOffLine];
    /** 与服务器断开连接 */
    [self disConnect];
}

/** 发送离线消息 */
- (void)sendOffLine{
    
    XMPPPresence *offLine = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offLine];
    
}

/** 与服务器断开连接 */
- (void)disConnect{
    [_xmppStream disconnect];
}

- (void)dealloc{
    //释放资源
    [self teardownStream];
}
@end
