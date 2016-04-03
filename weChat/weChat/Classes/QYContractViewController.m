//
//  QYContractViewController.m
//  weChat
//
//  Created by 天佑 on 16/4/2.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYContractViewController.h"
#import "QYChatViewController.h"

@interface QYContractViewController ()<NSFetchedResultsControllerDelegate>

/** 好友数组 */
@property (nonatomic, strong) NSArray *users;

@property (nonatomic, strong) NSFetchedResultsController *fetchRC;
@end

@implementation QYContractViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContract];
    [self loadStatus];
    [self.tableView reloadData];
}

//观察数据库数据改变的请求
- (void)loadStatus{
    
    /** 显示好友数据(数据在XMPPRoster.sqlite文件) */
    //1.上下文,关联XMPPRoster.sqlite文件
    NSManagedObjectContext *rosterContext = [XMPPTool shareXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    
    //2.request请求查询那张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    /** 过滤请求 */
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"subscription != %@ AND subscription != %@ AND subscription != %@" ,@"none",@"to",@"from"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"subscription = %@",@"both"];
    request.predicate = pre;
    
    //3.执行请求,创建结果控制器
    //如果数据库数据很多,那么会在子线程中执行
    _fetchRC = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:rosterContext sectionNameKeyPath:nil cacheName:nil];
    _fetchRC.delegate = self;
    NSError *error = nil;
    [_fetchRC performFetch:&error];
    QYLog(@"%@",_fetchRC.fetchedObjects);
}

#pragma mark - 结果控制器的代理方法,监听数据库内容改变
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    //刷新表格
    [self.tableView reloadData];
}
/** 加载好友数据 */
- (void)loadContract{
   
    /** 显示好友数据(数据在XMPPRoster.sqlite文件) */
    //1.上下文,关联XMPPRoster.sqlite文件
    NSManagedObjectContext *rosterContext = [XMPPTool shareXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    
    //2.request请求查询那张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //3.执行请求
    NSError *error = nil;
    NSArray *users = [rosterContext executeFetchRequest:request error:&error];
    self.users = users;
 
}

#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.users.count;
    return _fetchRC.fetchedObjects.count;
}


#pragma mark - delete的代理方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //拿到要删除的好友
    XMPPUserCoreDataStorageObject *user = _fetchRC.fetchedObjects[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除好友
        [[XMPPTool shareXMPPTool].roster removeUser:user.jid];
    }
    /* 删除好友后不需要刷新表格,因为数据库信息改变会调用
    controllerDidChangeContent:(NSFetchedResultsController *)controller
    这个方法刷新表格
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前点击的cell,拿到正在聊天的好友,通过prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender方法把好友传到聊天控制器去
    XMPPJID *friendJid = [_fetchRC.fetchedObjects[indexPath.row] jid];
    
    [self performSegueWithIdentifier:@"seguaToChat" sender:friendJid];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //获取对应的好友
//    XMPPUserCoreDataStorageObject *user = self.users[indexPath.row];
    XMPPUserCoreDataStorageObject *user = _fetchRC.fetchedObjects[indexPath.row];
    
//    //kvo监听用户状态改变
//    [user addObserver:self forKeyPath:@"sectionNum" options:NSKeyValueObservingOptionNew context:nil];
    
    //标识用户是否在线(sectionNum的值,0表示在线,1是离开,2是离线)
    switch ([user.sectionNum integerValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
            case 1:
            cell.detailTextLabel.text = @"离开";
            break;
            case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            QYLog(@"未知状态");
            break;
    }
    
    cell.textLabel.text = user.displayName;
    
    /** 显示好友的头像 */
    if (user.photo) {//默认情况下,不是程序一启动就有图片的
        cell.imageView.image = user.photo;
    }else{
        //从数据库获取头像
      NSData *data = [[XMPPTool shareXMPPTool].vavatar photoDataForJID:user.jid];
        cell.imageView.image = [UIImage imageWithData:data];
        
    }
    
    
    return cell;
}

////KVO监听用户状态改变实现方法
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    [self.tableView reloadData];
//}


//把正在聊天的好友传到下一个控制器
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[QYChatViewController class]]) {
        QYChatViewController *chatVc = destVc;
        chatVc.friendJid = sender;
    }
}
@end
