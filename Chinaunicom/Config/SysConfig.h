//
//  SysConfig.h
//  Chinaunicom
//
//  Created by LITK on 13-5-15.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#ifndef Chinaunicom_SysConfig_h
#define Chinaunicom_SysConfig_h

//定义接口服务器域名
#ifndef SERVERDOMAIN

////测试
//#define SERVERDOMAIN @"http://123.125.96.171:8080/"
//正式
#define SERVERDOMAIN @"http://123.125.96.185:8088/"
#endif

//定义接口服务器地址
#ifndef SERVERPATH
#define SERVERPATH [SERVERDOMAIN stringByAppendingFormat:@"mobilePortal/restful/"]
#endif
#define ImageUrl [SERVERDOMAIN stringByAppendingFormat:@"mobilePortal/"]
#define KEY_REMEMBER_PWD @"Remember_PWD"//标记是否保存密码
#define KEY_REMEMBER_AUTOMATICLOGIN @"Remember_automaticLogin"//标记是否自动登录
#define KEY_USER_PWD @"User_PWD"//用户密码
#define KEY_USER_NAME @"User_NAME"//用户名
#define KEY_USER_ID @"user_id"//
#define KEY_USER_ICON @"user_icon"
#define KEY_USER_INFO @"User_Info"//登录成功后返回的用户信息数据
#define KEY_LEFTMENU_INFO @"Left_Menu"//登录成功后返回的用户左边菜单
#define KEY_LEFT_BOTTOM_MENU_INFO @"Left_Bottom_Menu"

#define LoginPath  [SERVERPATH stringByAppendingFormat:@"user/login"]
//根据类型返回报告
#define ReportPath [SERVERPATH stringByAppendingFormat:@"user/getRepListByRepTypeId"]
//返回所有报告
#define AllReportPath [SERVERPATH stringByAppendingFormat:@"user/getReportList"]
#define ReportDetails [SERVERPATH stringByAppendingFormat:@"user/getReportById"]
#define FavShoucang [SERVERPATH stringByAppendingFormat:@"fav/addFav"]
#define FavZan [SERVERPATH stringByAppendingFormat:@"fav/addPra"]
#define FavCai [SERVERPATH stringByAppendingFormat:@"fav/addStep"]
#define delShoucang [SERVERPATH stringByAppendingFormat:@"fav/delFav"]
#define delZan [SERVERPATH stringByAppendingFormat:@"fav/delPra"]
#define delCai [SERVERPATH stringByAppendingFormat:@"fav/delStep"]
#define FavList [SERVERPATH stringByAppendingFormat:@"fav/getMyFavList"]
#define shoucangNumber [SERVERPATH stringByAppendingFormat:@"fav/favNum"]
#define caiNumber [SERVERPATH stringByAppendingFormat:@"fav/stepNum"]
#define zanNumber [SERVERPATH stringByAppendingFormat:@"fav/praNum"]
#define sendReport [SERVERPATH stringByAppendingFormat:@"user/saveReport"] //发布报告
#define getAudiList [SERVERPATH stringByAppendingFormat:@"RepAuditRestful/getRepAuditService"]
//获取用户的菜单权限
#define ReportAllType [SERVERPATH stringByAppendingFormat:@"RepTypeRestful/getMyMobilePrivilege"]
//获取用户关注的菜单
#define ReportType [SERVERPATH stringByAppendingFormat:@"RepTypeRestful/getMyAttention"]
#define DeleteReportType [SERVERPATH stringByAppendingFormat:@"RepTypeRestful/delMyAttention"]
#define AddReportType [SERVERPATH stringByAppendingFormat:@"RepTypeRestful/addMyAttention"]
//根据标题搜索报告
#define SearchReport [SERVERPATH stringByAppendingFormat:@"user/getRepListByTitle"]
//获取评论列表
#define CommentList [SERVERPATH stringByAppendingFormat:@"comment/commentList"]
//发布评论
#define PublishComment [SERVERPATH stringByAppendingFormat:@"comment/publishComment"]
/********************************个人主页***********************************************/
//修改报告
#define changeReport [SERVERPATH stringByAppendingFormat:@"RepAuditRestful/editRepAudit"]
//我的评论列表
#define getMyCommentsList [SERVERPATH stringByAppendingFormat:@"UserPrivilegeRe/getMyComments"]
//获取收藏列表
#define getMyFavoriteList [SERVERPATH stringByAppendingFormat:@"fav/getMyFavList"]
//修改用户头像
#define userPhoto [SERVERPATH stringByAppendingFormat:@"UserPrivilegeRe/updateHeadPic"]
//修改密码
#define userPwd [SERVERPATH stringByAppendingFormat:@"UserPrivilegeRe/updatePassword"]
//收藏列表
#define AddFavoriteList [SERVERPATH stringByAppendingFormat:@"fav/addFav"]
//通过审核
#define passReport [SERVERPATH stringByAppendingFormat:@"RepAuditRestful/passRepAudit"]
//退回报告
#define backReportUrl [SERVERPATH stringByAppendingFormat:@"RepAuditRestful/backRepAudit"]
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/********************************ESS实时看板***********************************************/
//ESS实时看板 用户发展总数（实时数据、月数据、年数据）
#define GET_ESS_TOTALNUM [SERVERPATH stringByAppendingFormat:@"daping/getDevUserSum"]
//获取ESS实时看板iPhone5总销量
#define GET_ESS_IPHONE5NUM [SERVERPATH stringByAppendingFormat:@"daping/getiPhone5Sum"]
//获取ESS实时看板iPhone 4S总销量
#define GET_ESS_IPHONE4GNUM [SERVERPATH stringByAppendingFormat:@"daping/getiPhone4SSum"]
//获取ESS实时看板3G用户发展行政区排名
#define GET_ESS_AREA_3GNUM [SERVERPATH stringByAppendingFormat:@"daping/getCurrDevUserDistrictRanking"]
//获取ESS实时看板iPhone5用户发展行政区排名
#define GET_ESS__AREA_IPHONE5NUM [SERVERPATH stringByAppendingFormat:@"daping/getiPhone5SaleDistrictRanking"]
//获取ESS实时看板iPhone4S用户发展行政区排名
#define GET_ESS_AREA_IPHONE4GNUM [SERVERPATH stringByAppendingFormat:@"daping/getiPhone4SSaleDistrictRanking"]
//3G用户发展省份数据(实时数据、月数据、年数据)
#define GET_ESS_PROVINCE_3GNUM [SERVERPATH stringByAppendingFormat:@"daping/get3GUserDevData"]
//iPhone 5省份数据(实时数据、月数据、年数据)
#define GET_ESS_PROVINCE_FIVENUM [SERVERPATH stringByAppendingFormat:@"daping/getiPhone5ProvinceData"]
//iPhone 4S省份数据(实时数据、月数据、年数据)
#define GET_ESS_PROVINCE_FOURSNUM [SERVERPATH stringByAppendingFormat:@"daping/getiPhone4SProvinceData"]


