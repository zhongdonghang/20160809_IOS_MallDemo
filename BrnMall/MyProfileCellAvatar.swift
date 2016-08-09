//
//  MyProfileCellAvatar.swift
//  BrnMall
//
//  Created by luoyp on 16/6/14.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class MyProfileCellAvatar: UITableViewCell {

	var title: String? {
		didSet {
			titleLabel.text = title

		}
	}
	static private let identifier = "MyProfileCellAvatar"

	class func cellFor(tableView: UITableView) -> MyProfileCellAvatar {

		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MyProfileCellAvatar

		if cell == nil {
			cell = MyProfileCellAvatar(style: .Default, reuseIdentifier: identifier)
		}
		cell?.selectionStyle = UITableViewCellSelectionStyle.Default
		return cell!
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	let bottomLine = UIView()
	private lazy var titleLabel = UILabel()

	private lazy var arrowView = UIImageView()
	var avatarView = UIImageView()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		titleLabel.textColor = UIColor.blackColor()
		titleLabel.font = UIFont.systemFontOfSize(16)
		titleLabel.alpha = 0.8
		contentView.addSubview(titleLabel)

		bottomLine.backgroundColor = UIColor.grayColor()
		bottomLine.alpha = 0.15
		contentView.addSubview(bottomLine)

		arrowView.image = UIImage(named: "icon_go")
		contentView.addSubview(arrowView)

		avatarView.layer.cornerRadius = 35
		avatarView.layer.masksToBounds = true
		contentView.addSubview(avatarView)
		selectionStyle = UITableViewCellSelectionStyle.None
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		arrowView.frame = CGRectMake(width - 20, (height - (arrowView.image?.size.height)!) * 0.5, (arrowView.image?.size.width)!, (arrowView.image?.size.height)!)

		titleLabel.frame = CGRectMake(10, 0, 100, height)
		avatarView.frame = CGRectMake(ScreenWidth - 102, 5, 70, 70)
		let leftMarge: CGFloat = 10
		bottomLine.frame = CGRectMake(leftMarge, height - 0.5, width - 20, 0.5)
	}
}

class MyProfileCellAvatarModel: NSObject {

	var title: String?
	var img: UIImageView?

	init(Title title: String, Img img: UIImageView) {
		self.title = title
		self.img = img
	}
}
