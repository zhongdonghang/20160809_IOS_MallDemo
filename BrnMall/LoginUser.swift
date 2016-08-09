//
//  User.swift
//  BrnMall
//
//  Created by luoyp on 16/3/31.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginUser: NSObject, NSCoding, Mappable {

	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(self.uid, forKey: "uid")
		aCoder.encodeObject(self.userName, forKey: "userName")
		aCoder.encodeObject(self.mobile, forKey: "mobile")
		aCoder.encodeObject(self.addr, forKey: "addr")

		aCoder.encodeObject(self.RealName, forKey: "realName")
		aCoder.encodeObject(self.Gender, forKey: "sex")
		aCoder.encodeObject(self.IdCard, forKey: "idCard")
		aCoder.encodeObject(self.Bio, forKey: "jianjie")
		aCoder.encodeObject(self.NickName, forKey: "nicheng")
		aCoder.encodeObject(self.Avatar, forKey: "avatar")
        aCoder.encodeObject(self.RegionId, forKey: "regionId")

	}

	required init?(coder aDecoder: NSCoder) {
		super.init()
		self.uid = aDecoder.decodeObjectForKey("uid") as! Int
		self.userName = aDecoder.decodeObjectForKey("userName") as! String
		self.mobile = aDecoder.decodeObjectForKey("mobile") as! String
		self.addr = aDecoder.decodeObjectForKey("addr") as! String

		self.RealName = aDecoder.decodeObjectForKey("realName") as! String
		self.Gender = aDecoder.decodeObjectForKey("sex") as! Int
        self.RegionId = aDecoder.decodeObjectForKey("regionId") as! Int
		self.IdCard = aDecoder.decodeObjectForKey("idCard") as! String
		self.Bio = aDecoder.decodeObjectForKey("jianjie") as! String
		self.NickName = aDecoder.decodeObjectForKey("nicheng") as! String
		self.Avatar = aDecoder.decodeObjectForKey("avatar") as! String

	}

	required init?(_ map: Map) {
	}

	func mapping(map: Map) {
		uid <- map["Uid"]
		userName <- map["UserName"]
		mobile <- map["Mobile"]
		addr <- map["Address"]

		RealName <- map["RealName"]
		Gender <- map["Gender"]
		IdCard <- map["IdCard"]
		Bio <- map["Bio"]
		NickName <- map["NickName"]
		Avatar <- map["Avatar"]
		RegionId <- map["RegionId"]
	}

	var uid = Int()
	var userName = String()
	var mobile = String()
	var addr = String()

	var RealName = String()
	var Gender = Int()
	var IdCard = String()
	var Bio = String()
	var NickName = String()
	var Avatar = String()
	var RegionId = Int()
}

class UserDataModel: Mappable {
	var user: LoginUser?

	required init?(_ map: Map) {
	}

	func mapping(map: Map) {
		user <- map["UserInfo"]
	}
}

class UserJsonModel: Mappable {
	var data: UserDataModel?
	var result: Bool!

	required init?(_ map: Map) {
	}

	func mapping(map: Map) {
		data <- map["data"]
		result <- map["result"]
	}
}