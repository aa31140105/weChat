//
//  QYMeTableViewController.m
//  weChat
//
//  Created by 天佑 on 16/3/26.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYMeTableViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"

@interface QYMeTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation QYMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 使用电子名片获取用户信息 */
    XMPPvCardTemp *myvCard = [XMPPTool shareXMPPTool].vCard.myvCardTemp;
    
    /** 获取头像 */
    if (myvCard.photo){
        self.iconImageView.image = [UIImage imageWithData:myvCard.photo];
    }
    
    /** 获取微信号(用户名) */

//    self.nameLable.text = myvCard.jid.user;
    self.nameLable.text = [@"微信号:" stringByAppendingString:[Account shareAccount].loginUser];
}

- (IBAction)logout:(id)sender {

    [[XMPPTool shareXMPPTool] xmpplogout];
    
    /** 注销的时候,把沙盒的登陆状态设置为NO */
    [Account shareAccount].login = NO;
    [[Account shareAccount] saveToSandBox];
    
    /** 切换控制器到登陆控制器 */
    id vc = [UIStoryboard storyboardWithName:@"QYLoginViewController" bundle:nil].instantiateInitialViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}



@end
