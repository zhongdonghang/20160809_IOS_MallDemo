//
//  FirstViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import MJRefresh

class HomeViewController: BaseViewController, TitleViewProtocol, UITextFieldDelegate {

	private var flag: Int = -1
	private var headView: HomeTableHeadView?
	private var goodsTableView: BMTableView!
	private var lastContentOffsetY: CGFloat = 0
	private var isAnimation: Bool = false
	private var headData: HeadResources?

	var bannerImg: [HeadResources] = []
	var hotGoods1: [HotGoods] = []
	var hotGoods2: [HotGoods] = []
	var hotGoods3: [HotGoods] = []
	var hotGoods4: [HotGoods] = []
	var hotGoods5: [HotGoods] = []
	var hotGoods6: [HotGoods] = []
	var hotGoods7: [HotGoods] = []
	var navView: UIView!

	private let searchBar = UITextField()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.colorWithCustom(0.94, g: 0.94, b: 0.94)
		print("HomeViewController viewDidLoad")
		navigationController?.navigationBar.barTintColor = BMNavigationBarColor

		let titleView = UILabel(frame: CGRectMake(10, 0, 100, 35))
		titleView.text = "精生缘商城"
		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			titleView.font = UIFont.boldSystemFontOfSize(16)
		} else {
			titleView.font = UIFont.boldSystemFontOfSize(14)
		}
		titleView.textAlignment = NSTextAlignment.Center
		titleView.textColor = UIColor.whiteColor()
		navigationItem.titleView = titleView

		setupSearchBar()
		addHomeNotification()

		buildTableView()

		buildTableHeadView()

		getBannerImg()

		getHomeHotGoods()

		NSNotificationCenter.defaultCenter().postNotificationName("ShopCarDidChange", object: nil, userInfo: nil)

		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewDidDisappear(animated: Bool) {
		// navView.hidden = true

	}
	func setupSearchBar() {
		navView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 44))
		// self.navigationController?.navigationBar.addSubview(navView)
		view.addSubview(navView)
		navView.backgroundColor = UIColor.init(red: 0.59, green: 0.22, blue: 0.59, alpha: 1.0)

		// 左边logo
		let logoView = UIImageView(image: UIImage.init(named: "homelogo"))
		logoView.frame = CGRect.init(x: 5, y: 0, width: 98, height: 44)
		logoView.center.x = 40
		logoView.center.y = 22
		navView.addSubview(logoView)

		let searchImg = UIButton()

		searchImg.frame = CGRect.init(x: ScreenWidth - 40, y: 0, width: 32, height: 32)
		searchImg.center.y = 22
		searchImg.setBackgroundImage(UIImage.init(named: "icon_search"), forState: UIControlState.Normal)
		searchImg.addTarget(self, action: #selector(HomeViewController.search), forControlEvents: UIControlEvents.TouchUpInside)
		navView.addSubview(searchImg)

		searchBar.frame = CGRectMake(95, 7, ScreenWidth - 140, 28)
		searchBar.placeholder = "输入商品名称"
		searchBar.delegate = self
		searchBar.keyboardType = UIKeyboardType.Default
		searchBar.font = UIFont.systemFontOfSize(13)
		searchBar.backgroundColor = UIColor.whiteColor()
		searchBar.layer.cornerRadius = 3
		searchBar.returnKeyType = .Search

		let paddingView = UIView(frame: CGRectMake(0, 0, 8, searchBar.frame.height))
		searchBar.leftView = paddingView
		searchBar.leftViewMode = UITextFieldViewMode.Always

		navView.addSubview(searchBar)
//		searchBar.addTarget(self, action: #selector(LoginViewController.textChanged), forControlEvents: UIControlEvents.EditingDidBegin)

	}
	func search() {
		if searchBar.text?.characters.count < 1 {
			ProgressHUDManager.showInfoStatus("请输入要查找的商品名称")
			return
		}
		let vc = SearchProductViewController()
		vc.keyword = searchBar.text!
		navigationController?.pushViewController(vc, animated: true)
		searchBar.text = ""
		searchBar.endEditing(false)
	}
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		search()
		return true
	}
	func addHomeNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "getMyShopCar", name: "ShopCarDidChange", object: nil)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "homeTableHeadViewHeightDidChange:", name: HomeTableHeadViewHeightDidChange, object: nil)
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	private func buildTableHeadView() {
		headView = HomeTableHeadView()

		headView?.delegate = self
		weak var tmpSelf = self
//
//		HeadResources.loadHomeHeadData { (data, error) -> Void in
//			if error == nil {
		// tmpSelf?.headView?.headData = HeadResources()
		// tmpSelf?.headData = HeadResources()
//				tmpSelf?.collectionView.reloadData()
//			}
//		}

		goodsTableView.addSubview(headView!)
		// tmpSelf?.collectionView.reloadData()
//		FreshHot.loadFreshHotData { (data, error) -> Void in
//			tmpSelf?.freshHot = data
//			tmpSelf?.collectionView.reloadData()
		tmpSelf?.goodsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
//		}
	}

	override func viewWillAppear(animated: Bool) {
		// navView.hidden = false
	}
	func getHomeHotGoods() {
		// ProgressHUDManager.showWithStatus("正在加载数据")
		let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		let group = dispatch_group_create()

		dispatch_group_async(group, globalQueue) { () -> Void in
			self.getHotGoods("33")
		}

		dispatch_group_async(group, globalQueue) { () -> Void in
			self.getHotGoods("34")
		}
		dispatch_group_async(group, globalQueue) { () -> Void in
			self.getHotGoods("35")
		}
		dispatch_group_async(group, globalQueue) { () -> Void in
			self.getHotGoods("36")
		}
		dispatch_group_async(group, globalQueue) { () -> Void in
			self.getHotGoods("37")
		}
		dispatch_group_async(group, globalQueue) { () -> Void in
			self.getHotGoods("38")
		}
		dispatch_group_async(group, globalQueue) { () -> Void in
			self.getHotGoods("39")
		}
		dispatch_group_notify(group, globalQueue) { () -> Void in
			ProgressHUDManager.dismiss()
			self.goodsTableView.reloadData()
		}
	}
	func getHotGoods(aid: String) {
		// ProgressHUDManager.showWithStatus("正在加载商品")
		manager.request(APIRouter.getAdByID(adId: aid)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)

			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				// print("首页返回热销商品 \(json)")
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(ReturnFalse)
					break
				}
				if "true" == json["result"].stringValue {

					let jsonArray = json["data"].arrayValue

					if jsonArray.count == 0 {
						// ProgressHUDManager.showInfoStatus(NoData)
						break
					}
					if jsonArray.count > 0 {
						for obj in jsonArray {
							let AdId = obj["AdId"].stringValue
							let AdPosId = obj["AdPosId"].stringValue
							let Title = obj["Title"].stringValue
							let Url = obj["Url"].stringValue
							let Body = obj["Body"].stringValue
							let ExtField1 = obj["ExtField1"].stringValue
							let ExtField2 = obj["ExtField2"].stringValue
							let ExtField3 = obj["ExtField3"].stringValue
							let ExtField4 = obj["ExtField4"].stringValue
							let ExtField5 = obj["ExtField5"].stringValue
							let State = obj["State"].stringValue
							let Type = obj["Type"].stringValue
							let img = obj["Body"].stringValue

							if aid == "34" {
								self.hotGoods1.append(HotGoods.init(Adid: AdId, Adposid: AdPosId, Title: Title, Url: Url, Body: adImgUrl + Body, ExtField1: ExtField1, ExtField2: ExtField2, ExtField3: ExtField3, ExtField4: ExtField4, ExtField5: ExtField5))
							}
							if aid == "35" {
								self.hotGoods2.append(HotGoods.init(Adid: AdId, Adposid: AdPosId, Title: Title, Url: Url, Body: adImgUrl + Body, ExtField1: ExtField1, ExtField2: ExtField2, ExtField3: ExtField3, ExtField4: ExtField4, ExtField5: ExtField5))
							}
							if aid == "36" {
								self.hotGoods3.append(HotGoods.init(Adid: AdId, Adposid: AdPosId, Title: Title, Url: Url, Body: adImgUrl + Body, ExtField1: ExtField1, ExtField2: ExtField2, ExtField3: ExtField3, ExtField4: ExtField4, ExtField5: ExtField5))
							}
							if aid == "37" {
								self.hotGoods4.append(HotGoods.init(Adid: AdId, Adposid: AdPosId, Title: Title, Url: Url, Body: adImgUrl + Body, ExtField1: ExtField1, ExtField2: ExtField2, ExtField3: ExtField3, ExtField4: ExtField4, ExtField5: ExtField5))
							}
							if aid == "38" {
								self.hotGoods5.append(HotGoods.init(Adid: AdId, Adposid: AdPosId, Title: Title, Url: Url, Body: adImgUrl + Body, ExtField1: ExtField1, ExtField2: ExtField2, ExtField3: ExtField3, ExtField4: ExtField4, ExtField5: ExtField5))
							}
							if aid == "33" {
								self.hotGoods6.append(HotGoods.init(Adid: AdId, Adposid: AdPosId, Title: Title, Url: Url, Body: adImgUrl + Body, ExtField1: ExtField1, ExtField2: ExtField2, ExtField3: ExtField3, ExtField4: ExtField4, ExtField5: ExtField5))
							}
							if aid == "39" {
								self.hotGoods7.append(HotGoods.init(Adid: AdId, Adposid: AdPosId, Title: Title, Url: Url, Body: adImgUrl + Body, ExtField1: ExtField1, ExtField2: ExtField2, ExtField3: ExtField3, ExtField4: ExtField4, ExtField5: ExtField5))
							}
						}
						SVProgressHUD.dismiss()
						self.goodsTableView.reloadData()
						break
					}
				}
			}
		})
	}

	func getBannerImg() {
		manager.request(APIRouter.getAdByID(adId: "2")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			// ProgressHUDManager.dismiss()

			switch data.result {

			case .Failure:

				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					for i in 0 ... 3 {
						self.bannerImg.append(HeadResources.init(Img: "", Pid: "", Title: ""))
					}
					break
				}
				if "true" == json["result"].stringValue {

					let jsonArray = json["data"].arrayValue

					if jsonArray.count == 0 {
						for i in 0 ... 3 {
							self.bannerImg.append(HeadResources.init(Img: "", Pid: "", Title: ""))
						}
						break
					}
					if jsonArray.count > 0 {
						for obj in jsonArray {
							let img = obj["Body"].stringValue
							let pid = obj["ExtField5"].stringValue
							let title = obj["Title"].stringValue
							self.bannerImg.append(HeadResources.init(Img: adImgUrl + img, Pid: pid, Title: title))
							// print("广告图片数量 \(self.bannerImg.count)")
						}
						self.headView?.headData = self.bannerImg

						self.goodsTableView.reloadData()
						break
					}
				}
			}
		})
	}

