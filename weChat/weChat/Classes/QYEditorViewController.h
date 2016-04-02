//
//  QYEditorViewController.h
//  weChat
//
//  Created by 天佑 on 16/4/2.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QYEditorViewController;
@protocol QYEditorViewControllerDelegate <NSObject>

- (void)editorViewController:(QYEditorViewController *)editorController didFinishSave:(id)sender;

@end

@interface QYEditorViewController : UITableViewController

//拿到上一个控制器传来的cell
@property (nonatomic, strong) UITableViewCell *preCell;

/** 代理属性 */
@property (nonatomic, weak) id<QYEditorViewControllerDelegate> delegate;
@end
