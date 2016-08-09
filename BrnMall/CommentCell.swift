//
//  CommentCell.swift
//  BrnMall
//
//  Created by luoyp on 16/5/26.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SnapKit

class CommentCell: UITableViewCell {

	static private let identifier = "CommentCell"

	// MARK: - 初始化子控件
	private lazy var userImageView: UIImageView = {
		let userImageView = UIImageView()
		return userImageView
	}()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.font = UIFont.systemFontOfSize(13)
		nameLabel.textColor = UIColor.blackColor()
		nameLabel.text = ""
		return nameLabel
	}()

	private lazy var commentLabel: UILabel = {
		let commentLabel = UILabel()
		commentLabel.textAlignment = NSTextAlignment.Left
		commentLabel.font = UIFont.systemFontOfSize(13)
		commentLabel.lineBreakMode = .ByCharWrapping
		commentLabel.numberOfLines = 0
		commentLabel.textColor = UIColor.blackColor()
		commentLabel.text = ""
		return commentLabel
	}()

	private lazy var commentTimeLabel: UILabel = {
		let commentTimeLabel = UILabel()
		commentTimeLabel.font = UIFont.systemFontOfSize(13)
		commentTimeLabel.lineBreakMode = .ByCharWrapping
		commentTimeLabel.numberOfLines = 0
		commentTimeLabel.textAlignment = .Right
		commentTimeLabel.text = ""
		return commentTimeLabel
	}()

	private lazy var lineView: UIView = {
		let lineView = UIView()
		lineView.backgroundColor = UIColor.lightGrayColor()
		lineView.alpha = 0.2
		return lineView
	}()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		backgroundColor = UIColor.clearColor()
		contentView.backgroundColor = UIColor.whiteColor()

		addSubview(userImageView)
		addSubview(lineView)
		addSubview(nameLabel)
		addSubview(commentTimeLabel)
		addSubview(commentLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView) -> CommentCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CommentCell

		if cell == nil {
			cell = CommentCell(style: .Default, reuseIdentifier: identifier)
		}

		return cell!
	}

	// MARK: - 模型set方法
	var comment: CommentModel? {
		didSet {
			userImageView.sd_setImageWithURL(NSURL(string: (comment?.UserImg)!), placeholderImage: UIImage.init(named: "account"))

			nameLabel.text = comment?.NickName
			commentTimeLabel.text = comment?.ReviewTime
			commentLabel.text = comment?.Content
		}
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		contentView.frame = CGRectMake(0, 0, width, height - 20)
		userImageView.frame = CGRectMake(10, 8, 20, 20)

		nameLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(contentView).offset(10)
			make.left.equalTo(40)
			make.width.equalTo(ScreenWidth / 2)
		})

		commentTimeLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(contentView).offset(10)
			make.right.equalTo(contentView).offset(-10)
			make.width.equalTo(ScreenWidth / 2 - 20)
		})

		lineView.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(nameLabel.snp_bottom).offset(5)
			make.right.equalTo(contentView).offset(-10)
			make.left.equalTo(contentView).offset(10)
			make.height.equalTo(1)
			make.width.equalTo(ScreenWidth - 40)
		})
		commentLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(lineView.snp_bottom).offset(5)
			make.right.equalTo(contentView).offset(-10)
			make.left.equalTo(contentView).offset(10)
			make.width.equalTo(ScreenWidth - 20)
		})

	}
}