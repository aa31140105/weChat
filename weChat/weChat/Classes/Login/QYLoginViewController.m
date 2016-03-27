//
//  QYLoginViewController.m
//  weChat
//
//  Created by 天佑 on 16/3/25.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYLoginViewController.h"
#import "AppDelegate.h"

@interface QYLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation QYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButton:(id)sender {
    
    /** 判断用户是否输入了账号密码 */
    if (self.accountTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        NSLog(@"请输入账号密码");
        return;
    }
    
    /** 登陆服务器 */
    /** 把用户名和密码保存到沙盒 */
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.accountTextField.text forKey:@"user"];
//    [defaults setObject:self.passwordTextField.text forKey:@"password"];
//    [defaults synchronize];

    [Account shareAccount].loginUser = self.accountTextField.text;
    [Account shareAccount].loginPwd = self.passwordTextField.text;
    [Account shareAccount].login = YES;
    
    /** 当前是登陆操作 */
    [XMPPTool shareXMPPTool].loginSuccess = YES;
    /** 利用block回调知道appdelegate的登陆结果 */
    __weak typeof (self) selVc = self;
    [[XMPPTool shareXMPPTool] xmppLogin:^(XMPPResultType resultType) {
        
        if (resultType == XMPPResultTypeLoginSuccess) {
            NSLog(@"登陆成功咯!");
            /** 切换到主界面 */
            [selVc changeToMain];
            
            /** 保存账号(单例) */
            [Account shareAccount].login = YES;
             [[Account shareAccount] saveToSandBox];
            
//            account.user = self.accountTextField.text;
//            account.pwd = self.passwordTextField.text;
//            account.login = YES;
//            NSLog(@"%@",account);
//            NSLog(@"%@",[[Account alloc]init]);
            
        }else {
            NSLog(@"登陆失败咯!");
        }
    }];
}

- (void)dealloc{
    NSLog(@"销毁");
}

/** 登陆成功后切换控制器到主界面 */
- (void)changeToMain{
    
    //回到主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
       
        /** 获取main.storyboard的第一个控制器 */
        id vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
        
        /** 切换window的根控制器 */
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        
    });
}

@end
