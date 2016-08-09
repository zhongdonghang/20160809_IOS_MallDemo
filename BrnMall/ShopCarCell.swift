//
//  ShopCarCellTableViewCell.swift
//  BrnMall
//
//  Created by luoyp on 16/4/6.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SnapKit

class ShopCarCell: UITableViewCell {

	static private let identifier = "ShopCarCell"

	// MARK: - 初始化子控件
	private lazy var goodsImageView: UIImageView = {
		let goodsImageView = UIImageView()
		return goodsImageView
	}()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.font = UIFont.systemFontOfSize(14)
		nameLabel.lineBreakMode = .ByWordWrapping
		nameLabel.numberOfLines = 1
		nameLabel.textColor = UIColor.blackColor()
		nameLabel.text = ""
		return nameLabel
	}()
	var checkBtn: UIButton = {
		let checkBtn = UIButton()
		checkBtn.setImage(UIImage.init(named: "uncheck"), forState: UIControlState.Normal)
		return checkBtn
	}()

	private lazy var buyView: BuyView = {
		let buyView = BuyView()
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

	private lazy var lineView: UIView = {
		let lineView = UIView()
		lineView.backgroundColor = UIColor.lightGrayColor()
		lineView.alpha = 0.2
		return lineView
	}()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		selectionStyle = .None
		contentView.backgroundColor = UIColor.whiteColor()

		addSubview(goodsImageView)
		addSubview(lineView)
		addSubview(nameLabel)
		addSubview(shopPriceLabel)

		addSubview(checkBtn)
		addSubview(buyView)
		weak var tmpSelf = self
		buyView.clickAddShopCar = {

			if tmpSelf!.addProductClick != nil {
				tmpSelf!.addProductClick!(imageView: tmpSelf!.goodsImageView)
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView) -> ShopCarCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ShopCarCell

		if cell == nil {
			cell = ShopCarCell(style: .Default, reuseIdentifier: identifier)
		}
		print("cell \(cell)")
		// cell?.selectionStyle = UITableViewCellSelectionStyle.Default
		return cell!
	}
	var ischeck: Bool = false {
		didSet {
			if ischeck {
				checkBtn.setImage(UIImage.init(named: "check"), forState: UIControlState.Normal)
			} else {
				checkBtn.setImage(UIImage.init(named: "uncheck"), forState: UIControlState.Normal)
			}
		}
	}
	// MARK: - 模型set方法
	var goods: ShopCar? {
		didSet {
			ischeck = (goods?.isCheck)!
			goodsImageView.sd_setImageWithURL(NSURL(string: BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!), placeholderImage: UIImage(named: "goodsdefault"))
			print("image URL :" + BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!)
			nameLabel.text = goods?.name

			if SysUtils.get("zhekou") != nil && SysUtils.get("zhekoutitle") != nil {
				let p = SysUtils.get("zhekou") as! NSString
				print("zhekou \(p.doubleValue*10/100)")
				let p1 = Double.init((goods?.shopPrice)!)

				let price = p1! * ((p.doubleValue * 10) / 100)

				shopPriceLabel.text = "￥ \(price.format())  (\(SysUtils.get("zhekoutitle")!))"

			} else {
				shopPriceLabel.text = "￥" + (goods?.shopPrice)!
                	}
			buyView.goods = goods
		}
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		checkBtn.frame = CGRectMake(6, height / 2 - 9, 18, 18)
		goodsImageView.frame = CGRectMake(36, 10, ScreenWidth * 0.7 * 0.25, height - 20)

		nameLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(15)
			make.left.equalTo(ScreenWidth * 0.7 * 0.25 + 40)
			make.width.equalTo(ScreenWidth - (ScreenWidth * 0.7 * 0.25 + 45))
		})
		shopPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(nameLabel.snp_bottom).offset(15)
			make.left.equalTo(nameLabel.snp_left)

		})
		buyView.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(shopPriceLabel.snp_bottom).offset(10)
			make.right.equalTo(nameLabel.snp_right).offset(0)
			make.width.equalTo(80)
			make.height.equalTo(25)
		})

		lineView.frame = CGRectMake(5, height - 1, width - 10, 1)
	}
}
