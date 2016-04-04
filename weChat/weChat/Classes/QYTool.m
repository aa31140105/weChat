//
//  QYTool.m
//  Ticket
//
//  Created by 天佑 on 16/2/2.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYTool.h"
@implementation QYTool

/**
 *  给UIImageView添加毛玻璃效果
 *
 *  @param imageView 需要添加毛玻璃效果的UIImageView
 */
+ (void)toolbarWithImageView:(UIImageView *)imageView{
    
    //1.加毛玻璃
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    // 2. 设置frame
    toolbar.frame = imageView.frame;
    
    // 3. 设置样式和透明度
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.alpha = 1;
    [imageView addSubview:toolbar];
    
}

/**
 *  传入一个歌曲名称,返回一个AVPlayer(必须导入AVFoundation框架,并且歌曲放在主目录下)
 *
 *  @param name 图片的名称
 *
 *  @return 返回播放器AVPlayer
 */
+ (AVPlayer *)playerWithSongName:(NSString *)name{
    
    // 资源的URL地址
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:nil];
    // 创建播放器曲目
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    // 创建播放器
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [player play];
    return player;
}

/**
 *  以九宫格的格式添加几行几列的UIView
 *
 *  @param view       要给哪个UIView添加子控件
 *  @param smallViewX 子控件UIView的宽度
 *  @param smallViewY 子控件UIView的高度
 *  @param col        列数
 *  @param line       行数
 */
+ (void)nineForView:(UIView *)view smallViewX:(NSUInteger)smallViewX smallViewY:(NSUInteger)smallViewY col:(NSUInteger)col line:(NSUInteger)line{
    
    // 计算间距的值
    NSUInteger marginX = (view.frame.size.width - smallViewX * col)/(col -1);
    NSUInteger marginY = (view.frame.size.height - smallViewY * line)/(line - 1);
    
    // 根据行数和列数计算UIView的控件个数
    NSUInteger index = col * line;
    
    //循环生成UIView控件
    for (int i = 0; i < index; ++i) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake((i%col) * (smallViewX+marginX), (i/col) * (smallViewY+marginY), smallViewX,smallViewY)];
        myView.backgroundColor = [UIColor redColor];
        [view addSubview:myView];
    }
}


/**
 *  给一个UIView控件添加平移动画
 *
 *  @param view       要添加平移动画的UIView
 *  @param translateX x方向上的位移
 *  @param translateY Y方法上的位移
 *  @param timer      动画的执行时长
 *  @param delay      延迟时间
 */
