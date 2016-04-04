//
//  QYTool.h
//  Ticket
//
//  Created by 天佑 on 16/2/2.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <pthread.h>
#import <MediaPlayer/MediaPlayer.h>
@interface QYTool : NSObject
/**
 *  给UIImageView添加毛玻璃效果
 *
 *  @param imageView 需要添加毛玻璃效果的UIImageView
 */
+ (void)toolbarWithImageView:(UIImageView *)imageView;

/**
 *  传入一个歌曲名称,返回一个AVPlayer(必须导入AVFoundation框架,并且歌曲放在主目录下)
 *
 *  @param name 图片的名称
 *
 *  @return 返回播放器AVPlayer
 */
+ (AVPlayer *)playerWithSongName:(NSString *)name;

/**
 *  以九宫格的格式添加几行几列的UIView
 *
 *  @param view       要给哪个UIView添加子控件
 *  @param smallViewX 子控件UIView的宽度
 *  @param smallViewY 子控件UIView的高度
 *  @param col        列数
 *  @param line       行数
 */
+ (void)nineForView:(UIView *)view smallViewX:(NSUInteger)smallViewX smallViewY:(NSUInteger)smallViewY col:(NSUInteger)col line:(NSUInteger)line;

/**
 *  给一个UIView控件添加平移动画
 *
 *  @param view       要添加平移动画的UIView
 *  @param translateX x方向上的位移
 *  @param translateY Y方法上的位移
 *  @param timer      动画的执行时长
 *  @param delay      延迟时间
 */
+ (void)translateAnimateWithView:(UIView *)view translateX:(double)translateX translateY:(double)translateY timer:(NSTimeInterval)timer delay:(NSTimeInterval)delay;

/**
 *  围绕左上角进行缩放
 *
 *  @param view   要进行缩放的UIView
 *  @param width  宽度的缩放比例,输入一个整数
 *  @param height 高度的缩放比例,输入一个整数
 *  @param time   缩放动画执行的时间
 *  @param delay  延迟时间
 */
+ (void)scaleAnimateWithView:(UIView *)view width:(double)width height:(double)height time:(NSTimeInterval)time delay:(NSTimeInterval)delay;

/**
 *  透明度动画
 *
 *  @param view  要添加透明度动画的UIView
 *  @param alpha alpha的变化值(0-1之间)
 *  @param time  动画的执行时间
 *  @param delay 动画的延迟时间
 */
+ (void)alphaAnimateWithView:(UIView *)view alpha:(double)alpha time:(NSTimeInterval)time deay:(NSTimeInterval)delay;

/**
 *  设置scrollView具有上拉刷新的下拉刷新的功能(总是有弹簧效果)
 *
 *  @param scrollView  具有弹簧效果的scrollView
 */
+ (void)scrollViewWithBounce:(UIScrollView *)scrollView;

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
+ (void)scrollViewPageWithArray:(NSArray *)images scrollView:(UIScrollView *)scrollView pageControl:(UIPageControl *)pageControl currentPageImage:(UIImage *)current pageImage:(UIImage *)other;

/**
 *  创建一个每隔N秒执行某个事件的定时器
 *
 *  @param sel     执行的事件
 *  @param target  给谁添加控制器,一般是self(UIViewController)
 *  @param timer   执行事件隔得事件
 *  @param repeats 是否重复执行
 */
+ (void)timerWithSEL:(SEL)sel target:(UIViewController *)target timer:(NSTimeInterval)timer repeats:(BOOL)repeats;

/**
 *  根据固定宽度和字号返回一个高度变化的UILabel
 *
 *  @param font  UILabel的UIFont
 *  @param width UILabel的宽度
 *  @param text  UILabel的text
 *
 *  @return 返回一个宽度固定,高度变化的UILabel
 */
+ (UILabel *)labelWithFont:(UIFont *)font width:(CGFloat)width text:(NSString *)text;

