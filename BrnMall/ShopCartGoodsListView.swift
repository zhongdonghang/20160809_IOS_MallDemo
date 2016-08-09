//
//  File.swift
//  BrnMall
//
//  Created by luoyp on 16/4/8.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class ShopCartGoodsListView: UIView {

	var goodsHeight: CGFloat = 0

	private var lastViewY: CGFloat = 0

	init(frame: CGRect, goodses: [ShopCar]) {
		super.init(frame: frame)

		backgroundColor = UIColor.whiteColor()

		for i in 0 ..< goodses.count {
			let goods = goodses[i]

			buildLineView(CGRectMake(15, lastViewY, ScreenWidth - 15, 0.5))

			let goodsDetailView = PayGoodsDetailView(frame: CGRectMake(0, lastViewY + 10, ScreenWidth, 20))
			goodsDetailView.goods = goods
			addSubview(goodsDetailView)
			lastViewY += 40
			goodsHeight += 40
		}

		let lineView = UIView(frame: CGRectMake(15, lastViewY - 0.5, ScreenWidth - 15, 0.5))
		lineView.backgroundColor = UIColor.blackColor()
		lineView.alpha = 0.1
		addSubview(lineView)

		goodsHeight += 40

		let finePriceLabel = UILabel(frame: CGRectMake(50, lastViewY, ScreenWidth - 60, 40))
		finePriceLabel.textAlignment = NSTextAlignment.Right
		finePriceLabel.textColor = UIColor.redColor()
		finePriceLabel.font = UIFont.systemFontOfSize(14)
		finePriceLabel.text = "合计:￥ " + totalPay(goodses)
		// + UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
		addSubview(finePriceLabel)

		let lineView1 = UIView(frame: CGRectMake(0, goodsHeight - 1, ScreenWidth, 1))
		lineView1.backgroundColor = UIColor.blackColor()
		lineView1.alpha = 0.1
		addSubview(lineView1)
	}

	func totalPay(goodses: [ShopCar]) -> String {
		var count = 0.0
		for i in 0 ... (goodses.count - 1) {
			count += (Double.init(goodses[i].shopPrice)! * Double.init(goodses[i].buyCount)!)
		}
		return String.init(count)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func buildLineView(lineFrame: CGRect) {
		let lineView = UIView(frame: lineFrame)
		lineView.backgroundColor = UIColor.blackColor()
		lineView.alpha = 0.1

		addSubview(lineView)
	}
}

class PayGoodsDetailView: UIView {

	let titleLabel = UILabel()
	let numberLabel = UILabel()
	let priceLabel = UILabel()
	let giftImageView = UIImageView()

	var isShowImageView = false

	var goods: ShopCar? {
		didSet {

			titleLabel.text = goods?.name

			numberLabel.text = "x" + "\(goods!.buyCount)"
			priceLabel.text = "￥" + (goods!.shopPrice)
			giftImageView.hidden = false
			giftImageView.sd_setImageWithURL(NSURL(string: BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!), placeholderImage: UIImage(named: "goodsdefault"))
			isShowImageView = true
			priceLabel.hidden = true
		}
	}

	override init(frame: CGRect) {
		super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 20))

		titleLabel.font = UIFont.systemFontOfSize(13)
		titleLabel.textColor = UIColor.blackColor()
		titleLabel.textAlignment = NSTextAlignment.Left
		addSubview(titleLabel)

		numberLabel.font = UIFont.systemFontOfSize(13)
		numberLabel.textColor = UIColor.blackColor()
		numberLabel.textAlignment = NSTextAlignment.Left
		addSubview(numberLabel)

//		priceLabel.font = UIFont.systemFontOfSize(13)
//		priceLabel.textColor = UIColor.blackColor()
//		priceLabel.textAlignment = NSTextAlignment.Right
//		addSubview(priceLabel)

		giftImageView.hidden = true
		giftImageView.image = UIImage(named: "zengsong")
		addSubview(giftImageView)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		if isShowImageView {
			giftImageView.frame = CGRectMake(15, (height - 20) * 0.5, 40, 20)
			titleLabel.frame = CGRectMake(CGRectGetMaxX(giftImageView.frame) + 5, 0, width * 0.75, height)
			numberLabel.frame = CGRectMake(ScreenWidth * 0.92, 0, 50, height)
		} else {
			titleLabel.frame = CGRectMake(15, 0, width * 0.75, height)
			numberLabel.frame = CGRectMake(ScreenWidth * 0.92, 0, 50, height)
		}
		// priceLabel.frame = CGRectMake(width - 60 - 10, 0, 60, 20)
	}
}