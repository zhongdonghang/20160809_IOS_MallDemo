//
//  FavoriteStore.swift
//  BrnMall
//
//  Created by luoyp on 16/7/6.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class FavoriteStore {
	init(ImgUrl imageUrl: String, Addtime addtime: String, Storename storename: String, StoreID storeId: String) {
		self.imgUrl = imageUrl
		self.addtime = addtime
		self.storename = storename
		self.storeId = storeId
	}
	var imgUrl = ""
	var addtime = ""
	var storename = ""
	var storeId = "" }