//
//  MineViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class MineViewController: BaseViewController {

	private var headView: MineHeadView!
	private var tableView: BMTableView!
	private var headViewHeight: CGFloat = 150
	private var tableHeadView: MineTabeHeadView!
	private var couponNum: Int = 0
	private let shareActionSheet: BMActionSheet = BMActionSheet()

	// MARK: Flag
	var iderVCSendIderSuccess = false

	// MARK: Lazy Property
	private lazy var mines: [MineCellModel] = {
		let mines = MineCellModel.loadMineCellModels()
		return mines
	}()

	// MARK:- view life circle
	override func loadView() {
		super.loadView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		print("MineViewController viewDidLoad")

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getUserInfo), name: "updateInfo", object: nil)

		navigationController?.navigationBar.barTintColor = BMNavigationBarColor
		// self.navigationController?.navigationBar.hidden = true
		buildUI()
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	override func viewWillAppear(animated: Bool) {

		navigationController?.setNavigationBarHidden(true, animated: animated)
		super.viewWillAppear(animated)
		getUserInfo()
		if let name = SysUtils.get("nicheng") {
			headView.iconView.phoneNum.text = name as? String
			if let url = SysUtils.get("avatar") {
				print("头像 \(userImgUrl + "\(url)"))")
				headView.iconView.iconImageView.kf_setImageWithURL(NSURL.init(string: userImgUrl + "\(url)")!, placeholderImage: Image.init(named: "v2_my_avatar"), optionsInfo: [.Transition(.Fade(1))])
			}

		} else {
			headView.iconView.phoneNum.text = "登录/注册"
			headView.iconView.iconImageView.kf_setImageWithURL(NSURL.init(string: "")!, placeholderImage: Image.init(named: "v2_my_avatar"), optionsInfo: [.Transition(.Fade(1))])
		}

		weak var tmpSelf = self
		Mine.loadMineData { (data, error) -> Void in
			if error == nil {
				if data?.data?.availble_coupon_num > 0 {
					tmpSelf!.couponNum = data!.data!.availble_coupon_num
					tmpSelf!.tableHeadView.setCouponNumer(data!.data!.availble_coupon_num)
				} else {
					tmpSelf!.tableHeadView.setCouponNumer(0)
				}
			}
		}
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

	}

	// MARK:- Private Method
	// MARK: Build UI
	private func buildUI() {

		weak var tmpSelf = self
		headView = MineHeadView(frame: CGRectMake(0, 0, ScreenWidth, headViewHeight), settingButtonClick: { () -> Void in
			let settingVc = SettingViewController()
			tmpSelf!.navigationController?.pushViewController(settingVc, animated: true)
		})

		headView.setLoginButtonClick({
			() -> Void in

			if self.checkLogin() {

				let vc = MyProfileVC()
				self.navigationController?.pushViewController(vc, animated: true)
			}

//			let vc = LoginViewController()
//			let nvc = BaseNavigationController.init(rootViewController: vc)
//			self.navigationController?.presentViewController(nvc, animated: true, completion: nil)
		})

		view.addSubview(headView)

		buildTableView()
	}

	func showUserName(name: String) {
		self.headView.setUserName(name)
	}

	private func buildTableView() {
		tableView = BMTableView(frame: CGRectMake(0, headViewHeight, ScreenWidth, ScreenHeight - headViewHeight), style: .Grouped)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = 42
		view.addSubview(tableView)

		weak var tmpSelf = self
		tableHeadView = MineTabeHeadView(frame: CGRectMake(0, 0, ScreenWidth, 70))
		// 点击headView回调
		tableHeadView.mineHeadViewClick = { (type) -> () in

			if !self.checkLogin() {
				return
			}
			switch type {
			case .Order:
				let orderVc = OrderViewController()
				tmpSelf!.navigationController?.pushViewController(orderVc, animated: true)
				break
			case .Coupon:
				let couponVC = CollectionViewController()
				tmpSelf!.navigationController!.pushViewController(couponVC, animated: true)
				break
			case .Message:
				let message = MessageViewController()
				tmpSelf!.navigationController?.pushViewController(message, animated: true)
				break
			}
		}

		tableView.tableHeaderView = tableHeadView
	}

	func getUserInfo() {
		if SysUtils.get("uid") == nil {

		} else {
			manager.request(APIRouter.getUserInfo("\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
				data in
				// print(data.result.value)
				switch data.result {

				case .Failure:
					// ProgressHUDManager.dismiss()

					break

				case .Success:
					let json: JSON = JSON(data.result.value!)
					if "false" == json["result"].stringValue {

						break
					}
					if "true" == json["result"].stringValue {
						let tempJson = json["data"]

						SysUtils.save(tempJson["Avatar"].stringValue, key: "avatar")

						SysUtils.save(tempJson["IdCard"].stringValue, key: "idCard")
						SysUtils.save(tempJson["NickName"].stringValue, key: "nicheng")
						SysUtils.save(tempJson["RealName"].stringValue, key: "realName")
						SysUtils.save(tempJson["Gender"].intValue, key: "sex")
						SysUtils.save(tempJson["Bio"].stringValue, key: "jianjie")

						SysUtils.save(tempJson["RegionId"].stringValue, key: "regionId")
						SysUtils.save(tempJson["Address"].stringValue, key: "addr")

						NSNotificationCenter.defaultCenter().postNotificationName("updateInfoSuccess", object: nil, userInfo: nil)
					}

					break
				}
			})
		}

	}
}

/// MARK:- UITableViewDataSource UITableViewDelegate
extension MineViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = MineCell.cellFor(tableView)

		if 0 == indexPath.section {
			cell.mineModel = mines[indexPath.row]
		} else if 1 == indexPath.section {
			cell.mineModel = mines[2]
		} else {
			if indexPath.row == 0 {
				cell.mineModel = mines[3]
			} else {
				cell.mineModel = mines[4]
			}
		}

		return cell
	}

	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 10
	}

	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.1
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if 0 == section {
			return 1
		} else if (1 == section) {
			return 1
		} else {
			return 0
		}
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if !self.checkLogin() {
			return
		}
		if 0 == indexPath.section {
			if 0 == indexPath.row {
				let adressVC = MyAdressViewController()
				navigationController?.pushViewController(adressVC, animated: true)
			} else {

			}
		} else if 1 == indexPath.section {

			let vc = RelationshipVC()
			navigationController?.pushViewController(vc, animated: true)
		} else if 2 == indexPath.section {
			if 0 == indexPath.row {
				let helpVc = HelpViewController()
				navigationController?.pushViewController(helpVc, animated: true)
			} else if 1 == indexPath.row {
				let ideaVC = IdeaViewController()
				navigationController!.pushViewController(ideaVC, animated: true)
			}
		}
	}
}