+ (void)translateAnimateWithView:(UIView *)view translateX:(double)translateX translateY:(double)translateY timer:(NSTimeInterval)timer delay:(NSTimeInterval)delay{
    /*
     UIViewAnimationOptionCurveEaseInOut  动画开始/结束比较缓慢,中间相对较快
     UIViewAnimationOptionCurveEaseIn     动画开始比较缓慢
     UIViewAnimationOptionCurveEaseOut    动画结束比较缓慢
     UIViewAnimationOptionCurveLinear     线性---> 匀速
     */
    
    [UIView animateWithDuration:timer delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = view.frame;
        frame.origin.x += translateX;
        frame.origin.y += translateY;
        view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  围绕左上角进行缩放
 *
 *  @param view   要进行缩放的UIView
 *  @param width  宽度的缩放比例,输入一个整数
 *  @param height 高度的缩放比例,输入一个整数
 *  @param time   缩放动画执行的时间
 *  @param delay  延迟时间
 */
+ (void)scaleAnimateWithView:(UIView *)view width:(double)width height:(double)height time:(NSTimeInterval)time delay:(NSTimeInterval)delay{
    
    [UIView animateWithDuration:time delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect frame = view.frame;
        frame.size.width *= width;
        frame.size.height *= height;
        view.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  透明度动画
 *
 *  @param view  要添加透明度动画的UIView
 *  @param alpha alpha的变化值(0-1之间)
 *  @param time  动画的执行时间
 *  @param delay 动画的延迟时间
 */
+ (void)alphaAnimateWithView:(UIView *)view alpha:(double)alpha time:(NSTimeInterval)time deay:(NSTimeInterval)delay{
    [UIView animateWithDuration:time delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.alpha -= alpha;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time animations:^{
            view.alpha += alpha;
        }];
    }];
    
}


/**
 *  设置scrollView具有上拉刷新的下拉刷新的功能(总是有弹簧效果)
 *
 *  @param scrollView  具有弹簧效果的scrollView
 */
+ (void)scrollViewWithBounce:(UIScrollView *)scrollView{
    
    // 不管有没有设置contentSize,总是有弹簧效果(下拉刷新)
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    
    // 设置contentSize
    // scrollView.contentSize = image.size;
    
    
    // 是否显示滚动条
    // scrollView.showsHorizontalScrollIndicator = NO;
    // scrollView.showsVerticalScrollIndicator = NO;
}

/**
 *  设置分页左右滚动UIScrollView
 *
 *  @param images      字符串数组,滚动的图片的名称
 *  @param scrollView  设置滚动的UIScrollView
 *  @param pageControl 设置分页的UIPageControl
 *  @param current     UIPageControl选中时显示的图片
 *  @param other       UIPageControl未选中时显示的图片
 *  注意若想让UIPageControl的图片跟着切换需要在UIScrollView的代理事件 scrollViewDidScroll中加入以下代码:
 *   1.计算页码
 *  int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
 *  2.设置页码
 *   self.pageControl.currentPage = page;
 *
 */
+ (void)scrollViewPageWithArray:(NSArray *)images scrollView:(UIScrollView *)scrollView pageControl:(UIPageControl *)pageControl currentPageImage:(UIImage *)current pageImage:(UIImage *)other{
    
    for (int i = 0; i < images.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:images[i]];
        imageView.frame = CGRectMake(i * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
    }
    // 2.设置contentSize
    // 这个0表示竖直方向不可以滚动
    scrollView.contentSize = CGSizeMake(images.count * scrollView.frame.size.width, 0);
    
    // 3.开启分页功能
    // 标准:以scrollView的尺寸为一页
    scrollView.pagingEnabled = YES;
    
    // 4.设置总页数
    pageControl.numberOfPages = images.count;
    
    // 5.单页的时候是否隐藏pageControl
    pageControl.hidesForSinglePage = YES;
    
    // 6.设置pageControl的图片
    [pageControl setValue:current forKeyPath:@"_currentPageImage"];
    [pageControl setValue:other  forKeyPath: @"_pageImage"];
    
}

/**
 *  创建一个每隔N秒执行某个事件的定时器
 *
 *  @param sel     执行的事件
 *  @param target  给谁添加控制器,一般是self(UIViewController)
 *  @param timer   执行事件隔得事件
 *  @param repeats 是否重复执行
 */
+ (void)timerWithSEL:(SEL)sel target:(UIViewController *)target timer:(NSTimeInterval)timer repeats:(BOOL)repeats{
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:timer target:target selector:sel userInfo:@"123" repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
}

/**
 *  根据固定宽度和字号返回一个高度变化的UILabel
 *
 *  @param font  UILabel的UIFont
 *  @param width UILabel的宽度
 *  @param text  UILabel的text
 *
 *  @return 返回一个宽度固定,高度变化的UILabel
 */
+ (UILabel *)labelWithFont:(UIFont *)font width:(CGFloat)width text:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    
    CGFloat twxtW = width;
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    NSDictionary *textAtt = @{NSFontAttributeName : font};
    CGSize textSize = CGSizeMake(twxtW, MAXFLOAT);
    CGFloat textH = [label.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size.height;
    label.frame = CGRectMake(0,0, twxtW, textH);
    return label;
}

/**
 *  根据字号自动计算UILabel的宽度
 *
 *  @param font UILabel的UIFont
 *  @param text UILabel的text内容
 *
 *  @return 返回一个宽度随字号变化的UILabel
 */
+ (UILabel *)labelWithFont:(UIFont *)font text:(NSString *)text{
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = font;
    NSDictionary *nameAtt = @{NSFontAttributeName : font};
    CGSize nameSize = [label.text sizeWithAttributes:nameAtt];
    CGFloat nameW = nameSize.width;
    CGFloat nameH = nameSize.height;
    label.frame = CGRectMake(0, 0, nameW, nameH);
    return label;
}

/**
 *  刷新某个tableView的某一组某一行的数组(局部刷新)
 *  这个方法只适合在添加一行数据的适合刷新,如果是删除数据后刷新要调用deleteRowsAtIndexPaths这个方法
 *  如果是修改数据后刷新,必须调用reloadRowsAtIndexPaths这个方法
 *  @param section         刷新tableView的哪一组的数据
 *  @param indexPathForRow 舒心tableView的哪一行的数据
 *  @param tableView       刷新哪一个TableView
 */
+ (void)partRefreshWithSection:(NSInteger)section indexPathForRow:(NSInteger)indexPathForRow tabelView:(UITableView *)tableView{
    NSArray *indexPaths = @[
                            [NSIndexPath indexPathForRow:indexPathForRow inSection:section]
                            ];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
}


/**
 *  自定义TableViewCell的左滑按钮的点击事件(按钮的顺序是从右至左的)
 *  这个办法必须要在这个方法里执行- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
 
 *  @param defaultTitle  第一个按钮显示的文字
 *  @param defaultHandle 第一个按钮的单击事件
 *  @param normalTitle   第二个按钮显示的文字
 *  @param normalHandle  第二个按钮的单击事件
 *
 *  @return 返回UITableViewRowAction格式的数组
 */
+ (NSArray<UITableViewRowAction *> *)leftSlideWithDefaultTitle:(NSString *)defaultTitle defaultHandle:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))defaultHandle normalTitle:(NSString *)normalTitle normalHandle:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))normalHandle{
    
    //创建第一个UITableViewRowAction
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:defaultTitle handler:defaultHandle];
    
    //创建第二个UITableViewRowAction
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:normalTitle handler:normalHandle];
    
    return @[action1,action2];
    
};


