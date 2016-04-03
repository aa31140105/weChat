//
//  QYChatViewController.h
//  weChat
//
//  Created by 天佑 on 16/4/3.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYChatViewController : UIViewController

/** 正在聊天的好友的Jid */
@property (nonatomic, strong) XMPPJID *friendJid;
@end