//ESS合约计划 整点合约计划总数
#define GET_ESS_CONTRANCTNUM [SERVERPATH stringByAppendingFormat:@"daping/getContSumOfESS"]
//ESS合约计划 整点趋势图
#define GET_ESS_HOURTREND [SERVERPATH stringByAppendingFormat:@"daping/get24HoursChartOfESS"]
//实时ECS交易总额 整点趋势图
#define GET_ECS_HOURTREND [SERVERPATH stringByAppendingFormat:@"daping/get24HoursChartOfECS"]
//整点商城订单总量 整点趋势图
#define GET_STORE_HOURTREND [SERVERPATH stringByAppendingFormat:@"daping/get24HoursChartOfMall"]
//商城用户发展 整点趋势图
#define GET_GUESS_HOURTREND [SERVERPATH stringByAppendingFormat:@""]


//ESS合约计划 月数据趋势图
#define GET_ESS_MONTHDATA [SERVERPATH stringByAppendingFormat:@"daping/getMonthDataOfESS"]
//ECS交易额 月数据趋势图
#define GET_ECS_MONTHDATA [SERVERPATH stringByAppendingFormat:@"daping/getMonthDataOfECS"]
//商城订单总量 月数据趋势图
#define GET_STORE_MONTHDATA [SERVERPATH stringByAppendingFormat:@"daping/getMonthDataOfMall"]
//商城用户发展 月数据趋势图
#define GET_GUESS_MONTHDATA [SERVERPATH stringByAppendingFormat:@"daping/getMonthDataOfMallUser"]

//ESS合约计划 年数据趋势图
#define GET_ESS_YEARDATA [SERVERPATH stringByAppendingFormat:@"daping/getYearDataOfESS"]
//ECS交易额 年数据趋势图
#define GET_ECS_YEARDATA [SERVERPATH stringByAppendingFormat:@"daping/getYearDataOfECS"]
//商城订单总量 年数据趋势图
#define GET_STORE_YEARDATA [SERVERPATH stringByAppendingFormat:@"daping/getYearDataOfMall"]
//商城用户发展 年数据趋势图
#define GET_GUESS_YEARDATA [SERVERPATH stringByAppendingFormat:@"daping/getYearDataOfMallUser"]

//ECS交易额 实时ECS交易总额
#define GET_ECS_TRADENUM [SERVERPATH stringByAppendingFormat:@"daping/getCurrGMVofECS"]
//商城订单量 整点商城订单总量
#define GET_ESS_STORENUM [SERVERPATH stringByAppendingFormat:@"daping/getMallGrossOfMall"]
//商城用户发展 整点用户发展总数
#define GET_ESS_GUESSNUM [SERVERPATH stringByAppendingFormat:@""]

//ECS交易额 省份排名（整点数据、月数据、年数据）
#define GET_PROVINCE_ECS [SERVERPATH stringByAppendingFormat:@"daping/getProvinceRankingOfECS"]
//商城订单量 省份排名（整点数据、月数据、年数据）
#define GET_PROVINCE_STORE [SERVERPATH stringByAppendingFormat:@"daping/getProvinceRankingOfMall"]
//商城用户发展 省份排名（整点数据、月数据、年数据）
#define GET_PROVINCE_GUESS [SERVERPATH stringByAppendingFormat:@"daping/getProvinceRankingOfMallUser"]
//ESS合约计划 省份排名（整点数据、月数据、年数据）
#define GET_PROVINCE_ESS [SERVERPATH stringByAppendingFormat:@"daping/getProvinceRankingOfESS"]

//全国数据 3G
#define GET_CHINA_3G [SERVERPATH stringByAppendingFormat:@"daping/get3G_nationwide"]
//全国数据 iphone5
#define GET_CHINA_IPHONE5 [SERVERPATH stringByAppendingFormat:@"daping/getiPhone5_nationwide"]
//全国数据 iphone4s
#define GET_CHINA_IPHONE4S [SERVERPATH stringByAppendingFormat:@"daping/getiPhone4S_nationwide"]

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define I5Height 548

#endif
