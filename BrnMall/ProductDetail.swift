//
//  ProductDetail.swift
//  BrnMall
//
//  Created by luoyp on 16/3/30.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
import ObjectMapper

//商品信息
struct ProductInfo: Mappable {
	var shopPrice: Double?
	var vipPrice: Double?
	var marketPrice: Double?
	var description: String?
	var pid: Int?
	var name: String?
	var img: String?
	var ReviewCount = 0
	init?(_ map: Map) {
	}

	mutating func mapping(map: Map) {
		pid <- map["Pid"]
		name <- map["Name"]
		img <- map["ShowImg"]
		marketPrice <- map["MarketPrice"]
		shopPrice <- map["ShopPrice"]
		vipPrice <- map["VipPrice"]
		description <- map["Description"]
		ReviewCount <- map["ReviewCount"]
	}
}

//商品图片
struct ProductImage: Mappable {
	var PImgId: Int?
	var Pid: Int?
	var ShowImg: String!
	var IsMain: Int?
	var DisplayOrder: Int?
	var StoreId: Int!

	init?(_ map: Map) {
	}

	mutating func mapping(map: Map) {
		PImgId <- map["PImgId"]
		Pid <- map["Pid"]
		ShowImg <- map["ShowImg"]
		IsMain <- map["IsMain"]
		DisplayOrder <- map["DisplayOrder"]
		StoreId <- map["StoreId"]

	}
}

//店铺信息
struct StoreInfo: Mappable {
	var StoreId: Int?
	var Name: String?
	var Logo: String?

	init?(_ map: Map) {
	}

	mutating func mapping(map: Map) {
		Logo <- map["Logo"]
		Name <- map["Name"]
		StoreId <- map["StoreId"]
	}
}
struct BrandInfo: Mappable {
	var name = ""
	var brandId = 0
	init?(_ map: Map) {
	}
	mutating func mapping(map: Map) {
		name <- map["Name"]
		brandId <- map["BrandId"]
	}
}
struct CategoryInfo: Mappable {
	var name = ""
	var CateId = 0
	init?(_ map: Map) {
	}
	mutating func mapping(map: Map) {
		name <- map["Name"]
		CateId <- map["CateId"]
	}
}
struct DataModel: Mappable {
	var pid: Int?
	var product: ProductInfo?
	var imgList: [ProductImage]?
	var store: StoreInfo?
	var brand: BrandInfo?
	var category: CategoryInfo?
	init?(_ map: Map) {
	}

	mutating func mapping(map: Map) {
		pid <- map["Pid"]
		product <- map["ProductInfo"]
		imgList <- map["ProductImageList"]
		store <- map["StoreInfo"]
		brand <- map["BrandInfo"]
		category <- map["CategoryInfo"]
	}
}

struct ProductDetailModel: Mappable {
	var data: DataModel?
	var result: Bool!

	init?(_ map: Map) {
	}

	mutating func mapping(map: Map) {
		data <- map["data"]
		result <- map["result"]
	}
}
