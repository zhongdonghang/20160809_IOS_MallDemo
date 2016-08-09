//
//  MyOrderCell.swift
//  BrnMall
//
//  Created by luoyp on 16/4/8.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {

	private var timeLabel: UILabel?
	private var statusTextLabel: UILabel?
	private var lineView1: UIView?
	private var goodsImage: OrderImageViews?
	private var lineView2: UIView?
	private var payWay: UILabel?
	private var productsPriceLabel: UILabel?
	private var payLabel: UILabel?
	private var storeLabel: UILabel?
	private var payButton: UIButton?
	private var cancelButton: UIButton?
	private var lineView3: UIView?
	private var buttons: UIView?
	private var indexPath: NSIndexPath?

	weak var delegate: MyOrderCellDelegate?

	var order: Order? {
		didSet {
			timeLabel?.text = order?.addtime
			storeLabel?.text = "配送店铺: " + (order?.storename)!
			payWay?.hidden = false
			if "10" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "已提交"
			}
			if "30" == order?.orderstate {
				payButton?.hidden = false
				cancelButton?.hidden = false
				payWay?.hidden = true
				payButton!.setTitle("现在付款", forState: UIControlState.Normal)
				statusTextLabel?.text = "等待付款"
			}
			if "50" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "确认中"
			}
			if "70" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "已确认"
			}
			if "90" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "已备货"
			}
			if "110" == order?.orderstate {
				statusTextLabel?.text = "已发货"
				if order?.paymode == "1" {
					payButton?.hidden = false
					cancelButton?.hidden = true
					payButton!.setTitle("确认收货", forState: UIControlState.Normal)

				} else {
					payButton?.hidden = true
					cancelButton?.hidden = true

				}
			}
			if "140" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "已收货"
				if order?.isreview == "0" {
					payButton?.hidden = false
					cancelButton?.hidden = true
					payButton!.setTitle("评  价", forState: UIControlState.Normal)

				} else {
					payButton?.hidden = true
					cancelButton?.hidden = true

				}
			}
			if "160" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "已完成"
				if order?.isreview == "0" {
					payButton?.hidden = false
					cancelButton?.hidden = true
					payButton!.setTitle("评  价", forState: UIControlState.Normal)

				} else {
					payButton?.hidden = true
					cancelButton?.hidden = true

				}
			}
			if "180" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "已退货"
			}
			if "200" == order?.orderstate {
				payButton?.hidden = true
				cancelButton?.hidden = true
				statusTextLabel?.text = "已取消"
			}

			goodsImage?.order_goods = order?.proList

			payWay?.text = "支付：" + (order?.payfriendname)!
