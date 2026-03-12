//
//  UserModel.m
//  zhihu-daily-app
//
//  实现UserModel的方法,登录状态持久化
//

#import "UserModel.h"

@implementation UserModel
/**
 获取单例对象
 */
+ (instancetype)sharedModel {
    static UserModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserModel alloc]init];
    });
    return  instance;
}
/**
 获取当前登录状态
 借读取NSUserDefaults中的键值判断（isLoggedIn)
 */
- (BOOL)isLoggedIn {
    //返回布尔值，键不存在则返回NO
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];
}
/**
 伪登录
 登录状态设置为YES并保存
 */
- (void)login {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isLoggedIn"];//设置登录状态为YES
    [defaults synchronize];//同步数据到磁盘
}
/**
 退出登录
 */
- (void)logout {
    //移除指定键的值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"isLoggedIn"];//移除指定键值对，读取isLoggedIn时可返回NO
    [defaults synchronize];
}

@end
