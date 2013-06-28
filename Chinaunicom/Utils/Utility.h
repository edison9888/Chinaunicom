//
//  UtilityFunction.h
//  GeneralApp
//
//  Created by lsy on 12-12-18.
//  Copyright (c) 2012年 lsy. All rights reserved.
//

//公用方法
#import <Foundation/Foundation.h>


#import "BaseViewController.h"

#import "SysConfig.h"
@interface Utility : NSObject
//单例
+(Utility*)Singleton;

//显示自定义警告框
+(void)showCustomAlert:(NSString*)msg;
//自定义导航左边的返回按钮
+(void)updateNavBackButton:(UINavigationItem*)customNavigationItem Seletor:(SEL)seletor Delegate:(id)delegate;
//自定义导航右边按钮
+(void)CustomNaRightButton:(UINavigationItem*)customNavigationItem Seletor:(SEL)seletor Delegate:(id)delegate ImageString:(NSString *)imageString;
//自定义导航右边按钮 更多
+(void)CustomNaRightButton:(UINavigationItem*)customNavigationItem Seletor:(SEL)seletor Delegate:(id)delegate ImageString:(NSString *)imageString highlightImageString:(NSString *)hstring aWidth:(NSString *)awidth aHeight:(NSString *)aheight;
//字符串转16进制颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

//文件路径格式化
+(NSString *)getFilePath:(NSString *)filename;

//文件路径格式化
+(NSString *)getFilePath:(NSString *)filename Dir:(NSString *)dir;

//检查文件是否存在
+(BOOL)checkFileExsit:(NSString *)fileName Dir:(NSString *)fileDir;

//计算文本的高度
+(CGFloat)calCellUILabelHeightWithFont:(float)fontSize contentWidth:(float)textWidth textContent:(NSString*)text;
//计算购物车商品数量
+(int)cartShopCount:(NSMutableArray*)array;
+(NSString *)changeToyuan :(NSString *)num;
+(NSString *)changeTohu :(NSString *)num;
+(NSString *)changeToWan :(NSString *)num;
//获取当天日期
+(NSString *)getTodayDate;
@end
