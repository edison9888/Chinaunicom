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
- (void)getReportDetail:(NSMutableDictionary *)dictionary sucess:(void (^) (ReportDetail *reportDetail))sucess falid:(void (^) (NSString *errorMsg))faild;
//获取评论列表
-(void)getCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableArray *commentDictionary))sucess falid:(void (^) (NSString *errorMsg))faild;
//发表评论
-(void)PublishCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSString *state))sucess falid:(void (^) (NSString *errorMsg))faild;
//发表带语音的评论
-(void)PublishCommentsWithAudioParamter:(NSMutableDictionary *)dictionary fileName:(NSString*)filename fileData:(NSData*)fileData
                              uploadKey:(NSString*)uploadKey Progress:(id)myProgress
                                 sucess:(void (^) (NSString *state))sucess falid:(void (^) (NSString *errorMsg))faild;
//获取我的评论列表
-(void)getMyCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableDictionary *commentDictionary))sucess falid:(void (^) (NSString *errorMsg))faild;
//收藏，赞，踩
-(void) favoriteZanCai:(NSString *)url paramter:(NSMutableDictionary *)dictionary sucess:(void (^)(NSString *msg))sucess falid:(void(^)(NSString *errorMsg))faild;
//收藏列表
-(void) FavoriteList:(NSMutableDictionary *)dictionary sucess:(void (^)(NSMutableArray *commentDictionary))sucess falid:(void(^)(NSString *errorMsg))faild;
//获取我已关注的菜单分类
-(void) getMyMenuReportType:(NSString *)userid sucess:(void(^)(NSArray *array))sucess falid:(void(^)(NSString *errorMsg))faild;
//获取全部菜单分类
-(void) getAllReportType:(NSString *)userid sucess:(void(^)(NSArray *array))sucess falid:(void(^)(NSString *errorMsg))faild;

//添加和删除分类
-(void) opreateReportType:(NSString *)url paramter:(NSMutableDictionary *)dictionary sucess:(void(^)(BOOL *isSucess))sucess falid:(void(^)(NSString *errorMsg))faild;
//获取审核列表
- (void)getAduitingList:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableArray *reportDictionary,NSInteger result))sucess falid:(void (^) (NSString *errorMsg))faild;
@end
