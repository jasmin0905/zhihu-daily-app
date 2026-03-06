//
//  News.h
//  zhihu-daily-app
//
//  新闻数据模型，储存从第三方库API获取新闻
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface News : NSObject
///新闻ID，跳转详情页
@property (nonatomic, copy) NSString *newsID;
///新闻标题
@property (nonatomic, copy) NSString *title;
///新闻缩略图URL
@property (nonatomic, copy) NSString *imageURL;

@end

NS_ASSUME_NONNULL_END