// MARK: Notifiation Action
	func homeTableHeadViewHeightDidChange(noti: NSNotification) {
		goodsTableView!.contentInset = UIEdgeInsetsMake(noti.object as! CGFloat, 0, NavigationH, 0)
		goodsTableView!.setContentOffset(CGPoint(x: 0, y: -(goodsTableView!.contentInset.top)), animated: false)
		lastContentOffsetY = goodsTableView.contentOffset.y
	}

	private func buildTableView() {

		goodsTableView = BMTableView.init(frame: CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108), style: UITableViewStyle.Grouped)
		goodsTableView.delegate = self
		goodsTableView.dataSource = self

		goodsTableView.backgroundColor = BMGlobalBackgroundColor
		goodsTableView.showsVerticalScrollIndicator = false
		goodsTableView.keyboardDismissMode = .OnDrag
		view.addSubview(goodsTableView)
//
//		let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: "headRefresh")
//		refreshHeadView.gifView?.frame = CGRectMake(0, 30, 100, 100)
		goodsTableView.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: "headRefresh")
	}
	func headRefresh() {

		self.goodsTableView.mj_header.endRefreshing()
		hotGoods1.removeAll()
		hotGoods2.removeAll()
		hotGoods3.removeAll()
		hotGoods4.removeAll()
		hotGoods5.removeAll()
		hotGoods6.removeAll()
		hotGoods7.removeAll()

		bannerImg.removeAll()
		getBannerImg()

		getHomeHotGoods()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func getMyShopCar() {

		if SysUtils.get("uid") == nil {
			return

		}

		manager.request(APIRouter.GetShopCart(uid: "\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					// ProgressHUDManager.showInfoStatus(ReturnFalse)
					break
				}
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let jsonArray = tempJson["StoreCartList"].arrayValue
					if jsonArray.count == 0 {
						break
					}
					var carcount = 0

					if jsonArray.count >= 1 {

						for i in 0 ... (jsonArray.count - 1) {
							let itemArray = jsonArray[i]["CartItemList"].arrayValue
							for j in 0 ... (itemArray.count - 1) {
								carcount += 1
							}
						}
						print("购物车商品数量\(carcount)")
						// 显示购物车小图标
						ShopCarRedDotView.sharedRedDotView.buyNumber = carcount
						break
					}
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

// MARK:- HomeHeadViewDelegate TableHeadViewAction
extension HomeViewController: HomeTableHeadViewDelegate {
	func tableHeadView(headView: HomeTableHeadView, focusImageViewClick index: Int) {
		print("点击广告 \(index)")
		let vc = ProductDetailViewController()
		vc.isFromFavorite = false
		vc.pid = bannerImg[index].pid
		vc.title = bannerImg[index].title

		self.navigationController?.pushViewController(vc, animated: true)
	}

}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, HomeCellDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// 1
		// Return the number of sections.
		return 8
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// 2
		if section == 0 {
			return 1
		}
		if section == 1 {
			return hotGoods1.count
		}
		if section == 2 {
			return hotGoods2.count
		}
		if section == 3 {
			return hotGoods3.count
		}
		if section == 4 {
			return hotGoods4.count
		}
		if section == 5 {
			return hotGoods5.count
		}
		if section == 6 {
			return hotGoods6.count
		}
		if section == 7 {
			return hotGoods7.count
		}
		return 0
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = HomeItemCell.cellWithTableView(tableView, index: indexPath)
			cell.delegate = self
			return cell
		}
		let cell = HomeTableViewCell.cellWithTableView(tableView, index: indexPath)
		if indexPath.section == 1 {
			cell.goods = hotGoods1[indexPath.row]
		}
		if indexPath.section == 2 {
			cell.goods = hotGoods2[indexPath.row]
		}
		if indexPath.section == 3 {
			cell.goods = hotGoods3[indexPath.row]
		}
		if indexPath.section == 4 {
			cell.goods = hotGoods4[indexPath.row]
		}
		if indexPath.section == 5 {
			cell.goods = hotGoods5[indexPath.row]
		}
		if indexPath.section == 6 {
			cell.goods = hotGoods6[indexPath.row]
		}
		if indexPath.section == 7 {
			cell.goods = hotGoods7[indexPath.row]
		}
		cell.delegate = self
		return cell
	}
	func homeCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int) {

		print(buttonType)

		if buttonType == 3314 {
			print("1")
			cateIndex = 0
			let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController
			tabBarController.setSelectIndex(from: 0, to: 2)
			return
		}
		if buttonType == 3315 {
			print("2")
			cateIndex = 3
			let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController
			tabBarController.setSelectIndex(from: 0, to: 2)
			return
		}
		if buttonType == 3316 {
			print("3")
			cateIndex = 4
			let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController
			tabBarController.setSelectIndex(from: 0, to: 2)
			return
		}
		if buttonType == 3317 {
			print("4")
			cateIndex = 5
			let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController
			tabBarController.setSelectIndex(from: 0, to: 2)
			return
		}
		if buttonType == 3318 {
			print("5")
			let vc = SearchProductViewController()
			navigationController?.pushViewController(vc, animated: true)
			return
		}

		var pid = ""

		if indexPath.section == 1 {
			pid = hotGoods1[indexPath.row].ExtField5
		}
		if indexPath.section == 2 {
			pid = hotGoods2[indexPath.row].ExtField5
		}
		if indexPath.section == 3 {
			pid = hotGoods3[indexPath.row].ExtField5
		}
		if indexPath.section == 4 {
			pid = hotGoods4[indexPath.row].ExtField5
		}
		if indexPath.section == 5 {
			pid = hotGoods5[indexPath.row].ExtField5
		}
		if indexPath.section == 6 {
			pid = hotGoods6[indexPath.row].ExtField5
		}
		if indexPath.section == 7 {
			pid = hotGoods7[indexPath.row].ExtField5
		}
		addToCar(pid)
	}
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

		return 0.1
	}
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 0.1
		}

		return 40
	}
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

		let footerview = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 2))
		footerview.backgroundColor = UIColor.clearColor()
		if section == 7 {
			footerview.backgroundColor = UIColor.clearColor()
			return footerview
		}
		return footerview
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		if indexPath.section == 0 {
			return 88
		}
		return 130
	}

	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let headerCell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CustomHeaderCell") as! CustomHeaderCell
