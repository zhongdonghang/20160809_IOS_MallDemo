

import UIKit
import SnapKit
import Cosmos

@objc protocol GoodsCellDelegate: NSObjectProtocol {
	optional func goodsCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int)
}

class ProductCell: UITableViewCell {

	static private let identifier = "ProductCell"
	var isBrand = false
	private var indexPath: NSIndexPath?
	var delegate: GoodsCellDelegate?
	// MARK: - 初始化子控件
	private lazy var goodsImageView: UIImageView = {
		let goodsImageView = UIImageView()
		return goodsImageView
	}()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.lineBreakMode = .ByWordWrapping
		nameLabel.numberOfLines = 0

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			nameLabel.font = UIFont.systemFontOfSize(13)
		} else {
			nameLabel.font = UIFont.systemFontOfSize(11)
		}
		nameLabel.textColor = BMTextBlackColor
		return nameLabel
	}()

	private lazy var buyBtn: UIButton = {
		let buyBtn = UIButton()
		buyBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
		buyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		buyBtn.layer.masksToBounds = true
		buyBtn.layer.cornerRadius = 2
		buyBtn.layer.borderColor = UIColor.init(red: 0.98, green: 0.45, blue: 0.16, alpha: 1.0).CGColor
		buyBtn.layer.borderWidth = 0.5
		buyBtn.backgroundColor = UIColor.init(red: 0.98, green: 0.45, blue: 0.16, alpha: 1.0)
		buyBtn.setTitle("加入购物车", forState: UIControlState.Normal)
		buyBtn.addTarget(self, action: "goodsCellButtonDidClick:", forControlEvents: UIControlEvents.TouchUpInside)
		buyBtn.enabled = true
		return buyBtn
	}()

	private lazy var shopPriceLabel: UILabel = {
		let shopPriceLabel = UILabel()
		shopPriceLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.53, alpha: 1.0)

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			shopPriceLabel.font = UIFont.systemFontOfSize(12)
		} else {
			shopPriceLabel.font = UIFont.systemFontOfSize(10)
		}
		shopPriceLabel.textAlignment = .Left

		return shopPriceLabel
	}()

	private lazy var marketPriceLabel: UILabel = {
		let marketPriceLabel = UILabel()
		marketPriceLabel.font = UIFont.italicSystemFontOfSize(10)
		marketPriceLabel.textColor = UIColor(red: 0.72, green: 0.73, blue: 0.73, alpha: 1.00)
		marketPriceLabel.textAlignment = .Left
		return marketPriceLabel
	}()

//	private lazy var memberPriceLabel: UILabel = {
//		let memberPriceLabel = UILabel()
//		memberPriceLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.53, alpha: 1.0)
//
//		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
//			memberPriceLabel.font = UIFont.italicSystemFontOfSize(12)
//		} else {
//			memberPriceLabel.font = UIFont.italicSystemFontOfSize(10)
//		}
//		memberPriceLabel.textAlignment = .Left
//
//		return memberPriceLabel
//	}()
//	private lazy var starCount: CosmosView = {
//		let starCount = CosmosView()
//		starCount.text = "100人评论"
//		if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
//			starCount.settings.starSize = 10
//			starCount.settings.textFont = UIFont.systemFontOfSize(12)
//		} else {
//			starCount.settings.textFont = UIFont.systemFontOfSize(14)
//			starCount.settings.starSize = 15
//		}
//		starCount.rating = 3
//		starCount.settings.starMargin = 2
//		return starCount
//	}()

	private lazy var lineView: UIView = {
		let lineView = UIView()
		lineView.backgroundColor = UIColor.lightGrayColor()
		lineView.alpha = 0.2
		return lineView
	}()

	func goodsCellButtonDidClick(sender: UIButton) {
		weak var tmpSelf = self
		// print("00000000000000")
		if tmpSelf?.delegate != nil {
			if tmpSelf!.delegate!.respondsToSelector("goodsCellButtonDidClick:buttonType:") {
				tmpSelf!.delegate!.goodsCellButtonDidClick!((tmpSelf?.indexPath)!, buttonType: sender.tag)
			}
		}
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		// selectionStyle = .Default
		let bgColorView = UIView()
		bgColorView.backgroundColor = BMGreyBackgroundColor
		self.selectedBackgroundView = bgColorView

		contentView.backgroundColor = UIColor.whiteColor()

		addSubview(goodsImageView)
		addSubview(lineView)
		addSubview(nameLabel)
		addSubview(shopPriceLabel)
		addSubview(marketPriceLabel)
		// addSubview(memberPriceLabel)
		addSubview(buyBtn)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class func cellWithTableView(tableView: UITableView, index: NSIndexPath) -> ProductCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ProductCell

		if cell == nil {
			cell = ProductCell(style: .Default, reuseIdentifier: identifier)
		}
		cell?.indexPath = index
		return cell!
	}