/**
 *  根据字号自动计算UILabel的宽度
 *
 *  @param font UILabel的UIFont
 *  @param text UILabel的text内容
 *
 *  @return 返回一个宽度随字号变化的UILabel
 */
+ (UILabel *)labelWithFont:(UIFont *)font text:(NSString *)text;

/**
 *  刷新某个tableView的某一组某一行的数组(局部刷新)
 *
 *  @param section         刷新tableView的哪一组的数据
 *  @param indexPathForRow 舒心tableView的哪一行的数据
 *  @param tableView       刷新哪一个TableView
 */
+ (void)partRefreshWithSection:(NSInteger)section indexPathForRow:(NSInteger)indexPathForRow tabelView:(UITableView *)tableView;

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
+ (NSArray<UITableViewRowAction *> *)leftSlideWithDefaultTitle:(NSString *)defaultTitle defaultHandle:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))defaultHandle normalTitle:(NSString *)normalTitle normalHandle:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))normalHandle;

/**
 *  给UIButton添加圆形外边框
 *
 *  @param btn 要添加圆形外边框的UIButton
 */
+ (void)cornerRadiusWithButton:(UIButton *)btn;

/**
 *  监听通知与发布通知
 *
 *  @param object           哪个对象要监听通知
 *  @param selector         监听到通知发布出来后执行的事件
 *  @param senderName       发布通知的名称
 *  @param senderObject     发布通知的对象
 *  @param senderDictionary 通知的内容(字典)
 */
+ (void)notificationWithObject:(id)object selector:(SEL)selector senderName:(NSString *)senderName senderObject:(id)senderObject senderDictionary:(NSDictionary *)senderDictionary;



/**
 *  把一个UIView生成PNG或者JPG格式的图片,保存在指定路径
 *
 *  @param path   图片要保存到的路径
 *  @param type   图片的格式png或者jpg
 *  @param UIView 要转成图片的UIView
 */
+ (void)clipScreenWithPath:(NSString *)path type:(NSString *)type UIView:(UIView *)view;

/**
 *  设置程序图标的提醒数字
 *
 *  @param value 提醒数字的值
 */
+ (void)bageValueWithNumber:(NSInteger)value;

/**
 *  设置联网状态
 *
 *  @param state 是否连接网络
 */
+ (void)connectState:(BOOL)state;

/**
 *  传入一个网站,打开这个网站
 *
 *  @param link 要打开的网站,注意要加上协议头
 */
+ (void)openURL:(NSString *)link;

/**
 *  加载指定标识的Xib控制器
 *
 *  @param name     Xib文件的名称
 *  @param identity Xib文件的标识
 *
 *  @return 返回一个根控制器为指定Xib的UIWindow
 */
+ (id)windowWithNibName:(NSString *)name identity:(NSString *)identity;

/**
 *  加载指定名字的控制器(带导航栏)
 *
 *  @param controller 加载的根控制器
 *
 *  @return 返回一个加载了指定导航控制器的UIWindow
 */
+ (id)windowWithViewController:(UIViewController *)controller;

/**
 *  传入一个根控制器,返回一个window
 *
 *  @param rootViewController 传入一个根控制器
 *
 *  @return 返回一个window
 */
+ (id)windowWithRootViewController:(UIViewController *)rootViewController;

/**
 *  返回一个导航栏被隐藏的导航控制器
 *
 *  @return 返回一个导航栏被隐藏的导航控制器
 */
+ (UINavigationController *)navHideNavigationbar;

/**
 *  将字典转为plist文件保存到沙盒的Caches文件中
 *
 *  @param name      保存的plist文件的文件名称(例如data.plist)
 *  @param dictArray 要保存的数组对象或者字典对象
 */
+ (void)saveToCachesWithName:(NSString *)name dictArray:(id)dictArray;

