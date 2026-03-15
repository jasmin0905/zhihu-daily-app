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
#import <AFNetworking/AFNetworking.h>

//匿名分类
@interface DetailViewController ()
<WKNavigationDelegate>
//网页视图
@property (nonatomic, strong) WKWebView *webView;
// 点赞按钮
@property (nonatomic, strong) UIButton *likeButton;
// 收藏按钮
@property (nonatomic, strong) UIButton *collectButton;
// 点赞数目标签
@property (nonatomic, strong) UILabel *likeCountLabel;
// 是否已点赞
@property (nonatomic, assign) BOOL isLiked;
// 是否已收藏
@property (nonatomic, assign) BOOL isCollected;
// 点赞数量
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic ,strong) UILabel *contentLabel;
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
    [self fetchNewsDetail];
}

/**
 *  初始化本地点赞/收藏状态
 *  从 NSUserDefaults 中读取当前新闻对应的点赞/收藏状态
 */
- (void)initLocalState {
    //判断news是否存在，为空直接返回
    if (!self.news) return;
    // 构造点赞状态的 key
    NSString *likeKey = [NSString stringWithFormat:@"liked_%@", self.news.newsID];
    // 读取本地存储的点赞状态，默认 NO
    self.isLiked = [[NSUserDefaults standardUserDefaults] boolForKey:likeKey];
    
    // 构造收藏状态的 key
    NSString *collectKey = [NSString stringWithFormat:@"collected_%@", self.news.newsID];
    // 读取本地存储的收藏状态，默认 NO
    self.isCollected = [[NSUserDefaults standardUserDefaults] boolForKey:collectKey];
    
    // 读取点赞数量
    NSString *countKey = [NSString stringWithFormat:@"likeCount_%@", self.news.newsID];
    NSInteger likeCount = [[NSUserDefaults standardUserDefaults] integerForKey:countKey];
    //如果本地没有点赞数，或为负数，强制设为0
    if (likeCount<0) {
        likeCount=0;
    }
    self.likeCount = likeCount;
}
/**
 导入文本
 */

// 请求新闻详情，用 webView 加载 HTML 正文
- (void)fetchNewsDetail {
    if (!self.news) return;
    
    NSString *url = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/%@", self.news.newsID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 知乎日报正文是 HTML 格式，字段是 body
        NSString *htmlBody = responseObject[@"body"];
        self.news.content = htmlBody;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 🔥 加载 HTML 正文，不是网页链接！
            [self.webView loadHTMLString:htmlBody baseURL:nil];
            self.webView.hidden = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求新闻详情失败：%@", error);
    }];
}

#pragma mark - 按钮点击事件
/**
 *  点赞按钮点击事件
 */
- (void)likeButtonTapped:(UIButton *)button {
    // 切换点赞/取消点赞状态
    self.isLiked = !self.isLiked;
    // 修改点赞数量
    self.likeCount = self.isLiked ? self.likeCount + 1 : self.likeCount - 1;
    
    // 保存到本地：将新的点赞状态写入 NSUserDefaults
    NSString *likeKey = [NSString stringWithFormat:@"liked_%@", self.news.newsID];
    [[NSUserDefaults standardUserDefaults] setBool:self.isLiked forKey:likeKey];
    
    // 保存数量
    NSString *countKey = [NSString stringWithFormat:@"likeCount_%@", self.news.newsID];
    [[NSUserDefaults standardUserDefaults] setInteger:self.likeCount forKey:countKey];
    
    // 更新UI
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", self.likeCount];
    [self updateLikeButtonState];
    
    //弹出提示：告诉用户操作结果
    NSString *tip = self.isLiked ? @"点赞成功" : @"取消点赞";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText; // 纯文本模式，不需要图标
    hud.label.text = tip;
    [hud hideAnimated:YES afterDelay:1.5]; // 1.5秒后自动消失
}
/**
 *  搭建页面UI
 */
