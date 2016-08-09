//
//  TixianLogModel.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class TixianLogModel {
	init(RecordId: String, Uid: String, State: String, PayType: String, PayAccount: String, ApplyAmount: String, ApplyRemark: String, ApplyTime: String, Phone: String, OperatorUid: String, OperatTime: String, Reason: String) {
		self.RecordId = RecordId
		self.Uid = Uid
		self.State = State
		self.PayType = PayType
		self.PayAccount = PayAccount
		self.ApplyAmount = ApplyAmount
		self.ApplyRemark = ApplyRemark
		self.ApplyTime = ApplyTime
		self.Phone = Phone
		self.OperatorUid = OperatorUid
		self.OperatTime = OperatTime
		self.Reason = Reason

	}

	var RecordId = ""
	var Uid = ""
	var State = ""
	var PayType = ""
	var PayAccount = ""
	var ApplyAmount = ""
	var ApplyRemark = ""
	var ApplyTime = ""
	var Phone = ""
	var OperatorUid = ""
	var OperatTime = ""
	var Reason = ""

}
