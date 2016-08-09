
import UIKit

class CategoryCell: UITableViewCell {

	private static let identifier = "CategoryCell"

	// MARK: Lazy Property
	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textColor = BMTextGreyColor
		nameLabel.lineBreakMode = .ByCharWrapping
		nameLabel.numberOfLines = 0
		nameLabel.highlightedTextColor = UIColor.blackColor()
		nameLabel.backgroundColor = BMGreyBackgroundColor
		nameLabel.textAlignment = NSTextAlignment.Left
		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			nameLabel.font = UIFont.systemFontOfSize(12)
		} else {
			nameLabel.font = UIFont.systemFontOfSize(10)
		}
		return nameLabel
	}()

	private lazy var backImageView: UIImageView = {
		let backImageView = UIImageView()
		// backImageView.image = UIImage(named: "llll")
		// backImageView.highlightedImage = UIImage(named: "kkkkkkk")
		backImageView.backgroundColor = UIColor.clearColor()
		return backImageView
	}()

	private lazy var yellowView: UIView = {
		let yellowView = UIView()
		yellowView.backgroundColor = BMGreyBackgroundColor

		return yellowView
	}()

	private lazy var lineView: UIView = {
		let lineView = UIView()
		// lineView.backgroundColor = UIColor.colorWithCustom(225, g: 225, b: 225)
		lineView.backgroundColor = UIColor.clearColor()
		return lineView
	}()
// MARK: 模型setter方法
	var categorie: String! {
		didSet {
			nameLabel.text = categorie
		}
	}
	var img: String! {
		didSet {
			backImageView.highlightedImage = UIImage(named: img)
			backImageView.image = UIImage(named: img)
		}
	}

// MARK: Method
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = BMGreyBackgroundColor
		addSubview(backImageView)
		addSubview(lineView)
		addSubview(yellowView)
		addSubview(nameLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView, index: NSIndexPath) -> CategoryCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CategoryCell
		if cell == nil {
			cell = CategoryCell(style: .Default, reuseIdentifier: identifier)
		}
		// cell?.selectionStyle = UITableViewCellSelectionStyle.None
		cell?.backgroundColor = BMGreyBackgroundColor
		return cell!
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if selected {
			contentView.backgroundColor = UIColor.whiteColor()
		}
		// nameLabel.highlighted = selected
		// backImageView.highlighted = selected
		yellowView.hidden = !selected
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		nameLabel.frame = CGRectMake(28, 0, width - 30, height)
		backImageView.frame = CGRectMake(5, height / 2 - 10, 18, 18)
		yellowView.frame = CGRectMake(0, height * 0.17, 8, height * 0.65)
		lineView.frame = CGRectMake(0, height - 1, width, 1)
	}
}
