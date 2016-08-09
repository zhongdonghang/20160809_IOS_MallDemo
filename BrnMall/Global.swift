//
//  Global.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

public var cateIndex = -1
// MARK: - 全局常用属性
public let NavigationH: CGFloat = 64
public let ScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
public let ScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
public let ScreenBounds: CGRect = UIScreen.mainScreen().bounds
public let ShopCarRedDotAnimationDuration: NSTimeInterval = 0.2

// MARK: - Home 属性
public let HotViewMargin: CGFloat = 10
public let HomeCollectionViewCellMargin: CGFloat = 10
public let HomeCollectionTextFont = UIFont.systemFontOfSize(14)
public let HomeCollectionCellAnimationDuration: NSTimeInterval = 1.0

// MARK: - 广告页通知
public let ADImageLoadSecussed = "ADImageLoadSecussed"
public let ADImageLoadFail = "ADImageLoadFail"
/// 首页headView高度改变
public let HomeTableHeadViewHeightDidChange = "HomeTableHeadViewHeightDidChange"

// MARK: - 常用颜色
public let BMGlobalBackgroundColor = UIColor.whiteColor()
public let BMGreyBackgroundColor = UIColor.init(red: 0.96, green: 0.97, blue: 0.97, alpha: 1.0)
public let BMNavigationBarColor = UIColor.colorWithCustom(51, g: 0, b: 51)
public let HomeSearBarBg = UIColor.init(red: 0.59, green: 0.22, blue: 0.59, alpha: 1.0)
public let BtnBg = UIColor.init(red: 0.59, green: 0.22, blue: 0.59, alpha: 1.0)
public let BMTextBlackColor = UIColor(red: 0.24, green: 0.25, blue: 0.25, alpha: 1.0)
public let BMTextGreyColor = UIColor.init(red: 0.54, green: 0.55, blue: 0.55, alpha: 1.0)
public let BMLineColor = UIColor.colorWithCustom(229, g: 229, b: 229)
public let BMInfoLabelBgColor = UIColor.colorWithCustom(248, g: 248, b: 248)
public let BMInfoLabelTextHintColor = UIColor.colorWithCustom(157, g: 157, b: 157)
public let BMInfoLabelTextColor = UIColor.colorWithCustom(25, g: 25, b: 25)

public let NoData: String = "亲,你访问的商品不存在"
public let NetFail: String = "亲,网络暂时连不上,稍后再试吧"
public let ReturnFalse: String = "亲,服务器正在更新,稍后再试吧"
public let Loading: String = "正在加载数据"
//购物车变化
public let ShopCarDidChangeNotification = "ShopCarDidChangeNotification"

public let ShopCarAdd = "ShopCarDidAdd"
public let ShopCarDidReduce = "ShopCarDidReduce"
//判断设备型号

enum UIUserInterfaceIdiom: Int
{
	case Unspecified
	case Phone
	case Pad
}

struct ScreenSize
{
	static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
	static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
	static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
	static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
	static let IS_IPHONE_4_OR_LESS = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
	static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
	static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
	static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
	static let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
//3号服务器：
//public let BaseIP = "http://jsy.nnbetter.com"
//public let BaseURL = BaseIP + "/api/app.asmx/"

//四号服务器：
public let BaseIP = "http://www.888jsy.com"
public let BaseURL = BaseIP + "/api/app.asmx/"

public let BaseImgUrl1 = BaseIP + "/upload/store/"
public let BaseImgUrl2 = "/product/show/thumb100_100/"
public let BaseImgUrl800 = "/product/show/thumb800_800/"
public let logoUrl = "/logo/thumb100_100/"
public let userImgUrl = BaseIP + "/upload/user/thumb100_100/"
public let brandImgUrl = BaseIP + "/upload/brand/thumb100_100/"
public let adImgUrl = BaseIP + "/upload/advert/"