//
//  myChatCell.h
//  weChat
//
//  Created by 天佑 on 16/4/4.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myChatCell : UITableViewCell
/** 文本内容 */
@property (nonatomic, strong) NSString *myText;

/** 头像 */
@property (nonatomic, weak) UIImageView *iconImage;
/** 文本框的uiview */
@property (nonatomic, weak) UIView *chatView;
/** 文本框的背景图 */
@property (nonatomic, weak) UIImageView *chatImage;
/** 文本框的label */
@property (nonatomic, weak) UILabel *chatLabel;

/** 判断是接收的信息还是发出去的信息 */
@property (nonatomic, assign,getter=isMySelf) BOOL mySelf;
@end
