//
//  ProfileViewController.m
//  weChat
//
//  Created by 天佑 on 16/4/2.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "ProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "QYEditorViewController.h"

@interface ProfileViewController () <QYEditorViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
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


#pragma mark - tableView的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取出当前点击的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (cell.tag) {
        case 1:
            [self selectPhoto];
            break;
            case 2:
            NSLog(@"什么都不做");
            break;
            case 3:
            [self performSegueWithIdentifier:@"firstLine" sender:cell];
        default:
            break;
    }
}

#pragma mark - 点击更换头像的方法
- (void)selectPhoto {
    // UIAlertControllerStyleAlert : 相当于弹出一个UIAlertView
    // UIAlertControllerStyleActionSheet : 相当于弹出一个UIActionSheet
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbum];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/** 打开相册 */
- (void)openAlbum
{
    // UIImagePickerControllerSourceTypeSavedPhotosAlbum : 从Moments相册中选一张图片
    // UIImagePickerControllerSourceTypePhotoLibrary : 从所有相册中选一张图片
    // UIImagePickerControllerSourceTypeCamera : 利用照相机中拍一张图片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //允许编辑图片的属性
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

/** 打开照相机 */
- (void)openCamera
{
    //防止在模拟器没有相机的情况下崩溃
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}



//通过segua传递参数给下一个控制器
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //获取目标控制器
    id destVc = segue.destinationViewController;
    //设置编辑名片控制器的cell属性
    if ([destVc isKindOfClass:[QYEditorViewController class]]) {
        QYEditorViewController *editVc = destVc;
        editVc.preCell = sender;
        
        //设置代理属性
        editVc.delegate = self;
    }
}

#pragma mark - 实现自定义代理方法
- (void)editorViewController:(QYEditorViewController *)editorController didFinishSave:(id)sender{
    /** 保存数据到数据库 */
    [self saveData];
}

#pragma mark - 保存数据到服务器的方法
- (void)saveData{
    
    /** 获取当前电子名片 */
    XMPPvCardTemp *myVCard = [XMPPTool shareXMPPTool].vCard.myvCardTemp;
    
    //设置myVCard里面的属性的值
    /** 设置头像 */
    myVCard.photo = UIImageJPEGRepresentation(self.iconImageView.image, 0.75);
    /** 昵称 */
    myVCard.nickname = self.nameLabel.text;
    /** 公司名称 */
    myVCard.orgName = self.company.text;
    /** 部门名称 */
    if (self.department.text != nil) {
        myVCard.orgUnits = @[self.department.text];
    }
    /** 职位 */
    myVCard.title = self.jobLevel.text;
    /** 电话 */
    myVCard.note = self.phone.text;
    /** 邮件 */
    myVCard.mailer = self.exmail.text;
    
    /** 把数据保存到服务器 */
    //内部实现把电子名片上传了一次,包括图片
    [[XMPPTool shareXMPPTool].vCard updateMyvCardTemp:myVCard];
}

#pragma mark - 选择相片的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 关闭图片选择界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 显示选择的图片(获取的是原图)
//    self.iconImageView.image = info[UIImagePickerControllerOriginalImage];
    
    //显示选择的图片(获取的是放大或者缩小后的图)
    self.iconImageView.image = info[UIImagePickerControllerEditedImage];
    
    //保存头像数据到数据库
    [self saveData];
}
@end
