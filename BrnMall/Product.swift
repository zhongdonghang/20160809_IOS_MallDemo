//
//  Product.swift
//  BrnMall
//
//  Created by luoyp on 16/3/28.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class Product {
	init(ImgUrl imageUrl: String, Name name: String, ShopPrice shopPrice: String, MarketPrice marketPrice: String, StarCount starCount: String, ID id: String, CommentCount commentCount: String, StoreID storeId: String, VipPrice vipPrice: String) {
		self.imgUrl = imageUrl
		self.name = name
		self.shopPrice = shopPrice
		self.marketPrice = marketPrice
		self.starCount = starCount
		self.Id = id
		self.commentCount = commentCount
		self.storeId = storeId
		self.vipPrice = vipPrice
	}
	var imgUrl = ""
	var name = ""
	var shopPrice = ""
	var marketPrice = ""
	var vipPrice = ""
	var starCount = ""
	var Id = ""
	var commentCount = ""
	var storeId = ""
}