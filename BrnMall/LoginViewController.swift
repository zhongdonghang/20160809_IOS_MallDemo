//
//  LoginViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import ObjectMapper

class LoginViewController: BaseViewController {

	var frostedView: UIVisualEffectView?
	var userNameTextField: UITextField?
	var passwordTextField: UITextField?
	var loginButton: UIButton?

	override func viewDidLoad() {
		super.viewDidLoad()

		buildNavigationItem("登录")
		navigationController?.setNavigationBarHidden(false, animated: true)

		self.userNameTextField = UITextField()
		self.userNameTextField!.textColor = UIColor.blackColor()
		self.userNameTextField!.backgroundColor = UIColor(white: 1, alpha: 0.1);
		self.userNameTextField!.font = UIFont.systemFontOfSize(15)
		self.userNameTextField!.layer.cornerRadius = 3;
		self.userNameTextField!.layer.borderWidth = 0.5
		self.userNameTextField!.keyboardType = .ASCIICapable
		self.userNameTextField!.layer.borderColor = BMNavigationBarColor.CGColor;
		self.userNameTextField!.placeholder = "用户名"
		self.userNameTextField!.clearButtonMode = .Always

		let userNameIconImageView = UIImageView(image: UIImage(named: "account")!.imageWithRenderingMode(.AlwaysTemplate));
		userNameIconImageView.frame = CGRectMake(0, 0, 34, 22)

		userNameIconImageView.contentMode = .ScaleAspectFit
		self.userNameTextField!.leftView = userNameIconImageView
		self.userNameTextField!.leftViewMode = .Always

		self.view.addSubview(self.userNameTextField!);

		self.userNameTextField!.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(40)
			make.centerX.equalTo(self.view)
			make.width.equalTo(300)
			make.height.equalTo(38)
		}

		self.passwordTextField = UITextField()
		self.passwordTextField!.textColor = UIColor.blackColor()
		self.passwordTextField!.backgroundColor = UIColor(white: 1, alpha: 0.1);
		self.passwordTextField!.font = UIFont.systemFontOfSize(15)
		self.passwordTextField!.layer.cornerRadius = 3;
		self.passwordTextField!.layer.borderWidth = 0.5
		self.passwordTextField!.keyboardType = .ASCIICapable
		self.passwordTextField!.secureTextEntry = true
		self.passwordTextField!.layer.borderColor = BMNavigationBarColor.CGColor
		self.passwordTextField!.placeholder = "密码"
		self.passwordTextField!.clearButtonMode = .Always

		let passwordIconImageView = UIImageView(image: UIImage(named: "lock")!.imageWithRenderingMode(.AlwaysTemplate));
		passwordIconImageView.frame = CGRectMake(0, 0, 34, 22)
		passwordIconImageView.contentMode = .ScaleAspectFit
		self.passwordTextField!.leftView = passwordIconImageView

		self.passwordTextField!.leftViewMode = .Always

		self.view.addSubview(self.passwordTextField!);

