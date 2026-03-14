//
//  UserModel.h
//  zhihu-daily-app
//
//  数据模型，管理登录状态
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
///当前是否已登录
@property (nonatomic, assign, readonly) BOOL isLoggedIn;
//用户名属性
@property (nonatomic, copy)NSString *username;
///获取单例
+ (instancetype)sharedModel;
///登录（伪）
- (void)login;
///退出登录
-(void)logout;


@end

NS_ASSUME_NONNULL_END
