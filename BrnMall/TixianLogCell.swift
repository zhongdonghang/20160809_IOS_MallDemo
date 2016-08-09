//
//  TixianLogCell.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
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

class TixianLogCell: UITableViewCell {

	static private let identifier = "TixianLogCell"

	private lazy var nickNameLabel: UILabel = {
		let nickNameLabel = UILabel()
		// nickNameLabel.backgroundColor = UIColor.blueColor()
		nickNameLabel.textAlignment = NSTextAlignment.Left
		nickNameLabel.lineBreakMode = .ByWordWrapping
		nickNameLabel.numberOfLines = 0
		nickNameLabel.font = UIFont.systemFontOfSize(14)
		nickNameLabel.textColor = UIColor.blackColor()
		return nickNameLabel
	}()

	private lazy var realNameLabel: UILabel = {
		let realNameLabel = UILabel()
		// realNameLabel.backgroundColor = UIColor.grayColor()
		realNameLabel.textColor = BMNavigationBarColor
		realNameLabel.font = UIFont.systemFontOfSize(14)
		realNameLabel.textAlignment = .Right

		return realNameLabel
	}()

	private lazy var timeLabel: UILabel = {
		let timeLabel = UILabel()
		timeLabel.font = UIFont.systemFontOfSize(13)
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

		addSubview(nickNameLabel)
		addSubview(realNameLabel)
		addSubview(timeLabel)
		addSubview(lineView)

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView, index: NSIndexPath) -> TixianLogCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TixianLogCell

		if cell == nil {
			cell = TixianLogCell(style: .Default, reuseIdentifier: identifier)
		}

		return cell!
	}

	// MARK: - 模型set方法
	var log: TixianLogModel? {
		didSet {
			nickNameLabel.text = "提现金额 \(log!.ApplyAmount)"
			timeLabel.text = "\(log!.ApplyTime)"
			if "1" == log!.State {
				realNameLabel.text = "申请中"
			}
			if "2" == log!.State {
				realNameLabel.text = "不通过"
			}
			if "3" == log!.State {
				realNameLabel.text = "已通过"
			}
		}
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		nickNameLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(contentView).offset(12)
			make.width.equalTo(ScreenWidth / 2)
			make.left.equalTo(contentView).offset(15)

		})
		realNameLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(contentView).offset(12)
			make.width.equalTo(ScreenWidth / 2 - 30)

			make.left.equalTo(nickNameLabel.snp_right).offset(5)
		})
		timeLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(realNameLabel.snp_bottom).offset(10)
			make.width.equalTo(ScreenWidth - 25)
			make.left.equalTo(contentView).offset(15)
		})

		lineView.frame = CGRectMake(5, height - 1, width - 15, 1)
	}
}
