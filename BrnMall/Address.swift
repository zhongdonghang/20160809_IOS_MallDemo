//
//  Address.swift
//  BrnMall
//
//  Created by luoyp on 16/4/7.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class Address {
	init(Uid uid: String, Aid aid: String, Name name: String, RegionId regionId: String, Address address: String, Mobile mobile: String, Phone phone: String, ZipCode zipcode: String, Email email: String, IsDefault isDefault: String, ProvinceName provinceName: String, CityName cityName: String, CountyName countyName: String, Provinceid provinceid: String, Cityid cityid: String, Countyid countyid: String) {
		self.uid = uid
		self.aid = aid
		self.name = name
		self.regionId = regionId
		self.address = address
		self.mobile = mobile
		self.phone = phone
		self.zipcode = zipcode
		self.email = email
		self.isDefault = isDefault
		self.ProvinceName = provinceName
		self.CityName = cityName
		self.CountyName = countyName

		self.Provinceid = provinceid
		self.Cityid = cityid
		self.Countyid = countyid
	}

	var uid = ""
	var aid = ""
	var name = ""
	var regionId = ""
	var address = ""
	var mobile = ""
	var phone = ""
	var zipcode = ""
	var email = ""
	var isDefault = ""
	var ProvinceName = ""
	var CityName = ""
	var CountyName = ""

	var Provinceid = ""
	var Cityid = ""
	var Countyid = ""
}