//
//  CustomHeaderCell.swift
//  IOS8SwiftHeaderFooterTutorial
//
//  Created by Arthur Knopper on 09/12/14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//

import UIKit

class CustomHeaderCell: UITableViewCell {

	static private let identifier = "CustomHeaderCell"

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.font = UIFont.systemFontOfSize(15)
		nameLabel.textColor = UIColor.blackColor()
		return nameLabel
	}()

	var addButtonClick: ((imageView: UIImageView) -> ())?

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		selectionStyle = .None
		contentView.backgroundColor = UIColor.whiteColor()

		backgroundColor = UIColor.whiteColor()

		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		addSubview(nameLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - 模型set方法
	// var activities: Activities? {
	// didSet {
	// self.type = .Horizontal
	// backImageView.sd_setImageWithURL(NSURL(string: activities!.img!), placeholderImage: UIImage(named: "v2_placeholder_full_size"))
	// }
	// }

	var goods: String? {
		didSet {

			nameLabel.text = goods

		}
	}

	class func cellWithTableView(tableView: UITableView) -> CustomHeaderCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomHeaderCell

		if cell == nil {
			cell = CustomHeaderCell(style: .Default, reuseIdentifier: identifier)
		}

		return cell!
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()
		nameLabel.frame = CGRectMake(5, 5, width, 20)
	}
}