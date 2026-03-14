//
//  ProfileView.m
//  zhihu-daily-app
//
//  实现个人页面UI布局,控件懒加载
//

#import "ProfileView.h"
#import <Masonry/Masonry.h>
@interface ProfileView ()
- (void)setupUI;
@end

@implementation ProfileView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - UI布局配置
/**
 视图加载完成时调用，完成UI初始化布局
 */
- (void)setupUI {
    //设置背景色为系统背景色，适配黑暗模式
    self.backgroundColor = [UIColor systemBackgroundColor];
    //添加相关子视图
    [self addSubview:self.avatarImageView];
    [self addSubview:self.usernameLabel];
    [self addSubview:self.logoutButton];
    //Masonry设置约束
    //头像约束，距顶部100，水平居中，宽高80
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(100);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    //用户名Label约束，头像下方20.左右边距24
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(24);
        make.right.equalTo(self.mas_left).offset(-24);
    }];
    //退出登录按钮约束，Label下方50，左右同输入框，高48
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(50);
        make.left.right.equalTo(self.usernameLabel);
        make.height.equalTo(@48);
    }];
}
#pragma mark - 懒加载
/**
 懒加载用户头像
 */
- (UIImageView *)avatarImageView {
    if(!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
        _avatarImageView.tintColor = [UIColor systemBlueColor];//图标颜色
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;//图片填充模式，等比例填充，超出部分会被裁减
        _avatarImageView.layer.cornerRadius = 40;//圆角
        _avatarImageView.layer.masksToBounds = YES;//是否裁剪超出部分，可使圆角生效
    }
    return _avatarImageView;
}
/**
 懒加载用户标签
 */
- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc]init];
        //默认未登录，登录后由Controller修改为实际用户名
        _usernameLabel.text = @"未登录";
        //字体设置
        _usernameLabel.font = [UIFont systemFontOfSize:16];
        //设置文字颜色为系统标签色，适配黑暗，浅色模式
        _usernameLabel.textColor = [UIColor labelColor];
        //设置文字居中对齐
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _usernameLabel;
}
/**
 懒加载退出登录
 */
- (UIButton *)logoutButton {
    if(!_logoutButton) {
        _logoutButton = [[UIButton alloc]init];
        //设置按钮标题：退出登录
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        //设置标题颜色
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //设置按钮背景色
        _logoutButton.backgroundColor = [UIColor systemBlueColor];
        //设置按钮圆角半径
        _logoutButton.layer.cornerRadius = 8;
        _logoutButton.layer.masksToBounds = YES;
    }
    return _logoutButton;
}



@end
