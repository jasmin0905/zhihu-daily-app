//
//  ProfileViewController.m
//  zhihu-daily-app
//
//  实现个人页面中心控制器功能
//

#import "ProfileViewController.h"
#import "ProfileView.h"//个人页面视图
#import "UserModel.h"//复用
#import "LoginViewController.h"//导入登录页面控制器，实现跳转

@interface ProfileViewController ()
@property (nonatomic, strong) ProfileView *profileView;
//点击手势，未登录时点击屏幕可跳转至登录页
@property (nonatomic, strong) UITapGestureRecognizer *loginTap;
- (void)setupUI;
- (void)bindData;
- (void)clickLogoutButton;
- (void)goToLogin;


@end

@implementation ProfileViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //页面UI搭建
    [self setupUI];
    //用户数据绑定到页面,“页面显示什么数据”
    [self bindData];
}
#pragma mark - 初始化UI界面
- (void)setupUI {
    //导航栏标题
    self.title = @"我的";
    //页面背景色，适应深浅色模式
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    //创建ProfileView,用来复用，节约代码
    self.profileView = [[ProfileView alloc] initWithFrame:self.view.bounds];
    //将ProfileView添加到当前控制器view上
    [self.view addSubview:self.profileView];
    //添加点击事件用于退出按钮
    [self.profileView.logoutButton addTarget:self
                                      action:@selector(clickLogoutButton)
                            forControlEvents:UIControlEventTouchUpInside];
    //初始化点击手势
    self.loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLogin)];
    //添加手势至页面
    [self.profileView addGestureRecognizer:self.loginTap];
}
#pragma mark - 绑定用户数据到界面
/**
 根据登录状态，显示不同数据
 已登录：显示用户名和退出按钮
 未登录：显示“未登录”，并隐藏退出按钮
 */
- (void)bindData {
    //获取单例用户对象,页面对象信息统一
    UserModel *userModel = [UserModel sharedModel];
    //判断是否登录
    if(userModel.isLoggedIn) {
        //显示用户名，有值显示，无值显示“用户”
        self.profileView.usernameLabel.text = userModel.username ?:@"用户";
        //显示退出登录按钮
        self.profileView.logoutButton.hidden = NO;
        //禁用点击手势
        self.loginTap.enabled = NO;
    }
    else {
        self.profileView.usernameLabel.text = @"未登录";
        //隐藏退出按钮
        self.profileView.logoutButton.hidden = YES;
        //可用点击手势
        self.loginTap.enabled = YES;
    }
}
#pragma mark - 按钮点击事件
//退出登录
- (void)clickLogoutButton {
    //创建弹窗对象
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确定要退出登录吗?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    //创建取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel//加粗“取消”蓝色，置于弹窗底部
                                                         handler:nil];//仅关闭弹窗，无额外逻辑
    //创建确定按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:(UIAlertActionStyleDestructive)//红色字体，警示
                                                     handler:^(UIAlertAction * _Nonnull action) {
        //调用UserModel登出方法，清空登录状态，清除用户名
        [[UserModel sharedModel] logout];
        //重绑数据，刷新页面为未登录状态
        [self bindData];
        //弹出“已退出登录；提示弹窗
        UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                          message:@"已退出登录"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault//一般状态，无强调作用
                                                         handler:nil];
        [tipAlert addAction:okAction];
        //将提示弹窗显示在屏幕上
        [self presentViewController:tipAlert
                           animated:YES//淡入动画
                         completion:nil];
        
    }];
    //添加按钮至弹窗
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    //显示弹窗，使用户必须点完“确定”或“取消”后才能退出弹窗，回到页面
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}
//处理未登录时点击页面跳转逻辑，使跳转到登录页面
- (void)goToLogin {
    //创建登录页面控制器实例
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    //登录页面导航控制器，用于返回个人中心页面
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //弹出登录页面
    [self presentViewController:nav animated:YES completion:nil];
}


@end

