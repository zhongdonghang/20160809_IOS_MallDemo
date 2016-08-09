//
//  HomeTableViewCell.swift
//  BrnMall
//
//  Created by luoyp on 16/6/1.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SnapKit
import Cosmos
import Kingfisher

class HomeItemCell: UITableViewCell {

	static private let identifier = "HomeItemCell"
	var isBrand = false
	private var indexPath: NSIndexPath?
	weak var delegate: HomeCellDelegate?

	// MARK: - 初始化子控件
	private lazy var goodsImageView: UIImageView = {
		let goodsImageView = UIImageView()
		return goodsImageView
	}()
	private lazy var buyBtn: UIButton = {
		let buyBtn = UIButton()

		return buyBtn
	}()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.lineBreakMode = .ByWordWrapping
		nameLabel.numberOfLines = 0

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			nameLabel.font = UIFont.systemFontOfSize(14)
		} else {
			nameLabel.font = UIFont.systemFontOfSize(12)
		}
		nameLabel.textColor = BMTextBlackColor
		return nameLabel
	}()

	private lazy var shopPriceLabel: UILabel = {
		let shopPriceLabel = UILabel()
		shopPriceLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.53, alpha: 1.0)

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			shopPriceLabel.font = UIFont.systemFontOfSize(14)
		} else {
			shopPriceLabel.font = UIFont.systemFontOfSize(12)
		}
		shopPriceLabel.textAlignment = .Left

		return shopPriceLabel
	}()

	private lazy var marketPriceLabel: UILabel = {
		let marketPriceLabel = UILabel()

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			marketPriceLabel.font = UIFont.systemFontOfSize(13)
		} else {
			marketPriceLabel.font = UIFont.systemFontOfSize(11)
		}
		marketPriceLabel.textColor = UIColor.init(red: 0.51, green: 0.51, blue: 0.52, alpha: 1.0)
		marketPriceLabel.textAlignment = .Left
		return marketPriceLabel
	}()

	private lazy var memberPriceLabel: UILabel = {
		let memberPriceLabel = UILabel()
		memberPriceLabel.textColor = UIColor.redColor()

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			memberPriceLabel.font = UIFont.systemFontOfSize(13)
		} else {
			memberPriceLabel.font = UIFont.systemFontOfSize(11)
		}
		memberPriceLabel.textAlignment = .Left

		return memberPriceLabel
	}()

	private lazy var lineView: UIView = {
		let lineView = UIView()
		lineView.backgroundColor = UIColor.lightGrayColor()
		lineView.alpha = 0.2
		return lineView
	}()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		selectionStyle = .None
		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
		setupViews()
//		addSubview(goodsImageView)
//		addSubview(lineView)
//		addSubview(nameLabel)
//		addSubview(shopPriceLabel)
//		addSubview(marketPriceLabel)
//		// addSubview(memberPriceLabel)
//		addSubview(buyBtn)
	}

	func setupViews() {

		var btntag = 3313
		for index in 0 ... 4 {
			let view = UIView()
			contentView.addSubview(view)
			view.snp_makeConstraints(closure: { (make) -> Void in
				make.centerY.equalTo(contentView.snp_centerY)

				make.left.equalTo(index * Int(ScreenWidth / 5))
				make.width.equalTo(ScreenWidth / 5)
				make.height.equalTo(height)

			})
			btntag += 1
			print(btntag)
			let btn = UIButton()
			btn.setBackgroundImage(UIImage.init(named: "item\(index)"), forState: UIControlState.Normal)

			btn.tag = btntag
			btn.addTarget(self, action: "homeCellButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
			view.addSubview(btn)
			btn.snp_makeConstraints(closure: { (make) -> Void in
				make.centerY.equalTo(contentView.snp_centerY)
				make.centerX.equalTo(view.snp_centerX)
				make.width.equalTo(40)
				make.height.equalTo(60)

			})

		}
	}

	func homeCellButtonClick(sender: UIButton) {
		weak var tmpSelf = self

		if tmpSelf?.delegate != nil {
			if tmpSelf!.delegate!.respondsToSelector("homeCellButtonDidClick:buttonType:") {
				tmpSelf!.delegate!.homeCellButtonDidClick!((tmpSelf?.indexPath)!, buttonType: sender.tag)
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView, index: NSIndexPath) -> HomeItemCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? HomeItemCell

		if cell == nil {
			cell = HomeItemCell(style: .Default, reuseIdentifier: identifier)
		}
		cell?.indexPath = index
		return cell!
	}

	// MARK: - 模型set方法
	var goods: HotGoods? {
		didSet {

		}
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

//		goodsImageView.frame = CGRectMake(15, 10, height - 20, height - 20)
//
//		if isBrand {
//			nameLabel.snp_makeConstraints(closure: { (make) -> Void in
//				make.top.equalTo(10)
//				make.left.equalTo(goodsImageView.bounds.width + 20)
//				make.width.equalTo(ScreenWidth - goodsImageView.bounds.width - 20)
//
//			})
//		} else {
//			nameLabel.snp_makeConstraints(closure: { (make) -> Void in
//				make.top.equalTo(10)
//				make.left.equalTo(goodsImageView.bounds.width + 20)
//				make.width.equalTo(ScreenWidth - goodsImageView.bounds.width - 20)
//
//			})
//		}
//		shopPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
//			make.top.equalTo(nameLabel.snp_bottom).offset(12)
//			make.left.equalTo(nameLabel.snp_left)
//
//		})
//		marketPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
//			make.top.equalTo(nameLabel.snp_bottom).offset(14)
//			make.left.equalTo(shopPriceLabel.snp_right).offset(5)
//			// make.width.equalTo(nameLabel.width)
//		})
//		buyBtn.snp_makeConstraints(closure: { (make) -> Void in
//			make.width.equalTo(70)
//			make.height.equalTo(22)
//			make.bottom.equalTo(contentView.snp_bottom).offset(-10)
//			make.right.equalTo(contentView.snp_right).offset(-10)
//			// make.width.equalTo(nameLabel.width)
//		})
//		// memberPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
//		// make.top.equalTo(shopPriceLabel.snp_bottom).offset(8)
//		// make.left.equalTo(shopPriceLabel.snp_left)
//		// make.width.equalTo(nameLabel.width)
//		// })
//
//		// starCount.snp_makeConstraints(closure: { (make) -> Void in
//		// make.top.equalTo(marketPriceLabel.snp_bottom).offset(18)
//		// make.left.equalTo(marketPriceLabel.snp_left)
//		// make.width.equalTo(nameLabel.width)
//		// })
//
//		// shopPriceLabel.frame = CGRectMake(CGRectGetMaxX(goodsImageView.frame), CGRectGetMaxY(CGRectMake(CGRectGetMaxX(goodsImageView.frame), CGRectGetMaxY(nameLabel.frame), 35, 15)), width, 20)
//
//		lineView.frame = CGRectMake(5, height - 1, width - 10, 1)
	}
}

