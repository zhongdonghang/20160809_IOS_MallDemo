//
//  PayLogModel.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class PayLogModel {
	init(LogId: String, Uid: String, UserAmount: Double, ActionTime: String, ActionDes: String, UserFrozenAmount: Double) {
		self.LogId = LogId
		self.Uid = Uid
		self.UserAmount = UserAmount
		self.ActionTime = ActionTime
		self.ActionDes = ActionDes
		self.UserFrozenAmount = UserFrozenAmount

	}
	var LogId = ""
	var Uid = ""
	var UserAmount = 0.0
	var ActionTime = ""
	var ActionDes = ""
	var UserFrozenAmount = 0.0
}
