//
//  PayLogCell.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SnapKit
import Cosmos

class PayLogCell: UITableViewCell {

	static private let identifier = "PayLogCell"

	private lazy var jiedongLabel: UILabel = {
		let jiedongLabel = UILabel()
		// nickNameLabel.backgroundColor = UIColor.blueColor()
		jiedongLabel.textAlignment = NSTextAlignment.Left
		jiedongLabel.lineBreakMode = .ByWordWrapping
		jiedongLabel.numberOfLines = 0
		jiedongLabel.font = UIFont.systemFontOfSize(14)
		jiedongLabel.textColor = UIColor.blackColor()
		return jiedongLabel
	}()

	private lazy var dongjieLabel: UILabel = {
		let dongjieLabel = UILabel()
		// realNameLabel.backgroundColor = UIColor.grayColor()
		dongjieLabel.textColor = BMInfoLabelTextColor
		dongjieLabel.font = UIFont.systemFontOfSize(14)
		dongjieLabel.textAlignment = .Right

		return dongjieLabel
	}()

	private lazy var mingxiLabel: UILabel = {
		let mingxiLabel = UILabel()
		mingxiLabel.font = UIFont.systemFontOfSize(13)
		mingxiLabel.textColor = BMInfoLabelTextColor
		mingxiLabel.lineBreakMode = .ByWordWrapping
		mingxiLabel.numberOfLines = 0
		mingxiLabel.textAlignment = .Left
		return mingxiLabel
	}()
	private lazy var timeLabel: UILabel = {
		let timeLabel = UILabel()
		timeLabel.font = UIFont.systemFontOfSize(12)
		timeLabel.textColor = BMInfoLabelTextColor
		timeLabel.lineBreakMode = .ByWordWrapping
		timeLabel.numberOfLines = 0
		timeLabel.textAlignment = .Right
		return timeLabel
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

		addSubview(jiedongLabel)
		addSubview(dongjieLabel)
		addSubview(mingxiLabel)
		addSubview(timeLabel)
		addSubview(lineView)

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView, index: NSIndexPath) -> PayLogCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? PayLogCell

		if cell == nil {
			cell = PayLogCell(style: .Default, reuseIdentifier: identifier)
		}

		return cell!
	}

	// MARK: - 模型set方法
	var log: PayLogModel? {
		didSet {
			jiedongLabel.text = "解冻 \(log!.UserAmount)"
			dongjieLabel.text = "冻结 \(log!.UserFrozenAmount)"
			mingxiLabel.text = "资金明细: \(log!.ActionDes)"
			timeLabel.text = log!.ActionTime
		}
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		jiedongLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(contentView).offset(12)
			make.width.equalTo(ScreenWidth / 2)
			make.left.equalTo(contentView).offset(15)

		})
		dongjieLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(contentView).offset(12)
			make.width.equalTo(ScreenWidth / 2 - 30)

			make.left.equalTo(jiedongLabel.snp_right).offset(5)
		})
		mingxiLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(dongjieLabel.snp_bottom).offset(10)
			make.width.equalTo(ScreenWidth - 25)
			make.left.equalTo(contentView).offset(15)
		})
		timeLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(mingxiLabel.snp_bottom).offset(15)
			make.width.equalTo(ScreenWidth - 25)
			make.left.equalTo(contentView).offset(15)
		})

		lineView.frame = CGRectMake(5, height - 1, width - 15, 1)
	}
}