		self.passwordTextField!.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(85)
			make.centerX.equalTo(self.view)
			make.width.equalTo(300)
			make.height.equalTo(40)
		}

		self.loginButton = UIButton();
		self.loginButton!.setTitle("登  录", forState: .Normal)
		self.loginButton?.setBackgroundImage(UIImage.imageWithColor(BtnBg), forState: UIControlState.Normal)
		self.loginButton?.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 130, b: 136)), forState: UIControlState.Highlighted)
		self.loginButton!.titleLabel!.font = UIFont.systemFontOfSize(20)
		self.loginButton!.layer.cornerRadius = 3;
		self.loginButton?.layer.masksToBounds = true
		self.loginButton?.enabled = false
		self.view.addSubview(self.loginButton!);

		self.loginButton!.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(150)
			make.centerX.equalTo(self.view)
			make.width.equalTo(300)
			make.height.equalTo(40)
		}

		self.loginButton?.addTarget(self, action: #selector(LoginViewController.loginClick(_:)), forControlEvents: .TouchUpInside)

		let forgetPasswordBtn = UIButton()
		forgetPasswordBtn.setTitle("忘记密码了?", forState: UIControlState.Normal)
		forgetPasswordBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
		forgetPasswordBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
		forgetPasswordBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.clearColor()), forState: UIControlState.Normal)
		forgetPasswordBtn.setTitleColor(BMNavigationBarColor, forState: UIControlState.Highlighted)
		forgetPasswordBtn.addTarget(self, action: #selector(LoginViewController.findPassword), forControlEvents: UIControlEvents.TouchUpInside)

		self.view.addSubview(forgetPasswordBtn);

		forgetPasswordBtn.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.loginButton!.snp_bottom).offset(14)
			make.right.equalTo(self.loginButton!).offset(-5)
		}

		let registUserBtn = UIButton()
		registUserBtn.setTitle("注册", forState: UIControlState.Normal)
		registUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
		registUserBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
		registUserBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.clearColor()), forState: UIControlState.Normal)
		registUserBtn.setTitleColor(BMNavigationBarColor, forState: UIControlState.Highlighted)
		registUserBtn.addTarget(self, action: #selector(LoginViewController.registNewUser), forControlEvents: UIControlEvents.TouchUpInside)

		self.view.addSubview(registUserBtn);

		registUserBtn.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.loginButton!.snp_bottom).offset(14)
			make.left.equalTo(self.loginButton!).offset(5)
		}

		self.passwordTextField?.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
		self.userNameTextField?.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingChanged)
	}

	func registNewUser() {
		let vc = RegistNewUserViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	func findPassword() {
		let vc = FindPasswordViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	func textChanged() {
		if self.userNameTextField?.text?.characters.count > 0 && self.passwordTextField?.text?.characters.count > 0 {
			self.loginButton?.enabled = true
		}
		else {
			self.loginButton?.enabled = false
		}
	}
	func loginClick(sneder: UIButton) {
		let name = userNameTextField?.text
		let pwd = passwordTextField?.text

		ProgressHUDManager.showWithStatus("正在登录")
		manager.request(APIRouter.login(name!, pwd!)).responseJSON(completionHandler: {
			data in
			print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				if let returnJson = data.result.value {
					let value = Mapper<UserJsonModel>().map(returnJson)

					if let res = value?.result where res == false {
						print(res)
						ProgressHUDManager.showInfoStatus("登录失败,请检查用户名密码")
						break
					}
					if let user: LoginUser = value?.data?.user {
						// print(user.userName)
						// SysUtils.save(returnJson, key: "user")
						SysUtils.save("10", key: "zhekou")
						SysUtils.save(user.uid, key: "uid")
						SysUtils.save(user.userName, key: "userName")
						SysUtils.save(user.Avatar, key: "avatar")

						SysUtils.save(user.IdCard, key: "idCard")
						SysUtils.save(user.NickName, key: "nicheng")
						SysUtils.save(user.RealName, key: "realName")
						SysUtils.save(user.Gender, key: "sex")
						SysUtils.save(user.Bio, key: "jianjie")
						SysUtils.save(user.RegionId, key: "regionId")
						SysUtils.save(user.addr, key: "addr")
						print("bind " + user.userName)
						GeTuiSdk.bindAlias(user.userName)
//						SysUtils.save(user.mobile!, key: "mobile")
//						SysUtils.save(user.addr!, key: "addr")

						self.getuserLevel("\(user.uid)")
					}

					ProgressHUDManager.showSuccessWithStatus("登录成功")
					self.dismissViewControllerAnimated(true, completion: nil)
					print(SysUtils.get("user"))
					print(SysUtils.get("uid"))

					break
				}
				ProgressHUDManager.showInfoStatus("登录失败,请检查用户名密码")
				// ProgressHUDManager.dismiss()
				break
			}
		})
	}
	func getuserLevel(uid: String) {
		manager.request(APIRouter.getUserLevel(Id: uid)).responseJSON(completionHandler: {
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
					if "true" == json["result"].stringValue {
						let s = json["data"]["Discount"].stringValue
						let t = json["data"]["Title"].stringValue
						print("折扣 = " + s + t)
						SysUtils.save(s, key: "zhekou")
						SysUtils.save(t, key: "zhekoutitle")

					}

					break
				}
			}
		})

	}
	override func leftNavigitonItemClick() {
		// NSNotificationCenter.defaultCenter().postNotificationName(LFBShopCarBuyProductNumberDidChangeNotification, object: nil, userInfo: nil)
		dismissViewControllerAnimated(true, completion: nil)
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
