//
//  QYChatViewController.m
//  weChat
//
//  Created by 天佑 on 16/4/3.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYChatViewController.h"
#import "myChatCell.h"


#import "QYTool.h"

@interface QYChatViewController ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *resultController;

/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 拿到View的底部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;

//拿到textField情况输入框
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation QYChatViewController
static NSString *ID = @"myChatCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 键盘的监听 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //注册cell
    [self.tableView registerClass:[myChatCell class] forCellReuseIdentifier:ID];
    
    [self loadData];

}

- (void)loadData{
    
    //加载数据库的数据
    
    //1.上下文
    NSManagedObjectContext *msgContext = [XMPPTool shareXMPPTool].msgArchivingStorage.mainThreadManagedObjectContext;
    //2.查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //3.过滤(条件)
    NSString *loginUserJid = [XMPPTool shareXMPPTool].xmppStream.myJID.bare;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",loginUserJid,self.friendJid.bare];
    
    //设置时间排序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    request.predicate = pre;
    
    //执行请求
    _resultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:msgContext sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    
    NSError *error = nil;
    [_resultController performFetch:&error];
}

/** 图片发送 */
- (IBAction)sendImage:(id)sender {
    
    //从图片库选择图片
    UIImagePickerController *imagePC = [[UIImagePickerController alloc]init];
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.delegate = self;
    [self presentViewController:imagePC animated:YES completion:nil];
}


#pragma mark - 用户选择图片代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [self sendAttachmentWithData:UIImagePNGRepresentation(img) bodyType:@"image"];
    
    //图片控制器要消除
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark -发送图片文件
- (void)sendAttachmentWithData:(NSData *)data bodyType:(NSString *)bodyType{
    
    //把二进制数据转为字符串base64编码
    NSString *imageBaseStr = [data base64EncodedStringWithOptions:0];
    
    //发送图片
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    //设置类型
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    
    //添加body
    [msg addBody:bodyType];
    
    //定义一个附件
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:imageBaseStr];
    
    //添加节点
    [msg addChild:attachment];
    
    //发送
    [[XMPPTool shareXMPPTool].xmppStream sendElement:msg];
}

#pragma mark - fetch的代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    //数据库内容改变调用的方法
    [self.tableView reloadData];
    
    //数据改变滚动表格到底部
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_resultController.fetchedObjects.count - 1 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultController.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   //适配cell的高度
    XMPPMessageArchiving_Message_CoreDataObject *msgObj = _resultController.fetchedObjects[indexPath.row];
    UILabel *label = [QYTool labelWithFont:[UIFont systemFontOfSize:18] width:200 text:msgObj.body];
    if (label.frame.size.height > 80) {
        return label.frame.size.height+60;
    }else{
        return 80;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    //获取聊天信息
    XMPPMessageArchiving_Message_CoreDataObject *msgObj = _resultController.fetchedObjects[indexPath.row];
    
    cell.mySelf = !msgObj.thread.length > 0;
   
    
    cell.myText = msgObj.body;
    //判断消息类型有没有附件
//    1.获取原始的xml数据
    XMPPMessage *message = msgObj.message;
    
    /** 可以根据msgObj的thread是否有值判断是好友发来的信息还是自己发出去的信息,有值说明是好友发来的信息 */
//    NSLog(@"%@,,,%@",msgObj.body,msgObj.thread);
    
    //获取附件的类型
    NSString *bodyType = [message attributeStringValueForName:@"bodyType"];
    if ([bodyType isEqualToString:@"image"]) {
//            //遍历message的子节点
//        NSArray *child = message.children;
//        for (XMPPElement *note in child) {
//            //获取节点的名字
//            if ([[note name] isEqualToString:@"attachment"]) {
//                
//                //获取附件的字符串,然后转换成NSData,然后转换成图片
//                NSString *imageBase64Str = [note stringValue];
//                NSData *imageData = [[NSData alloc]initWithBase64EncodedString:imageBase64Str options:0];
//                UIImage *image = [UIImage imageWithData:imageData];
////                cell.chatImage.image = image;
//                
//                
//            }
//        }
//        //清除循环引用
//        cell.chatLabel.text = nil;
    }else if([bodyType isEqualToString:@"sound"]){
        
    }else {//纯文本
//
        /** 获取好友和自己的头像的data数据 */
        NSData *imageData = [[XMPPTool shareXMPPTool].vavatar photoDataForJID:self.friendJid];
        NSData *myImageData = [[XMPPTool shareXMPPTool].vavatar photoDataForJID:[XMPPTool shareXMPPTool].xmppStream.myJID];
        if (msgObj.thread.length > 0) {
            
            cell.iconImage.image = [UIImage imageWithData:imageData];
        }else {
            cell.iconImage.image = [UIImage imageWithData:myImageData];
        }
    }

    return cell;
}

/** 表格滚动隐藏键盘 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textField endEditing:YES];
}

#pragma mark - 键盘的显示和隐藏方法
- (void)kbWillShow:(NSNotification *)noti{
    //获取键盘的高度
    CGFloat kbheight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.viewBottom.constant = kbheight;
}

- (void)kbWillHide:(NSNotification *)noti{
    self.viewBottom.constant = 0;
}

#pragma mark - textField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *txt = textField.text;
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [msg addBody:txt];
    [[XMPPTool shareXMPPTool].xmppStream sendElement:msg];
    
    //情况输入框的文本
    self.textField.text = nil;
    
    return YES;
}


//------------------------------
//泡泡文本
//- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
//    
//    //计算大小
//    UIFont *font = [UIFont systemFontOfSize:14];
//    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    // build single chat bubble cell with given text
//    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
//    returnView.backgroundColor = [UIColor clearColor];
//    
//    //背影图片
//    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
//    
//    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
//    NSLog(@"%f,%f",size.width,size.height);
//    
//    
//    //添加文本信息
//    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
//    bubbleText.backgroundColor = [UIColor clearColor];
//    bubbleText.font = font;
//    bubbleText.numberOfLines = 0;
//    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
//    bubbleText.text = text;
//    
//    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
//    
//    if(fromSelf)
//        returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
//    else
//        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
//    
//    [returnView addSubview:bubbleImageView];
//    [returnView addSubview:bubbleText];
//    
//    return returnView;
//}
@end
