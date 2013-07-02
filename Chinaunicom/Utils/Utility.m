//
//  UtilityFunction.m
//  GeneralApp
//
//  Created by lsy on 12-12-18.
//  Copyright (c) 2012年 lsy. All rights reserved.
//

#import "Utility.h"
static Utility *shareSource = nil;
@implementation Utility
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//单例
+(Utility*)Singleton{
    @synchronized(self) {
        if (shareSource == nil) {
            shareSource =[[self alloc] init];
        }
    }
    return shareSource;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (shareSource == nil) {
            shareSource = [super allocWithZone:zone];
            return shareSource;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}


- (id)autorelease
{
    return self;
}



//字符串转16进制颜色
//+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
//{
//    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
//    //例子，stringToConvert #ffffff
//    if ([cString length] < 6)
//        return 0xffffff;//如果非十六进制，返回白色
//    if ([cString hasPrefix:@"#"])
//        cString = [cString substringFromIndex:1];//去掉头
//    if ([cString length] != 6)//去头非十六进制，返回白色
//        return 0xffffff;
//    //分别取RGB的值
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//    NSString *rString = [cString substringWithRange:range];
//    
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//    
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//    
//    unsigned int r, g, b;
//    //NSScanner把扫描出的制定的字符串转换成Int类型
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//    //转换为UIColor
//    return [UIColor colorWithRed:((float) r / 255.0f)
//                           green:((float) g / 255.0f)
//                            blue:((float) b / 255.0f)
//                           alpha:1.0f];
//}

//文件路径格式化
+(NSString *)getFilePath:(NSString *)filename{
    //创建文档文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    NSString *imageDir = [documentsDirectory stringByAppendingPathComponent:@"ConfigPic"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:imageDir]) {
        [fileManager createDirectoryAtPath:imageDir
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return [imageDir stringByAppendingPathComponent:filename];
}

//文件路径格式化
+(NSString *)getFilePath:(NSString *)filename Dir:(NSString *)dir{
    //创建文档文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    NSString *imageDir = [documentsDirectory stringByAppendingPathComponent:dir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:imageDir]) {
        [fileManager createDirectoryAtPath:imageDir
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return [imageDir stringByAppendingPathComponent:filename];
}

//检查文件是否存在
+(BOOL)checkFileExsit:(NSString *)fileName Dir:(NSString *)fileDir{
    BOOL result = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *testPath = [[documentDirectory stringByAppendingPathComponent:fileDir] stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:testPath]){
        result = YES;
    }
    return result;
}

//计算文本的高度
+(CGFloat)calCellUILabelHeightWithFont:(float)fontSize contentWidth:(float)textWidth textContent:(NSString*)text{
    UIFont *font=[UIFont systemFontOfSize:fontSize];
    CGFloat tempHeight = [text sizeWithFont:font
                          constrainedToSize:CGSizeMake(textWidth, 20000)
                              lineBreakMode:UILineBreakModeWordWrap].height;
    return tempHeight;
}

//计算购物车商品数量
+(int)cartShopCount:(NSMutableArray*)array{
    int xCount=0;
    if ([array count]>0) {
        for (int i=0; i<[array count]; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            xCount+=[[dict valueForKey:@"count"] intValue];
        }
        return xCount;
    }else{
        return 0;
    }
}

//转换成单位万元
+(NSString *)changeToyuan :(NSString *)num
{
    NSString *str=[NSString stringWithFormat:@"%@",num];
    if (str!=nil ) {
       
        if(str.length >4 && str.length <9){
            str =[NSString stringWithFormat:@"%.2f万元",[str doubleValue]/10000];
        }else if (str.length>8){
            str=[NSString stringWithFormat:@"%.2f亿元",[str doubleValue]/100000000];
        }else{
            str=[NSString stringWithFormat:@"%@元",str];
        }
    }
    return str;
}
//转换成单位户
+(NSString *)changeTohu :(NSString *)num
{
    NSString *str=[NSString stringWithFormat:@"%@",num];
    if (str!=nil && ![str isEqualToString:@""]) {
        if(str.length >4 && str.length <9){
            str =[NSString stringWithFormat:@"%.2f万户",[str doubleValue]/10000];
        }else if (str.length>8){
            str=[NSString stringWithFormat:@"%.2f亿户",[str doubleValue]/100000000];
        }else{
            str=[NSString stringWithFormat:@"%@户",str];
        }
    }
    return str;
}
//转换成单位万
+(NSString *)changeToWan :(NSString *)num
{
    NSString *str=[NSString stringWithFormat:@"%@",num];
    if (str!=nil && ![str isEqualToString:@""]) {
        if(str.length >4 && str.length <9){
            str =[NSString stringWithFormat:@"%.2f万",[str doubleValue]/10000];
        }else if (str.length>8){
            str=[NSString stringWithFormat:@"%.2f亿",[str doubleValue]/100000000];
        }else{
            str=[NSString stringWithFormat:@"%@",str];
        }
    }
    return str;
}
+(NSString *)getTodayDate
{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    return date;
}

//找最大值
-(float )maxNum : (NSMutableArray *)array
{
    float big=0.0;
    if ([array count]!=0) {
        
        big=[[array objectAtIndex:0] floatValue];
        for (int i=0; i<[array count]; i++) {
            if (big<[[array objectAtIndex:i] floatValue]) {
                big=[[array objectAtIndex:i]floatValue];
            }
        }
    }
    return big;
    
}
//最大值+10%
-(float)bigNumAdd :(NSMutableArray *)array
{
    float big=[self maxNum:array];
    float newBig=big * 0.1 + big;
    return newBig;
}

//计算比例
+(NSMutableArray *)calculatePercentage :(NSMutableArray *)array height:(float)height
{
    float bigNum=[[[self alloc]init] bigNumAdd:array];
    float newNum=0;
    NSMutableArray *muArray=[NSMutableArray arrayWithCapacity:[array count]];
    //每个数 除以 最大值+10% 乘以 图片的高度
    for (int i=0; i<[array count]; i++) {
        float num=[[array objectAtIndex:i] floatValue];
        if (num!=0) {
            newNum=num/bigNum * height;
        }else
        {
            newNum=0;
        }
        [muArray addObject:[NSNumber numberWithFloat:newNum]];
    }
    return muArray;
}
@end
