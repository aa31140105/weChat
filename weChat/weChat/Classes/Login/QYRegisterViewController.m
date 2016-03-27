//
//  QYRegisterViewController.m
//  weChat
//
//  Created by 天佑 on 16/3/27.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYRegisterViewController.h"
#import "SVProgressHUD.h"

@interface QYRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registerAccount;

@property (weak, nonatomic) IBOutlet UITextField *registerPwd;
@end

@implementation QYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancle:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerBtn:(id)sender {
    
    /** 保存注册的账号密码 */
    [Account shareAccount].registerUser = self.registerAccount.text;
    [Account shareAccount].registerPwd = self.registerPwd.text;
    
    /** 显示正在注册 */
    [SVProgressHUD showWithStatus:@"正在注册..."];
    /** 当前正在注册 */
    [XMPPTool shareXMPPTool].loginSuccess = NO;
    __weak typeof(self) selfVc = self;
    [[XMPPTool shareXMPPTool] xmppRegister:^(XMPPResultType result) {
        [selfVc handleXMPPResult:result];
    }];
}

#pragma mark -处理注册结果
- (void)handleXMPPResult:(XMPPResultType)resultType{
    
    /** 隐藏提示 */
    [SVProgressHUD dismiss];
    
    /** 提示注册成功 */
    if (resultType == XMPPResultTypeResultSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"恭喜注册成功,请回到主界面登陆!"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"注册失败,用户名已存在"];
    }
    
}


@end
