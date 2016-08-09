//
//  SysUtils.swift
//  BrnMall
//
//  Created by luoyp on 16/3/31.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation

class SysUtils {
	static let sysDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

	static func getSysUserDefaults() -> NSUserDefaults
	{
		return sysDefaults
	}

	static func remove(key: String) {
		if (sysDefaults.objectForKey(key) != nil)
		{
			sysDefaults.removeObjectForKey(key)
			sysDefaults.synchronize()
		}
		sysDefaults.synchronize()
	}

	static func save(model: AnyObject, key: String) {
		if (sysDefaults.objectForKey(key) == nil)
		{
			sysDefaults.removeObjectForKey(key)
			sysDefaults.synchronize()
		}
		sysDefaults.setObject(model, forKey: key)
		sysDefaults.synchronize()
	}

	static func get(key: String) -> AnyObject? {

		if (sysDefaults.objectForKey(key) == nil)
		{
			return nil
		}

		return sysDefaults.objectForKey(key)!
	}
	// 判断是否登录
	static func checkIsLogin() -> Bool
	{
		var isTrue = false
		if (sysDefaults.objectForKey("uid") != nil)
		{
			isTrue = true
		}
		return isTrue
	}

	// 返回登录用户
	static func getLoginUser() -> LoginUser
	{
		let data: NSData = sysDefaults.objectForKey("LOGIN_USER") as! NSData
		let user: LoginUser = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! LoginUser
		return user
	}
	static func getSystemTime() -> String {
		let nowDate = NSDate()
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyyMMddHHmmss"

		let dateString = formatter.stringFromDate(nowDate)
		return dateString
	}
//	static func transTime(time: String) -> String {
//		var outputFormat = NSDateFormatter()
//		// 格式化规则
//		outputFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
//		var ns2 = (time as NSString).substringToIndex(10)
//		// 发布时间
//		let pubTime = NSDate(timeIntervalSince1970: Double.init(ns2)!)
//		return outputFormat.stringFromDate(pubTime)
//	}
	/**
	 生成随机字符串,

	 - parameter length: 生成的字符串的长度

	 - returns: 随机生成的字符串
	 */
	static func getRandomStringOfLength(length: Int) -> String {
		let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		var ranStr = ""
		for _ in 0 ..< length {
			let index = Int(arc4random_uniform(UInt32(chars.characters.count)))
			ranStr.append(chars[chars.startIndex.advancedBy(index)])
		}
		return ranStr

	}
}