/**
 *  给UIButton添加圆形外边框
 *
 *  @param btn 要添加圆形外边框的UIButton
 */
+ (void)cornerRadiusWithButton:(UIButton *)btn{
    // 设置边框宽度
    btn.layer.borderWidth = 1.0;
    // 设置边框颜色
    btn.layer.borderColor = [UIColor redColor].CGColor;
    // 设置圆角半径
    btn.layer.cornerRadius = btn.frame.size.width * 0.5;
}

/**
 *  监听通知与发布通知
 *
 *  @param object           哪个对象要监听通知
 *  @param selector         监听到通知发布出来后执行的事件
 *  @param senderName       发布通知的名称
 *  @param senderObject     发布通知的对象
 *  @param senderDictionary 通知的内容(字典)
 */
+ (void)notificationWithObject:(id)object selector:(SEL)selector senderName:(NSString *)senderName senderObject:(id)senderObject senderDictionary:(NSDictionary *)senderDictionary{
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:object selector:selector name:senderName  object:senderObject];
    
    //发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:senderName object:senderObject userInfo:senderDictionary];
    
    //    //移除监听(一般移除监听在对象即将销毁的时候,写在dealloc方法里移除,ios9以后可以不用移除监听)
    //    //移除某个事件的监听
    //    [[NSNotificationCenter defaultCenter] removeObserver:object name:senderName object:senderObject];
    //    //移除这个对象的所有监听
    //    [[NSNotificationCenter defaultCenter] removeObserver:object];
    
}

//-(UIImage *)imageWithBorder:(CGFloat)borderW color:(UIColor *)borderColor image:(UIImage *)image
//{
//    
//    //    1.开启一个上下文
//    CGSize size = CGSizeMake(image.size.width + 2*borderW,image.size.height+ 2*borderW);
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    //    2.绘制大圆,显示出来
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,size.width,size.height)];
//    [borderColor set];
//    [path fill];
//    // 3.绘制一个小圆,把小圆设置成裁剪区域
//    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW,borderW,image.size.width,image.size.height)];
//    //设置裁剪
//    [clipPath addClip];
//    //  4.把图片绘制到上下文当中
//    [image drawAtPoint:CGPointMake(borderW,borderW)];
//    // 5.从上下文当中取出图片
//    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
//    //  6.关闭上下文
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}


/**
 *  把一个UIView生成PNG或者JPG格式的图片,保存在指定路径
 *
 *  @param path   图片要保存到的路径
 *  @param type   图片的格式png或者jpg
 *  @param UIView 要转成图片的UIView
 */
