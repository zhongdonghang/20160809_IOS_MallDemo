//
//  SearchProductViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class SearchProductViewController: BaseViewController {

	private let searchBar = UISearchBar()
	var pageIndex: Int = 1

	var productsTableView: BMTableView?
	private var product_Data: [Product] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		print("SearchProductViewController viewDidLoad")
		buildSearchBar()
		buildProductsTableView()
		searchProductByKeyWord(keyword)
		// Do any additional setup after loading the view.
	}

	private func buildSearchBar() {
		(navigationController as! BaseNavigationController).backBtn.frame = CGRectMake(0, 0, 10, 40)

		let tmpView = UIView(frame: CGRectMake(0, 0, ScreenWidth * 0.8, 30))
		tmpView.backgroundColor = UIColor.whiteColor()
		tmpView.layer.masksToBounds = true
		tmpView.layer.cornerRadius = 6
		tmpView.layer.borderColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1).CGColor
		tmpView.layer.borderWidth = 0.2
		let image = UIImage.createImageFromView(tmpView)

		searchBar.frame = CGRectMake(0, 0, ScreenWidth * 0.80, 30)
		searchBar.placeholder = "请输入商品名称"
		searchBar.barTintColor = UIColor.whiteColor()
		searchBar.keyboardType = UIKeyboardType.Default
		searchBar.setSearchFieldBackgroundImage(image, forState: .Normal)
		searchBar.delegate = self
		navigationItem.titleView = searchBar

		let navVC = navigationController as! BaseNavigationController
		let leftBtn = navigationItem.leftBarButtonItem?.customView as? UIButton
		leftBtn!.addTarget(self, action: #selector(SearchProductViewController.leftButtonClcik), forControlEvents: UIControlEvents.TouchUpInside)
		navVC.isAnimation = false
	}

	private func buildProductsTableView() {
		productsTableView = BMTableView(frame: view.bounds, style: .Plain)
		productsTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
		productsTableView?.backgroundColor = BMGlobalBackgroundColor
		productsTableView?.delegate = self
		productsTableView?.dataSource = self
		productsTableView?.showsVerticalScrollIndicator = false
		productsTableView?.keyboardDismissMode = .OnDrag
		// productsTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		productsTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(SearchProductViewController.footRefresh))
		view.addSubview(productsTableView!)

	}
	var keyword = ""

	func footRefresh() {
		searchProductByKeyWord(keyword)
	}

	func leftButtonClcik() {
		searchBar.endEditing(false)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func searchProductByKeyWord(key: String) {
		ProgressHUDManager.showWithStatus("正在加载商品")
		manager.request(APIRouter.MallSearch(key, "\(pageIndex)")).responseJSON(completionHandler: {
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
					self.productsTableView?.reloadData()
					break
				}
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let jsonArray = tempJson["ProductList"].arrayValue
					if jsonArray.count == 0 {

						ProgressHUDManager.showInfoStatus("抱歉,暂时没有符合的商品")
						self.productsTableView?.reloadData()
						break
					}

					for obj in jsonArray {
						let imgUrl = obj["ShowImg"].stringValue
						let name = obj["Name"].stringValue
						let shopPrice = obj["ShopPrice"].stringValue
						let marketPrice = obj["MarketPrice"].stringValue
						// let starCount = obj["cateId"].stringValue
						let Id = obj["Pid"].stringValue
						let vipPrice = obj["VipPrice"].stringValue
						let commentCount = obj["ReviewCount"].stringValue
						let storeId = obj["StoreId"].stringValue

						self.product_Data.append(Product.init(ImgUrl: imgUrl, Name: name, ShopPrice: shopPrice, MarketPrice: marketPrice, StarCount: "3", ID: Id, CommentCount: commentCount, StoreID: storeId, VipPrice: vipPrice))
					}
					SVProgressHUD.dismiss()
					self.pageIndex += 1
					self.productsTableView?.reloadData()
				}
			}
		})
	}
	func addToCar(pid: String) {
		if !checkLogin() {
			return
		}

		manager.request(APIRouter.AddProductToCart(uid: "\(SysUtils.get("uid")!)", pid: pid, count: "1")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				break

			case .Success:
				if let returnJson = data.result.value {
					let json = JSON.init(returnJson)

					ProgressHUDManager.showSuccessWithStatus(json["data"][0]["msg"].stringValue)
					NSNotificationCenter.defaultCenter().postNotificationName("ShopCarDidChange", object: nil, userInfo: nil)
				}
				break
			}
		})
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchProductViewController: UITableViewDelegate, UITableViewDataSource, GoodsCellDelegate {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return product_Data.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = ProductCell.cellWithTableView(tableView, index: indexPath)
		cell.isBrand = true
		cell.goods = product_Data[indexPath.row]
		cell.delegate = self
		return cell
	}
	func goodsCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int) {
		print("\(indexPath.section)  \(indexPath.row)")
		var pid = ""
		pid = product_Data[indexPath.row].Id
		addToCar(pid)
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		return 115
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("点击商品")
		let vc = ProductDetailViewController()
		vc.isFromFavorite = false
		vc.pid = product_Data[indexPath.row].Id
		vc.name = product_Data[indexPath.row].name
		vc.price2 = product_Data[indexPath.row].shopPrice
		self.navigationController?.pushViewController(vc, animated: true)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

extension SearchProductViewController: UISearchBarDelegate, UIScrollViewDelegate {

	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		product_Data.removeAll()
		pageIndex = 1
		if searchBar.text?.characters.count > 0 {
			keyword = searchBar.text!
			searchProductByKeyWord(searchBar.text!)
		} else {

		}
	}
	func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
		return true
	}
	func scrollViewDidScroll(scrollView: UIScrollView) {

		searchBar.endEditing(false)
	}

	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.characters.count == 0 {
		}
	}
}
