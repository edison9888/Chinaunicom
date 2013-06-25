//
//  CommonHelper.h
//  Chinaunicom
//
//  Created by  on 13-5-10.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
//对数据进行排序
+ (void) changeSortArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;
@end
