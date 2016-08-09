//
//  FavoriteProduct.swift
//  BrnMall
//
//  Created by luoyp on 16/4/15.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation

class FavoriteProduct {
	init(ImgUrl imageUrl: String, Name name: String, Recordid recordid: String, Shopprice shopprice: String, Addtime addtime: String, ID id: String, Storename storename: String, StoreID storeId: String) {
		self.imgUrl = imageUrl
		self.name = name
		self.recordid = recordid
		self.shopprice = shopprice
		self.addtime = addtime
		self.Id = id
		self.storename = storename
		self.storeId = storeId
	}
	var imgUrl = ""
	var name = ""
	var recordid = ""
	var shopprice = ""
	var addtime = ""
	var Id = ""
	var storename = ""
	var storeId = ""
}