- (void)setupUI {
    // 页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 加载新闻的网页链接
    if (self.news.url && self.news.url.length > 0) {
        // 将新闻的url字符串转成NSURL对象
       // NSURL *url = [NSURL URLWithString:self.news.url];
        // 创建请求对象
       // NSURLRequest *request = [NSURLRequest requestWithURL:url];
        // 加载网页
       // [self.webView loadRequest:request];
    }
    else {
        //如果没有url，隐藏webView.避免空白
        self.webView.hidden = YES;
        // 新闻图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width-40, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        if (self.news.imageURL) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.news.imageURL]];
        }
        [self.view addSubview:imageView];
        
        // 新闻标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, self.view.bounds.size.width-40, 40)];
        titleLabel.text = self.news.title;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [UIColor blackColor];
        [self.view addSubview:titleLabel];
    }
    
    
    /**
     创建，配置点赞按钮
     */
    // 初始化点赞按钮，设置位置：屏幕底部偏左，宽60、高40
    UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.bounds.size.height - 80, 60, 40)];
    // 设置按钮正常状态下的显示文字
    [likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
    // 设置按钮文字颜色为黑色
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 将按钮添加到页面
    [self.view addSubview:likeBtn];
    // 赋值给成员变量，方便后续方法访问
    _likeButton = likeBtn;
    
    /**
     创建，配置收藏按钮
     */
    // 初始化收藏按钮，设置位置：点赞按钮右侧，宽60、高40
    UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, self.view.bounds.size.height - 80, 60, 40)];
    // 设置按钮正常状态下的显示文字
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    // 设置按钮文字颜色为黑色
    [collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 将按钮添加到页面
    [self.view addSubview:collectBtn];
    // 赋值给成员变量，方便后续方法访问
    _collectButton = collectBtn;
    
    // 点赞数目标签
    UILabel *likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, self.view.bounds.size.height - 120, 60, 40)];
    likeCountLabel.text = [NSString stringWithFormat:@"%ld", self.likeCount];
    likeCountLabel.textColor = [UIColor blackColor];
    [self.view addSubview:likeCountLabel];
    _likeCountLabel = likeCountLabel;
    
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
    // 初始化并添加网页视图（WKWebView），加载新闻内容
    // 创建网页视图：位置在标题下方，不遮挡图片和标题
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(20, 370, self.view.bounds.size.width-40, self.view.bounds.size.height - 450)];
    // 设置代理（处理网页加载状态）
    self.webView.navigationDelegate = self;
    // 将网页视图添加到页面上（最后添加，层级最高）
    [self.view addSubview:self.webView];
}

/**
 *  收藏按钮点击事件
 */
- (void)collectButtonTapped:(UIButton *)button {
    //切换收藏/取消收藏状态
    self.isCollected = !self.isCollected;
    
    // 保存到本地：将新的收藏状态写入 NSUserDefaults
    NSString *collectKey = [NSString stringWithFormat:@"collected_%@", self.news.newsID];
    [[NSUserDefaults standardUserDefaults] setBool:self.isCollected forKey:collectKey];
    
    // 更新UI
    [self updateCollectButtonState];
    
    // 弹出提示：告诉用户操作结果
    NSString *tip = self.isCollected ? @"收藏成功" : @"取消收藏";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tip;
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark - 更新按钮显示状态
/**
 *  根据 isLiked 决定点赞按钮显示 已点赞/未点赞 图片
 */
- (void)updateLikeButtonState {
    if (self.isLiked) {
        // 已点赞：变红
        [self.likeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        // 未点赞：变黑
        [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

/**
 *  根据 isCollected 决定收藏按钮显示 已收藏/未收藏 图片
 */
- (void)updateCollectButtonState {
    if (self.isCollected) {
        // 已收藏：变蓝
        [self.collectButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        // 未收藏：变黑
        [self.collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

@end
