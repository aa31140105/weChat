//
//  QYEditorViewController.m
//  weChat
//
//  Created by 天佑 on 16/4/2.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYEditorViewController.h"

@interface QYEditorViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation QYEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置键盘代理
    self.textField.delegate = self;
    
  //设置标题
    self.title = self.preCell.textLabel.text;
    
    //设置默认输入文本框的值
    self.textField.text = self.preCell.detailTextLabel.text;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveCell:(id)sender {
    
    self.preCell.detailTextLabel.text = self.textField.text;
    
    
//    //如果cell里的子控制器没有立即刷新可以使用这个方法
//    [self.preCell layoutSubviews];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    /** 告诉代理已经点击了保存按钮 */
    if ([self.delegate respondsToSelector:@selector(editorViewController:didFinishSave:)]) {
        [self.delegate editorViewController:self didFinishSave:sender];
    }
}
#pragma mark - 键盘弹出事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.textField resignFirstResponder];
}
#pragma mark - Table view data source


@end
