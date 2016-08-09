//
//  FavoriteProductCell.swift
//  BrnMall
//
//  Created by luoyp on 16/4/15.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SnapKit

class FavoriteProductCell: UITableViewCell {

	static private let identifier = "favoriteProductCell"

	// MARK: - 初始化子控件
	private lazy var goodsImageView: UIImageView = {
		let goodsImageView = UIImageView()
		return goodsImageView
	}()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.font = UIFont.systemFontOfSize(15)
		nameLabel.textColor = BMTextBlackColor
		nameLabel.text = ""
		return nameLabel
	}()

	private lazy var buyView: UIView = {
		let buyView = UIView()
		buyView.backgroundColor = UIColor.grayColor()
		return buyView
	}()

	var addProductClick: ((imageView: UIImageView) -> ())?

	private lazy var shopPriceLabel: UILabel = {
		let shopPriceLabel = UILabel()
		shopPriceLabel.textColor = UIColor.redColor()
		shopPriceLabel.font = UIFont.systemFontOfSize(14)
		shopPriceLabel.textAlignment = .Left
		shopPriceLabel.text = ""
		return shopPriceLabel
	}()

	private lazy var timeLabel: UILabel = {
		let timeLabel = UILabel()
		timeLabel.textColor = BMTextBlackColor
		timeLabel.font = UIFont.systemFontOfSize(12)
		timeLabel.textAlignment = NSTextAlignment.Right
		timeLabel.text = ""
		return timeLabel
	}()

	private lazy var storeNameLabel: UILabel = {
		let storeNameLabel = UILabel()
		storeNameLabel.textColor = BMTextBlackColor
		storeNameLabel.font = UIFont.systemFontOfSize(12)
		storeNameLabel.textAlignment = .Left
		storeNameLabel.text = ""
		return storeNameLabel
	}()

	private lazy var lineView: UIView = {
		let lineView = UIView()
		lineView.backgroundColor = UIColor.lightGrayColor()
		lineView.alpha = 0.2
		return lineView
	}()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		// selectionStyle = .None
		contentView.backgroundColor = UIColor.whiteColor()

		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		addSubview(goodsImageView)
		addSubview(lineView)
		addSubview(nameLabel)
		addSubview(shopPriceLabel)
		addSubview(timeLabel)
		addSubview(storeNameLabel)
		// addSubview(buyView)

		weak var tmpSelf = self
//		buyView.clickAddShopCar = {
//			if tmpSelf!.addProductClick != nil {
//				tmpSelf!.addProductClick!(imageView: tmpSelf!.goodsImageView)
//			}
//		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView) -> FavoriteProductCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? FavoriteProductCell

		if cell == nil {
			cell = FavoriteProductCell(style: .Default, reuseIdentifier: identifier)
		}

		return cell!
	}

	// MARK: - 模型set方法
	var goods: FavoriteProduct? {
		didSet {
			goodsImageView.sd_setImageWithURL(NSURL(string: BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!), placeholderImage: UIImage(named: "goodsdefault"))
			print("image URL :" + BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!)
			nameLabel.text = goods?.name
			shopPriceLabel.text = "￥ " + (goods?.shopprice)!
			timeLabel.text = goods?.addtime
			storeNameLabel.text = goods?.storename
			// buyView.goods = goods
		}
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		goodsImageView.frame = CGRectMake(10, 10, ScreenWidth * 0.7 * 0.25, height - 20)

		nameLabel.frame = CGRectMake(goodsImageView.bounds.width + 15, 10, ScreenWidth - goodsImageView.bounds.width - 20, 20)

		shopPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(nameLabel.snp_bottom).offset(15)
			make.left.equalTo(nameLabel.snp_left)
			make.width.equalTo(nameLabel.width)
		})
//		buyView.snp_makeConstraints(closure: { (make) -> Void in
//			make.top.equalTo(shopPriceLabel.snp_bottom).offset(10)
//			make.right.equalTo(nameLabel.snp_right).offset(0)
//			make.width.equalTo(ScreenWidth / 2)
//			make.height.equalTo(25)
//		})
		storeNameLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(shopPriceLabel.snp_bottom).offset(10)
			make.left.equalTo(nameLabel.snp_left)
			make.width.equalTo((ScreenWidth - goodsImageView.bounds.width + 15) / 2)
			make.height.equalTo(25)
		})
		timeLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(shopPriceLabel.snp_bottom).offset(10)
			make.right.equalTo(nameLabel.snp_right)
			make.width.equalTo((ScreenWidth - goodsImageView.bounds.width + 15) / 2)
			make.height.equalTo(25)
		})

		lineView.frame = CGRectMake(5, height - 1, width - 10, 1)
	}
}