+ (void)clipScreenWithPath:(NSString *)path type:(NSString *)type UIView:(UIView *)view
{
    
    //1.开启一个和传进来的View大小一样的位图上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO,0);
    //2.把控制器的View绘制到上下文当中
    //想把UIView上面的东西绘制到上下文当中,必须得使用渲染的方式
    //renderInContext:就是渲染的方式
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx ];
    //3从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭上下文
    UIGraphicsEndImageContext();
    //5.把生成的图片写入到桌面(以文件的方式进行传输:二进制流NSData,即把图片转为二进制流)
    NSData *data;
    if ([type isEqualToString:@"png"]) {
        //生成PNG格式的图片
        data = UIImagePNGRepresentation(newImage);
    }
    else if ([type isEqualToString:@"jpg"]){
        //5.1把图片转为二进制流(第一个参数是图片,第2个参数是图片压缩质量:1是最原始的质量)
        data = UIImageJPEGRepresentation(newImage,1);
    }
    
    [data writeToFile:path atomically:YES];
}

/**
 *  设置程序图标的提醒数字
 *
 *  @param value 提醒数字的值
 */
+ (void)bageValueWithNumber:(NSInteger)value{
    //设置提醒图标
    //1.获取UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    //2.注册用户通知
    UIUserNotificationSettings *notice = [UIUserNotificationSettings settingsForTypes:
                                          UIUserNotificationTypeBadge categories:nil];
    [app registerUserNotificationSettings:notice];
    //3.设置提醒值.
    app.applicationIconBadgeNumber = value;
}

/**
 *  设置联网状态
 *
 *  @param state 是否连接网络
 */
+ (void)connectState:(BOOL)state{
    
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = state;
}

/**
 *  传入一个网站,打开这个网站
 *
 *  @param link 要打开的网站,注意要加上协议头
 */
+ (void)openURL:(NSString *)link{
    //1.获取UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:link];
    [app openURL:url];
}

/**
 *  加载指定标识的Xib控制器
 *
 *  @param name     Xib文件的名称
 *  @param identity Xib文件的标识
 *
 *  @return 返回一个根控制器为指定Xib的UIWindow
 */
+ (id)windowWithNibName:(NSString *)name identity:(NSString *)identity{
    //1.创建窗口
    UIWindow *window = [[UIWindow alloc]init];
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口的根控制器
    //通过StoryBoard加载控制器.
    //2.1创建storyBoard对象
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
    
    //2.2.加载storyBoard箭头指向的控制器
    //    UIViewController *vc =  [storyBoard instantiateInitialViewController];
    //2.3.加载指定标识的控制器
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:identity];
    
    window.rootViewController = vc;
    //3.显示窗口
    [window makeKeyAndVisible];
    return window;
}

/**
 *  加载指定名字的控制器(带导航栏)
 *
 *  @param controller 加载的根控制器
 *
 *  @return 返回一个加载了指定导航控制器的UIWindow
 */
+ (id)windowWithViewController:(UIViewController *)controller{
    UIWindow *window = [[UIWindow alloc]init];
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor orangeColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    nav.view.backgroundColor = [UIColor grayColor];
    
    window.rootViewController  = nav;
    
    [window makeKeyAndVisible];
    return window;
}

/**
 *  传入一个根控制器,返回一个window
 *
 *  @param rootViewController 传入一个根控制器
 *
 *  @return 返回一个window
 */
+ (id)windowWithRootViewController:(UIViewController *)rootViewController{
    // 1.创建窗口
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2.设置窗口的跟控制器
    // 2.1创建窗口跟控制器
    window.rootViewController = rootViewController;
    
    // 3,让窗口显示
    [window makeKeyAndVisible];
    return window;
}

/**
 *  返回一个导航栏被隐藏的导航控制器
 *
 *  @return 返回一个导航栏被隐藏的导航控制器
 */
