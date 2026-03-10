//
//  DetailViewController.m
//  zhihu-daily-app
//
//  实现新闻详情页功能
//

#import "DetailViewController.h"
#import "News.h"
#import <WebKit/WebKit.h>//网页视图
#import <SDWebImage/SDWebImage.h>//图片加载
#import <MBProgressHUD/MBProgressHUD.h>//提示框
//匿名分类
@interface DetailViewController ()
<WKNavigationDelegate>
//网页视图
@property (nonatomic, strong) WKWebView *webView;
// 点赞按钮
@property (nonatomic, strong) UIButton *likeButton;
// 收藏按钮
@property (nonatomic, strong) UIButton *collectButton;
// 是否已点赞
@property (nonatomic, assign) BOOL isLiked;
// 是否已收藏
@property (nonatomic, assign) BOOL isCollected;
// 点赞数量
@property (nonatomic, assign) NSInteger likeCount;
@end
@implementation DetailViewController
#pragma mark - 页面生命周期
/**
 *  页面加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  读取本地存储的点赞/收藏状态，恢复用户上次操作
    [self initLocalState];
    
    // 搭建页面UI
    [self setupUI];
}
/**
 *  初始化本地点赞/收藏状态
 *  从 NSUserDefaults 中读取当前新闻对应的点赞/收藏状态
 */
- (void)initLocalState {
    // 构造点赞状态的 key
    NSString *likeKey = [NSString stringWithFormat:@"liked_%@", self.news.newsID];
    // 读取本地存储的点赞状态，默认 NO
    self.isLiked = [[NSUserDefaults standardUserDefaults] boolForKey:likeKey];
    
    // 构造收藏状态的 key
    NSString *collectKey = [NSString stringWithFormat:@"collected_%@", self.news.newsID];
    // 读取本地存储的收藏状态，默认 NO
    self.isCollected = [[NSUserDefaults standardUserDefaults] boolForKey:collectKey];
}
/**
 *  搭建页面UI
 */
- (void)setupUI {
    
    // 绑定点赞按钮的点击事件
    [self.likeButton addTarget:self
                        action:@selector(likeButtonTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    
    // 绑定收藏按钮的点击事件
    [self.collectButton addTarget:self
                           action:@selector(collectButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    // 页面刚加载时,更新按钮图片
    [self updateLikeButtonState];
    [self updateCollectButtonState];
}
#pragma mark - 按钮点击事件
/**
 *  点赞按钮点击事件
 */
- (void)likeButtonTapped:(UIButton *)button {
    // 切换点赞/取消点赞状态
    self.isLiked = !self.isLiked;
    
    // 2. 保存到本地：将新的点赞状态写入 NSUserDefaults
    NSString *likeKey = [NSString stringWithFormat:@"liked_%@", self.news.newsID];
    [[NSUserDefaults standardUserDefaults] setBool:self.isLiked forKey:likeKey];
    
    // 更新UI：根据新的状态切换按钮图片
    [self updateLikeButtonState];
    
    //弹出提示：告诉用户操作结果
    NSString *tip = self.isLiked ? @"点赞成功" : @"取消点赞";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText; // 纯文本模式，不需要图标
    hud.label.text = tip;
    [hud hideAnimated:YES afterDelay:1.5]; // 1.5秒后自动消失
}
/**
 *  收藏按钮点击事件
 */
- (void)collectButtonTapped:(UIButton *)button {
    //切换收藏/取消收藏状态
    self.isCollected = !self.isCollected;
    
    // 2. 保存到本地：将新的收藏状态写入 NSUserDefaults
    NSString *collectKey = [NSString stringWithFormat:@"collected_%@", self.news.newsID];
    [[NSUserDefaults standardUserDefaults] setBool:self.isCollected forKey:collectKey];
    
    // 3. 更新UI：根据新的状态切换按钮图片
    [self updateCollectButtonState];
    
    // 4. 弹出提示：告诉用户操作结果
    NSString *tip = self.isCollected ? @"收藏成功" : @"取消收藏";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tip;
    [hud hideAnimated:YES afterDelay:1.5];
}
#pragma mark - 更新按钮显示状态
/**
 *  根据 isLiked 决定点赞按钮显示 已点赞/未点赞 图片
 *  当 isLiked 为 YES 时，显示“已点赞”图标；为 NO 时，显示“未点赞”图标
 */
- (void)updateLikeButtonState {
    if (self.isLiked) {
        // 已点赞：设置为高亮/选中状态的图标
        [self.likeButton setImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
    } else {
        // 未点赞：设置为默认/未选中状态的图标
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    }
}
/**
 *  根据 isCollected 决定收藏按钮显示 已收藏/未收藏 图片
 *  当 isCollected 为 YES 时，显示“已收藏”图标；为 NO 时，显示“未收藏”图标
 */
- (void)updateCollectButtonState {
    if (self.isCollected) {
        // 已收藏：设置为高亮/选中状态的图标
        [self.collectButton setImage:[UIImage imageNamed:@"icon_collected"] forState:UIControlStateNormal];
    } else {
        // 未收藏：设置为默认/未选中状态的图标
        [self.collectButton setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    }
}

@end
