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

@objc protocol HomeCellDelegate: NSObjectProtocol {
	optional func homeCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int)
}
class HomeTableViewCell: UITableViewCell {

	static private let identifier = "HomeTableViewCell"
	var isBrand = false
	private var indexPath: NSIndexPath?
	weak var delegate: HomeCellDelegate?

	// MARK: - 初始化子控件
	private lazy var goodsImageView: UIImageView = {
		let goodsImageView = UIImageView()
		return goodsImageView
	}()
	private lazy var jxImageView: UIImageView = {
		let jxImageView = UIImageView()
		jxImageView.image = UIImage.init(named: "jingxuan.png")
		return jxImageView
	}()
	private lazy var buyBtn: UIButton = {
		let buyBtn = UIButton()
		buyBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
		buyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		buyBtn.layer.masksToBounds = true
		buyBtn.layer.cornerRadius = 2
		buyBtn.layer.borderColor = UIColor.init(red: 0.98, green: 0.45, blue: 0.16, alpha: 1.0).CGColor
		buyBtn.layer.borderWidth = 0.5
		buyBtn.backgroundColor = UIColor.init(red: 0.98, green: 0.45, blue: 0.16, alpha: 1.0)
		buyBtn.setTitle("加入购物车", forState: UIControlState.Normal)
		buyBtn.addTarget(self, action: "homeCellButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
		buyBtn.enabled = true
		return buyBtn
	}()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.lineBreakMode = .ByWordWrapping
		nameLabel.numberOfLines = 0

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			nameLabel.font = UIFont.systemFontOfSize(13)
		} else {
			nameLabel.font = UIFont.systemFontOfSize(11)
		}
		nameLabel.textColor = UIColor.blackColor()
		return nameLabel
	}()

	private lazy var shopPriceLabel: UILabel = {
		let shopPriceLabel = UILabel()
		shopPriceLabel.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.53, alpha: 1.00)

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			shopPriceLabel.font = UIFont.systemFontOfSize(13)
		} else {
			shopPriceLabel.font = UIFont.systemFontOfSize(11)
		}
		shopPriceLabel.textAlignment = .Left

		return shopPriceLabel
	}()

	private lazy var marketPriceLabel: UILabel = {
		let marketPriceLabel = UILabel()
		marketPriceLabel.font = UIFont.italicSystemFontOfSize(10)
		marketPriceLabel.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.53, alpha: 1.00)
		marketPriceLabel.textAlignment = .Left
		return marketPriceLabel
	}()

	private lazy var memberPriceLabel: UILabel = {
		let memberPriceLabel = UILabel()
		memberPriceLabel.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.53, alpha: 1.00)

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			memberPriceLabel.font = UIFont.italicSystemFontOfSize(12)
		} else {
			memberPriceLabel.font = UIFont.italicSystemFontOfSize(10)
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

		// selectionStyle = .Default
		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		contentView.backgroundColor = UIColor.whiteColor()

		addSubview(jxImageView)
		addSubview(goodsImageView)
		addSubview(lineView)
		addSubview(nameLabel)
		addSubview(shopPriceLabel)
		addSubview(marketPriceLabel)
		// addSubview(memberPriceLabel)
		addSubview(buyBtn)
	}

	func homeCellButtonClick(sender: UIButton) {
		weak var tmpSelf = self
		// print("00000000000000")
		if tmpSelf?.delegate != nil {
			if tmpSelf!.delegate!.respondsToSelector("homeCellButtonDidClick:buttonType:") {
				tmpSelf!.delegate!.homeCellButtonDidClick!((tmpSelf?.indexPath)!, buttonType: sender.tag)
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView, index: NSIndexPath) -> HomeTableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? HomeTableViewCell

		if cell == nil {
			cell = HomeTableViewCell(style: .Default, reuseIdentifier: identifier)
		}
		cell?.indexPath = index
		return cell!
	}

	// MARK: - 模型set方法
	var goods: HotGoods? {
		didSet {
			goodsImageView.kf_setImageWithURL(NSURL.init(string: (goods?.body)!)!, placeholderImage: Image.init(named: "goodsdefault"), optionsInfo: [.Transition(.Fade(1))])

			nameLabel.text = goods?.ExtField1

			shopPriceLabel.text = "现价￥ " + (goods?.ExtField2)!
			marketPriceLabel.text = "原价￥ " + (goods?.ExtField3)!

			// 1
			let string = marketPriceLabel.text! as NSString
			var attributedString = NSMutableAttributedString(string: string as String)

			// 2

			let secondAttributes = [NSForegroundColorAttributeName: UIColor.grayColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSStrikethroughStyleAttributeName: 1]

			// 3
			attributedString.addAttributes(secondAttributes, range: string.rangeOfString(string as String))

			// 4
			marketPriceLabel.attributedText = attributedString

			if SysUtils.get("uid") == nil {
				// memberPriceLabel.text = "会员价￥ 登陆可见"
			}
			else {
				if SysUtils.get("zhekou") != nil && SysUtils.get("zhekoutitle") != nil {

					// memberPriceLabel.text = "会员价￥" + (goods?.ExtField5)!
				}
			}
		}
	}
	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		goodsImageView.frame = CGRectMake(15, 10, height + 10, height - 20)

		jxImageView.frame = CGRectMake(height + 28, 10, 30, 18)

		if isBrand {
			nameLabel.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(10)
				make.left.equalTo(jxImageView.snp_right).inset(-2)
				make.right.equalTo(contentView.snp_right).inset(-4)

			})
		} else {
			nameLabel.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(10)
				make.left.equalTo(jxImageView.snp_right).inset(-2)
				make.right.equalTo(contentView.snp_right).inset(-4)

			})
		}

		shopPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(nameLabel.snp_bottom).offset(12)
			make.left.equalTo(goodsImageView.bounds.width + 28)

		})
//		memberPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
//			make.top.equalTo(shopPriceLabel.snp_bottom).offset(2)
//			make.left.equalTo(goodsImageView.bounds.width + 28)
//
//		})
		marketPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(shopPriceLabel.snp_bottom).offset(2)
			make.left.equalTo(goodsImageView.bounds.width + 28)

		})

		buyBtn.snp_makeConstraints(closure: { (make) -> Void in
			make.width.equalTo(75)
			make.height.equalTo(22)
			make.bottom.equalTo(contentView.snp_bottom).offset(-10)
			make.right.equalTo(contentView.snp_right).offset(-10)
			// make.width.equalTo(nameLabel.width)
		})

		// starCount.snp_makeConstraints(closure: { (make) -> Void in
		// make.top.equalTo(marketPriceLabel.snp_bottom).offset(18)
		// make.left.equalTo(marketPriceLabel.snp_left)
		// make.width.equalTo(nameLabel.width)
		// })

		// shopPriceLabel.frame = CGRectMake(CGRectGetMaxX(goodsImageView.frame), CGRectGetMaxY(CGRectMake(CGRectGetMaxX(goodsImageView.frame), CGRectGetMaxY(nameLabel.frame), 35, 15)), width, 20)

		lineView.frame = CGRectMake(5, height - 1, width - 10, 1)
	}
}

