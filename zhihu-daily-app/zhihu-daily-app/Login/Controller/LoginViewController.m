//
//  LoginViewController.m
//  zhihu-daily-app
//
//  实现登录页面控制器的功能
//

#import "LoginViewController.h"
#import "UserModel.h"//管理登录状态
#import "LoginView.h"//登录页面视图

@interface LoginViewController ()
//访问UI控件
@property (nonatomic, strong) LoginView *loginView;
//关闭当前页面
- (void)dismissSelf;
//点击登录按钮
- (void)clickLoginButton;
@end


@implementation LoginViewController

#pragma mark - 页面关闭
/**
 关闭当前登录页面
 */
- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 登录按钮点击
- (void)clickLoginButton {
    NSString *username = self.loginView.usernameField.text;
    if (username.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        //添加按钮用来关闭提示框
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        //添加按钮至弹窗
        [alert addAction:confirmAction];
        //展示弹窗
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }
    //调用UserModel实现伪登录
    [[UserModel sharedModel] login];
    //创建登录成功弹窗
    UIAlertController *succesAlert = [UIAlertController alertControllerWithTitle:@"登录成功" message:@"欢迎回来" preferredStyle:UIAlertControllerStyleAlert];
    //创建确定按钮，点击后关闭登录页面
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissSelf];
    }];
    //将按钮添加到成功弹窗中
    [succesAlert addAction:confirmAction];
    //展示弹窗
    [self presentViewController:succesAlert animated:YES completion:nil];
}
#pragma mark - Lifecycle
/**
 视图加载时调用。初始化UI布局
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark -UI初始化
/**
 初始化部分UI：导航栏，绑定按钮等
 */
- (void)setupUI {
    //设置导航栏标题
    self.title = @"登录";
    //添加按钮用于关闭登录页面
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissSelf)];
    //创建LoginView，添加控制器视图
    self.loginView = [[LoginView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.loginView];
        //登录按钮绑定点击事件
        [self.loginView.loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    
    
}





@end
