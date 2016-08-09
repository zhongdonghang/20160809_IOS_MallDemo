//
//  BrandCell.swift
//  BrnMall
//
//  Created by luoyp on 16/5/24.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import Kingfisher

class BrandCell: UICollectionViewCell {

	// MARK: Lazy Property
	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textColor = BMTextGreyColor
		nameLabel.highlightedTextColor = UIColor.blackColor()
		nameLabel.backgroundColor = UIColor.clearColor()
		nameLabel.textAlignment = NSTextAlignment.Center

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			nameLabel.font = UIFont.systemFontOfSize(13)
		} else {
			nameLabel.font = UIFont.systemFontOfSize(10)
		}
		return nameLabel
	}()
	private lazy var logoImageView: UIImageView = {
		let logoImageView = UIImageView()
		logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
		return logoImageView
	}()

	// MARK: 模型setter方法
	var brand: BrandModel! {
		didSet {
			nameLabel.text = brand.name
			logoImageView.kf_setImageWithURL(NSURL.init(string: (brand.imgUrl))!, placeholderImage: Image.init(named: "goodsdefault"), optionsInfo: [.Transition(.Fade(1))])
		}
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		// backgroundColor = BMGreyBackgroundColor

		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView
		addSubview(logoImageView)
		addSubview(nameLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		nameLabel.frame = bounds
		logoImageView.frame = CGRectMake(2, 20, (ScreenWidth * 0.75 - HomeCollectionViewCellMargin * 2) * 0.33 - 10, 60)
		nameLabel.frame = CGRectMake(0, CGRectGetMaxY(logoImageView.frame) + 5, width, 20)
	}
}

