//
//  BrandModel.swift
//  BrnMall
//
//  Created by luoyp on 16/5/24.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class BrandModel {
	init(ImgUrl imageUrl: String, Name name: String, ID id: String) {
		self.imgUrl = imageUrl
		self.name = name
		self.brandId = id
	}
	var imgUrl = ""
	var name = ""
	var brandId = ""

}