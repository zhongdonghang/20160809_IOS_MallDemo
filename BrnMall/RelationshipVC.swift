//
//  RelationshipVC.swift
//  BrnMall
//
//  Created by luoyp on 16/6/14.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import MJRefresh

class RelationshipVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

	var tableView: BMTableView?

	var data1: [RelationshipModel] = []
	var data2: [RelationshipModel] = []

	var adHeaders: [String]?

	override func loadView() {
		super.loadView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		buildNavigationItem("介绍人关系")
		navigationController?.setNavigationBarHidden(false, animated: true)

		self.adHeaders = [
			"我的介绍人",
			"我介绍的会员"
		]

		// 创建表视图
		self.tableView = BMTableView(frame: view.bounds, style: .Grouped)
		self.tableView!.delegate = self
		self.tableView!.dataSource = self
		self.tableView!.rowHeight = 64
		self.tableView!.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(RelationshipVC.headRefresh))

		self.view.addSubview(self.tableView!)

		getRelation()
	}

	func headRefresh() {
		self.tableView?.mj_header.endRefreshing()
		data2.removeAll()
		data1.removeAll()
		getRelation()
	}
	func getRelation() {
		ProgressHUDManager.showWithStatus("正在加载数据")
		manager.request(APIRouter.GetIntroducers("\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
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
					let myIntroducersJsonArray = tempJson["MyIntroducers"].arrayValue
					let introducersJsonArray = tempJson["introducer"].arrayValue

					if myIntroducersJsonArray.count >= 1 {
						for j in 0 ... (myIntroducersJsonArray.count - 1) {

							let NickName = myIntroducersJsonArray[j]["NickName"].stringValue
							let UserName = myIntroducersJsonArray[j]["UserName"].stringValue
							let AddTime = myIntroducersJsonArray[j]["AddTime"].stringValue

							self.data2.append(RelationshipModel.init(NickName: NickName, Name: UserName, Time: AddTime))
						}
					}
					if introducersJsonArray.count >= 1 {
						for j in 0 ... (introducersJsonArray.count - 1) {

							let NickName = introducersJsonArray[j]["NickName"].stringValue
							let UserName = introducersJsonArray[j]["UserName"].stringValue
							let AddTime = introducersJsonArray[j]["AddTime"].stringValue

							self.data1.append(RelationshipModel.init(NickName: NickName, Name: UserName, Time: AddTime))
						}
					}

					SVProgressHUD.dismiss()
					self.tableView!.reloadData()

					break
				}

			}
		})
	}

// 在本例中，有2个分区
	func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
		return 2;
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 1 {
			if data2.count == 0 {
				return 1
			}
			return data2.count
		}
		if data1.count == 0 {
			return 1
		}
		return data1.count
	}

	func tableView(tableView: UITableView, titleForHeaderInSection
		section: Int) -> String
	{
		var headers = self.adHeaders!;
		return headers[section];
	}

// 创建各单元显示内容(创建参数indexPath指定的单元）
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
		-> UITableViewCell
	{

		let cell = RelationCell.cellWithTableView(tableView, index: indexPath)

		if indexPath.section == 0 {
			if data1.count == 0 {
				cell.relation = RelationshipModel.init(NickName: "无", Name: "", Time: "")
				return cell
			}
			cell.relation = data1[indexPath.row]
		}
		if indexPath.section == 1 {
			if data2.count == 0 {
				cell.relation = RelationshipModel.init(NickName: "无", Name: "", Time: "")
				return cell
			}
			cell.relation = data2[indexPath.row]
		}

		return cell
	}

// UITableViewDelegate 方法，处理列表项的选中事件
	func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
	{
		self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)

	}

}
