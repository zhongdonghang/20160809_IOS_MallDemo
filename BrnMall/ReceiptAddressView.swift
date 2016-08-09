//
//  File.swift
//  BrnMall
//
//  Created by luoyp on 16/4/8.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
class ReceiptAddressView: UIView {

	private let topImageView = UIImageView(image: UIImage(named: "v2_shoprail"))
	private let bottomImageView = UIImageView(image: UIImage(named: "v2_shoprail"))
	private let consigneeLabel = UILabel()
	private let phoneNumLabel = UILabel()
	private let receiptAdressLabel = UILabel()
	private let consigneeTextLabel = UILabel()
	private let phoneNumTextLabel = UILabel()
	private let receiptAdressTextLabel = UILabel()
	private let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
	private let modifyButton = UIButton()
	var modifyButtonClickCallBack: (() -> ())?
	var adress: Address? {
		didSet {
			if adress != nil {
				consigneeTextLabel.text = adress?.name
				phoneNumTextLabel.text = adress?.mobile
				receiptAdressTextLabel.text = adress!.address
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = UIColor.whiteColor()

		addSubview(topImageView)
		addSubview(bottomImageView)
		addSubview(arrowImageView)

		modifyButton.setTitle("修改", forState: UIControlState.Normal)
		modifyButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
		modifyButton.addTarget(self, action: "modifyButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
		modifyButton.titleLabel?.font = UIFont.systemFontOfSize(14)
		addSubview(modifyButton)

		initLabel(consigneeLabel, text: "收  货  人  ")
		initLabel(phoneNumLabel, text: "电       话  ")
		initLabel(receiptAdressLabel, text: "收货地址  ")
		initLabel(consigneeTextLabel, text: "")
		initLabel(phoneNumTextLabel, text: "")
		initLabel(receiptAdressTextLabel, text: "")
	}

	convenience init(frame: CGRect, modifyButtonClickCallBack: (() -> ())) {
		self.init(frame: frame)

		self.modifyButtonClickCallBack = modifyButtonClickCallBack
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let leftMargin: CGFloat = 15

		topImageView.frame = CGRectMake(0, 0, width, 2)
		bottomImageView.frame = CGRectMake(0, height - 2, width, 2)
		consigneeLabel.frame = CGRectMake(leftMargin, 10, consigneeLabel.width, consigneeLabel.height)
		consigneeTextLabel.frame = CGRectMake(CGRectGetMaxX(consigneeLabel.frame) + 5, consigneeLabel.y, 150, consigneeLabel.height)
		phoneNumLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(consigneeLabel.frame) + 5, phoneNumLabel.width, phoneNumLabel.height)
		phoneNumTextLabel.frame = CGRectMake(consigneeTextLabel.x, phoneNumLabel.y, 150, phoneNumLabel.height)
		receiptAdressLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(phoneNumTextLabel.frame) + 5, receiptAdressLabel.width, receiptAdressLabel.height)
		receiptAdressTextLabel.frame = CGRectMake(consigneeTextLabel.x, receiptAdressLabel.y, ScreenWidth - consigneeTextLabel.x, receiptAdressLabel.height)
		modifyButton.frame = CGRectMake(width - 60, 0, 30, height)
		arrowImageView.frame = CGRectMake(width - 15, (height - arrowImageView.height) * 0.5, arrowImageView.width, arrowImageView.height)
	}

	private func initLabel(label: UILabel, text: String) {
		label.text = text
		label.font = UIFont.systemFontOfSize(14)
		label.textColor = UIColor.blackColor()
		label.sizeToFit()
		addSubview(label)
	}

	func modifyButtonClick() {
		if modifyButtonClickCallBack != nil {
			modifyButtonClickCallBack!()
		}
	}
}