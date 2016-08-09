//
//  MessageViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import MJRefresh
import Kingfisher

class MessageViewController: BaseViewController {
	private var product_Data: [PayLogModel] = []
	var myView: UIView!
	var logoView = UIImageView()
	var nameLabel = UILabel()
	var favoriteBtn = UIButton()
	var phoneLabel = UILabel()
	var qqLabel = UILabel()
	var productsTableView: BMTableView?

	var index = 1
	var ketixian = 0.0
	var dongjie = 0.0

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		buildNavigationItem("我的资产")
		navigationController?.setNavigationBarHidden(false, animated: true)
		buildStoreView()
		buildProductsTableView()

		logoView.layer.cornerRadius = 42
		logoView.layer.masksToBounds = true

		if let url = SysUtils.get("avatar") {
			print("头像 \(userImgUrl + "\(url)"))")
			logoView.kf_setImageWithURL(NSURL.init(string: userImgUrl + "\(url)")!, placeholderImage: Image.init(named: "v2_my_avatar"), optionsInfo: [.Transition(.Fade(1))])
		}

		let logBtn = UIButton()
		logBtn.setTitle("提现记录", forState: UIControlState.Normal)
		logBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		logBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
		logBtn.setBackgroundImage(UIImage.imageWithColor(BtnBg), forState: UIControlState.Normal)
		logBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
		logBtn.addTarget(self, action: #selector(MessageViewController.log), forControlEvents: UIControlEvents.TouchUpInside)

		let bottomView = UIView.init(frame: CGRect.init(x: 0, y: ScreenHeight - 100, width: ScreenWidth, height: 36))
		bottomView.backgroundColor = UIColor.whiteColor()

		let applyBtn = UIButton()
		applyBtn.setTitle("申请提现", forState: UIControlState.Normal)
		applyBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		applyBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
		applyBtn.setBackgroundImage(UIImage.imageWithColor(BtnBg), forState: UIControlState.Normal)
		applyBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
		applyBtn.addTarget(self, action: #selector(MessageViewController.apply), forControlEvents: UIControlEvents.TouchUpInside)

		view.addSubview(bottomView)

		bottomView.addSubview(logBtn)
		bottomView.addSubview(applyBtn)

		logBtn.snp_makeConstraints(closure: { (make) -> Void in
			make.centerY.equalTo(bottomView.snp_centerY)
			make.left.equalTo(0)
			make.width.equalTo(ScreenWidth / 2)
			make.height.equalTo(36)
		})
		applyBtn.snp_makeConstraints(closure: { (make) -> Void in
			make.centerY.equalTo(bottomView.snp_centerY)
			make.left.equalTo(logBtn.snp_right).offset(1)
			make.width.equalTo(ScreenWidth / 2)
			make.height.equalTo(36)
		})

		ProgressHUDManager.showWithStatus("正在加载信息")
		getMoneyInfo()

	}

	func log() {
		print("提现记录")
		let vc = TixianLogVC()
		navigationController?.pushViewController(vc, animated: true)
	}

	func apply() {
		print("申请")
		if ketixian < 0.2 {
			ProgressHUDManager.showInfoStatus("可提现资产必须达到 0.2 元才可提现")
			return
		}
		let vc = ApplyVC()
		vc.ketixian = ketixian
		navigationController?.pushViewController(vc, animated: true)
	}
	private func buildProductsTableView() {
		productsTableView = BMTableView(frame: CGRect.init(x: 0, y: 105, width: ScreenWidth, height: ScreenHeight - 206))
		productsTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
		productsTableView?.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		productsTableView?.delegate = self
		productsTableView?.dataSource = self

		productsTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(MessageViewController.headRefresh))
		productsTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(MessageViewController.footRefresh))
		view.addSubview(productsTableView!)
	}

	func buildStoreView() {
		myView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
		myView.backgroundColor = UIColor.whiteColor()

		myView.addSubview(logoView)
		myView.addSubview(nameLabel)
		myView.addSubview(phoneLabel)
		myView.addSubview(qqLabel)

		self.view.addSubview(myView)

		logoView.snp_makeConstraints(closure: { (make) -> Void in
			make.centerY.equalTo(myView.snp_centerY)
			make.left.equalTo(myView).offset(5)
			make.width.equalTo(80)
			make.height.equalTo(80)
		})

		logoView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage.init(named: "logo"))
		// nameLabel.backgroundColor = UIColor.grayColor()
		nameLabel.font = UIFont.systemFontOfSize(14)
		nameLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(myView).offset(10)
			make.left.equalTo(myView).offset(100)
			make.width.equalTo(myView).offset(-105)
			make.height.equalTo(20)
		})
		// phoneLabel.backgroundColor = UIColor.grayColor()
		phoneLabel.font = UIFont.systemFontOfSize(14)
		phoneLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(myView).offset(30)
			make.left.equalTo(myView).offset(100)
			make.width.equalTo(myView).offset(-105)
			make.height.equalTo(20)
		})

		// qqLabel.backgroundColor = UIColor.grayColor()
		qqLabel.font = UIFont.systemFontOfSize(14)
		qqLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(myView).offset(50)
			make.left.equalTo(myView).offset(100)
			make.width.equalTo(myView).offset(-105)
			make.height.equalTo(20)
		})

	}

	func headRefresh() {
		self.productsTableView?.mj_header.endRefreshing()
		index = 1
		product_Data.removeAll()

		getMoneyInfo()
	}
	func footRefresh() {
		self.productsTableView?.mj_footer.endRefreshing()
		getMoneyInfo()
	}
	func getMoneyInfo() {
		manager.request(APIRouter.payCreditList("\(SysUtils.get("uid")!)", "\(index)")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)

			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(ReturnFalse)
					break
				}
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let jsonArray = tempJson["PayCreditLogList"].arrayValue
					if jsonArray.count == 0 {
						ProgressHUDManager.showInfoStatus("没有数据了")
						break
					}

					self.phoneLabel.text = "可提现资产  \(tempJson["UserAmount"].stringValue)"
					self.qqLabel.text = "冻结资产  \(tempJson["UserFrozenAmount"].stringValue)"
					self.dongjie = tempJson["UserFrozenAmount"].doubleValue
					self.ketixian = tempJson["UserAmount"].doubleValue
					for obj in jsonArray {
						let LogId = obj["LogId"].stringValue
						let Uid = obj["Uid"].stringValue
						let UserAmount = obj["UserAmount"].doubleValue
						let ActionTime = obj["ActionTime"].stringValue
						let ActionDes = obj["ActionDes"].stringValue
						let UserFrozenAmount = obj["UserFrozenAmount"].doubleValue
						self.product_Data.append(PayLogModel.init(LogId: LogId, Uid: Uid, UserAmount: UserAmount, ActionTime: ActionTime, ActionDes: ActionDes, UserFrozenAmount: UserFrozenAmount))
					}

					self.index += 1
					SVProgressHUD.dismiss()

					self.productsTableView?.reloadData()
				}
			}
		})
	}
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension MessageViewController: UITableViewDelegate, UITableViewDataSource, GoodsCellDelegate {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return product_Data.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = PayLogCell.cellWithTableView(tableView, index: indexPath)
		cell.log = product_Data[indexPath.row]
		return cell
	}
	func goodsCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int) {
		print("\(indexPath.section)  \(indexPath.row)")
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		return 115
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}