/**
 *  从沙盒目录下的Caches文件中读取一个数组或者字典
 *
 *  @param name     要读取的文件名(例如:data.plist)
 *  @param dataType 要读取的数据是数组还是字典,数组输入@"aray",字典输入@"dict"
 *
 *  @return 返回一个数组或者一个字典
 */
+ (id)readFromCachesWithName:(NSString *)name dataType:(NSString *)dataType;

/**
 *  将对象保存到沙盒中的Preferences文件中(保存用户的偏好设置)
 *这个方法只适合保存对象类型,若要保存float,BOOL等其他类型需另写
 *  @param object      需要保存的对象(值)
 *  @param objetForKey 保存的对象的键名(键)
 */
+ (void)saveToPreferencesWithobject:(id)object objectForKey:(id)objetForKey;

/**
 *  从沙盒的Preferences文件中通过键读取某个对象的值(读取用户的偏好设置)
 *  这个方法只适合从Preferences文件读取对象
 *  @param objectForKey 需要读取的键
 *
 *  @return 返回一个对象类型
 */
+ (id)readFromPreferencesWithObjectForKey:(id)objectForKey;

/**
 *  modal出一个全屏的UIView
 *
 *  @return 返回一个modal出来的全屏的UIView
 */
+ (UIView *)modalWithView;

/**
 *  给对象添加一个手势
 * @param gestureType swipe表示轻扫手势,longPress表示长按手势,tap表示点按手势,rotation表示旋转手势
 pinch表示捏合手势,pan表示拖动手势
 *  @param direction 轻扫手势的方向,字符串up,left,down,other分别为上下左右
 *  @param target    监听的对象(UIViewController)
 *  @param object    要添加手势的对象
 *  @param event     手势的执行事件
 */
+ (void)gestureWithType:(NSString *)gestureType swipeDirection:(NSString *)direction target:(UIViewController *)target forObject:(id)object event:(SEL)event;

/**
 *  通过HTTP地址,下载一张网络上的图片
 *
 *  @param imageURL 网络上的图片的地址
 *
 *  @return 返回一张网络上的图片
 */
+ (UIImage *)imageWithImageURL:(NSString *)imageURL;

/**
 *  利用pthread创建一个执行某个函数的子线程
 *  注意使用pthread必须导入头文件<pthread.h>
 *  @param pthread_attr_t 线程的属性
 *  @param hanshu         指向函数的指针
 *  @param canshu         函数需要接收的参数
 */
+ (void)pthreadWithPthread_attr_t:(const pthread_attr_t *)pthread_attr_t hanshu:(void *(*)(void *))hanshu canshu:(void *)canshu;

/**
 *  利用NSThread判断当前线程是否是主线程
 *
 *  @return 返回1表示当前线程是主线程,返回0表示子线程
 */
+ (BOOL)isMainThread;

/**
 *  利用NSThread开启一个子线程,设置name和threadPriority优先级
 *
 *  @param selector 线程执行的方法
 *  @param target   目标对象,一般是self控制器
 *  @param object   selector方法所带的参数
 *  @param name     子线程的名字
 *  @param priority 子线程的优先级(0-1),默认写0.5
 */
+ (void)NSThreadWithSelector:(SEL)selector target:(id)target object:(id)object name:(NSString *)name priority:(CGFloat)priority;

/**
 *  创建同步函数/异步函数+并发/串行的线程
 *  或者创建同步函数/异步函数+主队列的线程
 *
 *  @param attr     DISPATCH_QUEUE_CONCURRENT表示并发,DISPATCH_QUEUE_SERIAL表示串行,nil或者0表示主队列
 *  @param identity 标签
 *  @param type     表示同步函数或者异步函数,字符串async表示异步函数,其他字符串都表示同步函数
 *  @param block    线程执行的代码块
 */
+ (void)dispatchWithAttr_t:(dispatch_queue_attr_t)attr identity:(const char *)identity type:(NSString *)type block:(dispatch_block_t)block;

