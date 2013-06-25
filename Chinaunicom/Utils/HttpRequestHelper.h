//
//  HttpRequestHelper.h
//  Chinaunicom
//
//  Created by LITK on 13-5-15.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@class ASIFormDataRequest;

@interface HttpRequestHelper : NSObject

//asiHttpRequest
+ (ASIHTTPRequest *)requestWithUrl:(NSString *)urlStr;
+ (ASIFormDataRequest *)formRequestWithUrl:(NSString *)urlStr;
//异步Get请求 JSON
+(ASIHTTPRequest*)asyncGetRequest:(NSString*)url
                         parameter:(NSMutableDictionary *)dictionary
                         requestComplete:(void(^)(NSString *responseStr))complete
                         requestFailed:(void(^)(NSString*errorMsg))failed;
//异步Post请求
+(ASIFormDataRequest*)asyncPostRequest:(NSString*)url
                            parameter:(NSMutableDictionary *)dictionary
                            requestComplete:(void(^)(NSString *responseStr))complete
                            requestFailed:(void(^)(NSString*errorMsg))failed;

//异步Post(语音)
+(ASIFormDataRequest*)asyncPostRequest:(NSString*)url
                             parameter:(NSMutableDictionary *)dictionary
                              filename:(NSString*)fname
                              fileData:(NSData*)fData
                             uploadKey:(NSString*)uploadKey
                              Progress:(id)myProgress
                       requestComplete:(void(^)(NSString *responseStr))complete
                         requestFailed:(void(^)(NSString*errorMsg))failed;

@end
