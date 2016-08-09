//
//  ShopCartViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD
import Alamofire

class ShopCartViewController: BaseViewController {

	private var product_Data: [ShopCar] = []
	var select_product_Data: [ShopCar] = []
	var productsTableView: BMTableView?
	private var bottomView: UIView?
	let totalPayLabel = UILabel()
	let addToCar = UIButton()
	var isFromDetail = false

	override func viewDidLoad() {
		super.viewDidLoad()

		print("ShopCartViewController viewDidLoad")
		// buildNavigationItem("购物车")
		let titleView = UILabel(frame: CGRectMake(0, 0, 100, 35))
		titleView.text = "购物车"
        if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
            titleView.font = UIFont.boldSystemFontOfSize(16)
        } else {
            titleView.font = UIFont.boldSystemFontOfSize(14)
        }
		titleView.textAlignment = NSTextAlignment.Center
		titleView.textColor = UIColor.whiteColor()
		navigationItem.titleView = titleView
		self.navigationController?.navigationBar.barTintColor = BMNavigationBarColor
		self.navigationItem.setHidesBackButton(true, animated: true)
		// Do any additional setup after loading the view.
		view = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationH))
		view.backgroundColor = UIColor.blueColor()

		if isFromDetail {
			bottomView = UIView(frame: CGRectMake(0, ScreenHeight - 40 - NavigationH, ScreenWidth, 40))
		}
		else {
			bottomView = UIView(frame: CGRectMake(0, ScreenHeight - 89 - NavigationH, ScreenWidth, 40))
		}
		bottomView?.backgroundColor = BMGreyBackgroundColor

		buildProductsTableView()
		initBottomView()
		view.addSubview(bottomView!)
		addNSNotification()
		addToCar.enabled = false

		if SysUtils.get("uid") == nil {
			let vc = LoginViewController()
			let nvc = BaseNavigationController.init(rootViewController: vc)
			self.navigationController?.presentViewController(nvc, animated: true, completion: nil)

		}

	}
	override func viewWillAppear(animated: Bool) {
		if SysUtils.get("uid") != nil {
			ProgressHUDManager.showWithStatus(Loading)
//
//			let delayInSeconds = 2.5
//			let popTime = dispatch_time(DISPATCH_TIME_NOW,
//				Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
//			dispatch_after(popTime, dispatch_get_main_queue()) { // 2

			self.getMyShopCar()
			// }
		}

	}
	// MARK: - Build UI
	private func buildProductsTableView() {
		productsTableView = BMTableView(frame: view.bounds, style: .Plain)
		productsTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 99, right: 0)
		productsTableView?.backgroundColor = BMGlobalBackgroundColor
		productsTableView?.delegate = self
		productsTableView?.dataSource = self
		// productsTableView?.allowsMultipleSelection = true
		productsTableView?.showsVerticalScrollIndicator = false
		productsTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
