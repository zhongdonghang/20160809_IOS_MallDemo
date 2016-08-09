//
//  OrderViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class OrderViewController: BaseViewController {

	var orderTableView: BMTableView!
	var orders: [Order] = []
	var pageIndex = 1
	var pageSize = "10"

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		buildNavigationItem("我的订单")
		navigationController?.setNavigationBarHidden(false, animated: true)
		addNSNotification()
		bulidOrderTableView()
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	// MARK - Add Notification KVO Action
	private func addNSNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(headRefresh), name: "paySuccessreloadorder", object: nil)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setNavigationBarHidden(false, animated: animated)
	}

	private func bulidOrderTableView() {
		orderTableView = BMTableView(frame: view.bounds, style: UITableViewStyle.Plain)
		orderTableView.delegate = self
		orderTableView.dataSource = self
		orderTableView.backgroundColor = UIColor.clearColor()
		orderTableView.contentInset = UIEdgeInsetsMake(0, 0, 42, 0)
		orderTableView.showsVerticalScrollIndicator = false
		orderTableView.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		view.addSubview(orderTableView)
		orderTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.footRefresh))

		ProgressHUDManager.showWithStatus(Loading)
		loadOderData()
	}
	var isFootRefresh = false

	func footRefresh() {
		orderTableView.mj_footer.endRefreshing()
		isFootRefresh = true
		loadOderData()
	}

	func headRefresh() {
		orderTableView.mj_header.endRefreshing()
		orders.removeAll()
		pageIndex = 1
		ProgressHUDManager.showWithStatus(Loading)
		loadOderData()

	}

	private func loadOderData() {
		manager.request(APIRouter.GetMyOrderList(uid: "\(SysUtils.get("uid")!)", pageIndex: "\(pageIndex)", pageSize: "12", state: "")).responseJSON(completionHandler: {
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
					let jsonArray = tempJson["OrderList"].arrayValue
					if jsonArray.count == 0 {
						if !self.isFootRefresh {
							ProgressHUDManager.showInfoStatus("您还没有订单,去逛一逛吧")
						}
						self.isFootRefresh = false
						break
					}

					if jsonArray.count >= 1 {
						for j in 0 ... (jsonArray.count - 1) {

							let OId = jsonArray[j]["OId"].stringValue
							let UId = jsonArray[j]["UId"].stringValue
							let OrderState = jsonArray[j]["OrderState"].stringValue
							let OrderAmount = jsonArray[j]["OrderAmount"].stringValue
							let AddTime = jsonArray[j]["AddTime"].stringValue
							let StoreId = jsonArray[j]["StoreId"].stringValue
							let PayFriendName = jsonArray[j]["PayFriendName"].stringValue
							let storeName = jsonArray[j]["StoreName"].stringValue
							let OSN = jsonArray[j]["OSN"].stringValue
							let realpay = jsonArray[j]["Surplusmoney"].stringValue
							let paymode = jsonArray[j]["PayMode"].stringValue
							let IsReview = jsonArray[j]["IsReview"].stringValue

							var proList: [OrderPro] = []
							let proListJson = jsonArray[j]["ProList"].arrayValue
							if proListJson.count >= 1 {
								for i in 0 ... (proListJson.count - 1) {
									let PId = proListJson[i]["PId"].stringValue
									let PName = proListJson[i]["PName"].stringValue
									let img = proListJson[i]["ShowImg"].stringValue
									proList.append(OrderPro.init(Pid: PId, PName: PName, Img: img, StoreId: StoreId))
								}
							}

							self.orders.append(Order.init(Oid: OId, Uid: UId, OrderState: OrderState, OrderAmount: OrderAmount, AddTime: AddTime, StoreId: StoreId, PayName: PayFriendName, StoreName: storeName, OSN: OSN, RealPay: realpay, Paymode: paymode, Isreview: IsReview, ProList: proList))
						}
						self.pageIndex += 1

						SVProgressHUD.dismiss()
						self.orderTableView.reloadData()

						break
					}
				}
			}
		})
	}
	func orderConfirm(oid: String) {
		ProgressHUDManager.showWithStatus("正在确认收货")
		manager.request(APIRouter.OrderReceive("\(SysUtils.get("uid")!)", oid)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:

				if let returnJson = data.result.value {
					let json: JSON = JSON.init(returnJson)
					// print(json)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					}
					if "true" == json["result"].stringValue {
						self.orders.removeAll()
						self.pageIndex = 1
						self.loadOderData()

						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					}
					break
				}
				ProgressHUDManager.showInfoStatus("服务器繁忙,请稍后再试吧")
				// ProgressHUDManager.dismiss()
				break
			}
		})
	}
	private func cancelOrder(uid: String, oid: String) {
		ProgressHUDManager.showWithStatus("正在取消")
		manager.request(APIRouter.CancelOrder(uid: uid, oid: oid)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:

				if let returnJson = data.result.value {
					let json: JSON = JSON.init(returnJson)
					// print(json)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					}
					if "true" == json["result"].stringValue {
						self.orders.removeAll()
						self.pageIndex = 1
						self.loadOderData()

						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					}
					break
				}
				ProgressHUDManager.showInfoStatus("服务器繁忙,请稍后再试吧")
				// ProgressHUDManager.dismiss()
				break
			}
		})
	}
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource, MyOrderCellDelegate {

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = MyOrderCell.myOrderCell(tableView, indexPath: indexPath)
		cell.order = orders[indexPath.row]
		cell.delegate = self
		return cell
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 185.0
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return orders.count
		// return 5
	}

	func orderCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int) {
		if buttonType == 0 {
			// print("现在付款 \(orders[indexPath.row].oid)")
			let order = orders[indexPath.row]

			if "140" == order.orderstate || "160" == order.orderstate {
				let vc = ReViewVC()
				vc.order = orders[indexPath.row]
				navigationController?.pushViewController(vc, animated: true)
				return
			}

			if "110" == order.orderstate {
				let alert = UIAlertController.init(title: "提示", message: "确认收货吗？", preferredStyle: .Alert)

				let ok = UIAlertAction.init(title: "取消", style: .Default, handler: {
					(action: UIAlertAction!) -> Void in

				})
				let cancel = UIAlertAction.init(title: "确认收货", style: .Default, handler: {
					(action: UIAlertAction!) -> Void in
					let oid = self.orders[indexPath.row].oid
					self.orderConfirm(oid)
				})

				alert.addAction(ok)
				alert.addAction(cancel)
				self.presentViewController(alert, animated: true, completion: nil)
				return
			}
			let vc = PayVC()
			vc.order = MyOrder.init(id: Int.init(order.oid)!, title: order.osn, content: order.storename, url: "", createdAt: "", price: Double.init(order.realPay)!, paid: true, productID: Int.init(order.oid)!)
			let nvc = BaseNavigationController.init(rootViewController: vc)
			self.navigationController!.presentViewController(nvc, animated: true, completion: nil)
		}

		// }
		if buttonType == 1 {
			let alert = UIAlertController.init(title: "提示", message: "确认取消订单吗？", preferredStyle: .Alert)

			let ok = UIAlertAction.init(title: "取消订单", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in
				print("取消订单 \(self.orders[indexPath.row].oid)")
				let uid = self.orders[indexPath.row].uid
				let oid = self.orders[indexPath.row].oid
				self.cancelOrder(uid, oid: oid)
			})
			let cancel = UIAlertAction.init(title: "我点错了", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in
			})

			alert.addAction(ok)
			alert.addAction(cancel)
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let orderDetailVC = OrderDetailVC()
		orderDetailVC.order = orders[indexPath.row]
		navigationController?.pushViewController(orderDetailVC, animated: true)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}