//		headerCell.backgroundColor = UIColor.cyanColor()

		if section == 0 {
			let headerCell = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0))
			headerCell.backgroundColor = UIColor.clearColor()
			return headerCell
		}
		let headerCell = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
		headerCell.backgroundColor = UIColor.clearColor()
		var goods = UILabel(frame: CGRect(x: 15, y: 0, width: ScreenWidth, height: 40))
		goods.textAlignment = .Left

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			goods.font = UIFont.systemFontOfSize(14)
		} else {
			goods.font = UIFont.systemFontOfSize(12)
		}
		goods.textColor = UIColor.darkGrayColor()
		headerCell.addSubview(goods)
		let line = UIView(frame: CGRect(x: 5, y: 38, width: ScreenWidth - 10, height: 2))
		headerCell.addSubview(line)

		let btn = UIButton(frame: CGRect(x: ScreenWidth - 60, y: 4, width: 58, height: 32))
		btn.backgroundColor = UIColor.clearColor()
		btn.setTitleColor(UIColor.init(red: 0.43, green: 0.78, blue: 0.95, alpha: 1.0), forState: UIControlState.Normal)
		btn.setTitleColor(UIColor.init(red: 0.43, green: 0.80, blue: 0.95, alpha: 1.0), forState: UIControlState.Highlighted)
		btn.titleLabel?.font = UIFont.systemFontOfSize(12)
		btn.setTitle("更多...", forState: UIControlState.Normal)
		btn.tag = section
		btn.addTarget(self, action: #selector(HomeViewController.clickMore(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		headerCell.addSubview(btn)

		switch (section) {
		case 1:
			goods.text = "保健品"
			line.backgroundColor = UIColor.init(red: 0.65, green: 0.82, blue: 0.48, alpha: 1.0)
		case 2:
			goods.text = "保健食品"
			line.backgroundColor = UIColor.init(red: 0.95, green: 0.41, blue: 0.52, alpha: 1.0)
		case 3:
			goods.text = "保健器材"
			line.backgroundColor = UIColor.init(red: 0.65, green: 0.82, blue: 0.48, alpha: 1.0)
		case 4:
			goods.text = "化妆品"
			line.backgroundColor = UIColor.init(red: 0.95, green: 0.41, blue: 0.52, alpha: 1.0)
		case 5:
			goods.text = "洗护用品"
			line.backgroundColor = UIColor.init(red: 0.65, green: 0.82, blue: 0.48, alpha: 1.0)
		case 6:
			goods.text = "情趣用品"
			line.backgroundColor = UIColor.init(red: 0.95, green: 0.41, blue: 0.52, alpha: 1.0)
		case 7:
			goods.text = "保健礼品"
			line.backgroundColor = UIColor.init(red: 0.65, green: 0.82, blue: 0.48, alpha: 1.0)
		default:
			goods.text = ""
		}
		return headerCell
	}
	func clickMore(sender: UIButton) {
		let section = sender.tag
		let vc = ProductsViewController()
//		vc.curID = curID
		cateIndex = section - 1

		switch (section) {
		case 1:
			print("保健品")
			vc.titlename = "保健品"
			break
		case 2:
			print("保健食品")
			vc.titlename = "保健食品"
			break
		case 3:
			print("保健器材")
			vc.titlename = "保健器材"
			break
		case 4:
			print("化妆品")
			vc.titlename = "化妆品"
			break
		case 5:
			print("洗护用品")
			vc.titlename = "洗护用品"
			break
		case 6:
			print("情趣用品")
			vc.titlename = "情趣用品"
			break
		case 7:
			print("保健礼品")
			vc.titlename = "保健礼品"
		default: break

		}
		let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController
		tabBarController.setSelectIndex(from: 0, to: 2)

		// self.navigationController?.pushViewController(vc, animated: true)
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("点击商品")
		if indexPath.section == 0 {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			return
		}
		let vc = ProductDetailViewController()
		vc.isFromFavorite = false
		if indexPath.section == 1 {
			vc.pid = hotGoods1[indexPath.row].ExtField5
			vc.name = hotGoods1[indexPath.row].ExtField1
			vc.price2 = hotGoods1[indexPath.row].ExtField2
		}
		if indexPath.section == 2 {
			vc.pid = hotGoods2[indexPath.row].ExtField5
			vc.name = hotGoods2[indexPath.row].ExtField1
			vc.price2 = hotGoods2[indexPath.row].ExtField2
		}
		if indexPath.section == 3 {
			vc.pid = hotGoods3[indexPath.row].ExtField5
			vc.name = hotGoods3[indexPath.row].ExtField1
			vc.price2 = hotGoods3[indexPath.row].ExtField2
		}
		if indexPath.section == 4 {
			vc.pid = hotGoods4[indexPath.row].ExtField5
			vc.name = hotGoods4[indexPath.row].ExtField1
			vc.price2 = hotGoods4[indexPath.row].ExtField2
		}
		if indexPath.section == 5 {
			vc.pid = hotGoods5[indexPath.row].ExtField5
			vc.name = hotGoods5[indexPath.row].ExtField1
			vc.price2 = hotGoods5[indexPath.row].ExtField2
		}
		if indexPath.section == 6 {
			vc.pid = hotGoods6[indexPath.row].ExtField5
			vc.name = hotGoods6[indexPath.row].ExtField1
			vc.price2 = hotGoods6[indexPath.row].ExtField2
		}
		if indexPath.section == 7 {
			vc.pid = hotGoods7[indexPath.row].ExtField5
			vc.name = hotGoods7[indexPath.row].ExtField1
			vc.price2 = hotGoods7[indexPath.row].ExtField2
		}
		self.navigationController?.pushViewController(vc, animated: true)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

