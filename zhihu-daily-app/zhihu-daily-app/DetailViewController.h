//
//  DetailViewController.h
//  zhihu-daily-app
//
//  新闻详情页，展示单条新闻完整内容，点赞，收藏功能
//

#import <UIKit/UIKit.h>
@class News;//提前声明

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, strong)News *news;

@end

NS_ASSUME_NONNULL_END