//			if SysUtils.get("zhekou") != nil && SysUtils.get("zhekoutitle") != nil {
//				let p = SysUtils.get("zhekou") as! NSString
//				print("zhekou \(p.doubleValue*10/100)")
//				let p1 = Double.init((order?.orderamount)!)
//
//				let price = p1! * ((p.doubleValue * 10) / 100)
//
//				productsPriceLabel?.text = "￥\(price.format()) (共\(order!.proList.count)件)"
//
//			} else {

			productsPriceLabel?.text = (order?.realPay)! + " ￥ (共\(order!.proList.count)件)"
			// }

		}
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		// selectionStyle = UITableViewCellSelectionStyle.None

		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		backgroundColor = UIColor.clearColor()
		contentView.backgroundColor = UIColor.whiteColor()

		timeLabel = UILabel()
		timeLabel?.font = UIFont.systemFontOfSize(13)
		timeLabel?.textColor = UIColor.blackColor()
		contentView.addSubview(timeLabel!)

		statusTextLabel = UILabel()
		statusTextLabel?.textAlignment = NSTextAlignment.Right
		statusTextLabel?.font = timeLabel?.font
		statusTextLabel?.textColor = UIColor.redColor()
		contentView.addSubview(statusTextLabel!)

		goodsImage = OrderImageViews()
		// goodsName?.backgroundColor = UIColor.grayColor()
		contentView.addSubview(goodsImage!)

		payWay = UILabel()
		payWay?.textColor = UIColor.grayColor()
		payWay?.textAlignment = NSTextAlignment.Right
		payWay?.font = timeLabel?.font
		contentView.addSubview(payWay!)

		payLabel = UILabel()
		payLabel?.text = "实付: "
		payLabel?.textColor = UIColor.grayColor()
		payLabel?.font = payWay?.font
		contentView.addSubview(payLabel!)

		productsPriceLabel = UILabel()
		productsPriceLabel?.textColor = UIColor.blackColor()
		productsPriceLabel?.textAlignment = NSTextAlignment.Left
		productsPriceLabel?.font = payLabel?.font
		productsPriceLabel?.textColor = UIColor.grayColor()
		contentView.addSubview(productsPriceLabel!)

		lineView1 = UIView()
		lineView1?.backgroundColor = UIColor.lightGrayColor()
		lineView1?.alpha = 0.1
		contentView.addSubview(lineView1!)

		lineView2 = UIView()
		lineView2?.backgroundColor = UIColor.lightGrayColor()
		lineView2?.alpha = 0.1
		contentView.addSubview(lineView2!)

		lineView3 = UIView()
		lineView3?.backgroundColor = UIColor.lightGrayColor()
		lineView3?.alpha = 0.1
		contentView.addSubview(lineView3!)

		buttons = UIView()
		contentView.addSubview(buttons!)

		let btnW: CGFloat = 60
		let btnH: CGFloat = 26

		storeLabel = UILabel(frame: CGRectMake(10, (self.height - btnH) * 0.5, ScreenWidth / 2, btnH))
		storeLabel?.font = UIFont.systemFontOfSize(13)
		storeLabel?.textColor = UIColor.grayColor()
		buttons?.addSubview(storeLabel!)

		for i in 0 ..< 2 {
			if i == 1 {
				cancelButton = UIButton(frame: CGRectMake(ScreenWidth - CGFloat(i + 1) * (btnW + 10) - 5, (self.height - btnH) * 0.5, btnW, btnH))
				cancelButton!.tag = i
				cancelButton!.titleLabel?.font = UIFont.systemFontOfSize(12)
				cancelButton!.setTitleColor(BMNavigationBarColor, forState: .Normal)
				cancelButton!.layer.masksToBounds = true
				cancelButton!.layer.cornerRadius = 5
				cancelButton?.layer.borderColor = BMNavigationBarColor.CGColor
				cancelButton?.layer.borderWidth = 0.5
				cancelButton!.backgroundColor = UIColor.clearColor()
				cancelButton!.setTitle("取消订单", forState: UIControlState.Normal)
				cancelButton!.addTarget(self, action: "orderButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
				cancelButton?.hidden = true
				buttons!.addSubview(cancelButton!)
			}

			if i == 0 {
				payButton = UIButton(frame: CGRectMake(ScreenWidth - CGFloat(i + 1) * (btnW + 10), (self.height - btnH) * 0.5, btnW, btnH))
				payButton!.tag = i
				payButton!.titleLabel?.font = UIFont.systemFontOfSize(12)
				payButton!.setTitleColor(UIColor.redColor(), forState: .Normal)
				payButton!.layer.masksToBounds = true
				payButton!.layer.cornerRadius = 5
				payButton?.layer.borderColor = UIColor.redColor().CGColor
				payButton?.layer.borderWidth = 0.5
				payButton!.backgroundColor = UIColor.clearColor()
				payButton!.setTitle("现在付款", forState: UIControlState.Normal)
				payButton!.addTarget(self, action: "orderButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
				payButton?.hidden = true
				buttons!.addSubview(payButton!)
			}
		}
	}
	func orderButtonClick(sender: UIButton) {
		weak var tmpSelf = self

		if tmpSelf?.delegate != nil {
			if tmpSelf!.delegate!.respondsToSelector("orderCellButtonDidClick:buttonType:") {
				tmpSelf!.delegate!.orderCellButtonDidClick!((tmpSelf?.indexPath)!, buttonType: sender.tag)
			}
		}
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static private let identifier = "OrderCell"
	class func myOrderCell(tableView: UITableView, indexPath: NSIndexPath) -> MyOrderCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MyOrderCell

		if cell == nil {
			cell = MyOrderCell(style: .Default, reuseIdentifier: identifier)
		}

		cell?.indexPath = indexPath

		return cell!
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let margin: CGFloat = 10
		let topViewHeight: CGFloat = 30
		contentView.frame = CGRectMake(0, 0, width, height - 20)
		timeLabel?.frame = CGRectMake(margin, 0, ScreenWidth, topViewHeight)
		statusTextLabel?.frame = CGRectMake(ScreenWidth - 150, 0, 140, topViewHeight)
		lineView1?.frame = CGRectMake(margin, topViewHeight, ScreenWidth - margin, 1)
		goodsImage?.frame = CGRectMake(margin, topViewHeight, width - 20, 65)
		lineView2?.frame = CGRectMake(margin, CGRectGetMaxY(goodsImage!.frame), width - margin, 1)
		productsPriceLabel?.frame = CGRectMake(margin + 35, CGRectGetMaxY(goodsImage!.frame), 130, topViewHeight)
		payLabel?.frame = CGRectMake(margin, productsPriceLabel!.y, 30, topViewHeight)
		payWay?.frame = CGRectMake(180, productsPriceLabel!.y, 120, topViewHeight)
		lineView3?.frame = CGRectMake(margin, CGRectGetMaxY(payLabel!.frame), width - margin, 1)
		buttons?.frame = CGRectMake(0, CGRectGetMaxY(payWay!.frame), width, 40)
	}
}

