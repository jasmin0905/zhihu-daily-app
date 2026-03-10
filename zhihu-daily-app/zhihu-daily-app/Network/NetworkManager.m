//
//  NetworkManager.m
//  zhihu-daily-app
//
//  网络请求管理类的实现，封装网络请求具体逻辑
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkManager
/**
 *  @brief  单例方法，保证全局唯一网络管理对象
 *  @return 唯一NetworkManager实例
 */
+ (instancetype)sharedManager{
    static NetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });
    return instance;
}
/**
 * @brief 获取最新新闻列表
 * @param success 成功回调，返回新闻列表数据字典
 * @param failure 失败回调，返回错误信息
 */
- (void)fetchLatestNewsWithSuccess:
(SuccessBlock)success
                           failure:(FailureBlock)failure{
    //知乎日报新闻列表接口地址
    NSString *urlString = @"https://news-at.zhihu.com/api/4/news/latest";
    //创建网络需求管理者，发送请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //配置JSON解析器
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //发起GET请求
    [manager GET:urlString
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        }
              failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error) {
            if (failure) {
                failure(error);
            }
        }];
    }
//获取新闻详情
- (void)fetchNewsDetailWithID:(NSString *)newsID success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *urlString = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/%@", newsID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlString
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
}
    
@end