+ (UINavigationController *)navHideNavigationbar{
    UINavigationController *nav = [[UINavigationController alloc]init];
    [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    [nav.navigationBar setShadowImage:[[UIImage alloc] init]];
    return nav;
}

/**
 *  将数组或者字典转为plist文件保存到沙盒的Caches文件中
 *
 *  @param name      保存的plist文件的文件名称(例如data.plist)
 *  @param dictArray 要保存的数组对象或者字典对象
 */
+ (void)saveToCachesWithName:(NSString *)name dictArray:(id)dictArray {
    //第一个参数:搜索的目录;第二个参数:搜索的范围;第三个参数:是否展开路径(在ios当中识别~)
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //stringByAppendingPathComponent拼接一个文件路径.自动加一个(/)
    NSString *filePath = [path stringByAppendingPathComponent:name];
    //路径是沙盒路径.
    [dictArray writeToFile:filePath atomically:YES];
}

/**
 *  从沙盒目录下的Caches文件中读取一个数组或者字典
 *
 *  @param name     要读取的文件名(例如:data.plist)
 *  @param dataType 要读取的数据是数组还是字典,数组输入@"aray",字典输入@"dict"
 *
 *  @return 返回一个数组或者一个字典
 */
+ (id)readFromCachesWithName:(NSString *)name dataType:(NSString *)dataType{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:name];
    if ([dataType isEqualToString:@"array"]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        return array;
    }
    else if ([dataType isEqualToString:@"dict"]){
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return dict;
    }
    else {
        return @"dataType参数输入错误,请输入字符串array表示读取数组,输入字符串dict表示读取字典!";
    }
}

/**
 *  将对象保存到沙盒中的Preferences文件中(保存用户的偏好设置)
 *  这个方法只适合保存对象类型,若要保存float,BOOL等其他类型需另写
 *  @param object      需要保存的对象(值)
 *  @param objetForKey 保存的对象的键名(键)
 */
+ (void)saveToPreferencesWithobject:(id)object objectForKey:(id)objetForKey{
    //NSUserDefaults它保存是一个plist.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:objetForKey];
    [defaults synchronize];
}

/**
 *  从沙盒的Preferences文件中通过键读取某个对象的值(读取用户的偏好设置)
 *  这个方法只适合从Preferences文件读取对象
 *  @param objectForKey 需要读取的键
 *
 *  @return 返回一个对象类型
 */
+ (id)readFromPreferencesWithObjectForKey:(id)objectForKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:objectForKey];
    return object;
}

/**
 *  modal出一个全屏的UIView
 *
 *  @return 返回一个modal出来的全屏的UIView
 */
+ (UIView *)modalWithView{
    
    UIView *VC = [[UIView alloc]init];
    VC.backgroundColor = [UIColor yellowColor];
    CGRect myRect = [UIScreen mainScreen].bounds;
    myRect.origin.y = myRect.size.height;
    VC.frame = myRect;
    [UIView animateWithDuration:1 animations:^{
        
        VC.frame = [UIScreen mainScreen].bounds;
    }];
    return VC;
}

/**
 *  给对象添加一个手势
 *
 *  @param gestureType swipe表示轻扫手势,longPress表示长按手势,tap表示点按手势,rotation表示旋转手势
 pinch表示捏合手势,pan表示拖动手势
 *  @param direction 轻扫手势的方向,字符串up,left,down,other分别为上下左右
 *  @param target    监听的对象(UIViewController)
 *  @param object    要添加手势的对象
 *  @param event     手势的执行事件
 */
+ (void)gestureWithType:(NSString *)gestureType swipeDirection:(NSString *)direction target:(UIViewController *)target forObject:(id)object event:(SEL)event{
    
    //添加轻扫手势
    if ([gestureType isEqualToString:@"swipe"]) {
        //1.创建手势
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:event];
        if ([direction isEqualToString:@"up"]) {
            //设置向上轻扫的方向
            swipe.direction = UISwipeGestureRecognizerDirectionUp;
        }else if ([direction isEqualToString:@"left"]){
            //设置向左轻扫的方向
            swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        }
        else if ([direction isEqualToString:@"down"]){
            //设置向下轻扫的方向
            swipe.direction = UISwipeGestureRecognizerDirectionDown;
        }
        else if ([direction isEqualToString:@"right"]){
            //设置向右轻扫的方向
            swipe.direction = UISwipeGestureRecognizerDirectionRight;
        }
        //给对象添加手势
        [object addGestureRecognizer:swipe];
    }
    else if ([gestureType isEqualToString:@"longPress"]){
        //创建长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:event];
        //2.添加手势
        [object addGestureRecognizer:longPress];
        
    }
    else if ([gestureType isEqualToString:@"tap"]){
        //添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:event];
        
        //2.添加手势
        [object addGestureRecognizer:tap];
    }
    else if ([gestureType isEqualToString:@"rotation"]){
        //添加旋转手势
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:target action:event];
        //添加手势
        [object addGestureRecognizer:rotation];
    }
    else if ([gestureType isEqualToString:@"pinch"]){
        //添加捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:event];
        [object addGestureRecognizer:pinch];
    }
    else if ([gestureType isEqualToString:@"pan"]){
        //添加拖动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:event];
        [object addGestureRecognizer:pan];
    }
}