@objc protocol MyOrderCellDelegate: NSObjectProtocol {
	optional func orderCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int)
}

class OrderImageViews: UIView {

	var imageViews: UIView?
	var arrowImageView: UIImageView?

	var order_goods: [OrderPro]? {
		didSet {
			let imageViewsSubViews = imageViews?.subviews
			for i in 0 ..< order_goods!.count {
				if i < 4 {
					let subImageView = imageViewsSubViews![i] as! UIImageView
					subImageView.hidden = false

					subImageView.sd_setImageWithURL(NSURL(string: BaseImgUrl1 + order_goods![i].storeid + BaseImgUrl2 + order_goods![i].img), placeholderImage: UIImage(named: "goodsdefault"))
				}
			}

			for var i = order_goods!.count; i < 4; i += 1 {
				let subImageView = imageViewsSubViews![i]
				subImageView.hidden = true
			}

			if order_goods?.count >= 5 {
				let subImageView = imageViewsSubViews![4]
				subImageView.hidden = false
			} else {
				let subImageView = imageViewsSubViews![4]
				subImageView.hidden = true
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		imageViews = UIView(frame: CGRectMake(0, 5, ScreenWidth, 55))
		for i in 0 ... 4 {
			let imageView = UIImageView(frame: CGRectMake(CGFloat(i) * 60 + 10, 0, 55, 55))
			if 4 == i {
				imageView.image = UIImage(named: "v2_goodmore")
			}
			imageView.contentMode = UIViewContentMode.ScaleAspectFit
			imageView.hidden = true
			imageViews?.addSubview(imageView)
		}

		arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
		arrowImageView?.frame = CGRectMake(ScreenWidth - 28, (65 - arrowImageView!.bounds.size.height) * 0.5, arrowImageView!.bounds.size.width, arrowImageView!.bounds.size.height)
		imageViews?.addSubview(arrowImageView!)
		addSubview(imageViews!)
	}

	convenience init(frame: CGRect, order_goods: [OrderPro]) {
		self.init(frame: frame)
		self.order_goods = order_goods
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
