//
//  HttpRequestHelper.m
//  Chinaunicom
//
//  Created by LITK on 13-5-15.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define UserAgent  @"Chinaunicom 1.0"
#define TimeOut 10
#define RetryTimes 2


//定义服务器响应码
typedef enum {
	RequestStatus_OK = 200,
    RequestStatus_ErrorRequest = 400,
    RequestStatus_NotFound = 404,
    RequestStatus_Error = 500,
}RequestStatus;


@implementation HttpRequestHelper

+ (ASIHTTPRequest *)requestWithUrl:(NSString *)urlStr{
    
//    NSLog(@"请求地址:%@",urlStr);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setUserAgentString:UserAgent];
    
    //设置超时
    [request setTimeOutSeconds:TimeOut];//设置超时时间
    [request setNumberOfTimesToRetryOnTimeout:RetryTimes];//超时重试次数
    
    return request;
}

+ (ASIFormDataRequest *)formRequestWithUrl:(NSString *)urlStr{
//    NSLog(@"请求地址:%@",urlStr);
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setUserAgentString:UserAgent];
    
    //设置超时
    [request setTimeOutSeconds:TimeOut];//设置超时时间
    [request setNumberOfTimesToRetryOnTimeout:RetryTimes];//超时重试次数
    
    //设置缓存
    //    [request setDownloadCache:[ASIDownloadCache sharedCache]];//设置下载缓存
    //    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];//缓存策略
    //    [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];//缓存存储方式
    //    [request setSecondsToCache:60*60*24*30];// 缓存30天
    
    return request;
}

#pragma mark - 发送异步Get请求
+ (ASIHTTPRequest *)asyncGetRequest:(NSString *)url
                           parameter:(NSMutableDictionary *)dictionary
                           requestComplete:(void (^)(NSString *responseStr))requestComplete
                           requestFailed:(void (^)(NSString *errorMsg))requestFailed{
    
    ASIHTTPRequest *_request = [self requestWithUrl:url];
    __weak ASIHTTPRequest *request = _request;
    [request setUserAgentString:UserAgent];
    
    //设置请求方式
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=utf-8"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]];
    [request buildPostBody];
    
    
    //请求成功
    [request setCompletionBlock:^{
        switch (request.responseStatusCode) {
            case RequestStatus_OK:
                requestComplete(request.responseString);break;
            case RequestStatus_ErrorRequest:
                requestFailed(@"错误的请求");break;
            case RequestStatus_NotFound:
                requestFailed(@"找不到指定的资源");break;
            case RequestStatus_Error:
                requestFailed(@"内部服务器错误");break;
            default:
                requestFailed(@"服务器出错");break;
        }
    }];
    
    //请求失败
    [request setFailedBlock:^{
        requestFailed([NSString stringWithFormat:@"网络连接失败"]);
    }];
    
    //开始请求
    [request startAsynchronous];
    return request;
}

#pragma mark - 异步Post请求
+(ASIFormDataRequest*)asyncPostRequest:(NSString*)url
                             parameter:(NSMutableDictionary *)dictionary
                             requestComplete:(void(^)(NSString *responseStr))complete
                             requestFailed:(void(^)(NSString*errorMsg))failed{

    ASIFormDataRequest *_request = [self formRequestWithUrl:url];
    __weak ASIFormDataRequest *request = _request;
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setUserAgentString:UserAgent];
    [request buildPostBody];
    //设置请求参数
	if (dictionary != nil) {
		NSArray *parameterKeys_ = [dictionary allKeys];
		for (int i=0; i<[parameterKeys_ count]; i++) {
			id key_ = [parameterKeys_ objectAtIndex:i];
			id value_ = [dictionary objectForKey:key_];
            [request addRequestHeader:key_ value:[NSString stringWithFormat:@"%@",value_]];
		}
	}
    [request setResponseEncoding:NSUTF8StringEncoding];

    //请求成功
    [request setCompletionBlock:^{
        switch (request.responseStatusCode) {
            case RequestStatus_OK:
                
                complete([request.responseHeaders objectForKey:@"state"]);
                NSLog(@"%@",request.responseHeaders);
                break;
            case RequestStatus_ErrorRequest:
                failed(@"错误的请求");break;
            case RequestStatus_NotFound:
                failed(@"找不到指定的资源");break;
            case RequestStatus_Error:
                failed(@"内部服务器错误");break;
            default:
                failed(@"服务器出错");break;
        }
    }];
    
    //请求失败
    [request setFailedBlock:^{
        failed([NSString stringWithFormat:@"内部错误,请稍后在试..."]);
    }];
    
    //开始请求
    [request startAsynchronous];
    return request;

}

#pragma mark - 异步Post(语音)
+(ASIFormDataRequest*)asyncPostRequest:(NSString*)url
                       parameter:(NSMutableDictionary *)dictionary
                       filename:(NSString*)fname
                       fileData:(NSData*)fData
                       uploadKey:(NSString*)uploadKey
                       Progress:(id)myProgress
                       requestComplete:(void(^)(NSString *responseStr))complete
                       requestFailed:(void(^)(NSString*errorMsg))failed{
    
    ASIFormDataRequest *_request = [self formRequestWithUrl:url];
    __weak ASIFormDataRequest *request = _request;
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setUserAgentString:UserAgent];
    [request buildPostBody];
    //设置请求参数
	if (dictionary != nil) {
		NSArray *parameterKeys_ = [dictionary allKeys];
		for (int i=0; i<[parameterKeys_ count]; i++) {
			id key_ = [parameterKeys_ objectAtIndex:i];
			id value_ = [dictionary objectForKey:key_];
            [request addRequestHeader:key_ value:[NSString stringWithFormat:@"%@",value_]];
		}
	}
    
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"]; //image/jpeg  form-data
    [request addRequestHeader:uploadKey value:fname];
    //    [request addData:fData withFileName:fname andContentType:@"image/jpeg" forKey:uploadKey];
    [request addData:fData forKey:uploadKey];
    [request setUploadProgressDelegate:myProgress];
    [request setShouldContinueWhenAppEntersBackground:YES];//当应用后台运行时仍然请求数据
    
    [request setResponseEncoding:NSUTF8StringEncoding];
    
    //请求成功
    [request setCompletionBlock:^{
        switch (request.responseStatusCode) {
            case RequestStatus_OK:
                NSLog(@"%@",request.responseHeaders);
                  complete([request.responseHeaders objectForKey:@"state"]);
                break;
            case RequestStatus_ErrorRequest:
                failed(@"错误的请求");break;
            case RequestStatus_NotFound:
                failed(@"找不到指定的资源");break;
            case RequestStatus_Error:
                failed(@"内部服务器错误");break;
            default:
                failed(@"服务器出错");break;
        }
    }];
    
    //请求失败
    [request setFailedBlock:^{
        failed([NSString stringWithFormat:@"内部错误,请稍后在试..."]);
    }];
    
    //开始请求
    [request startAsynchronous];
    return request;
    
}

@end
