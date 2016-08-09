//
//  HotGoods.swift
//  BrnMall
//
//  Created by luoyp on 16/4/20.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class HotGoods {
	init(Adid adid: String, Adposid adposid: String, Title title: String, Url url: String, Body body: String, ExtField1 e1: String, ExtField2 e2: String, ExtField3 e3: String, ExtField4 e4: String, ExtField5 e5: String) {
		self.adid = adid
		self.adposid = adposid
		self.title = title
		self.url = url
		self.body = body
		self.ExtField1 = e1
		self.ExtField2 = e2
		self.ExtField3 = e3
		self.ExtField4 = e4
		self.ExtField5 = e5
	}
	var adid = ""
	var adposid = ""
	var title = ""
	var url = ""
	var body = ""
	var ExtField1 = ""
	var ExtField2 = ""
	var ExtField3 = ""
	var ExtField4 = ""
	var ExtField5 = ""
}