/**
 *  通过HTTP地址,下载一张网络上的图片
 *
 *  @param imageURL 网络上的图片的地址
 *
 *  @return 返回一张网络上的图片
 */
+ (UIImage *)imageWithImageURL:(NSString *)imageURL{
    
    NSURL *url = [NSURL URLWithString:imageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
/**
 *  利用pthread创建一个执行某个函数的子线程
 *  注意使用pthread必须导入头文件<pthread.h>
 *  @param pthread_attr_t 线程的属性
 *  @param hanshu         指向函数的指针
 *  @param canshu         函数需要接收的参数
 */
+ (void)pthreadWithPthread_attr_t:(const pthread_attr_t *)pthread_attr_t hanshu:(void *(*)(void *))hanshu canshu:(void *)canshu{
    //创建线程对象
    pthread_t thread;
    //参数1.线程的对象,传递地址
    //参数2.线程的属性 null
    //参数3.指向函数的指针
    //参数4.函数需要接收的参数
    pthread_create(&thread, NULL,hanshu, canshu);
}

/**
 *  利用NSThread判断当前线程是否是主线程
 *
 *  @return 返回1表示当前线程是主线程,返回0表示子线程
 */
+ (BOOL)isMainThread{
    NSThread *currentThread = [NSThread currentThread];
    BOOL isMainThread = [currentThread isMainThread];
    return isMainThread;
}

/**
 *  利用NSThread开启一个子线程,设置name和threadPriority优先级
 *
 *  @param selector 线程执行的方法
 *  @param target   目标对象,一般是self控制器
 *  @param object   selector方法所带的参数
 *  @param name     子线程的名字
 *  @param priority 子线程的优先级(0-1),默认写0.5
 */
+ (void)NSThreadWithSelector:(SEL)selector target:(id)target object:(id)object name:(NSString *)name priority:(CGFloat)priority{
    NSThread *thread2 = [[NSThread alloc]initWithTarget:target selector:selector object:object];
    thread2.name = name;
    thread2.threadPriority = priority;
    [thread2 start];
}

/**
 *  创建同步函数/异步函数+并发/串行的线程
 *  或者创建同步函数/异步函数+主队列的线程
 *
 *  @param attr     DISPATCH_QUEUE_CONCURRENT表示并发,DISPATCH_QUEUE_SERIAL表示串行,nil或者0表示主队列
 *  @param identity 标签
 *  @param type     表示同步函数或者异步函数,字符串async表示异步函数,其他字符串都表示同步函数
 *  @param block    线程执行的代码块
 */
+ (void)dispatchWithAttr_t:(dispatch_queue_attr_t)attr identity:(const char *)identity type:(NSString *)type block:(dispatch_block_t)block{
    dispatch_queue_t queue;
    if (!attr) {
        queue = dispatch_get_main_queue();
    }
    else{
        queue = dispatch_queue_create(identity, attr);
    }
    if ([type isEqualToString:@"async"]) {
        dispatch_async(queue, block);
    }
    else {
        dispatch_sync(queue, block);
    }
    
}

/**
 *  将某个文件夹下的所有文件剪切到另外一个文件中(常规操作)
 *
 *  @param fromPath 剪切的文件夹的路径
 *  @param toPath   剪切的东西放到的那个文件夹的路径
 */
+ (void)cutFromPath:(NSString *)fromPath toPath:(NSString *)toPath{
    //剪切文件
    //    //1.拿到文件路径
    //    NSString *from =fromPath;
    //    //2.获得目标文件的路径
    //    NSString *to = toPath;
    //3.得到目录下的所有文件
    NSArray *subPaths = [[NSFileManager defaultManager]subpathsAtPath:fromPath];
    //4.遍历所有文件,执行剪切操作
    NSInteger count = subPaths.count;
    for (int i = 0; i < count; ++i) {
        //4.1拼接文件的全路径
        //stringByAppendingPathComponent拼接的时候会自动添加/
        NSString *fullPath = [fromPath stringByAppendingPathComponent:subPaths[i]];
        NSString *toFullPath = [toPath stringByAppendingPathComponent:subPaths[i]];
        //4.2执行剪切操作
        [[NSFileManager defaultManager]moveItemAtPath:fullPath toPath:toFullPath error:nil];
        
    }
}

/**
 *  将某个文件夹下的所有文件剪切到另外一个文件中(利用GCD的迭代操作,系统自动分配线程来进行操作)
 *
 *  @param fromPath 剪切的文件夹的路径
 *  @param toPath   剪切的东西放到的那个文件夹的路径
 */
+ (void)cutWithGCDFormPath:(NSString *)fromPath toPath:(NSString *)toPath{
    //1.拿到文件路径
    NSString *from = fromPath;
    
    //2.获得目标文件路径
    NSString *to = toPath;
    
    //3.得到目录下面的所有文件
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:from];
    
    //4.遍历所有文件,然后执行剪切操作
    NSInteger count = subPaths.count;
    
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t i) {
        //4.1 拼接文件的全路径
        // NSString *fullPath = [from stringByAppendingString:subPaths[i]];
        //在拼接的时候会自动添加/
        NSString *fullPath = [from stringByAppendingPathComponent:subPaths[i]];
        NSString *toFullPath = [to stringByAppendingPathComponent:subPaths[i]];
        
        //4.2 执行剪切操作
        /*
         第一个参数:要剪切的文件在哪里
         第二个参数:文件应该被存到哪个位置
         */
        [[NSFileManager defaultManager]moveItemAtPath:fullPath toPath:toFullPath error:nil];
        
        
    });
}


