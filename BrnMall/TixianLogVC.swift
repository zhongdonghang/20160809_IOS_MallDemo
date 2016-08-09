//
//  TixianLogVC.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import SVProgressHUD

class TixianLogVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

	var tableView: BMTableView?

	var data: [TixianLogModel] = []

	var index = 1

	override func loadView() {
		super.loadView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		buildNavigationItem("提现记录")
		navigationController?.setNavigationBarHidden(false, animated: true)

		// 创建表视图
		self.tableView = BMTableView(frame: view.bounds, style: .Grouped)
		self.tableView!.delegate = self
		self.tableView!.dataSource = self

		self.tableView!.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(TixianLogVC.headRefresh))
		self.tableView!.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(TixianLogVC.footRefresh))
		self.view.addSubview(self.tableView!)

		getRelation()
	}

	func headRefresh() {
		self.tableView?.mj_header.endRefreshing()
		index = 1
		data.removeAll()
		getRelation()
	}
	func footRefresh() {
		self.tableView?.mj_footer.endRefreshing()

		getRelation()
	}

	func getRelation() {
		ProgressHUDManager.showWithStatus("正在加载数据")
		manager.request(APIRouter.withdrawlList("\(SysUtils.get("uid")!)", "\(index)")).responseJSON(completionHandler: {
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
					let jsonArray = tempJson["WithdrawalLogList"].arrayValue

					if jsonArray.count == 0 {
						ProgressHUDManager.showInfoStatus("没有数据了")
						break
					}
					if jsonArray.count >= 1 {
						for j in 0 ... (jsonArray.count - 1) {

							let RecordId = jsonArray[j]["RecordId"].stringValue
							let Uid = jsonArray[j]["Uid"].stringValue
							let State = jsonArray[j]["State"].stringValue
							let PayType = jsonArray[j]["PayType"].stringValue
							let PayAccount = jsonArray[j]["PayAccount"].stringValue
							let ApplyAmount = jsonArray[j]["ApplyAmount"].stringValue
							let ApplyRemark = jsonArray[j]["ApplyRemark"].stringValue
							let ApplyTime = jsonArray[j]["ApplyTime"].stringValue
							let Phone = jsonArray[j]["Phone"].stringValue
							let OperatorUid = jsonArray[j]["OperatorUid"].stringValue
							let OperatTime = jsonArray[j]["OperatTime"].stringValue
							let Reason = jsonArray[j]["Reason"].stringValue

							self.data.append(TixianLogModel.init(RecordId: RecordId, Uid: Uid, State: State, PayType: PayType, PayAccount: PayAccount, ApplyAmount: ApplyAmount, ApplyRemark: ApplyRemark, ApplyTime: ApplyTime, Phone: Phone, OperatorUid: OperatorUid, OperatTime: OperatTime, Reason: Reason))
						}
					}
					self.index += 1
					SVProgressHUD.dismiss()
					self.tableView!.reloadData()

					break
				}

			}
		})
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return data.count
	}

	// 创建各单元显示内容(创建参数indexPath指定的单元）
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
		-> UITableViewCell
	{

		let cell = TixianLogCell.cellWithTableView(tableView, index: indexPath)

		cell.log = data[indexPath.row]

		return cell
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
	// UITableViewDelegate 方法，处理列表项的选中事件
	func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
	{
		self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)

		let vc = TixianDetailVC()
		vc.tixianModel = data[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}

}

