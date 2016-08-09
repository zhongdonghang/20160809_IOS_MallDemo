//
//  RelationshipModel.swift
//  BrnMall
//
//  Created by luoyp on 16/6/15.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class RelationshipModel {
	init(NickName nickName: String, Name name: String, Time time: String) {
		self.nickName = nickName
		self.realName = name
		self.time = time

	}
	var nickName = ""
	var realName = ""
	var time = ""

}