//
//  ShopCar.swift
//  BrnMall
//
//  Created by luoyp on 16/4/6.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class ShopCar {
	init(ImgUrl imageUrl: String, Name name: String, ShopPrice shopPrice: String, BuyCount buyCount: String, ID id: String, Uid uid: String, StoreID storeId: String) {
		self.imgUrl = imageUrl
		self.name = name
		self.shopPrice = shopPrice
		self.buyCount = buyCount
		self.Id = id
		self.uid = uid
		self.storeId = storeId
	}
	var imgUrl = ""
	var name = ""
	var shopPrice = ""
	var buyCount = ""
	var Id = ""
	var uid = ""
	var storeId = ""
	var isCheck = false
}