/**
 *  传入2张图片,将两个图片组合在一起,然后返回这个图片
 *  (图片合成的模式是第一张图片在上半部分,第二张图片在下半部分
 *  @param imageOne 要合成的第一张图片
 *  @param imageTwo 要合成的第二张图片
 *  @param size     合成后的图片的大小
 *
 *  @return 合成后的图片(UIImage类型)
 */
+ (UIImage *)composeWithImageOne:(UIImage *)imageOne ImageTwo:(UIImage *)imageTwo size:(CGSize)size{
    //创建上下文
    UIGraphicsBeginImageContext(size);
    
    
    //2画图1
    [imageOne drawInRect:CGRectMake(0, 0, size.width, size.height*0.5)];
    imageOne = nil;
    //3.画图2
    [imageTwo drawInRect:CGRectMake(0, size.height*0.5, size.width, size.height*0.5)];
    imageTwo = nil;
    //4.根据上下文得到一张图片
    UIImage *image3 = UIGraphicsGetImageFromCurrentImageContext();
    
    //5.关闭上下文
    UIGraphicsEndImageContext();
    return image3;
    
}


/**
 *  利用队列组合成两张图片
 *
 *  @param blockOne   第一个子线程的代码块(主要是从网络上加载一张图片)
 *  @param blockTwo   第二个子线程的代码块(主要是从网络上加载第二张图片)
 *  @param blockThree 第三个子线程的代码块(拦截操作,在子线程1和子线程2完成后的操作)
 */
+ (void)dispatch_groupWithBlockOne:(dispatch_block_t)blockOne blockTwo:(dispatch_block_t)blockTwo blockThree:(dispatch_block_t)blockThree{
    
    //获得队列组
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //开子线程
    dispatch_group_async(group, queue,blockOne);
    
    dispatch_group_async(group, queue,blockTwo);
    
    
    //合并图片
    dispatch_group_notify(group, queue,blockThree);
    
}

/**
 *  传入NSBlockOperation类型的数组,利用NSOperation的依赖按数组的顺序执行NSBlockOperation
 *  当最后一个NSBlockOperation已经执行完后,利用completionBlock监听提示用户
 *  @param NSBlockOperations 传入NSBlockOperation的数组
 */
+ (void)NSBlockOperations:(NSArray *)NSBlockOperations{
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    for (NSInteger i = NSBlockOperations.count-1; i >=0; --i) {
        if (i>0) {
            //添加依赖
            [NSBlockOperations[i] addDependency:NSBlockOperations[i-1]];
        }
        //利用completionBlock监听提示用户最后一个NSBlockOperation已经执行完
        if (i ==0) {
            
            NSBlockOperation *block1 =(NSBlockOperation *)NSBlockOperations[i];
            block1.completionBlock = ^{
                NSLog(@"最后一个NSBlockOperation已经执行完!");
            };
        }
        //添加操作到队列
        [queue addOperation:NSBlockOperations[i]];
    }
}


