//
//  CommentModel.swift
//  BrnMall
//
//  Created by luoyp on 16/5/26.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class CommentModel {
	init(NickName nickName: String, ReviewTime reviewTime: String, Content content: String, UserImg userImg: String, Star star: String) {
		self.NickName = nickName
		self.ReviewTime = reviewTime
		self.Content = content
		self.UserImg = userImg
		self.Star = star
	}
	var NickName = ""
	var ReviewTime = ""
	var Content = ""
	var UserImg = ""
	var Star = ""

}