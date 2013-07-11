//
//  requestServiceHelper.m
//  Chinaunicom
//
//  Created by LITK on 13-5-15.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//


#import "User.h"
#import "ReportDetail.h"
#import "HttpRequestHelper.h"

@implementation requestServiceHelper

static requestServiceHelper *requestService;
//类的实例
+ (requestServiceHelper *)defaultService{
    @synchronized(requestService) {
        if (!requestService){
            requestService = [[requestServiceHelper alloc]init];
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
            
            User *user_=[[User alloc]init];
            user_.userId=[dictionary objectForKey:@"userId"];
            user_.account=[dictionary objectForKey:@"account"];
            user_.name=[dictionary objectForKey:@"name"];
            user_.icon=[dictionary objectForKey:@"icons"];
            sucess(user_);
        }else{
            faild(responseStr);
        }
    }requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
    
}
//添加和删除报告类型
-(void)opreateReportType:(NSString *)url paramter:(NSMutableDictionary *)dictionary sucess:(void (^)(BOOL isSucess))sucess falid:(void (^)(NSString *))faild
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
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSArray *reportArray=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"object"];
        if (reportArray ) {
            sucess(reportArray);
        }
        
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
- (void)getReportDetail:(NSMutableDictionary *)dictionary sucess:(void (^) (NSDictionary *reportDetail))sucess falid:(void (^) (NSString *errorMsg))faild{
    [HttpRequestHelper asyncGetRequest:ReportDetails parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if (dictionary) {
            sucess(dictionary);
        }else{
            
            faild(responseStr);
        }
    }requestFailed:^(NSString *errorMsg) {
        faild(errorMsg);
        
    }];
}
#pragma mark - 获取评论列表
-(void)getCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSMutableArray *commentDictionary,NSInteger num))sucess falid:(void (^) (NSString *errorMsg))faild{

    [HttpRequestHelper asyncGetRequest:CommentList parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        NSMutableArray *dictionary=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"commentList"];
        NSString *str=[[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil] objectForKey:@"totalNum"];
        
        if ([dictionary count]>0) {
            
            sucess(dictionary,[str integerValue]);
         
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
-(void)getMyCommentsWithParamter:(NSMutableDictionary *)dictionary sucess:(void (^) (NSArray *commentDictionary))sucess falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:getMyCommentsList parameter:dictionary requestComplete:^(NSString *responseStr) {
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        //NSMutableDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *reportArray=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
//        NSMutableDictionary *reportDic=[[NSMutableDictionary alloc] initWithObjects:[reportArray objectAtIndex:1] forKeys:[reportArray objectAtIndex:1]];

        if (reportArray) {
            
            sucess(reportArray);
            
        }else{
            
            faild(nil);
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
        
        NSMutableArray *reportArray=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSMutableArray *reportDic=[[NSMutableArray alloc] initWithArray:[reportArray objectAtIndex:1]];
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
//获取ESS实时看板3G用户发展总数
-(void)getESStotleNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ESS_TOTALNUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSString *str=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        sucess(str);

    }requestFailed:^(NSString *errorMsg) {
    
        faild(errorMsg);
        
    }];
}
//获取ESS实时看板3G用户发展行政区排名
-(void)getEssAreaNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSArray *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ESS_AREA_3GNUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
    
         if (array) {
             NSMutableArray *muArray=[NSMutableArray arrayWithCapacity:7];
             for (int i=0; i<[array count]; i++) {
                 NSString *str=[[array objectAtIndex:i]objectForKey:@"value"];
                 [muArray addObject:str];
             }
             NSArray *newArray=[NSArray arrayWithArray:muArray];
             
             sucess(newArray);
        }
     
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//获取ESS实时看板iphone5用户发展总数
-(void)getESSIphoneFiveNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ESS_IPHONE5NUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSString *str=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        sucess(str);
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//获取ESS实时看板iphone5用户发展行政区排名
-(void)getEssAreaIphoneFiveNum:(NSMutableDictionary *)dictionary
              sucess:(void (^) (NSArray *str))sucess
               falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ESS__AREA_IPHONE5NUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if (array) {
            NSMutableArray *muArray=[NSMutableArray arrayWithCapacity:7];
            for (int i=0; i<[array count]; i++) {
                NSString *str=[[array objectAtIndex:i]objectForKey:@"value"];
                [muArray addObject:str];
            }
            NSArray *newArray=[NSArray arrayWithArray:muArray];
            sucess(newArray);
        }
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//获取ESS实时看板iphone4s用户发展总数
-(void)getESSIphoneFsNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ESS_IPHONE4GNUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSString *str=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        sucess(str);
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//获取ESS实时看板iphone4s用户发展行政区排名
-(void)getEssAreaIphoneFsNum:(NSMutableDictionary *)dictionary
              sucess:(void (^) (NSArray *str))sucess
               falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ESS_AREA_IPHONE4GNUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if (array) {
            NSMutableArray *muArray=[NSMutableArray arrayWithCapacity:7];
            for (int i=0; i<[array count]; i++) {
                NSString *str=[[array objectAtIndex:i]objectForKey:@"value"];
                [muArray addObject:str];
            }
            NSArray *newArray=[NSArray arrayWithArray:muArray];
            sucess(newArray);
        }
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}

