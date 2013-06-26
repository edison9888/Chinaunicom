//
//  requestServiceHelper.m
//  Chinaunicom
//
//  Created by LITK on 13-5-15.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "requestServiceHelper.h"
#import "User.h"
#import "ReportDetail.h"
#import "HttpRequestHelper.h"
#import "SysConfig.h"

@implementation requestServiceHelper

static requestServiceHelper *requestService;
//类的实例
+ (requestServiceHelper *)defaultService{
    @synchronized(requestService) {
        if (!requestService){
            requestService = [requestServiceHelper new];
        }
    }
    return requestService;
}
#pragma mark - 登陆
- (void)loginWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (User *user))sucess falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:LoginPath parameter:dictionary requestComplete:^(NSString *responseStr) {

        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dictionary count]>0) {
            
            User *user_=[User new];
            
            user_.userId=[dictionary objectForKey:@"userId"];
            user_.account=[dictionary objectForKey:@"account"];
            user_.name=[dictionary objectForKey:@"name"];
            user_.icon=[dictionary objectForKey:@"icons"];
            sucess(user_);
            //NSLog(@"%@",dictionary);
            
                       
        }else{
            
            faild(responseStr);
        }
        
        
    }requestFailed:^(NSString *errorMsg) {
        
        //NSLog(@"%@",errorMsg);
        faild(errorMsg);

    }];
    
}
//添加和删除报告类型
-(void)opreateReportType:(NSString *)url paramter:(NSMutableDictionary *)dictionary sucess:(void (^)(BOOL *))sucess falid:(void (^)(NSString *))faild
{
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
        if([responseStr isEqualToString:@"success"])
        {
            sucess(YES);
        }
        else
            sucess(NO);
    } requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}

#pragma mark- 获取我已关注的菜单分类
-(void)getMyMenuReportType:(NSString *)userid sucess:(void (^)(NSArray *))sucess falid:(void (^)(NSString *))faild
{
    NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
    [dir setValue:@"1" forKey:@"pageIndex"];
    [dir setValue:@"100" forKey:@"pageSize"];
    [dir setValue:userid forKey:@"userId"];
    [HttpRequestHelper asyncGetRequest:ReportType parameter:dir requestComplete:^(NSString *responseStr) {
        //code
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSArray *reportArray=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"object"];
        sucess(reportArray);
    } requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}
-(void)getAllReportType:(NSString *)userid sucess:(void(^)(NSArray *array))sucess falid:(void(^)(NSString *errorMsg))faild{

    NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
    [dir setValue:@"1" forKey:@"pageIndex"];
    [dir setValue:@"10" forKey:@"pageSize"];
    [dir setValue:userid forKey:@"userId"];
    
    [HttpRequestHelper asyncGetRequest:ReportAllType parameter:dir requestComplete:^(NSString *responseStr) {
        //code
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSArray *reportArray=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"object"];
        sucess(reportArray);
    } requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
    
}

#pragma mark - 获取报告列表
- (void) getReportList:(NSString *)url parmeter:(NSMutableDictionary *)dictionary sucess:(void (^)(NSMutableArray *reportDictionary,NSInteger result))sucess falid:(void (^)(NSString *))faild{
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr)
     {
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSMutableArray *reportArray=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"object"];
        NSString *total=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"number"];
        
        if ([reportArray count]>0) {
            
            sucess(reportArray,[total integerValue]);

        }
        else{
            faild(responseStr);
        }

    } requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}
#pragma mark - 获取报告详细内容
- (void)getReportDetail:(NSMutableDictionary *)dictionary sucess:(void (^) (ReportDetail *reportDetail))sucess falid:(void (^) (NSString *errorMsg))faild{
    [HttpRequestHelper asyncGetRequest:ReportDetails parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dictionary count]>0) {
            
            ReportDetail *_reportDetail=[[ReportDetail alloc] init];
            _reportDetail.reportTitle=[dictionary objectForKey:@"title"];
            _reportDetail.reportContent=[dictionary objectForKey:@"reportContent"];
            _reportDetail.published=[dictionary objectForKey:@"published"];
            _reportDetail.size=[dictionary objectForKey:@"size"];
            _reportDetail.fromtype=[dictionary objectForKey:@"reportType"];
            _reportDetail.isFav=[dictionary objectForKey:@"isFav"];
            _reportDetail.picPath=[dictionary objectForKey:@"picPath"];
             _reportDetail.favId=[dictionary objectForKey:@"favId"];
            sucess(_reportDetail);
        }else{
            
            faild(responseStr);
        }
        
        
    }requestFailed:^(NSString *errorMsg) {
        
        //NSLog(@"%@",errorMsg);
        faild(errorMsg);
        
    }];
}
#pragma mark - 获取评论列表
-(void)getCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableArray *commentDictionary))sucess falid:(void (^) (NSString *errorMsg))faild{

    [HttpRequestHelper asyncGetRequest:CommentList parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSMutableArray *dictionary=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"commentList"];
        
        
        if ([dictionary count]>0) {
            
            sucess(dictionary);
         
        }else{
            
            faild(responseStr);
        }
        
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];

}

