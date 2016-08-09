//
//  WeChatOrder.swift
//  BrnMall
//
//  Created by luoyp on 16/4/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation

struct WeChatOrder {
	let appid: String
	let mch_id: String
	let device_info: String
	let nonce_str: String
	let sign: String
	let body: String
	let detail: String
	let attach: String
	let out_trade_no: String
	let fee_type: String
	let total_fee: String
	let spbill_create_ip: String
	let time_start: String
	let time_expire: String
	let goods_tag: String
	let notify_url: String
	let trade_type: String
	let product_id: String
	let limit_pay: String
	let openid: String
	
	init(appid: String,
		mch_id: String,
		device_info: String,
		nonce_str: String,
		body: String,
		sign: String,
		detail: String,
		attach: String,
		out_trade_no: String,
		fee_type: String,
		total_fee: String,
		spbill_create_ip: String,
		time_start: String,
		time_expire: String,
		goods_tag: String,
		notify_url: String,
		trade_type: String,
		product_id: String,
		limit_pay: String,
		openid: String) {
			self.appid = appid
			self.mch_id = mch_id
			self.device_info = device_info
			self.nonce_str = nonce_str
			self.sign = sign
			self.body = body
			self.detail = detail
			self.attach = attach
			self.out_trade_no = out_trade_no
			self.fee_type = fee_type
			self.total_fee = total_fee
			self.spbill_create_ip = spbill_create_ip
			self.time_start = time_start
			self.time_expire = time_expire
			self.goods_tag = goods_tag
			self.notify_url = notify_url
			self.trade_type = trade_type
			self.product_id = product_id
			self.limit_pay = limit_pay
			self.openid = openid
	}
}