//
//  LoginView.h
//  zhihu-daily-app
//
//  登录页面视图
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginView : UIView
@property (nonatomic, strong) UILabel *tipLabel;
//用户名输入框，用于伪登录
@property (nonatomic, strong) UITextField *usernameField;
//登录按钮
@property (nonatomic, strong) UIButton *loginButton;

@end

NS_ASSUME_NONNULL_END
