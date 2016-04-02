//
//  ProfileViewController.m
//  weChat
//
//  Created by 天佑 on 16/4/2.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "ProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatAccount;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *jobLevel;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *exmail;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //为什么电子名片的模型是temp,因为解析电子名片的xml没有完善,有些节点并未解析
    //1.内部查找数据
    XMPPvCardTemp *myvCard = [XMPPTool shareXMPPTool].vCard.myvCardTemp;
    
    //获取头像
    if (myvCard.photo) {
        self.iconImageView.image = [UIImage imageWithData:myvCard.photo];
    }
    
    //微信号
    self.chatAccount.text = [Account shareAccount].loginUser;
    //名称
    self.nameLabel.text = myvCard.nickname;
    //公司
    self.company.text = myvCard.orgName;
    //部门
    if (myvCard.orgUnits.count > 0) {
        
        self.department.text = myvCard.orgUnits[0];
    }
    //职位
    self.jobLevel.text = myvCard.title;
    //电话
    self.phone.text = myvCard.note;
    //邮件
//    self.exmail.text = myvCard.emailAddresses;
    self.exmail.text = myvCard.mailer;
    
    
}


#pragma mark - Table view data source


@end
