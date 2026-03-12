//
//  LoginView.m
//  zhihu-daily-app
//
//  实现页面视图
//

#import "LoginView.h"
#import <Masonry/Masonry.h>

@interface LoginView ()
- (void)setupUI;
@end

@implementation LoginView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark -UI布局配置
/**
 视图加载完成时调用，初始化UI布局
 */
- (void)setupUI {
    //设置背景色为系统背景色，并能自动适配黑暗模式
    self.backgroundColor = [UIColor systemBackgroundColor];
    //添加UI组件到视图层，并设置懒加载触发方法
    [self addSubview:self.tipLabel];
    [self addSubview:self.usernameField];
    [self addSubview:self.loginButton];
    //用Masonry设置约束
    //Label约束：距顶部120，左右边距24
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(120);
        make.left.equalTo(self.mas_left).offset(24);
        make.right.equalTo(self.mas_right).offset(-24);
    }];
    //用户名输入框约束：在Label下方20，左右同Label,高48
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.tipLabel);
        make.height.equalTo(@48);
    }];
    //登录按钮约束：输入框下方32，左右同输入框，高48
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).offset(32);
        make.left.right.equalTo(self.usernameField);
        make.height.equalTo(@48);
    }];
    }
#pragma mark -懒加载
/**
 提示标签，第一次访问时创建，节省内存
 */
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"请输入用户名";
        _tipLabel.font = [UIFont systemFontOfSize:16
                                         weight:UIFontWeightMedium];
        _tipLabel.textColor = [UIColor labelColor];//自动适配黑暗模式
    }
    return  _tipLabel;
}
/**
 用户名输入框
 */
- (UITextField *)usernameField {
    if (!_usernameField) {
        _usernameField = [[UITextField alloc]init];
        _usernameField.placeholder = @"请输入你的用户名";
        _usernameField.borderStyle = UITextBorderStyleRoundedRect;//圆角边框
        _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;//编辑时显示清除按钮
    }
    return _usernameField;
}
/**
 懒加载登录按钮
 */
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];//未登录状态
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//未登录按钮字体颜色
        _loginButton.backgroundColor = [UIColor systemBlueColor];
        _loginButton.layer.cornerRadius = 8;//圆角
        _loginButton.layer.masksToBounds = YES;//裁剪圆角
    }
    return _loginButton;
}





@end




