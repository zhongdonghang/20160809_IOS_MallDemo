

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class ProductsViewController: BaseViewController {

	// 当前显示的商品所属分类ID

	var isViewBrand: Bool = false
	var isViewCategory: Bool = false
	var titlename: String = ""
	var curID: String = ""
	var brandId: String = ""
	var pageIndex: Int = 1
	let pageSize: String = "12"
	var productsTableView: BMTableView?
	private var product_Data: [Product] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		if isViewBrand {
			view = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationH))
			buildNavigationItem(titlename)
		} else if isViewCategory {
			view = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationH))
			buildNavigationItem(titlename)
		} else {
			view = UIView(frame: CGRectMake(ScreenWidth * 0.25, 0, ScreenWidth * 0.75, ScreenHeight - NavigationH))
		}

		buildProductsTableView()
	}

	// MARK: - Build UI
	private func buildProductsTableView() {
		productsTableView = BMTableView(frame: view.bounds, style: .Plain)
		productsTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
		productsTableView?.backgroundColor = BMGlobalBackgroundColor
		productsTableView?.delegate = self
		productsTableView?.dataSource = self
		productsTableView?.showsVerticalScrollIndicator = false
		productsTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		productsTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.footRefresh))
		view.addSubview(productsTableView!)

		if isViewCategory {
			productsTableView?.mj_header.endRefreshing()
			self.pageIndex = 1
			product_Data.removeAll()
			self.productsTableView?.reloadData()

			ProgressHUDManager.showWithStatus(Loading)
			getProductByCategoryId()
			return
		}

		if isViewBrand {
			productsTableView?.mj_header.endRefreshing()
			self.pageIndex = 1
			product_Data.removeAll()
			self.productsTableView?.reloadData()

			ProgressHUDManager.showWithStatus(Loading)
			getProductByBrandId()
			return
		}
	}

	func clickCategotyItem() {
		if isViewBrand {
			productsTableView?.mj_header.endRefreshing()
			self.pageIndex = 1
			product_Data.removeAll()
			self.productsTableView?.reloadData()

			ProgressHUDManager.showWithStatus(Loading)
			getProductByBrandId()
			return
		}
		productsTableView?.mj_header.endRefreshing()
		self.pageIndex = 1
		product_Data.removeAll()
		self.productsTableView?.reloadData()
		print("刷新商品分类ID \(curID)....")
		ProgressHUDManager.showWithStatus(Loading)
		getProductByCategoryId()
	}
	var isFootRefresh = false
	func footRefresh() {
		if isViewBrand {
			productsTableView?.mj_footer.endRefreshing()
			isFootRefresh = true
			getProductByBrandId()
			return
		}
		productsTableView?.mj_footer.endRefreshing()
		print("刷新商品分类ID \(curID)....")
		isFootRefresh = true
		getProductByCategoryId()
	}
	func headRefresh() {
		if isViewBrand {
			productsTableView?.mj_header.endRefreshing()
			self.pageIndex = 1
			product_Data.removeAll()
			self.productsTableView?.reloadData()

			ProgressHUDManager.showWithStatus(Loading)
			getProductByBrandId()
			return
		}
		productsTableView?.mj_header.endRefreshing()
		self.pageIndex = 1
		product_Data.removeAll()
		print("刷新商品分类ID \(curID)....")
		ProgressHUDManager.showWithStatus(Loading)
		getProductByCategoryId()
	}
	/**
	 根据一级目录id获取商品
	 */
	func getProductByCategoryId() {

		manager.request(APIRouter.getProductListByCategoryID(id: curID, pageIndex: "\(pageIndex)", pageSize: pageSize)).responseJSON(completionHandler: {
			data in

			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				// print(json)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(ReturnFalse)
					break
				}
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let jsonArray = tempJson["ProductList"].arrayValue
					if jsonArray.count == 0 {
						if !self.isFootRefresh {
							ProgressHUDManager.showInfoStatus(NoData)
						}
						self.isFootRefresh = false
						break
					}

					for obj in jsonArray {
						let imgUrl = obj["ShowImg"].stringValue
						let name = obj["Name"].stringValue
						let shopPrice = obj["ShopPrice"].stringValue
						let marketPrice = obj["MarketPrice"].stringValue
						let vipPrice = obj["VipPrice"].stringValue
						// let starCount = obj["cateId"].stringValue
						let Id = obj["Pid"].stringValue
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
	func getProductByBrandId() {
		manager.request(APIRouter.getProductListByBrandID(id: curID, pageIndex: "\(pageIndex)", pageSize: pageSize, brandId: brandId)).responseJSON(completionHandler: {
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
					let jsonArray = tempJson["ProductList"].arrayValue
					if jsonArray.count == 0 {
						if !self.isFootRefresh {
							ProgressHUDManager.showInfoStatus(NoData)
						}
						self.isFootRefresh = false
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
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource, GoodsCellDelegate {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return product_Data.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = ProductCell.cellWithTableView(tableView, index: indexPath)
		cell.isBrand = isViewBrand
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

		return 108
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