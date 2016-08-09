//
//  MyProfileVC.swift
//  BrnMall
//
//  Created by luoyp on 16/4/1.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire

class MyProfileVC: BaseViewController {
	private var headView: MineHeadView!
	private var tableView: BMTableView!
	var rightBtn = UIBarButtonItem()
	typealias Update = (NSIndexPath, String) -> Void
	var update: Update?

	private let shareActionSheet: BMActionSheet = BMActionSheet()

	// MARK: Flag
	var iderVCSendIderSuccess = false

	// MARK:- view life circle
	override func loadView() {
		super.loadView()

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		print("MineViewController viewDidLoad")
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadAvatar), name: "updateInfoSuccess", object: nil)
		buildNavigationItem("用户中心")

		rightBtn = UIBarButtonItem.barButton("保 存", titleColor: UIColor.whiteColor(),
			image: UIImage(named: "icon_update")!, hightLightImage: nil,
			target: self, action: Selector("save"), type: ItemButtonType.Right)
		navigationItem.rightBarButtonItem = nil

		navigationController?.setNavigationBarHidden(false, animated: true)
		buildUI()
	}
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

	}
	func save() {
		print("保存用户信息 \(SysUtils.get("regionId")!)")
		manager.request(APIRouter.UserEdit("\(SysUtils.get("uid")!)", "\(SysUtils.get("nicheng")!)", "\(SysUtils.get("realName")!)", "\(SysUtils.get("sex")!)", "\(SysUtils.get("idCard")!)", "", "\(SysUtils.get("regionId")!)", "\(SysUtils.get("jianjie")!)", "\(SysUtils.get("addr")!)")).responseJSON(completionHandler: {
			data in
			print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus("信息上传失败,请稍后再试")
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus("信息上传失败,请稍后再试")
					break
				}
				if "true" == json["result"].stringValue {
					NSNotificationCenter.defaultCenter().postNotificationName("updateInfo", object: nil, userInfo: nil)
					ProgressHUDManager.showInfoStatus("信息更新成功")
					self.navigationController?.popViewControllerAnimated(true)

				}

				break
			}
		})
	}
	// MARK:- Private Method
	// MARK: Build UI
	private func buildUI() {

		buildTableView()
	}

	func showUserName(name: String) {
		self.headView.setUserName(name)
	}

	private func buildTableView() {
		tableView = BMTableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - 10), style: .Grouped)
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)

	}
	func reloadAvatar() {
		var indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
	}

	func logout() {
		let alert = UIAlertController.init(title: "注销提示", message: "确定退出当前用户吗？", preferredStyle: .Alert)

		let ok = UIAlertAction.init(title: "我点错了", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
		})
		let cancel = UIAlertAction.init(title: "注销用户", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in

			SysUtils.remove("uid")
			SysUtils.remove("userName")
			SysUtils.remove("LOGIN_USER")
			SysUtils.remove("zhekou")
			SysUtils.remove("zhekoutitle")
			SysUtils.remove("avatar")
			SysUtils.remove("nicheng")
			SysUtils.remove("realName")
			SysUtils.remove("sex")
			SysUtils.remove("idCard")
			SysUtils.remove("jianjie")
			SysUtils.remove("addr")
			SysUtils.remove("regionId")

			self.navigationController?.popViewControllerAnimated(true)

		})

		alert.addAction(ok)
		alert.addAction(cancel)
		self.presentViewController(alert, animated: true, completion: nil)

		return
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

