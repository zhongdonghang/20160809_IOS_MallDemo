

import UIKit
import SnapKit
import Cosmos

class RelationCell: UITableViewCell {

	static private let identifier = "RelationCell"

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
		realNameLabel.textColor = UIColor.init(red: 0.97, green: 0.32, blue: 0.0, alpha: 1.0)
		realNameLabel.font = UIFont.systemFontOfSize(14)
		realNameLabel.textAlignment = .Right

		return realNameLabel
	}()

	private lazy var timeLabel: UILabel = {
		let timeLabel = UILabel()
		timeLabel.font = UIFont.systemFontOfSize(13)
		timeLabel.textColor = BMInfoLabelTextColor
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

	class func cellWithTableView(tableView: UITableView, index: NSIndexPath) -> RelationCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? RelationCell

		if cell == nil {
			cell = RelationCell(style: .Default, reuseIdentifier: identifier)
		}

		return cell!
	}

	// MARK: - 模型set方法
	var relation: RelationshipModel? {
		didSet {
			nickNameLabel.text = relation?.nickName
			realNameLabel.text = relation?.realName
			timeLabel.text = relation?.time
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
