//
//  PayPasswordViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/7/7.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class PayPasswordViewController: BaseViewController {

	var pwd1TextField: UITextField!
	var pwd2TextField: UITextField!
	var postButton: UIButton?

	override func viewDidLoad() {
		super.viewDidLoad()

		buildNavigationItem("支付密码")
		navigationController?.setNavigationBarHidden(false, animated: true)

		let scrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
		self.view.addSubview(scrollView)
		scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height + 200)
		scrollView.showsVerticalScrollIndicator = false;
		scrollView.showsHorizontalScrollIndicator = false;
		scrollView.scrollEnabled = true

		pwd1TextField = UITextField(frame: CGRectMake(5, 15, self.view.bounds.width - 10, 40))
		pwd1TextField.secureTextEntry = true
		pwd1TextField.borderStyle = UITextBorderStyle.RoundedRect
		pwd1TextField.placeholder = "支付密码"
		scrollView.addSubview(pwd1TextField)

		pwd2TextField = UITextField(frame: CGRectMake(5, 65, self.view.bounds.width - 10, 40))
		pwd2TextField.secureTextEntry = true
		pwd2TextField.borderStyle = UITextBorderStyle.RoundedRect
		pwd2TextField.placeholder = "请再次输入支付密码"
		scrollView.addSubview(pwd2TextField)

		self.postButton = UIButton();
		self.postButton!.setTitle("提 交", forState: .Normal)
		self.postButton?.setBackgroundImage(UIImage.imageWithColor(BtnBg), forState: UIControlState.Normal)
		self.postButton?.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 180, b: 136)), forState: UIControlState.Highlighted)

		self.postButton!.addTarget(self, action: #selector(updatepwd), forControlEvents: .TouchUpInside)

		self.postButton!.titleLabel!.font = UIFont.systemFontOfSize(20)
		self.postButton!.layer.cornerRadius = 3;
		self.postButton?.layer.masksToBounds = true
		self.postButton?.enabled = false
		scrollView.addSubview(self.postButton!);

		self.pwd1TextField.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
		self.pwd2TextField.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)

		self.postButton!.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(pwd2TextField.snp_bottom).inset(-20)
			make.centerX.equalTo(self.view)
			make.width.equalTo(self.view.bounds.width - 10)
			make.height.equalTo(40)
		}

		// Do any additional setup after loading the view.
	}

	func textChanged() {

		if self.pwd1TextField.text?.characters.count > 5 && self.pwd2TextField.text?.characters.count > 5 {
			self.postButton!.enabled = true
		}

	}

	func updatepwd() {
		if self.pwd1TextField.text! != self.pwd2TextField.text! {
			ProgressHUDManager.showInfoStatus("两次输入密码不一致")
			return
		}
		ProgressHUDManager.showWithStatus("正在提交信息")
		manager.request(APIRouter.UserPayPasswordEdit("\(SysUtils.get("uid")!)", self.pwd1TextField.text!, self.pwd2TextField.text!)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
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
					NSNotificationCenter.defaultCenter().postNotificationName("paySuccessreloadorder", object: nil, userInfo: nil)
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

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */

}
