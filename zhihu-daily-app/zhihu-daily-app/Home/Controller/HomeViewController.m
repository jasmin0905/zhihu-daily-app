//
//  HomeViewController.m
//  zhihu-daily-app
//
//  首页控制器实现，包含Banner轮播
//

#import "HomeViewController.h"
#import "NewsCell.h"//复用
#import "NetworkManager.h"//复用
#import "News.h"//复用
#import "DetailViewController.h"
#import <SDWebImage/SDWebImage.h>//复用图片加载库
#import <MJRefresh/MJRefresh.h>//下拉刷新
//匿名分类
@interface HomeViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate>
//新闻列表
@property (nonatomic, strong) UICollectionView *collectionView;
//顶部轮播图
@property (nonatomic, strong) UIScrollView *bannerScrollView;
//轮播图页码
@property (nonatomic, strong) UIPageControl *pageControl;
//新闻列表数据
@property (nonatomic ,strong) NSArray<News *> *newsList;
//轮播图数据
@property (nonatomic ,strong) NSArray<News *> *topStories;
//声明网络请求方法
- (void)fetchHomeData;
//声明构建Banner方法
- (void)setupBanner;

@end


@implementation HomeViewController
#pragma mark - 页面加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    //页面背景
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏标题
    self.title = @"知乎日报";
    //添加轮播图
    [self.view addSubview:self.bannerScrollView];
    //添加新闻列表
    [self.view addSubview:self.collectionView];
    //请求网络数据
    [self fetchHomeData];
}
#pragma mark - 布局子控件,bounds发生变化时用
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //获取屏宽
    CGFloat screenW = self.view.bounds.size.width;
    //定义轮播图高度
    CGFloat bannerH = 200;
    //设置轮播图位置，大小
    self.bannerScrollView.frame = CGRectMake(0, 0, screenW, bannerH);
    //设置新闻列表位置，大小
    //顶部紧贴轮播图底部，宽度all,高度占屏幕剩余部分
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.bannerScrollView.frame), screenW, self.view.bounds.size.height - CGRectGetMaxY(self.bannerScrollView.frame));
}
#pragma mark - 网络请求，获取首页数据
- (void)fetchHomeData {
    //调用封装好的NetworkManager
    [[NetworkManager sharedManager] fetchLatestNewsWithSuccess:^(id responseObject) {
        //网络请求成功，responseObject返回JSON数据，被解析为NSDictionary
        NSDictionary *data = responseObject;
        //创建一个可变数组，存储解析后的News对象
        NSMutableArray *topArray = [NSMutableArray array];
        //遍历“top_stories"数组（JSON)
        for (NSDictionary *dict in data[@"top_stories"]) {
                     // 创建一个 News 对象
                     News *news = [[News alloc] init];
                     // 从字典中取出对应字段，赋值给 News 对象的属性
                     news.newsID = dict[@"id"];
                     news.title = dict[@"title"];
                     news.imageURL = dict[@"image"];
                     // 将 News 对象添加到数组中
                     [topArray addObject:news];
                 }
                 // 将解析好的轮播图数据赋值给私有属性
                 self.topStories = topArray;
                 // 调用方法，新数据构建轮播图 UI
                 [self setupBanner];
        //新闻列表数据
        NSMutableArray *listArray = [NSMutableArray array];
        //遍历“stories"数组(JSON)
        for (NSDictionary *dict in data[@"stories"]) {
                     News *news = [[News alloc] init];
                     news.newsID = dict[@"id"];
                     news.title = dict[@"title"];
                     news.imageURL = dict[@"images"][0]; // 取第一个
                     [listArray addObject:news];
                 }
                 // 将解析好的列表数据赋值给私有属性
                 self.newsList = listArray;
                 // 刷新列表，让新数据显示出来
                 [self.collectionView reloadData];
             } failure:^(NSError *error) {
                 // 网络请求失败，打印错误信息，方便调试
                 NSLog(@"首页数据请求失败：%@", error);
             }];
         }