/**
 *  将某个文件夹下的所有文件剪切到另外一个文件中(常规操作)
 *
 *  @param fromPath 剪切的文件夹的路径
 *  @param toPath   剪切的东西放到的那个文件夹的路径
 */
+ (void)cutFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 *  将某个文件夹下的所有文件剪切到另外一个文件中(利用GCD的迭代操作,系统自动分配线程来进行操作)
 *
 *  @param fromPath 剪切的文件夹的路径
 *  @param toPath   剪切的东西放到的那个文件夹的路径
 */
+ (void)cutWithGCDFormPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 *  传入2张图片,将两个图片组合在一起,然后返回这个图片
 *  (图片合成的模式是第一张图片在上半部分,第二张图片在下半部分
 *  @param imageOne 要合成的第一张图片
 *  @param imageTwo 要合成的第二张图片
 *  @param size     合成后的图片的大小
 *
 *  @return 合成后的图片(UIImage类型)
 */
+ (UIImage *)composeWithImageOne:(UIImage *)imageOne ImageTwo:(UIImage *)imageTwo size:(CGSize)size;

/**
 *  利用队列组合成两张图片
 *
 *  @param blockOne   第一个子线程的代码块(主要是从网络上加载一张图片)
 *  @param blockTwo   第二个子线程的代码块(主要是从网络上加载第二张图片)
 *  @param blockThree 第三个子线程的代码块(拦截操作,在子线程1和子线程2完成后的操作)
 */
+ (void)dispatch_groupWithBlockOne:(dispatch_block_t)blockOne blockTwo:(dispatch_block_t)blockTwo blockThree:(dispatch_block_t)blockThree;

/**
 *  传入NSBlockOperation类型的数组,利用NSOperation的依赖按数组的顺序执行NSBlockOperation
 *
 *  @param NSBlockOperations 传入NSBlockOperation的数组
 */
+ (void)NSBlockOperations:(NSArray *)NSBlockOperations;

/**
 *  发送一个常规的post请求
 *
 *  @param URL       请求路径
 *  @param Uer_Agent 设置请求头细腻
 *  @param HTTPBody  设置请求体信息
 *  @param block     发送请求执行的代码块
 */
+ (void)postWithURL:(NSString *)URL User_Agent:(NSString *)Uer_Agent HTTPBody:(NSString *)HTTPBody
              block:(void (^)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError))block;

/**
 *  发送一个get请求
 *
 *  @param URL       设置请求路径
 *  @param translate 请求路径是否需要转码,1为需要转码,0为不需要
 *  @param block     设置发送请求执行的代码块
 */
+ (void)getWithURL:(NSString *)URL translate:(BOOL)translate block:(void (^)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError))block;

/**
 *  JSON数据转换为OC对象
 *
 *  @param json 要转换的JSON数据
 *
 *  @return 转换后的OC对象
 */
+ (id)objectFromJsonWithJson:(NSData *)json;

/**
 *  把OC对象转换为JSON数据
 *
 *  @param object 要转换的OC对象
 *
 *  @return 转换后的JSON数据(二进制数据)
 */
+ (NSData *)jsonFromOCWithObject:(id)object;

/**
 *  传入一个视频URL,播放URL的视频
 *  注意使用这个功能必须导入框架<MediaPlayer/MediaPlayer.h>
 *  @param url 视频的URL地址
 *  @param viewController 一般是self
 */
+ (void)videoWithURL:(NSURL *)url viewController:(UIViewController *)viewController;

/**
 *  图片不要渲染
 *
 *  @param name 图片名字
 *
 *  @return 返回一张不要渲染的图片
 */
+ (UIImage *)imageWithRenderOriginalName:(NSString *)name;

/**
 *  设置拉伸图片使图片不变形
 *
 *  @param image 需要拉伸的图片
 */
+ (UIImage *)stretchableImage:(UIImage *)image;

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *
 *  @return 返回文件夹尺寸
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totleSize))completion;


/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
@end
