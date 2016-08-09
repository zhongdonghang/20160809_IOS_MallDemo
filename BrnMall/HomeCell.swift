//
//  HomeCell.swift
//  BrnMall
//
//  Created by luoyp on 16/4/19.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

enum HomeCellTyep: Int {
	case Horizontal = 0
	case Vertical = 1
}

class HomeCell: UICollectionViewCell {
	// MARK: - 初始化子空间
	private lazy var backImageView: UIImageView = {
		let backImageView = UIImageView()
		return backImageView
	}()

	private lazy var goodsImageView: UIImageView = {
		let goodsImageView = UIImageView()
		goodsImageView.contentMode = UIViewContentMode.ScaleAspectFit
		return goodsImageView
	}()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			nameLabel.font = UIFont.systemFontOfSize(15)
		} else {
			nameLabel.font = UIFont.systemFontOfSize(12)
		}
		nameLabel.textColor = UIColor.blackColor()
		return nameLabel
	}()

	private lazy var fineImageView: UIImageView = {
		let fineImageView = UIImageView()
		fineImageView.image = UIImage(named: "jingxuan.png")
		return fineImageView
	}()

	private lazy var giveImageView: UIImageView = {
		let giveImageView = UIImageView()
		giveImageView.image = UIImage(named: "buyOne.png")
		return giveImageView
	}()

	private lazy var priceLabel: UILabel = {
		let priceLabel = UILabel()
		priceLabel.textColor = UIColor.init(red: 0.97, green: 0.32, blue: 0.0, alpha: 1.0)

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			priceLabel.font = UIFont.systemFontOfSize(14)
		} else {
			priceLabel.font = UIFont.systemFontOfSize(12)
		}
		priceLabel.textAlignment = .Left
		return priceLabel
	}()

	// private var discountPriceView: DiscountPriceView?

	private lazy var buyView: BuyView = {
		let buyView = BuyView()
		return buyView
	}()

	private var type: HomeCellTyep? {
		didSet {
			backImageView.hidden = !(type == HomeCellTyep.Horizontal)
			goodsImageView.hidden = (type == HomeCellTyep.Horizontal)
			nameLabel.hidden = (type == HomeCellTyep.Horizontal)
			fineImageView.hidden = (type == HomeCellTyep.Horizontal)
			giveImageView.hidden = (type == HomeCellTyep.Horizontal)
			priceLabel.hidden = (type == HomeCellTyep.Horizontal)
			// discountPriceView?.hidden = (type == HomeCellTyep.Horizontal)
			buyView.hidden = (type == HomeCellTyep.Horizontal)
		}
	}

	var addButtonClick: ((imageView: UIImageView) -> ())?

	// MARK: - 便利构造方法
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.whiteColor()

		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		addSubview(backImageView)
		addSubview(goodsImageView)
		addSubview(nameLabel)
		addSubview(fineImageView)
		addSubview(giveImageView)
		addSubview(priceLabel)
		// addSubview(buyView)

//		weak var tmpSelf = self
//		buyView.clickAddShopCar = { ()
//			if tmpSelf?.addButtonClick != nil {
//				tmpSelf!.addButtonClick!(imageView: tmpSelf!.goodsImageView)
//			}
//		}
	}

	// MARK: - 模型set方法
//	var activities: Activities? {
//		didSet {
//			self.type = .Horizontal
//			backImageView.sd_setImageWithURL(NSURL(string: activities!.img!), placeholderImage: UIImage(named: "v2_placeholder_full_size"))
//		}
//	}

	var goods: HotGoods? {
		didSet {
			print((goods?.body)!)
			self.type = .Vertical
			if goods?.title == "000" {
				goodsImageView.kf_setImageWithURL(NSURL.init(string: (goods?.body)!)!, placeholderImage: nil, optionsInfo: [.Transition(.Fade(1))])
				nameLabel.text = ""
				priceLabel.text = ""
				fineImageView.hidden = true
			}
			else {
				goodsImageView.kf_setImageWithURL(NSURL.init(string: (goods?.body)!)!, placeholderImage: Image.init(named: "goodsdefault"), optionsInfo: [.Transition(.Fade(1))])
				nameLabel.text = goods?.title
				priceLabel.text = "￥" + (goods?.ExtField2)!
			}

//			if goods!.pm_desc == "买一赠一" {
//				giveImageView.hidden = false
//			} else {
//
//				giveImageView.hidden = true
//			}
//			if discountPriceView != nil {
//				discountPriceView!.removeFromSuperview()
//			}
//			discountPriceView = DiscountPriceView(price: goods?.price, marketPrice: goods?.market_price)
//			addSubview(discountPriceView!)

			// specificsLabel.text = goods?.specifics
			// buyView.goods = goods
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		backImageView.frame = bounds

		goodsImageView.frame = CGRectMake(5, 5, (ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 10, 180)
		nameLabel.frame = CGRectMake(5, CGRectGetMaxY(goodsImageView.frame) + 5, width, 20)

		fineImageView.frame = CGRectMake(5, CGRectGetMaxY(nameLabel.frame) + 10, 30, 15)
		priceLabel.frame = CGRectMake(45, CGRectGetMaxY(nameLabel.frame) + 8, width - 50, 20)

		// fineImageView.frame = CGRectMake(5, CGRectGetMaxY(nameLabel.frame), 30, 15)
		// giveImageView.frame = CGRectMake(CGRectGetMaxX(fineImageView.frame) + 3, fineImageView.y, 35, 15)
		// specificsLabel.frame = CGRectMake(nameLabel.x, CGRectGetMaxY(fineImageView.frame), width, 20)
		// discountPriceView?.frame = CGRectMake(nameLabel.x, CGRectGetMaxY(specificsLabel.frame), 60, height - CGRectGetMaxY(specificsLabel.frame))
		// buyView.frame = CGRectMake(width - 85, height - 30, 80, 25)
	}
}