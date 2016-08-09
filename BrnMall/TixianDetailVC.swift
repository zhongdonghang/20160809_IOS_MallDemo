//
//  TixianDetailVC.swift
//  BrnMall
//
//  Created by luoyp on 16/6/27.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class TixianDetailVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

	var tableView: BMTableView?
	var tixianModel: TixianLogModel!

	var data: [TixianLogModel] = []

	var index = 1

	override func loadView() {
		super.loadView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		buildNavigationItem("申请提现详情")
		navigationController?.setNavigationBarHidden(false, animated: true)

		// 创建表视图
		self.tableView = BMTableView(frame: view.bounds, style: .Grouped)
		self.tableView!.delegate = self
		self.tableView!.dataSource = self

		self.view.addSubview(self.tableView!)

	}

//	func getRelation() {
//		ProgressHUDManager.showWithStatus("正在加载数据")
//		manager.request(APIRouter.withdrawlList("\(SysUtils.get("uid")!)", "\(index)")).responseJSON(completionHandler: {
//			data in
//			// print(data.result.value)
//			switch data.result {
//
//			case .Failure:
//				ProgressHUDManager.showInfoStatus(NetFail)
//				break
//
//			case .Success:
//				let json: JSON = JSON(data.result.value!)
//				if "false" == json["result"].stringValue {
//					ProgressHUDManager.showInfoStatus(ReturnFalse)
//					break
//				}
//				if "true" == json["result"].stringValue {
//					let tempJson = json["data"]
//					let jsonArray = tempJson["WithdrawalLogList"].arrayValue
//
//					if jsonArray.count == 0 {
//						ProgressHUDManager.showInfoStatus("没有数据了")
//						break
//					}
//					if jsonArray.count >= 1 {
//						for j in 0 ... (jsonArray.count - 1) {
//
//							let RecordId = jsonArray[j]["RecordId"].stringValue
//							let Uid = jsonArray[j]["Uid"].stringValue
//							let State = jsonArray[j]["State"].stringValue
//							let PayType = jsonArray[j]["PayType"].stringValue
//							let PayAccount = jsonArray[j]["PayAccount"].stringValue
//							let ApplyAmount = jsonArray[j]["ApplyAmount"].stringValue
//							let ApplyRemark = jsonArray[j]["ApplyRemark"].stringValue
//							let ApplyTime = jsonArray[j]["ApplyTime"].stringValue
//							let Phone = jsonArray[j]["Phone"].stringValue
//							let OperatorUid = jsonArray[j]["OperatorUid"].stringValue
//							let OperatTime = jsonArray[j]["OperatTime"].stringValue
//							let Reason = jsonArray[j]["Reason"].stringValue
//
//							self.data.append(TixianLogModel.init(RecordId: RecordId, Uid: Uid, State: State, PayType: PayType, PayAccount: PayAccount, ApplyAmount: ApplyAmount, ApplyRemark: ApplyRemark, ApplyTime: ApplyTime, Phone: Phone, OperatorUid: OperatorUid, OperatTime: OperatTime, Reason: Reason))
//						}
//					}
//					self.index += 1
//					SVProgressHUD.dismiss()
//					self.tableView!.reloadData()
//
//					break
//				}
//
//			}
//		})
//	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return 7
	}

	// 创建各单元显示内容(创建参数indexPath指定的单元）
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
		-> UITableViewCell
	{

		let cell = TixianDetailCell.cellFor(tableView)
		if indexPath.row == 0 {
			cell.title = "提现金额"
			cell.detail = tixianModel.ApplyAmount
		}
		if indexPath.row == 1 {
			cell.title = "申请状态"
			if "1" == tixianModel.State {
				cell.detail = "申请中"
			}
			if "2" == tixianModel.State {
				cell.detail = "不通过"
			}
			if "3" == tixianModel.State {
				cell.detail = "已通过"
			}
		}
		if indexPath.row == 2 {
			cell.title = "账号"
			if "1" == tixianModel.PayType {
				cell.detail = "支付宝: \(tixianModel.PayAccount)"
			}
			if "2" == tixianModel.PayType {
				cell.detail = "银行卡: \(tixianModel.PayAccount)"
			}
		}
		if indexPath.row == 3 {
			cell.title = "账号信息"
			cell.detail = tixianModel.ApplyRemark.stringByReplacingOccurrencesOfString("\n", withString: " ")
		}
		if indexPath.row == 4 {
			cell.title = "申请时间"
			cell.detail = "\(tixianModel.ApplyTime)"
		}
		if indexPath.row == 5 {
			cell.title = "批示信息"
			cell.detail = tixianModel.Reason.stringByReplacingOccurrencesOfString("\n", withString: " ")
		}
		if indexPath.row == 6 {
			cell.title = "批示时间"
			cell.detail = "\(tixianModel.OperatTime)"
		}
		return cell
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 42
	}
	// UITableViewDelegate 方法，处理列表项的选中事件
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)

	}

}