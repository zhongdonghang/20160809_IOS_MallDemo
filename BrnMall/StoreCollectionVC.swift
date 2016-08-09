//
//  StoreCollectionVC.swift
//  BrnMall
//
//  Created by luoyp on 16/4/15.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class StoreCollectionVC: UIViewController {

	private var favoriteProductTableView: BMTableView?

	private var favoriteProduct: [FavoriteStore] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		favoriteProductTableView = BMTableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationH), style: .Plain)
		favoriteProductTableView?.backgroundColor = UIColor.whiteColor()
		favoriteProductTableView?.delegate = self
		favoriteProductTableView?.dataSource = self
		favoriteProductTableView?.rowHeight = 100
		favoriteProductTableView?.showsVerticalScrollIndicator = false
		favoriteProductTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		// productsTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.footRefresh))
		view.addSubview(favoriteProductTableView!)

		// Do any additional setup after loading the view.
	}

	func headRefresh() {
		favoriteProductTableView?.mj_header.endRefreshing()
		favoriteProduct.removeAll()

		// ProgressHUDManager.showWithStatus(Loading)
		getFavoriteStore()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func getFavoriteStore() {

		favoriteProduct.removeAll()

		manager.request(APIRouter.FavoriteStoreList(uid: "\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
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

					let jsonArray = json["data"].arrayValue
					if jsonArray.count == 0 {
						ProgressHUDManager.showInfoStatus("没有收藏店铺")
						// SVProgressHUD.dismiss()
						break
					}

					if jsonArray.count >= 1 {

						for j in 0 ... (jsonArray.count - 1) {
							let storeid = jsonArray[j]["storeid"].stringValue
							let addtime = jsonArray[j]["addtime"].stringValue
							let name = jsonArray[j]["name"].stringValue
							let logo = jsonArray[j]["logo"].stringValue

							self.favoriteProduct.append(FavoriteStore.init(ImgUrl: logo, Addtime: addtime, Storename: name, StoreID: storeid))
						}

						SVProgressHUD.dismiss()
						self.favoriteProductTableView?.reloadData()

						break
					}
				}
			}
		})
	}
}
extension StoreCollectionVC: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = FavoriteStoreCell.cellWithTableView(tableView)
		cell.store = favoriteProduct[indexPath.row]
		//
		// if indexPath.row == 0 {
		// cell.orderStateType = .Top
		// } else if indexPath.row == orderStatuses!.count - 1 {
		// cell.orderStateType = .Bottom
		// } else {
		// cell.orderStateType = .Middle
		// }

		return cell
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let vc = StoreVC()
		vc.storeid = favoriteProduct[indexPath.row].storeId
		vc.storename = favoriteProduct[indexPath.row].storename

		// let nav = BaseNavigationController(rootViewController: shopCarVC)
		self.navigationController?.pushViewController(vc, animated: true)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return favoriteProduct.count ?? 0
		// return 19
	}
	func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
		return "删除"
	}

	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		deleteFavoriteProduct(indexPath)
	}
	func deleteFavoriteProduct(index: NSIndexPath) {
		ProgressHUDManager.showWithStatus("正在删除")
		let product = favoriteProduct[index.row]
		manager.request(APIRouter.deleteFavoritetStore(uid: "\(SysUtils.get("uid")!)", storeid: favoriteProduct[index.row].storeId)).responseJSON(completionHandler: {
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
						break
					}
					if "true" == json["result"].stringValue {
						self.headRefresh()
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					}

					break
				}
			}
		})
	}
}
