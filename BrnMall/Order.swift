//
//  Order.swift
//  BrnMall
//
//  Created by luoyp on 16/4/8.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation

struct OrderPro
{
	init(Pid pid: String, PName pname: String, Img img: String, StoreId storeId: String) {
		self.pid = pid
		self.pname = pname
		self.img = img
		self.storeid = storeId
	}
	var pid = ""
	var pname = ""
	var img = ""
	var storeid = ""
}

class Order
{

	init(Oid oid: String, Uid uid: String, OrderState state: String, OrderAmount amount: String, AddTime time: String, StoreId storeId: String, PayName payname: String, StoreName storeName: String, OSN osn: String, RealPay realpay: String, Paymode paymode: String, Isreview isreview: String, ProList prolist: [OrderPro]) {
		self.oid = oid
		self.uid = uid
		self.orderstate = state
		self.orderamount = amount
		self.addtime = time
		self.storeid = storeId
		self.payfriendname = payname
		self.proList = prolist
		self.storename = storeName
		self.osn = osn
		self.realPay = realpay
		self.paymode = paymode
		self.isreview = isreview
	}
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
	var payfriendname: String = ""
	var paymode: String = ""
	var realPay: String = ""
	var consignee: String = ""
	var proList: [OrderPro] = []
}
