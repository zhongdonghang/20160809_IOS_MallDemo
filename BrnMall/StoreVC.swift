//
//  StoreVC.swift
//  BrnMall
//
//  Created by luoyp on 16/3/31.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import SnapKit
import SwiftyJSON
import SVProgressHUD
import Kingfisher

class StoreVC: BaseViewController {
	var storeid = "0"
	var storename = ""

	private var product_Data: [Product] = []
	var storeView: UIView!
	var logoView = UIImageView()
	var nameLabel = UILabel()
	var favoriteBtn = UIButton()
	var phoneLabel = UILabel()
	var qqLabel = UILabel()
	var productsTableView: BMTableView?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		buildNavigationItem("店铺详情")
		navigationController?.setNavigationBarHidden(false, animated: true)
		buildStoreView()
		buildProductsTableView()

		logoView.layer.cornerRadius = 42
		logoView.layer.masksToBounds = true

		ProgressHUDManager.showWithStatus("正在加载店铺信息")
		getStoreGoods()

	}
	private func buildProductsTableView() {
		productsTableView = BMTableView(frame: CGRect.init(x: 0, y: 105, width: ScreenWidth, height: ScreenHeight - 120))
		productsTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
		productsTableView?.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		productsTableView?.delegate = self
		productsTableView?.dataSource = self

		productsTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		// productsTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.footRefresh))
		view.addSubview(productsTableView!)
	}

	func buildStoreView() {
		storeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
		storeView.backgroundColor = UIColor.whiteColor()

		storeView.addSubview(logoView)
		storeView.addSubview(nameLabel)
		storeView.addSubview(phoneLabel)
		storeView.addSubview(qqLabel)

		self.view.addSubview(storeView)

		logoView.snp_makeConstraints(closure: { (make) -> Void in
			make.centerY.equalTo(storeView.snp_centerY)
			make.left.equalTo(storeView).offset(5)
			make.width.equalTo(80)
			make.height.equalTo(80)
		})

		logoView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage.init(named: "logo"))
		// nameLabel.backgroundColor = UIColor.grayColor()
		nameLabel.font = UIFont.systemFontOfSize(14)
		nameLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(storeView).offset(10)
			make.left.equalTo(storeView).offset(100)
			make.width.equalTo(storeView).offset(-105)
			make.height.equalTo(20)
		})
		// phoneLabel.backgroundColor = UIColor.grayColor()
		phoneLabel.font = UIFont.systemFontOfSize(14)
		phoneLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(storeView).offset(30)
			make.left.equalTo(storeView).offset(100)
			make.width.equalTo(storeView).offset(-105)
			make.height.equalTo(20)
		})

		// qqLabel.backgroundColor = UIColor.grayColor()
		qqLabel.font = UIFont.systemFontOfSize(14)
		qqLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(storeView).offset(50)
			make.left.equalTo(storeView).offset(100)
			make.width.equalTo(storeView).offset(-105)
			make.height.equalTo(20)
		})
		getStoreInfo()
	}

	func headRefresh() {
		self.productsTableView?.mj_header.endRefreshing()
		getStoreInfo()
		product_Data.removeAll()
		getStoreGoods()
	}

	func getStoreInfo() {
		manager.request(APIRouter.GetStoreInfo(Id: "\(storeid)")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				break

			case .Success:
				if let returnJson = data.result.value {

					let json: JSON = JSON.init(returnJson)
					// print(json)
					if "true" == json["result"].stringValue {
						self.nameLabel.text = json["data"]["Name"].stringValue
						self.phoneLabel.text = "电话: " + json["data"]["Mobile"].stringValue
						self.qqLabel.text = "QQ: " + json["data"]["QQ"].stringValue
						print(BaseImgUrl1 + "\(self.storeid)" + logoUrl + json["data"]["Logo"].stringValue)
						self.logoView.sd_setImageWithURL(NSURL(string: BaseImgUrl1 + "\(self.storeid)" + logoUrl + json["data"]["Logo"].stringValue), placeholderImage: UIImage.init(named: "goodsdefault"))
					}

					break
				}
			}
		})
	}

	func getStoreGoods() {
		product_Data.removeAll()

		manager.request(APIRouter.GetStoreGoods(Id: "\(storeid)")).responseJSON(completionHandler: {
			data in
			print(data.result.value)

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
					let jsonArray = tempJson["ProductList"].arrayValue
					if jsonArray.count == 0 {
						ProgressHUDManager.showInfoStatus("本店暂无商品信息")
						break
					}

					for obj in jsonArray {
						let imgUrl = obj["ShowImg"].stringValue
						let name = obj["Name"].stringValue
						let shopPrice = obj["ShopPrice"].stringValue
						let marketPrice = obj["MarketPrice"].stringValue
						// let starCount = obj["cateId"].stringValue
						let vipPrice = obj["VipPrice"].stringValue
						let Id = obj["Pid"].stringValue
						let commentCount = obj["ReviewCount"].stringValue
						let storeId = obj["StoreId"].stringValue

						self.product_Data.append(Product.init(ImgUrl: imgUrl, Name: name, ShopPrice: shopPrice, MarketPrice: marketPrice, StarCount: "3", ID: Id, CommentCount: commentCount, StoreID: storeId, VipPrice: vipPrice))
					}
					SVProgressHUD.dismiss()

					self.productsTableView?.reloadData()
				}
			}
		})
	}
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension StoreVC: UITableViewDelegate, UITableViewDataSource, GoodsCellDelegate {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print(product_Data.count)
		return product_Data.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = ProductCell.cellWithTableView(tableView, index: indexPath)
		cell.delegate = self
		print(indexPath.row)
		cell.goods = product_Data[indexPath.row]
		return cell
	}
	func goodsCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int) {
		print("\(indexPath.section)  \(indexPath.row)")
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		return 105
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
