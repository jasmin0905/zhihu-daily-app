//
//  AppDelegate.m
//  zhihu-daily-app
//
//  实现AppDelegate.h的方法，配置主窗口和根视图控制器
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//应用启动完成后可调用，初始化窗口和根视图控制器
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建UIWindow
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //设置UIWindow的背景颜色
    self.window.backgroundColor = [UIColor whiteColor];
    //创建homeVC
    ViewController *homeVC = [[ViewController alloc] init];
    //创建导航控制器，以首页为根控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    //将导航控制器设置为window的根视图控制器
    self.window.rootViewController = nav;
    //让window成为keyWindow并可见
    [self.window makeKeyAndVisible];
    
    return YES;
}







@end
