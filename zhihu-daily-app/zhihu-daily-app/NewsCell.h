//
//  NewsCell.h
//  zhihu-daily-app
//
//  首页新闻列表单元格，展示单条新闻封面，标题
//

#import <UIKit/UIKit.h>
//声明 News为类，避免循环引用
@class News;

NS_ASSUME_NONNULL_BEGIN

@interface NewsCell : UICollectionViewCell
///可用来通过外界赋值更新Cell显示
@property (nonatomic, strong) News *news;

@end

NS_ASSUME_NONNULL_END
