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
#define SERVERDOMAIN @"http://123.125.96.171:8080/"
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
//返回所有报告
#define ReportPath [SERVERPATH stringByAppendingFormat:@"user/getRepListByRepTypeId"]
//根据类型返回报告
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
#define sendReport [SERVERPATH stringByAppendingFormat:@"user/saveReport"]
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
//我的评论列表
#define getMyCommentsList [SERVERPATH stringByAppendingFormat:@"UserPrivilegeRe/getMyComments"]
//获取收藏列表
#define getMyFavoriteList [SERVERPATH stringByAppendingFormat:@"fav/getMyFavList"]
//修改用户头像
#define userPhoto [SERVERPATH stringByAppendingFormat:@"UserPrivilegeRe/updateHeadPic"]
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


//ESS合约计划 整点合约计划总数
#define GET_ESS_CONTRANCTNUM [SERVERPATH stringByAppendingFormat:@"daping/getContSumOfESS"]
//ESS合约计划 整点趋势图
#define GET_ESS_HOURTREND [SERVERPATH stringByAppendingFormat:@"daping/get24HoursChartOfESS"]

//ECS交易额 实时ECS交易总额
#define GET_ECS_TRADENUM [SERVERPATH stringByAppendingFormat:@"daping/getCurrGMVofECS"]
//商城订单量 整点商城订单总量
#define GET_ESS_STORENUM [SERVERPATH stringByAppendingFormat:@"daping/getMallGrossOfMall"]
#endif
