//
//  CollectionViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class CollectionViewController: BaseViewController {

	private var favoriteProductTableView: BMTableView?
	private var segment: BMSegmentedControl!
	private var favoriteStoreVC: StoreCollectionVC?
	private var favoriteProduct: [FavoriteProduct] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		// buildNavigationItem("我的收藏")
		// self.view.backgroundColor = UIColor.blueColor()

		navigationController?.setNavigationBarHidden(false, animated: true)

		buildNavigationItem()
		buildFavoriteProductTableView()

		ProgressHUDManager.showWithStatus(Loading)
		getFavoriteProduct()
		// Do any additional setup after loading the view.
	}

	func getFavoriteProduct() {

		favoriteProduct.removeAll()
		favoriteProductTableView?.reloadData()

		manager.request(APIRouter.FavoriteProductList(uid: "\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
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
						ProgressHUDManager.showInfoStatus("没有收藏商品")
						// SVProgressHUD.dismiss()
						break
					}

					if jsonArray.count >= 1 {

						for j in 0 ... (jsonArray.count - 1) {
							let recordid = jsonArray[j]["recordid"].stringValue
							let pid = jsonArray[j]["pid"].stringValue
							let shopprice = jsonArray[j]["shopprice"].stringValue
							let addtime = jsonArray[j]["addtime"].stringValue
							let storeid = jsonArray[j]["storeid"].stringValue
							let name = jsonArray[j]["name"].stringValue
							let showimg = jsonArray[j]["showimg"].stringValue
							let storename = jsonArray[j]["storename"].stringValue
							self.favoriteProduct.append(FavoriteProduct.init(ImgUrl: showimg, Name: name, Recordid: recordid, Shopprice: shopprice, Addtime: addtime, ID: pid, Storename: storename, StoreID: storeid))
						}

						SVProgressHUD.dismiss()
						self.favoriteProductTableView?.reloadData()

						break
					}
				}
			}
		})
	}
	private func buildNavigationItem() {
//		let rightItem = UIBarButtonItem.barButton("投诉", titleColor: UIColor.whiteColor(), target: self, action: "rightItemButtonClick")
//		navigationItem.rightBarButtonItem = rightItem
		weak var tmpSelf = self
		segment = BMSegmentedControl(items: ["商品收藏", "店铺收藏"], didSelectedIndex: { (index) -> () in
			if index == 0 {
				tmpSelf!.showOrderStatusView()
			} else if index == 1 {
				tmpSelf!.showOrderDetailView()
			}
		})
		navigationItem.titleView = segment
		navigationItem.titleView?.frame = CGRectMake(0, 5, 180, 27)
	}

	private func buildFavoriteProductTableView() {
		favoriteProductTableView = BMTableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationH), style: .Plain)
		favoriteProductTableView?.backgroundColor = UIColor.whiteColor()
		favoriteProductTableView?.delegate = self
		favoriteProductTableView?.dataSource = self
		favoriteProductTableView?.rowHeight = 100
		favoriteProductTableView?.showsVerticalScrollIndicator = false
		favoriteProductTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		// productsTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.footRefresh))
		view.addSubview(favoriteProductTableView!)
	}

	func headRefresh() {
		favoriteProductTableView?.mj_header.endRefreshing()
		favoriteProduct.removeAll()
		favoriteProductTableView?.reloadData()
		// ProgressHUDManager.showWithStatus(Loading)
		getFavoriteProduct()
	}

	func showOrderStatusView() {
		weak var tmpSelf = self
		tmpSelf!.favoriteStoreVC?.view.hidden = true
		tmpSelf!.favoriteProductTableView?.hidden = false
	}

	func showOrderDetailView() {
		weak var tmpSelf = self
		if tmpSelf!.favoriteStoreVC == nil {
			tmpSelf!.favoriteStoreVC = StoreCollectionVC()
			tmpSelf!.favoriteStoreVC?.view.hidden = false
			// tmpSelf!.orderDetailVC?.order = order
			tmpSelf!.addChildViewController(favoriteStoreVC!)
			tmpSelf!.view.insertSubview(favoriteStoreVC!.view, atIndex: 0)
			tmpSelf?.favoriteStoreVC?.getFavoriteStore()
		} else {
			tmpSelf!.favoriteStoreVC?.view.hidden = false
		}
		tmpSelf!.favoriteProductTableView?.hidden = true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension CollectionViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = FavoriteProductCell.cellWithTableView(tableView)
		cell.goods = favoriteProduct[indexPath.row]
//
//		if indexPath.row == 0 {
//			cell.orderStateType = .Top
//		} else if indexPath.row == orderStatuses!.count - 1 {
//			cell.orderStateType = .Bottom
//		} else {
//			cell.orderStateType = .Middle
//		}

		return cell
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let vc = ProductDetailViewController()
		vc.isFromFavorite = true
		vc.pid = favoriteProduct[indexPath.row].Id
		vc.name = favoriteProduct[indexPath.row].name
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
		manager.request(APIRouter.deleteFavoritetProduct(uid: "\(SysUtils.get("uid")!)", pid: product.Id)).responseJSON(completionHandler: {
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