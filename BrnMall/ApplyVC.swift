//
//  ApplyVC.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ApplyVC: BaseViewController, UITextFieldDelegate {

	var text1: UITextField!
	var text2: UITextField!
	var text3: UITextView!
	var text4: UITextField!
	var label: UILabel!
	var label1: UILabel!
	var label2: UILabel!
	var couponLabel: UILabel!
	var ketixian = 0.0
	var txfs = 0
	var btn: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		buildNavigationItem("申请提现")
		navigationController?.setNavigationBarHidden(false, animated: true)

		let scrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
		self.view.addSubview(scrollView)
		scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height + 320)
		scrollView.showsVerticalScrollIndicator = false;
		scrollView.showsHorizontalScrollIndicator = false;
		scrollView.scrollEnabled = true

		// Do any additional setup after loading the view.

		label1 = UILabel(frame: CGRectMake(5, 5, self.view.bounds.width - 10, 30))
		label1.textAlignment = .Left
		label1.font = UIFont.systemFontOfSize(14)
		label1.numberOfLines = 2
		label1.lineBreakMode = .ByCharWrapping
		label1.textColor = BMNavigationBarColor
		label1.text = "可提现金额  \(ketixian) 元"

		scrollView.addSubview(label1)

		text1 = UITextField(frame: CGRectMake(5, 35, self.view.bounds.width - 10, 40))
		text1.borderStyle = UITextBorderStyle.RoundedRect
		text1.font = UIFont.systemFontOfSize(12)
		text1.keyboardType = .NumberPad
		text1.tag = 101
		text1.delegate = self
		text1.placeholder = "提现金额"
		scrollView.addSubview(text1)

		text2 = UITextField(frame: CGRectMake(5, 85, self.view.bounds.width - 10, 40))
		text2.borderStyle = UITextBorderStyle.RoundedRect
		text2.placeholder = "账号"
		text2.font = UIFont.systemFontOfSize(12)
		scrollView.addSubview(text2)

		text3 = UITextView(frame: CGRectMake(5, 142, self.view.bounds.width - 10, 80))
		text3.font = UIFont.systemFontOfSize(12)
		text3.textAlignment = .Left
		text3.layer.cornerRadius = 3
		text3.layer.borderColor = UIColor.init(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0).CGColor
		text3.layer.borderWidth = 1
		text3.scrollEnabled = true

		scrollView.addSubview(text3)

		label = UILabel(frame: CGRectMake(5, 220, self.view.bounds.width - 10, 40))
		label.textAlignment = .Left
		label.font = UIFont.systemFontOfSize(10)
		label.numberOfLines = 2
		label.lineBreakMode = .ByCharWrapping
		label.textColor = BMNavigationBarColor
		label.text = "1、银行卡提现，请填写姓名、所属银行及开通银行网点\n2、支付宝提现，请填写真实姓名"

		scrollView.addSubview(label)

		text4 = UITextField(frame: CGRectMake(5, 275, self.view.bounds.width - 10, 40))
		text4.font = UIFont.systemFontOfSize(12)
		text4.borderStyle = UITextBorderStyle.RoundedRect
		text4.placeholder = "联系方式"
		scrollView.addSubview(text4)

		let couponView = UIView(frame: CGRectMake(5, 325, ScreenWidth, 40))
		couponView.backgroundColor = UIColor.whiteColor()

		let couponImageView = UIImageView(image: UIImage(named: "pay_icon"))
		couponImageView.frame = CGRectMake(5, 10, 20, 20)

		couponView.addSubview(couponImageView)
		couponLabel = UILabel(frame: CGRectMake(32, 0, ScreenWidth * 0.4, 40))
		couponLabel.text = "提现方式"
		couponLabel.textColor = UIColor.redColor()
		couponLabel.font = UIFont.systemFontOfSize(14)
		couponView.addSubview(couponLabel)

		let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
		arrowImageView.frame = CGRectMake(ScreenWidth - 25, 15, 5, 10)
		couponView.addSubview(arrowImageView)

		let checkButton = UIButton(frame: CGRectMake(ScreenWidth - 65, 0, 40, 40))
		checkButton.setTitle("选择", forState: UIControlState.Normal)
		checkButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
		checkButton.titleLabel?.font = UIFont.systemFontOfSize(14)
		checkButton.addTarget(self, action: #selector(ApplyVC.selectPayType), forControlEvents: UIControlEvents.TouchUpInside)
		couponView.addSubview(checkButton)

		scrollView.addSubview(couponView)
		label2 = UILabel(frame: CGRectMake(5, 365, self.view.bounds.width - 10, 30))
		label2.textAlignment = .Left
		label2.font = UIFont.systemFontOfSize(12)
		label2.numberOfLines = 2
		label2.lineBreakMode = .ByCharWrapping
		label2.textColor = BMNavigationBarColor
		label2.text = "注意：请认真根据提示填写申请信息，这将直接影响到审核结果！"
		scrollView.addSubview(label2)
		self.btn = UIButton();
		self.btn.setTitle("提交申请", forState: .Normal)
		self.btn.setBackgroundImage(UIImage.imageWithColor(BtnBg), forState: UIControlState.Normal)
		self.btn.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 180, b: 136)), forState: UIControlState.Highlighted)

		self.btn.addTarget(self, action: #selector(ApplyVC.post), forControlEvents: .TouchUpInside)

		self.btn.titleLabel!.font = UIFont.systemFontOfSize(20)
		self.btn.layer.cornerRadius = 3;
		self.btn.layer.masksToBounds = true

		scrollView.addSubview(self.btn);

		self.btn.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(label2.snp_bottom).inset(-20)
			make.centerX.equalTo(self.view)
			make.width.equalTo(self.view.bounds.width - 10)
			make.height.equalTo(40)
		}

	}
	func selectPayType() {
		let alert = UIAlertController.init(title: "选择提现方式", message: "", preferredStyle: .ActionSheet)

		let photo = UIAlertAction.init(title: "支付宝", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
			self.txfs = 1
			self.couponLabel.text = "提现方式:   支付宝"

		})

		let takephoto = UIAlertAction.init(title: "银行卡", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
			self.txfs = 2
			self.couponLabel.text = "提现方式:   银行卡"

		})

		alert.addAction(photo)
		alert.addAction(takephoto)

		self.presentViewController(alert, animated: true, completion: nil)
		return
	}
	func post() {
		print("提交")
		if text1.text?.characters.count == 0 {
			ProgressHUDManager.showInfoStatus("请输入提现金额")
			return
		}
		if Double.init(text1.text!)! > ketixian {
			ProgressHUDManager.showInfoStatus("输入提现金额大于可提现金额 \(ketixian)")
			return
		}
		if text2.text?.characters.count == 0 {
			ProgressHUDManager.showInfoStatus("请输入账号")
			return
		}
		if text3.text?.characters.count == 0 {
			ProgressHUDManager.showInfoStatus("请输入账号信息")
			return
		}
		if text4.text?.characters.count == 0 {
			ProgressHUDManager.showInfoStatus("请输入联系方式")
			return
		}
		if txfs == 0 {
			ProgressHUDManager.showInfoStatus("请选择提现方式")
			return
		}

		ProgressHUDManager.showWithStatus("正在提交申请")
		manager.request(APIRouter.withdrawlApply("\(SysUtils.get("uid")!)", "\(text1.text!)", "\(text2.text!)", "\(text3.text!)", "\(txfs)", "\(text4.text!)")).responseJSON(completionHandler: {
			data in
			print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus("信息提交失败,请稍后再试")
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus("\(json["data"][0]["msg"].stringValue)")
					break
				}
				if "true" == json["result"].stringValue {

					ProgressHUDManager.showInfoStatus("\(json["data"][0]["msg"].stringValue)")
					self.navigationController?.popViewControllerAnimated(true)

				}

				break
			}
		})
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		if text1.tag == 101 {
			// Create an `NSCharacterSet` set which includes everything *but* the digits
			let inverseSet = NSCharacterSet(charactersInString: "0123456789.").invertedSet

			let components = string.componentsSeparatedByCharactersInSet(inverseSet)

			// Rejoin these components
			let filtered = components.joinWithSeparator("") // use join("", components) if you are using Swift
			return string == filtered
		}
		return true
	}

}
