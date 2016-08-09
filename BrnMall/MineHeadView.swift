

import UIKit

class MineHeadView: UIImageView {

	let setUpBtn: UIButton = UIButton(type: .Custom)
	let loginBtn: UIButton = UIButton(type: .Custom)

	var iconView: IconView = IconView()
	var buttonClick: (Void -> Void)?
	var loginClick: (Void -> Void)?

	override init(frame: CGRect) {
		super.init(frame: frame)
		// image = UIImage(named: "v2_my_avatar_bg")
		self.backgroundColor = UIColor(patternImage: UIImage(named: "mine_bg")!)
		setUpBtn.setImage(UIImage(named: "v2_my_settings_icon"), forState: .Normal)
		setUpBtn.addTarget(self, action: #selector(MineHeadView.setUpButtonClick), forControlEvents: .TouchUpInside)
		loginBtn.addTarget(self, action: #selector(MineHeadView.loginButtonClick), forControlEvents: .TouchUpInside)
		// addSubview(setUpBtn)
		addSubview(iconView)
		addSubview(loginBtn)
		self.userInteractionEnabled = true
	}

	convenience init(frame: CGRect, settingButtonClick: (() -> Void)) {
		self.init(frame: frame)
		buttonClick = settingButtonClick
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let iconViewWH: CGFloat = 150
		iconView.frame = CGRectMake((width - 150) * 0.5, 30, iconViewWH, iconViewWH)
		loginBtn.frame = CGRectMake((width - 150) * 0.5, 30, iconViewWH, iconViewWH + 30)
		setUpBtn.frame = CGRectMake(width - 50, 10, 50, 50)
	}

	func setUpButtonClick() {
		buttonClick?()
	}
	func setLoginButtonClick(loginButtonClick: (() -> Void)) {
		loginClick = loginButtonClick
	}
	func loginButtonClick() {
		loginClick?()
	}
	func setUserName(name: String) {
		iconView.phoneNum.text = name
	}
}

class IconView: UIView {

	var iconImageView: UIImageView!
	var phoneNum: UILabel!

	override init(frame: CGRect) {
		super.init(frame: frame)
		iconImageView = UIImageView(image: UIImage(named: "v2_my_avatar"))
		iconImageView.layer.cornerRadius = 42
		iconImageView.layer.masksToBounds = true
		addSubview(iconImageView)

		phoneNum = UILabel()
		phoneNum.text = "登录/注册"
		phoneNum.font = UIFont.italicSystemFontOfSize(14)
		phoneNum.textColor = UIColor.whiteColor()
		phoneNum.textAlignment = .Center
		addSubview(phoneNum)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		iconImageView.frame = CGRectMake((width - iconImageView.size.width) * 0.5, 0, 84, 84)
		phoneNum.frame = CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + 5, width, 30)
	}
}