//省份数据(实时数据、月数据、年数据)
-(void)getEssProvinceNum:(NSMutableDictionary *)dictionary
                     url:(NSString *)url
                      sucess:(void (^) (NSArray *str))sucess
                       falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if (array) {
//            NSMutableArray *muArray=[NSMutableArray arrayWithCapacity:7];
//            for (int i=0; i<[array count]; i++) {
//                NSString *str=[[array objectAtIndex:i]objectForKey:@"value"];
//                [muArray addObject:str];
//            }
//            NSArray *newArray=[NSArray arrayWithArray:muArray];
            sucess(array);
        }
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}


//获取ESS合约计划
//整点合约计划总数
-(void)getEsscontractNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ESS_CONTRANCTNUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSString *str=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        sucess(str);
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//整点趋势图
-(void)getEssHourTrend:(NSMutableDictionary *)dictionary
                   ulr:(NSString *)url
                  sucess:(void (^) (NSDictionary *nsdict))sucess
                   falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if (dict) {
            sucess(dict);
        }
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//ESS合约计划月数据
-(void)getEssMonthData:(NSMutableDictionary *)dictionary
                   url:(NSString *)url
                sucess:(void (^) (NSDictionary *nsdict))sucess
                 falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if (dict) {
            sucess(dict);
        }
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//ESS合约计划年数据
-(void)getEssYearData:(NSMutableDictionary *)dictionary
                  url:(NSString *)url
                sucess:(void (^) (NSDictionary *nsdict))sucess
                 falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if (dict) {
            sucess(dict);
        }
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}

//ECS交易额
//实时ECS交易总额
-(void)getEcstradeNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:GET_ECS_TRADENUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSString *str=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        sucess(str);
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];

}
//商城订单量
//整点商城订单总量
-(void)getEssstoreNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    [HttpRequestHelper asyncGetRequest:GET_ESS_STORENUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSString *str=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        sucess(str);
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}
//商城用户发展
//整点用户发展总数
-(void)getEssGuessNum:(NSMutableDictionary *)dictionary
               sucess:(void (^) (NSString *str))sucess
                falid:(void (^) (NSString *errorMsg))faild{
    [HttpRequestHelper asyncGetRequest:GET_ESS_GUESSNUM parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSString *str=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        sucess(str);
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];

}

//省份数据(实时数据、月数据、年数据)
-(void)getProvinceNum:(NSMutableDictionary *)dictionary
                     url:(NSString *)url
                  sucess:(void (^) (NSArray *str))sucess
                   falid:(void (^) (NSString *errorMsg))faild{
    
    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
        
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if (array) {
            sucess(array);
        }
        
    }requestFailed:^(NSString *errorMsg) {
        
        faild(errorMsg);
        
    }];
}

@end