#pragma mark - 懒加载，新闻列表
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // 创建流水布局对象
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 获取屏幕宽
        CGFloat w = self.view.bounds.size.width;
        // 设置每个 cell 的尺寸：宽度全屏，高度 = 图片 16:9 + 标题区域 80 点
        layout.itemSize = CGSizeMake(w, w * 9 / 16 + 80);
        // 设置 cell 之间的行间距为 0
        layout.minimumLineSpacing = 0;
        // 设置 cell 之间的列间距为 0
        layout.minimumInteritemSpacing = 0;

        // 2. 创建 UICollectionView 对象
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        // 设置背景色为白色
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 提供数据
        _collectionView.dataSource = self;
        // 处理交互
        _collectionView.delegate = self;
        // 注册自定义 NewsCell，用于列表复用
        [_collectionView registerClass:[NewsCell class] forCellWithReuseIdentifier:@"NewsCellID"];

        // 下拉刷新
        __weak typeof(self) weakSelf = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf fetchHomeData];
            [weakSelf.collectionView.mj_header endRefreshing];
        }];
    }
    return _collectionView;
}
#pragma mark - 懒加载，轮播图
- (UIScrollView *)bannerScrollView {
    if(!_bannerScrollView) {
        _bannerScrollView = [[UIScrollView alloc]init];
        //分页模式，轮播页滚动
        _bannerScrollView.pagingEnabled = YES;
        //隐藏水平滚动条
        _bannerScrollView.showsHorizontalScrollIndicator = NO;
        //设置代理为控制器，监听滚动事件，更新页码
        _bannerScrollView.delegate = self;
    }
    return  _bannerScrollView;
}
#pragma mark - 懒加载，页码指示器
- (UIPageControl *)pageControl {
    if(!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        //当前页指示器颜色为白
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        //其它页指示器颜色为浅灰
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return  _pageControl;
}
#pragma mark - 构建轮播图内容
/**
 一页包括一张图片和一个新闻标题
 */
- (void)setupBanner {
    //没有轮播图数据可直接返回
    if (self.topStories.count ==0)
        return;;
    //获取轮播图宽，高
    CGFloat w = self.bannerScrollView.bounds.size.width;
    CGFloat h = self.bannerScrollView.bounds.size.height;
    //设置轮播图滚动范围：宽度=单页宽度*页数，高度固定
    self.bannerScrollView.contentSize = CGSizeMake(w * self.topStories.count, h);
    //循环创建每一页
    for (NSInteger i = 0; i < self.topStories.count; i++) {
             // 获取当前页对应的 News 对象
             News *news = self.topStories[i];
             //  创建图片视图
             UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
             // 设置图片填充模式：按比例填充，超出部分裁剪，保证图片不变形
             iv.contentMode = UIViewContentModeScaleAspectFill;
             // 开启裁剪，避免图片超出视图边界
             iv.clipsToBounds = YES;
             // 使用 SDWebImage 异步加载网络图片
             [iv sd_setImageWithURL:[NSURL URLWithString:news.imageURL]];
             // 将图片视图添加到轮播图容器中
             [self.bannerScrollView addSubview:iv];
             // 创建标题标签
             UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, h - 60, w - 32, 40)];
             // 设置标题文字
             titleLabel.text = news.title;
             // 设置文字颜色为白色，在图片上更清晰
             titleLabel.textColor = [UIColor whiteColor];
             // 设置字体为粗体，字号 17
             titleLabel.font = [UIFont boldSystemFontOfSize:17];
             // 允许文字换行，最多显示 2 行
             titleLabel.numberOfLines = 2;
             // 将标题标签添加到图片视图上（作为子视图）
             [iv addSubview:titleLabel];
         }
         //  设置页码指示器
         // 总页数 = 轮播图数据的个数
         self.pageControl.numberOfPages = self.topStories.count;
         // 设置指示器的位置：底部居中
         self.pageControl.frame = CGRectMake(0, h - 30, w, 20);
         // 将指示器添加到轮播图容器中
         [self.bannerScrollView addSubview:self.pageControl];
     }
#pragma mark - 滚动时更新页码
/**
 UIScrollView滚动时，系统可调用此方法根据偏移量计算当前页码，并实时更新pageControl
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //先忽略列表滚动
    if (scrollView == self.bannerScrollView) {
        //计算页码：偏移量/单页宽度
        NSInteger page = scrollView.contentOffset.x/scrollView.bounds.size.width;
        //更新页码指示器
        self.pageControl.currentPage = page;
    }
}
#pragma mark - 实现数据源的方法
/**
 返回每个分区中item个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newsList.count;
}
//返回指定位置的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     // 从复用池中取出我们之前注册的 NewsCell
     NewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsCellID" forIndexPath:indexPath];
     // 获取当前位置对应的 News 对象
     News *news = self.newsList[indexPath.item];
     // 给 cell 赋值，cell 内部的 setNews: 方法会自动刷新 UI
     cell.news = news;
     return cell;
 }
#pragma mark -处理cell点击问题
/**
 点击列表中的cell时将会调用这个方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     // 获取被点击 cell 对应的 News 对象
     News *news = self.newsList[indexPath.item];
     // 创建项目中专门的详情页控制器
     DetailViewController *detailVC = [[DetailViewController alloc] init];
     //传递新闻数据
     detailVC.news = news;
     // 设置详情页的标题为新闻标题
     detailVC.title = news.title;
     // 设置详情页的背景色为白色
     detailVC.view.backgroundColor = [UIColor whiteColor];
     // 使用导航栏 push 到详情页
     [self.navigationController pushViewController:detailVC animated:YES];
 }
@end
