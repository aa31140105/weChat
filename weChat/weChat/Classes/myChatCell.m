//
//  myChatCell.m
//  weChat
//
//  Created by 天佑 on 16/4/4.
//  Copyright © 2016年 天佑. All rights reserved.
//


#import "myChatCell.h"
#import "QYTool.h"

@interface myChatCell ()

@end

@implementation myChatCell


/** 添加所以得子控件 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        UIImageView *iconImage = [[UIImageView alloc]init];
        [self.contentView addSubview:iconImage];
        self.iconImage = iconImage;
        
        /** 聊天文本框的uiview */
        UIView *chatView = [[UIView alloc]init];
        [self.contentView addSubview:chatView];
        self.chatView = chatView;
        
        /** 聊天背景图 */
        UIImageView *chatImage = [[UIImageView alloc]init];
        [self.chatView addSubview:chatImage];
        self.chatImage = chatImage;
        
        /** 聊天文本框的label */
        UILabel *chatLabel = [[UILabel alloc]init];
        [self.chatView addSubview:chatLabel];
        self.chatLabel = chatLabel;
        
    }
    return self;
}

-(void)setMyText:(NSString *)myText{
    
    UILabel *label = [QYTool labelWithFont:[UIFont systemFontOfSize:18] width:200 text:myText];
    self.chatLabel.frame =CGRectMake(label.frame.origin.x + 20, label.frame.origin.y + 10, label.frame.size.width, label.frame.size.height);
    self.chatLabel.numberOfLines = 0;
    self.chatLabel.font = [UIFont systemFontOfSize:18];
    _myText = myText;
}

/** 设置所有子控件的frame */
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.mySelf) {
        [self myCellFrame];
        
    }else{
    
        [self friendCellFrame];
    }
}

/** 好友cell消息的布局 */
- (void)friendCellFrame{
 
    CGFloat iconImageX = 10;
    CGFloat iconImageY = 10;
    CGFloat iconImageW = 60;
    CGFloat iconImageH = 60;
    self.iconImage.frame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    
    self.chatLabel.text = self.myText;
    [self.chatLabel sizeToFit];
    
    self.chatView.frame = CGRectMake(80, 10, self.chatLabel.frame.size.width+40, self.chatLabel.frame.size.height+40);
    
    
    self.chatImage.frame = self.chatView.bounds;
    self.chatImage.image = [QYTool stretchableImage:[UIImage imageNamed:@"ReceiverTextNodeBkg"]];
}

/** 自己的Cell的布局 */
- (void)myCellFrame{
    
    CGFloat iconImageX =QYScreenW - 70 ;
    CGFloat iconImageY = 10;
    CGFloat iconImageW = 60;
    CGFloat iconImageH = 60;
    self.iconImage.frame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    
    self.chatLabel.text = self.myText;
    [self.chatLabel sizeToFit];
    
    CGFloat chatViewX =QYScreenW - self.chatLabel.frame.size.width - 120;
    CGFloat chatViewY = 10;
    self.chatView.frame = CGRectMake(chatViewX, chatViewY, self.chatLabel.frame.size.width+40, self.chatLabel.frame.size.height+40);
    
    self.chatImage.frame = self.chatView.bounds;
    self.chatImage.image = [QYTool stretchableImage:[UIImage imageNamed:@"SenderAppNodeBkg_HL"]];
}

- (void)awakeFromNib {

}


@end