//		productsTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.footRefresh))
		view.addSubview(productsTableView!)
	}
	func footRefresh() {
		productsTableView?.mj_footer.endRefreshing()
		print("刷新购物车....")
	}
	func headRefresh() {
		productsTableView?.mj_header.endRefreshing()
		if SysUtils.get("uid") == nil {
			let vc = LoginViewController()
			let nvc = BaseNavigationController.init(rootViewController: vc)
			self.navigationController?.presentViewController(nvc, animated: true, completion: nil)
			return

		}

		product_Data.removeAll()
		productsTableView?.reloadData()
		ProgressHUDManager.showWithStatus(Loading)
		getMyShopCar()
		print("刷新购物车....")
	}

	func getMyShopCar() {

		product_Data.removeAll()
		productsTableView?.reloadData()

		manager.request(APIRouter.GetShopCart(uid: "\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				print("购物车json \(json)")
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(ReturnFalse)
					break
				}
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let jsonArray = tempJson["StoreCartList"].arrayValue
					if jsonArray.count == 0 {
						// ProgressHUDManager.showInfoStatus("购物车空了,去逛逛吧")
						ShopCarRedDotView.sharedRedDotView.buyNumber = 0
						self.addToCar.enabled = false
						self.totalPay()
						SVProgressHUD.dismiss()
						break
					}
					var carcount = 0
					if jsonArray.count >= 1 {

						for i in 0 ... (jsonArray.count - 1) {
							let itemArray = jsonArray[i]["CartItemList"].arrayValue

							if itemArray.count >= 1 {
								for j in 0 ... (itemArray.count - 1) {
									carcount += 1
									// print(itemArray[j]["Item"]["OrderProductInfo"].description)
									let imgUrl = itemArray[j]["Item"]["OrderProductInfo"]["ShowImg"].stringValue
									let name = itemArray[j]["Item"]["OrderProductInfo"]["Name"].stringValue
									let shopPrice = itemArray[j]["Item"]["OrderProductInfo"]["ShopPrice"].stringValue
									let buyCount = itemArray[j]["Item"]["OrderProductInfo"]["RealCount"].stringValue
									let Id = itemArray[j]["Item"]["OrderProductInfo"]["Pid"].stringValue
									let uid = itemArray[j]["Item"]["OrderProductInfo"]["Uid"].stringValue
									let storeId = itemArray[j]["Item"]["OrderProductInfo"]["StoreId"].stringValue
									self.product_Data.append(ShopCar.init(ImgUrl: imgUrl, Name: name, ShopPrice: shopPrice, BuyCount: buyCount, ID: Id, Uid: uid, StoreID: storeId))
								}
							}
						}
						print("购物车商品数量\(carcount)")
						// 显示购物车小图标
						ShopCarRedDotView.sharedRedDotView.buyNumber = carcount
						SVProgressHUD.dismiss()
						self.productsTableView?.reloadData()
						// self.totalPay()
						self.addToCar.enabled = true
						break
					}
				}
			}
		})
	}

	func totalPay() {
		var count = 0.0
		if product_Data.count == 0 {
			totalPayLabel.text = ""
			return
		}
		for i in 0 ... (product_Data.count - 1) {
			count += (Double.init(product_Data[i].shopPrice)! * Double.init(product_Data[i].buyCount)!)
		}

		if SysUtils.get("zhekou") != nil && SysUtils.get("zhekoutitle") != nil {
			let p = SysUtils.get("zhekou") as! NSString
			print("zhekou \(p.doubleValue*10/100)")
			let p1 = Double.init(count)

			let price = p1 * ((p.doubleValue * 10) / 100)

			totalPayLabel.text = " 总额(不含运费):￥ \(price.format()) (\(SysUtils.get("zhekoutitle")!))"
		} else {

			totalPayLabel.text = " 总额(不含运费): \(count) ￥"
		}
	}
	func initBottomView() {
		// shopCar = ShopCarView(frame: CGRectMake(ScreenWidth - 70, 50 - 61 - 10, 61, 61), shopViewClick: { () -> () in
		// let shopCarVC = ShopCartViewController()
		// let nav = BaseNavigationController(rootViewController: shopCarVC)
		// self.presentViewController(nav, animated: true, completion: nil)
		// })
		// bottomView?.addSubview(shopCar!)

		addToCar.setTitle("去结算", forState: .Normal)
		addToCar.titleLabel?.font = UIFont.systemFontOfSize(15)
		addToCar.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 0.99, green: 0.20, blue: 0.20, alpha: 1.00)), forState: UIControlState.Normal)
		addToCar.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 130, b: 136)), forState: UIControlState.Highlighted)
		addToCar.addTarget(self, action: #selector(self.toPay), forControlEvents: UIControlEvents.TouchUpInside)
		addToCar.titleLabel?.textAlignment = NSTextAlignment.Center
		bottomView?.addSubview(addToCar)
		bottomView?.addSubview(totalPayLabel)
		addToCar.snp_makeConstraints { (make) -> Void in
			make.height.right.equalTo(bottomView!)
			make.centerY.equalTo(bottomView!)
			make.width.equalTo(100)
		}
		totalPayLabel.textColor = UIColor.redColor()
		totalPayLabel.font = UIFont.systemFontOfSize(13)
		totalPayLabel.snp_makeConstraints { (make) -> Void in
			make.height.left.equalTo(bottomView!).inset(10)
			make.centerY.equalTo(bottomView!)
			make.width.equalTo(ScreenWidth - 120)
		}
	}

	func toPay() {
		select_product_Data.removeAll()

		print("结算")
		if product_Data.count == 0 {
			ProgressHUDManager.showInfoStatus("购物车空了,去逛逛吧")
			return
		}
		for obj in product_Data {
			if obj.isCheck {
				select_product_Data.append(obj)
			}
		}
		if select_product_Data.count == 0 {
			ProgressHUDManager.showInfoStatus("请选择需要购买的商品")
			return
		}
		let vc = EditOrderVC()
		vc.product_Data = self.select_product_Data
//		let nvc = BaseNavigationController()
//		nvc.addChildViewController(vc)
		self.navigationController?.pushViewController(vc, animated: true)
		// self.dismissViewControllerAnimated(true, completion: nil)
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

// MARK - Add Notification KVO Action
	private func addNSNotification() {
		// NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopCartViewController.totalPay), name: ShopCarDidChangeNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopCartViewController.getMyShopCar), name: "CreateOrder", object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopCartViewController.reduce(_:)), name: ShopCarDidReduce, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopCartViewController.add(_:)), name: ShopCarAdd, object: nil)
	}
	func add(noti: NSNotification) {
		print("add\(noti.object)")
		addToCar(noti.object! as! String, count: "1")

	}
	func reduce(noti: NSNotification) {
		print("reduce\(noti.object)")
		addToCar(noti.object! as! String, count: "-1")

	}
	func addToCar(id: String, count: String) {
		if !checkLogin() {
			return
		}

		manager.request(APIRouter.AddProductToCart(uid: "\(SysUtils.get("uid")!)", pid: id, count: count)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			NSNotificationCenter.defaultCenter().postNotificationName(ShopCarDidChangeNotification, object: nil, userInfo: nil)
		})
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func leftNavigitonItemClick() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension ShopCartViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return product_Data.count
		// return 11
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = ShopCarCell.cellWithTableView(tableView)
		cell.goods = product_Data[indexPath.row]
		cell.checkBtn.tag = indexPath.row

		cell.checkBtn.addTarget(self, action: #selector(ShopCartViewController.clickCheck(_:)), forControlEvents: .TouchUpInside)
		return cell
	}

	func clickCheck(sender: UIButton) {

		print("选择row \(sender.tag)")
		let index = NSIndexPath.init(forRow: sender.tag, inSection: 0)
		tableView(self.productsTableView!, didSelectRowAtIndexPath: index)

	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		return 105
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("点击商品")
		self.productsTableView?.deselectRowAtIndexPath(indexPath, animated: true)
		product_Data[indexPath.row].isCheck = !product_Data[indexPath.row].isCheck
		self.productsTableView?.reloadData()
	}

	func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
		return "删除"
	}

	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		deleteCarProduct(indexPath)
	}

	func deleteCarProduct(index: NSIndexPath) {
		ProgressHUDManager.showWithStatus("正在删除")
		let product = product_Data[index.row]
		manager.request(APIRouter.deleteCartProduct(uid: product.uid, pid: product.Id)).responseJSON(completionHandler: {
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