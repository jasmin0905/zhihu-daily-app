//
//  AppDelegate.m
//  zhihu-daily-app
//
//  实现AppDelegate.h的方法，配置主窗口和根视图控制器
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

//应用启动完成后可调用，初始化窗口和根视图控制器
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建UIWindow
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //设置UIWindow的背景颜色
    self.window.backgroundColor = [UIColor whiteColor];
    /**
     首页
     */
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    //将首页控制器包装进导航控制器，实现页面跳转
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    //为导航控制器设置底部TabBar显示，标题“首页”
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil selectedImage:nil];
    /**
     构建个人中心模块，初始化个人中心视图控制器
     */
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    // 将个人中心控制器包装进导航控制器，保证页面跳转能力与首页一致
         UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
         // 为导航控制器设置底部TabBar显示样式：标题为"我的"
         profileNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:nil selectedImage:nil];
         //组装底部TabBar控制器
         // 初始化UITabBarController，作为应用的根容器，管理多个子模块切换
         UITabBarController *tabBarVC = [[UITabBarController alloc] init];
         // 将首页和个人中心的导航控制器数组，赋值给TabBar的viewControllers
         // 数组顺序决定了TabBar按钮的显示顺序：第0位是"首页"，第1位是"我的"
         tabBarVC.viewControllers = @[homeNav, profileNav];
         // 将TabBar控制器设置为窗口的根视图控制器，整个应用的UI结构由此展开
         self.window.rootViewController = tabBarVC;
         // 让窗口成为应用的关键窗口并可见，应用正式展示UI
         [self.window makeKeyAndVisible];
         // 返回YES表示应用启动成功
         return YES;
    
}







@end
