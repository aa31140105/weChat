//
//  AddContractViewController.m
//  weChat
//
//  Created by 天佑 on 16/4/3.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "AddContractViewController.h"
#import "SVProgressHUD.h"

@interface AddContractViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation AddContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
}


- (IBAction)addContract:(id)sender {
    /** 添加好友 */
    NSString *user = self.textField.text;
    
    //不能添加自己为好友
    if ([user isEqualToString:[Account shareAccount].loginUser]) {
        [self showMessage:@"不能添加自己为好友"];
        return;
    }
    
    //获取好友列表
    XMPPJID *userjid = [XMPPJID jidWithUser:user domain:[Account shareAccount].domain resource:nil];
    //判断当前好友是否存在
   BOOL userExit = [[XMPPTool shareXMPPTool].rosterStorage userExistsWithJID:userjid xmppStream:[XMPPTool shareXMPPTool].xmppStream];
    if (userExit) {
        [self showMessage:@"好友已经存在"];
    }
    
    //添加好友(订阅好友)
    //不论数据库是否有该人都会添加,解决办法1拦截服务器请求,如果发现服务器没有该好友,则不返回数据给客户端
    [[XMPPTool shareXMPPTool].roster subscribePresenceToUser:userjid];
    
    //方案2:过滤数据库的Subscription字段的查询请求
    //字段的值none 表示对方没有同意添加好友,to:发送给对方的请求,from:别人发来的请求,both:双方互为好友
   //过滤查询在QYContractViewController.m的方法:loadStatus里执行
}

- (void)showMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    // 按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
