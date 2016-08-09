//
//  OrderDetail.swift
//  BrnMall
//
//  Created by luoyp on 16/4/9.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
struct OrderDetailPro
{
	init(Pid pid: String, PName pname: String, Img img: String, StoreId storeId: String, RealCount realCount: String) {
		self.pid = pid
		self.pname = pname
		self.img = img
		self.storeid = storeId
		self.realCount = realCount
	}
	var pid = ""
	var pname = ""
	var img = ""
	var storeid = ""
	var realCount = ""
}

class OrderDetail
{

	init(Oid oid: String, Uid uid: String, OrderState state: String, OrderAmount amount: String, AddTime time: String, StoreId storeId: String, PayName payname: String, ShipTime shipTime: String, Address address: String, BuyerRemark buyerRemark: String, ShipSN shipSN: String, Consignee consignee: String, Mobile mobile: String, OSN oSN: String, SurplusMoney money: String, StoreName storename: String, ShipCoName shipCoName: String, Paymode paymode: String, Isreview isreview: String, ProList prolist: [OrderDetailPro]) {
		self.oid = oid
		self.uid = uid
		self.orderstate = state
		self.surplusMoney = money
		self.orderamount = amount
		self.addtime = time
		self.storeid = storeId
		self.payfriendname = payname
		self.shipTime = shipTime
		self.address = address
		self.buyerRemark = buyerRemark
		self.consignee = consignee
		self.mobile = mobile
		self.shipSN = shipSN
		self.osn = oSN
		self.storename = storename
		self.shipconame = shipCoName
		self.proList = prolist
		self.paymode = paymode
		self.isreview = isreview
	}
	var surplusMoney = ""
	var oid: String = ""
	var osn: String = ""
	var uid: String = ""
	var orderstate: String = ""
	var orderamount: String = ""
	var parentid: String = ""
	var isreview: String = ""
	var addtime: String = ""
	var storeid: String = ""
	var storename: String = ""
	var shipcoid: String = ""
	var shipconame: String = ""
	var shipTime: String = ""
	var shipSN: String = ""
	var payfriendname: String = ""
	var paymode: String = ""
	var consignee: String = ""
	var address: String = ""
	var buyerRemark: String = ""
	var mobile: String = ""
	var proList: [OrderDetailPro] = []
}