/**
 *  发送一个常规的post请求
 *
 *  @param URL       请求路径
 *  @param Uer_Agent 设置请求头细腻
 *  @param HTTPBody  设置请求体信息
 *  @param block     发送请求执行的代码块
 */
+ (void)postWithURL:(NSString *)URL User_Agent:(NSString *)Uer_Agent HTTPBody:(NSString *)HTTPBody
              block:(void (^)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError))block{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:URL];
    
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    
    //设置属性,请求超时的时间
    request.timeoutInterval = 10;
    
    //设置请求头信息
    [request setValue:HTTPBody forHTTPHeaderField:@"User-Agent"];
    
    //4.设置请求体信息
    request.HTTPBody = [HTTPBody dataUsingEncoding:NSUTF8StringEncoding];
    
    //5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:block];
}

/**
 *  发送一个get请求
 *
 *  @param URL       设置请求路径
 *  @param translate 请求路径是否需要转码,1为需要转码,0为不需要
 *  @param block     设置发送请求执行的代码块
 */
+ (void)getWithURL:(NSString *)URL translate:(BOOL)translate block:(void (^)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError))block{
    NSString *urlStr = URL;
    //先判断是否需要转码
    if (translate) {
        urlStr = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:block];
    
}

/**
 *  JSON数据转换为OC对象
 *
 *  @param json 要转换的JSON数据
 *
 *  @return 转换后的OC对象
 */
+ (id)objectFromJsonWithJson:(NSData *)json{
    /*
     NSJSONReadingMutableContainers = (1UL << 0), 可变字典和数组
     NSJSONReadingMutableLeaves = (1UL << 1),      内部所有的字符串都是可变的 ios7之后又问题  一般不用
     NSJSONReadingAllowFragments = (1UL << 2)   既不是字典也不是数组,则必须使用该枚举值
     */
    //反序列化  JSON数据转为OC对象
    id obj = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
    return obj;
}

/**
 *  把OC对象转换为JSON数据
 *
 *  @param object 要转换的OC对象
 *
 *  @return 转换后的JSON数据(二进制数据)
 */
+ (NSData *)jsonFromOCWithObject:(id)object{
    //判断传进来的对象能不能转换成JSON数据
    BOOL isValid = [NSJSONSerialization isValidJSONObject:object];
    if (!isValid) {
        NSLog(@"当前的OC对象不能转换为JSON");
        return nil;
    }
    else{
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        return data;
    }
    
}

/**
 *  传入一个视频URL,播放URL的视频
 *  注意使用这个功能必须导入框架<MediaPlayer/MediaPlayer.h>
 *  @param url 视频的URL地址
 *  @param viewController 一般是self
 */
+ (void)videoWithURL:(NSURL *)url viewController:(UIViewController *)viewController{
    //3.创建播放控制器
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
    
    //4.弹出控制器
    [viewController presentViewController:vc animated:YES completion:nil];
}

/**
 *  图片不要渲染
 *
 *  @param name 图片名字
 *
 *  @return 返回一张不要渲染的图片
 */
+ (UIImage *)imageWithRenderOriginalName:(NSString *)name{
    UIImage *image =  [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 *  设置拉伸图片使图片不变形
 *
 *  @param image 需要拉伸的图片
 */
+ (UIImage *)stretchableImage:(UIImage *)image{
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *
 *  @return 返回文件夹尺寸
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath
{
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"笨蛋 需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [excp raise];
        
    }
    
    // 获取cache文件夹下所有文件,不包括子路径的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接完成全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
    
}

/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
// 自己去计算SDWebImage做的缓存
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totleSize))completion
{
    
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"笨蛋 需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [excp raise];
        
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 获取文件夹下所有的子路径,包含子路径的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        
        NSInteger totalSize = 0;
        
        for (NSString *subPath in subPaths) {
            // 获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断是否文件夹
            BOOL isDirectory;
            // 判断文件是否存在,并且判断是否是文件夹
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 获取文件属性
            // attributesOfItemAtPath:只能获取文件尺寸,获取文件夹不对,
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            
            // 获取文件尺寸
            NSInteger fileSize = [attr fileSize];
            
            totalSize += fileSize;
        }
        
        // 计算完成回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
        
        
        
    });
    
    
}
@end
