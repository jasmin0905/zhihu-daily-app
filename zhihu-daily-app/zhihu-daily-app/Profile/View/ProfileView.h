//
//  ProfileView.h
//  zhihu-daily-app
//
//  个人页面视图，展示用户信息与操作按钮
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileView : UIView
//头像视图
@property (nonatomic ,strong) UIImageView *avatarImageView;
//用户名输入框
@property (nonatomic, strong) UILabel *usernameLabel;
//退出登录按钮
@property (nonatomic, strong) UIButton *logoutButton;

@end

NS_ASSUME_NONNULL_END
