//
//  NewsCell.m
//  zhihu-daily-app
//
//  首页新闻列表单元格实现
//

#import "NewsCell.h"
#import "News.h"
#import <SDWebImage/SDWebImage.h>

//匿名分类
@interface NewsCell()
//封面图片
@property (nonatomic, strong) UIImageView *coverImageView;
//新闻标题
@property (nonatomic ,strong) UILabel *titleLabel;

@end
@implementation NewsCell
/**
 初始化单元格
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        //单元格背景白色
        self.contentView.backgroundColor = [UIColor whiteColor];
        //创建布局子控件
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return  self;
}
//布局发生变化时自动调用
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellWidth = self.contentView.bounds.size.width;
    CGFloat coverHeight = cellWidth * 9/16;
    //封面图布局
    self.coverImageView.frame = CGRectMake(0, 0, cellWidth, coverHeight);
    //标题布局
    self.titleLabel.frame = CGRectMake(16, coverHeight+12, cellWidth-32,60);
}
//懒加载，封面图
- (UIImageView *)coverImageView {
    if (!_coverImageView){
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}
//懒加载，标题
- (UILabel *)titleLabel{
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:17//字体
                                             weight:UIFontWeightSemibold];
        _titleLabel.numberOfLines = 2;//适配Cell高度
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;//文本过长时，末尾省略号
    }
    return _titleLabel;
}
    //赋值模型时刷新UI
    - (void)setNews:(News *)news {
         _news = news;
         
         self.titleLabel.text = news.title;
         [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:news.imageURL]
                               placeholderImage:nil];
     }

@end
