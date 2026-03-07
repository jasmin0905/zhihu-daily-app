//
//  NetworkManager.h
//  zhihu-daily-app
//
//  网络请求管理类，统一处理API请求，封装AFNetworking,提供获取新闻列表和详情接口
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
//定义回调类型
typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSError*_Nullable error);


@interface NetworkManager : NSObject
/// 单例方法，保证全局唯一
+ (instancetype)sharedManager;
///获取最新新闻列表
///@param success 成功回调，返回新闻数据字典
///@param failure 失败回调，返回错误信息
- (void)fetchLatestNewsWithSuccess:
(SuccessBlock)success
                          failure:(FailureBlock)failure;
///获取新闻详情
///@param newsID  新闻ID
///@param success  成功回调，返回新闻详情字典
///@param failure  失败回调，返回错误信息
- (void)fetchNewsDetailWithID:(NSString *)newsID
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END