// MARK: - 模型set方法
	var goods: Product? {
		didSet {
			print(BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!)
			goodsImageView.sd_setImageWithURL(NSURL(string: BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!), placeholderImage: UIImage(named: "goodsdefault"))
			// print("image URL :" + BaseImgUrl1 + (goods?.storeId)! + BaseImgUrl2 + (goods?.imgUrl)!)
			nameLabel.text = goods?.name
			shopPriceLabel.text = "商城价￥ " + (goods?.shopPrice)!
			marketPriceLabel.text = "市场价 ￥" + (goods?.marketPrice)!

			// 1
			let string = marketPriceLabel.text! as NSString
			var attributedString = NSMutableAttributedString(string: string as String)

			// 2

			let secondAttributes = [NSForegroundColorAttributeName: UIColor.grayColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSStrikethroughStyleAttributeName: 1]

			// 3
			attributedString.addAttributes(secondAttributes, range: string.rangeOfString(string as String))

			// 4
			marketPriceLabel.attributedText = attributedString

//			if SysUtils.get("uid") == nil {
//				memberPriceLabel.text = "会员价￥ 未登陆"
//			}
//			else {
//
//				memberPriceLabel.text = "会员价￥ " + (goods?.vipPrice)!
//
//			}
			// starCount.text = (goods?.commentCount)! + " 人评价"
		}
	}

// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()

		goodsImageView.frame = CGRectMake(10, 10, ScreenWidth * 0.75 * 0.3, height - 25)

		if isBrand {
			nameLabel.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(10)
				make.left.equalTo(goodsImageView.bounds.width + 20)
				make.width.equalTo(ScreenWidth - goodsImageView.bounds.width - 20)

			})
		} else {
			nameLabel.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(10)
				make.left.equalTo(goodsImageView.bounds.width + 20)
				make.width.equalTo(ScreenWidth * 0.75 - goodsImageView.bounds.width - 20)

			})
		}
		shopPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(nameLabel.snp_bottom).offset(5)
			make.left.equalTo(goodsImageView.bounds.width + 20)

		})
//		memberPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
//			make.top.equalTo(shopPriceLabel.snp_bottom).offset(2)
//			make.left.equalTo(goodsImageView.bounds.width + 20)
//		})
		marketPriceLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(shopPriceLabel.snp_bottom).offset(2)
			make.left.equalTo(goodsImageView.bounds.width + 20)

		})

		buyBtn.snp_makeConstraints(closure: { (make) -> Void in
			make.width.equalTo(70)
			make.height.equalTo(22)
			make.bottom.equalTo(contentView.snp_bottom).offset(-8)
			make.right.equalTo(contentView.snp_right).offset(-10)
			// make.width.equalTo(nameLabel.width)
		})

//		starCount.snp_makeConstraints(closure: { (make) -> Void in
//			make.top.equalTo(marketPriceLabel.snp_bottom).offset(18)
//			make.left.equalTo(marketPriceLabel.snp_left)
//			make.width.equalTo(nameLabel.width)
//		})

//		shopPriceLabel.frame = CGRectMake(CGRectGetMaxX(goodsImageView.frame), CGRectGetMaxY(CGRectMake(CGRectGetMaxX(goodsImageView.frame), CGRectGetMaxY(nameLabel.frame), 35, 15)), width, 20)

		lineView.frame = CGRectMake(5, height - 1, width - 10, 1)
	}
}