/// MARK:- UITableViewDataSource UITableViewDelegate
extension MyProfileVC: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = MyProfileCell.cellFor(tableView)

		if 0 == indexPath.section {
			let cell = MyProfileCellAvatar.cellFor(tableView)
			cell.title = "头像"
			if let url = SysUtils.get("avatar") {

				cell.avatarView.kf_setImageWithURL(NSURL.init(string: userImgUrl + "\(url)")!, placeholderImage: Image.init(named: "v2_my_avatar"), optionsInfo: [.Transition(.Fade(1))])
			}

			else {

				cell.avatarView.kf_setImageWithURL(NSURL.init(string: "")!, placeholderImage: Image.init(named: "v2_my_avatar"), optionsInfo: [.Transition(.Fade(1))])
			}
			return cell

		} else if 1 == indexPath.section {
			if indexPath.row == 0 {
				cell.title = "昵称 "
				cell.detail = SysUtils.get("nicheng") as? String
			}
			if indexPath.row == 1 {
				cell.title = "真名 "
				cell.detail = SysUtils.get("realName") as? String
			}
			if indexPath.row == 2 {
				cell.title = "性别 "
				if let sex = SysUtils.get("sex") as? Int {
					if 1 == sex {
						cell.detail = "男"
					}
					if 2 == sex {
						cell.detail = "女"
					}
					if 0 == sex {
						cell.detail = "其他"
					}
				}
			}
			if indexPath.row == 3 {
				cell.title = "身份证 "
				cell.detail = SysUtils.get("idCard") as? String
			}
			if indexPath.row == 4 {
				cell.title = "简介 "
				cell.detail = SysUtils.get("jianjie") as? String
			}
		}
		else if indexPath.section == 2 {
			if indexPath.row == 0 {
				cell.title = "登录密码"
			}
			if indexPath.row == 1 {
				cell.title = "支付密码"
			}
		}
		else {
			cell.title = "退出当前账号"

		}

		return cell
	}

	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

		if section == 0 {
			return 1
		}
		return 10
	}

	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.1
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 82
		}
		return 42
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if 0 == section {
			return 1
		} else if (1 == section) {
			return 5
		} else if section == 2 {
			return 2
		}
		else {
			return 1
		}
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if indexPath.section == 3 {
			logout()
			return
		}
		if indexPath.section == 0 {
			let alert = UIAlertController.init(title: "选择头像", message: "", preferredStyle: .ActionSheet)

			let photo = UIAlertAction.init(title: "从相册选择", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in

				if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
					var imagePicker = UIImagePickerController()
					imagePicker.delegate = self
					imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
					imagePicker.allowsEditing = true
					self.presentViewController(imagePicker, animated: true, completion: nil)
				}
				else {
					ProgressHUDManager.showInfoStatus("无法读取照片,权限是否已被禁止？")
				}

			})
			let takephoto = UIAlertAction.init(title: "拍照", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in

				if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
					var imagePicker = UIImagePickerController()
					imagePicker.delegate = self
					imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
					imagePicker.allowsEditing = false
					self.presentViewController(imagePicker, animated: true, completion: nil)
				} else {
					ProgressHUDManager.showInfoStatus("拍照不可用,权限是否已被禁止？")
				}
			})
			let cancel = UIAlertAction.init(title: "取消", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in

			})

			alert.addAction(photo)
			alert.addAction(takephoto)
			alert.addAction(cancel)
			self.presentViewController(alert, animated: true, completion: nil)
			return
		}
		if 1 == indexPath.section {
			navigationItem.rightBarButtonItem = rightBtn
			editingRow(indexPath)

		} else if 2 == indexPath.section {
			if indexPath.row == 0 {
				let vc = FindPasswordViewController()
				self.navigationController?.pushViewController(vc, animated: true)
			}
            if indexPath.row == 1 {
                let vc = PayPasswordViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
		}
	}

	func editingRow(index: NSIndexPath) {
		if index.row == 0 {
			showInput(index, title: "昵称", update: {
				(NSIndexPath, String) -> Void in
				SysUtils.save(String, key: "nicheng")
			})
		}
		if index.row == 1 {
			showInput(index, title: "真名", update: {
				(NSIndexPath, String) -> Void in
				SysUtils.save(String, key: "realName")
			})
		}
		if index.row == 2 {
			let alert = UIAlertController.init(title: "性别", message: "", preferredStyle: .ActionSheet)

			let photo = UIAlertAction.init(title: "男", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in
				SysUtils.save(1, key: "sex")
				self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Fade)
			})
			let takephoto = UIAlertAction.init(title: "女", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in
				SysUtils.save(2, key: "sex")
				self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Fade)
			})
			let cancel = UIAlertAction.init(title: "其他", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in
				SysUtils.save(0, key: "sex")
				self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Fade)

			})

			alert.addAction(photo)
			alert.addAction(takephoto)
			alert.addAction(cancel)
			self.presentViewController(alert, animated: true, completion: nil)
		}
		if index.row == 3 {
			showInput(index, title: "身份证", update: {
				(NSIndexPath, String) -> Void in
				if String.characters.count == 18 || String.characters.count == 15 {
					SysUtils.save(String, key: "idCard")

				} else {
					ProgressHUDManager.showInfoStatus("请输入15或者18位身份证号")
					return
				}

			})
		}
		if index.row == 4 {
			showInput(index, title: "简介", update: {
				(NSIndexPath, String) -> Void in
				SysUtils.save(String, key: "jianjie")
			})
		}

	}

	func showInput(index: NSIndexPath, title: String, update: Update) {
		let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)

		let saveAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {
			alert -> Void in
			let firstTextField = alertController.textFields![0] as UITextField

			update(index, firstTextField.text!)
			self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Fade)
		})

		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: {
			(action: UIAlertAction!) -> Void in

		})

		alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
			textField.placeholder = title
		}
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)

		self.presentViewController(alertController, animated: true, completion: nil)
	}
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
		if image != nil {
			let newImg = resizeImage(image, newWidth: 240)
			var imageData = UIImagePNGRepresentation(newImg)
			if imageData != nil {
				let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
				updateAvatar(base64String)
			}

		}
		else {
			ProgressHUDManager.showInfoStatus("获取照片失败,权限是否已被禁止？")
		}
		self.dismissViewControllerAnimated(true, completion: nil);
	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController)
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

		let scale = newWidth / image.size.width
		let newHeight = image.size.height * scale
		UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
		image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage
	}
	func updateAvatar(avatar: String) {
		// manager.request(APIRouter.updateAvatar("\(SysUtils.get("uid")!)", avatar))
		Alamofire.request(.POST, BaseURL + "UserAvatarEdit", parameters: ["uid": "\(SysUtils.get("uid")!)", "avatar": avatar]).responseJSON(completionHandler: {
			data in
			print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus("头像上传失败,请稍后再试")
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus("头像上传失败,请稍后再试")
					break
				}
				if "true" == json["result"].stringValue {
					NSNotificationCenter.defaultCenter().postNotificationName("updateInfo", object: nil, userInfo: nil)
					ProgressHUDManager.showInfoStatus("头像更新成功")

				}

				break
			}
		})
	}
}
