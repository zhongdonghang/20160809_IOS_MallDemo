//
//  RegistNewUserViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/22.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegistNewUserViewController: BaseViewController {

	var nameTextField: UITextField!
	var pwd1TextField: UITextField!
	var pwd2TextField: UITextField!
	var yzmTextField: UITextField!
	var introduceNameNameTextField: UITextField!

	var registButton: UIButton?
	var yzmButton: UIButton?
	override func viewDidLoad() {
		super.viewDidLoad()
		buildNavigationItem("新用户注册")
		navigationController?.setNavigationBarHidden(false, animated: true)

		let scrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
		self.view.addSubview(scrollView)
		scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height + 200)
		scrollView.showsVerticalScrollIndicator = false;
		scrollView.showsHorizontalScrollIndicator = false;
		scrollView.scrollEnabled = true

		// Do any additional setup after loading the view.

		nameTextField = UITextField(frame: CGRectMake(5, 5, (self.view.bounds.width - 10) * 2 / 3 - 10, 40))
		nameTextField.borderStyle = UITextBorderStyle.RoundedRect
		nameTextField.placeholder = "手机号"
		scrollView.addSubview(nameTextField)

		yzmButton = UIButton(frame: CGRectMake((self.view.bounds.width - 10) * 2 / 3 + 5, 5, (self.view.bounds.width - 30) / 3, 40))

		yzmButton?.setTitle("获取验证码", forState: UIControlState.Normal)
		self.yzmButton!.addTarget(self, action: #selector(getYzm), forControlEvents: .TouchUpInside)

		self.yzmButton!.titleLabel!.font = UIFont.systemFontOfSize(14)
		self.yzmButton!.layer.cornerRadius = 3;
		self.yzmButton?.layer.masksToBounds = true
		self.yzmButton?.setBackgroundImage(UIImage.imageWithColor(BtnBg), forState: UIControlState.Normal)
		self.yzmButton?.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 130, b: 136)), forState: UIControlState.Highlighted)
		self.yzmButton?.enabled = false
		scrollView.addSubview(self.yzmButton!);
		yzmTextField = UITextField(frame: CGRectMake(5, 55, self.view.bounds.width - 10, 40))
		yzmTextField.borderStyle = UITextBorderStyle.RoundedRect
		yzmTextField.placeholder = "手机短信验证码"
		scrollView.addSubview(yzmTextField)

		pwd1TextField = UITextField(frame: CGRectMake(5, 105, self.view.bounds.width - 10, 40))
		pwd1TextField.secureTextEntry = true
		pwd1TextField.borderStyle = UITextBorderStyle.RoundedRect
		pwd1TextField.placeholder = "登录密码"
		scrollView.addSubview(pwd1TextField)

		pwd2TextField = UITextField(frame: CGRectMake(5, 155, self.view.bounds.width - 10, 40))
		pwd2TextField.secureTextEntry = true
		pwd2TextField.borderStyle = UITextBorderStyle.RoundedRect
		pwd2TextField.placeholder = "请再次输入登录密码"
		scrollView.addSubview(pwd2TextField)

		introduceNameNameTextField = UITextField(frame: CGRectMake(5, 205, self.view.bounds.width - 10, 40))
		introduceNameNameTextField.borderStyle = UITextBorderStyle.RoundedRect
		introduceNameNameTextField.placeholder = "推荐者手机号(可选填)"
		scrollView.addSubview(introduceNameNameTextField)

		self.registButton = UIButton();
		self.registButton!.setTitle("注  册", forState: .Normal)
		self.registButton?.setBackgroundImage(UIImage.imageWithColor(BtnBg), forState: UIControlState.Normal)
		self.registButton?.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 180, b: 136)), forState: UIControlState.Highlighted)

		self.registButton!.addTarget(self, action: #selector(LoginViewController.registNewUser), forControlEvents: .TouchUpInside)

		self.registButton!.titleLabel!.font = UIFont.systemFontOfSize(20)
		self.registButton!.layer.cornerRadius = 3;
		self.registButton?.layer.masksToBounds = true
		self.registButton?.enabled = false
		scrollView.addSubview(self.registButton!);

		self.registButton!.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(introduceNameNameTextField.snp_bottom).inset(-20)
			make.centerX.equalTo(self.view)
			make.width.equalTo(self.view.bounds.width - 10)
			make.height.equalTo(40)
		}

		self.nameTextField.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
		self.pwd1TextField.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
		self.pwd2TextField.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
		self.yzmTextField.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
		self.introduceNameNameTextField.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
	}

	func textChanged() {
		if self.nameTextField.text?.characters.count == 11 {
			self.yzmButton?.enabled = true
		}
		else {
			self.yzmButton?.enabled = false
		}
		if self.nameTextField.text?.characters.count > 0 && self.pwd1TextField.text?.characters.count > 0 && self.pwd2TextField.text?.characters.count > 0 && self.yzmTextField.text?.characters.count > 0 {
			self.registButton!.enabled = true
		}
		else {
			self.registButton!.enabled = false
		}
	}
	var code = ""

	func getYzm() {
		print("手机验证码")
		manager.request(APIRouter.getPhoneVerifyCode(self.nameTextField.text!, "0")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				break

			case .Success:
				if let returnJson = data.result.value {
					let json: JSON = JSON.init(returnJson)
					print(json)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)

					}
					if "true" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus("已发送验证码")
						self.code = json["data"].stringValue
					}
					break
				}
				// ProgressHUDManager.dismiss()
				break
			}
		})
	}

	func registNewUser() {
		if code != self.yzmTextField.text {
			ProgressHUDManager.showInfoStatus("验证码错误,请重新获取")
			return
		}
		ProgressHUDManager.showWithStatus("正在注册")
		manager.request(APIRouter.registNewUser(self.nameTextField.text!, self.pwd1TextField.text!, self.pwd2TextField.text!, self.introduceNameNameTextField.text!)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				if let returnJson = data.result.value {
					let json: JSON = JSON.init(returnJson)
					print(json)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					}
					if "true" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus("注册成功")
						self.navigationController?.popViewControllerAnimated(true)
					}
					break
				}
				ProgressHUDManager.showInfoStatus("服务器繁忙,请稍后再试吧")
				// ProgressHUDManager.dismiss()
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
