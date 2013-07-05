//
//  requestServiceHelper.h
//  Chinaunicom
//
//  Created by LITK on 13-5-15.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class NSString;
@class ReportDetail;

@interface requestServiceHelper : NSObject
//实例变量
+ (requestServiceHelper *)defaultService;
//登陆
- (void)loginWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (User *user))sucess falid:(void (^) (NSString *errorMsg))faild;
//获取报告列表
- (void)getReportList:(NSString *)url parmeter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableArray *reportDictionary,NSInteger result))sucess falid:(void (^) (NSString *errorMsg))faild;
//获取报告详细内容
- (void)getReportDetail:(NSMutableDictionary *)dictionary sucess:(void (^) (NSDictionary *reportDetail))sucess falid:(void (^) (NSString *errorMsg))faild;
//获取评论列表
-(void)getCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableArray *commentDictionary,NSInteger num))sucess falid:(void (^) (NSString *errorMsg))faild;
//发表评论
-(void)PublishCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSString *state))sucess falid:(void (^) (NSString *errorMsg))faild;
//发表带语音的评论
-(void)PublishCommentsWithAudioParamter:(NSMutableDictionary *)dictionary fileName:(NSString*)filename fileData:(NSData*)fileData
                              uploadKey:(NSString*)uploadKey Progress:(id)myProgress
                                 sucess:(void (^) (NSString *state))sucess falid:(void (^) (NSString *errorMsg))faild;
//获取我的评论列表
-(void)getMyCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSArray *commentDictionary))sucess falid:(void (^) (NSString *errorMsg))faild;
//收藏，赞，踩
-(void) favoriteZanCai:(NSString *)url paramter:(NSMutableDictionary *)dictionary sucess:(void (^)(NSString *msg))sucess falid:(void(^)(NSString *errorMsg))faild;
//收藏列表
-(void) FavoriteList:(NSMutableDictionary *)dictionary sucess:(void (^)(NSMutableArray *commentDictionary))sucess falid:(void(^)(NSString *errorMsg))faild;
//获取我已关注的菜单分类
-(void) getMyMenuReportType:(NSString *)userid sucess:(void(^)(NSArray *array))sucess falid:(void(^)(NSString *errorMsg))faild;
//获取全部菜单分类
-(void) getAllReportType:(NSString *)userid sucess:(void(^)(NSArray *array))sucess falid:(void(^)(NSString *errorMsg))faild;

//添加和删除分类
-(void) opreateReportType:(NSString *)url paramter:(NSMutableDictionary *)dictionary sucess:(void(^)(BOOL isSucess))sucess falid:(void(^)(NSString *errorMsg))faild;


//获取审核列表
- (void)getAduitingList:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableArray *reportDictionary,NSInteger result))sucess falid:(void (^) (NSString *errorMsg))faild;
/**********************************************************************************/
//获取ESS实时看板用户发展总数
-(void)getESStotleNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild;
//获取ESS实时看板3G用户发展行政区排名
-(void)getEssAreaNum:(NSMutableDictionary *)dictionary
              sucess:(void (^) (NSArray *str))sucess
               falid:(void (^) (NSString *errorMsg))faild;
//获取ESS实时看板iphone5用户发展总数
-(void)getESSIphoneFiveNum:(NSMutableDictionary *)dictionary
                    sucess:(void (^) (NSString *str))sucess
                     falid:(void (^) (NSString *errorMsg))faild;
//获取ESS实时看板iphone5用户发展行政区排名
-(void)getEssAreaIphoneFiveNum:(NSMutableDictionary *)dictionary
                        sucess:(void (^) (NSArray *str))sucess
                         falid:(void (^) (NSString *errorMsg))faild;
//获取ESS实时看板iphone4s用户发展总数
-(void)getESSIphoneFsNum:(NSMutableDictionary *)dictionary
                  sucess:(void (^) (NSString *str))sucess
                   falid:(void (^) (NSString *errorMsg))faild;
//获取ESS实时看板iphone4s用户发展行政区排名
-(void)getEssAreaIphoneFsNum:(NSMutableDictionary *)dictionary
                      sucess:(void (^) (NSArray *str))sucess
                       falid:(void (^) (NSString *errorMsg))faild;
//省份数据(实时数据、月数据、年数据)
-(void)getEssProvinceNum:(NSMutableDictionary *)dictionary
                     url:(NSString *)url
                  sucess:(void (^) (NSArray *str))sucess
                   falid:(void (^) (NSString *errorMsg))faild;



//获取ESS合约计划
//整点合约计划总数
-(void)getEsscontractNum:(NSMutableDictionary *)dictionary
                  sucess:(void (^) (NSString *str))sucess
                   falid:(void (^) (NSString *errorMsg))faild;
//所有整点趋势图
-(void)getEssHourTrend:(NSMutableDictionary *)dictionary
                   ulr:(NSString *)url
                sucess:(void (^) (NSDictionary *nsdict))sucess
                 falid:(void (^) (NSString *errorMsg))faild;
//所有月数据
-(void)getEssMonthData:(NSMutableDictionary *)dictionary
                   url:(NSString *)url
                sucess:(void (^) (NSDictionary *nsdict))sucess
                 falid:(void (^) (NSString *errorMsg))faild;
//所有年数据
-(void)getEssYearData:(NSMutableDictionary *)dictionary
                  url:(NSString *)url
               sucess:(void (^) (NSDictionary *nsdict))sucess
                falid:(void (^) (NSString *errorMsg))faild;



//ECS交易额
//实时ECS交易总额
-(void)getEcstradeNum:(NSMutableDictionary *)dictionary
                  sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild;
//商城订单量
//整点商城订单总量
-(void)getEssstoreNum:(NSMutableDictionary *)dictionary
                  sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild;
//商城用户发展
//整点用户发展总数
-(void)getEssGuessNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild;
//省份数据(实时数据、月数据、年数据)
-(void)getProvinceNum:(NSMutableDictionary *)dictionary
                  url:(NSString *)url
               sucess:(void (^) (NSArray *str))sucess
                falid:(void (^) (NSString *errorMsg))faild;
@end
