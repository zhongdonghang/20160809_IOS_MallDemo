//
//  TixianDetailCell.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class TixianDetailCell: UITableViewCell {

	var detail: String? {
		didSet {
			detaildeLabel.text = detail

		}
	}
	var title: String? {
		didSet {
			titleLabel.text = title

		}
	}
	static private let identifier = "TixianDetailCell"

	class func cellFor(tableView: UITableView) -> TixianDetailCell {

		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TixianDetailCell

		if cell == nil {
			cell = TixianDetailCell(style: .Default, reuseIdentifier: identifier)
		}
		cell?.selectionStyle = UITableViewCellSelectionStyle.Default
		return cell!
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	let bottomLine = UIView()
	private lazy var titleLabel = UILabel()
	private lazy var detaildeLabel = UILabel()
	private lazy var arrowView = UIImageView()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		titleLabel.textColor = UIColor.blackColor()
		titleLabel.font = UIFont.systemFontOfSize(13)
		titleLabel.alpha = 0.8
		contentView.addSubview(titleLabel)

		bottomLine.backgroundColor = UIColor.grayColor()
		bottomLine.alpha = 0.15
		contentView.addSubview(bottomLine)

		arrowView.image = UIImage(named: "icon_go")
		// contentView.addSubview(arrowView)

		detaildeLabel.font = UIFont.systemFontOfSize(13)
		detaildeLabel.alpha = 0.8
		detaildeLabel.numberOfLines = 0
		detaildeLabel.textAlignment = .Right
		contentView.addSubview(detaildeLabel)
		selectionStyle = UITableViewCellSelectionStyle.None
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		// arrowView.frame = CGRectMake(width - 20, (height - (arrowView.image?.size.height)!) * 0.5, (arrowView.image?.size.width)!, (arrowView.image?.size.height)!)

		titleLabel.frame = CGRectMake(10, 0, 60, height)
		detaildeLabel.frame = CGRectMake(70, 0, ScreenWidth - 75, height)
		let leftMarge: CGFloat = 20
		bottomLine.frame = CGRectMake(leftMarge, height - 0.5, width - leftMarge, 0.5)
	}
}