#pragma mark - 发表评论
-(void)PublishCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSString *state))sucess falid:(void (^) (NSString *errorMsg))faild{

    [HttpRequestHelper asyncPostRequest:PublishComment parameter:dictionary requestComplete:^(NSString *responseStr) {
                
        if ([responseStr isEqualToString:@"success"]) {
            
            sucess(responseStr);
            
        }else{
            
            faild(responseStr);
        }
        
    } requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
    }];

}
#pragma mark -  发表带语音的评论
-(void)PublishCommentsWithAudioParamter:(NSMutableDictionary *)dictionary fileName:(NSString*)filename fileData:(NSData*)fileData
                              uploadKey:(NSString*)uploadKey Progress:(id)myProgress
                               sucess:(void (^) (NSString *state))sucess falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncPostRequest:PublishComment parameter:dictionary filename:filename fileData:fileData uploadKey:uploadKey
        Progress:myProgress requestComplete:^(NSString *responseStr) {
            
            sucess(responseStr);
        
    } requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
    
}

#pragma mark - 获取我的评论列表
-(void)getMyCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableDictionary *commentDictionary))sucess falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:getMyCommentsList parameter:dictionary requestComplete:^(NSString *responseStr) {
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        //NSMutableDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *reportArray=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        NSMutableDictionary *reportDic=[[NSMutableDictionary alloc] initWithObjects:[reportArray objectAtIndex:1] forKeys:[reportArray objectAtIndex:1]];

        if ([dictionary count]>0) {
            
            sucess(reportDic);
            
        }else{
            
            faild(responseStr);
        }
        
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
    
}

#pragma mark - 收藏，赞，踩
-(void) favoriteZanCai:(NSString *)url paramter:(NSMutableDictionary *)dictionary sucess:(void (^)(NSString *))sucess falid:(void (^)(NSString *))faild{
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
        sucess(responseStr);
    } requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}
#pragma mark - 获取收藏列表
-(void) FavoriteList:(NSMutableDictionary *)dictionary sucess:(void (^)(NSMutableArray *commentDictionary))sucess falid:(void(^)(NSString *errorMsg))faild
{
    [HttpRequestHelper asyncGetRequest:getMyFavoriteList parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        //NSMutableDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *reportArray=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        NSMutableArray *reportDic=[[NSMutableArray alloc] initWithArray:[reportArray objectAtIndex:1]];
//        NSLog(@"%@",responseStr);
        if ([dictionary count]>0) {
            
            sucess(reportDic);
            
        }else{
            
            faild(responseStr);
        }
        
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
    

}
//获取审核列表
-(void) getAduitingList:(NSMutableDictionary *)dictionary sucess:(void (^)(NSMutableArray *, NSInteger))sucess falid:(void (^)(NSString *))faild
{
    [HttpRequestHelper asyncGetRequest:getAudiList parameter:dictionary requestComplete:^(NSString *responseStr) {
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSMutableArray *reportArray=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"object"];
        NSString *total=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"number"];
        
        if ([reportArray count]>0) {
            
            sucess(reportArray,[total integerValue]);
            
        }
        else{
            faild(responseStr);
        }
        
    } requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);

    }];
}

/**********************************************************************************/
//获取ESS实时看板用户发展总数
-(void)getESStotleNum:(NSMutableDictionary *)dictionary sucess:(void (^) ( NSMutableArray *commentDictionary))sucess falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncPostRequest:GET_ESS_TOTALNUM parameter:dictionary requestComplete:^(NSString *responseStr) {

        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        //NSMutableDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *reportArray=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
//        NSMutableDictionary *reportDic=[[NSMutableDictionary alloc] initWithObjects:[reportArray objectAtIndex:1] forKeys:[reportArray objectAtIndex:1]];
        
        if ([reportArray count]>0) {
            
            sucess(reportArray);
            
        }else{
            
            faild(responseStr);
        }
        
        
    }requestFailed:^(NSString *errorMsg) {
        NSLog(@"errorms=%@",errorMsg);
        faild(errorMsg);
        
    }];
    
}

@end
