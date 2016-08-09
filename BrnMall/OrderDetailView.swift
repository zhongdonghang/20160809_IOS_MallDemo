//
//  File.swift
//  BrnMall
//
//  Created by luoyp on 16/4/9.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class OrderDetailView: UIView {

	var order: OrderDetail? {
		didSet {
			initLabel(orderNumberLabel, text: ("订  单  号    " + order!.osn))
			initLabel(consigneeLabel, text: ("配送单号    " + order!.shipSN))
			initLabel(orderBuyTimeLabel, text: ("下单时间   " + order!.addtime))
			if order!.shipTime.containsString("1900") {
				initLabel(deliverTimeLabel, text: "配送时间  未备送")
			}
			else {
				initLabel(deliverTimeLabel, text: "配送时间  " + order!.shipTime)
			}
			initLabel(deliverWayLabel, text: "配送方式 " + order!.shipconame)
			initLabel(payWayLabel, text: "支付方式 " + order!.payfriendname)

			initLabel(remarksLabel, text: "备注信息 " + order!.buyerRemark)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.whiteColor()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let orderNumberLabel = UILabel()
	let consigneeLabel = UILabel()
	let orderBuyTimeLabel = UILabel()
	let deliverTimeLabel = UILabel()
	let deliverWayLabel = UILabel()
	let payWayLabel = UILabel()
	let remarksLabel = UILabel()

	private func initLabel(label: UILabel, text: String) {
		label.text = text
		label.font = UIFont.systemFontOfSize(14)
		label.textColor = BMTextBlackColor
		addSubview(label)
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let leftMargin: CGFloat = 10
		let labelWidth: CGFloat = width - 2 * leftMargin
		let labelHeight: CGFloat = 25

		orderNumberLabel.frame = CGRectMake(leftMargin, 5, labelWidth, labelHeight)
		consigneeLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(orderNumberLabel.frame), labelWidth, labelHeight)
		orderBuyTimeLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(consigneeLabel.frame), labelWidth, labelHeight)
		deliverTimeLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(orderBuyTimeLabel.frame), labelWidth, labelHeight)
		deliverWayLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(deliverTimeLabel.frame), labelWidth, labelHeight)
		payWayLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(deliverWayLabel.frame), labelWidth, labelHeight)
		remarksLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(payWayLabel.frame), labelWidth, labelHeight)
	}
}
