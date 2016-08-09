//
//  EditOrderVC.swift
//  BrnMall
//
//  Created by luoyp on 16/4/8.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import MJRefresh

class EditOrderVC: BaseViewController {

	var product_Data: [ShopCar] = []
	var receiptAdressView: ReceiptAddressView?
	private var scrollView = UIScrollView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 50))
	private var tableHeaderView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 200))

	let bottomView = UIView(frame: CGRectMake(0, ScreenHeight - 50 - 60, ScreenWidth, 45))
	let shifuLabel = UILabel.init(frame: CGRect.init(x: 8, y: 0, width: 240, height: 50))
	private let payActionSheet: PayActionSheet = PayActionSheet()
	var couponLabel: UILabel!
	var beisongLabel: UILabel!
	var payType = 0
	var beisong = -1
	var payName = "alipay"

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		buildNavigationItem("填写订单")
		navigationController?.setNavigationBarHidden(false, animated: true)
		buildScrollView()

//		for i in 0 ..< product_Data.count {
//			print(product_Data[i].name + " 数量:" + product_Data[i].buyCount)
//		}
		// Do any additional setup after loading the view.
	}
	override func leftNavigitonItemClick() {
		// NSNotificationCenter.defaultCenter().postNotificationName(LFBShopCarBuyProductNumberDidChangeNotification, object: nil, userInfo: nil)
		self.navigationController?.popViewControllerAnimated(true)
	}
	private func buildScrollView() {
		scrollView.contentSize = CGSize(width: ScreenWidth, height: 1000)
		scrollView.backgroundColor = UIColor.clearColor()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		view.addSubview(scrollView)

		buildTableHeaderView()
		scrollView.addSubview(tableHeaderView)
	}
	func headRefresh() {
		scrollView.mj_header.endRefreshing()
		if -1 == self.beisong {
			ProgressHUDManager.showInfoStatus("请选择备送方式")
			return
		}
		getShipFreeAmount("\(self.beisong)")
	}
	private func buildTableHeaderView() {
		shifuLabel.textColor = UIColor.redColor()
		shifuLabel.font = UIFont.systemFontOfSize(12)

		tableHeaderView.backgroundColor = UIColor.clearColor()
		buildReceiptAddress()
		buildCouponView()
		beisongView()
		buildCarefullyView()
	}
	private func buildCouponView() {
		let couponView = UIView(frame: CGRectMake(0, 110, ScreenWidth, 40))
		couponView.backgroundColor = UIColor.whiteColor()
		tableHeaderView.addSubview(couponView)

		let couponImageView = UIImageView(image: UIImage(named: "pay_icon"))
		couponImageView.frame = CGRectMake(15, 10, 20, 20)
		couponView.addSubview(couponImageView)

		couponLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(couponImageView.frame) + 10, 0, ScreenWidth * 0.4, 40))
		couponLabel.text = "支付方式"
		couponLabel.textColor = UIColor.redColor()
		couponLabel.font = UIFont.systemFontOfSize(14)
		couponView.addSubview(couponLabel)

		let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
		arrowImageView.frame = CGRectMake(ScreenWidth - 10 - 5, 15, 5, 10)
		couponView.addSubview(arrowImageView)

		let btn = UIButton(frame: CGRectMake(ScreenWidth - 65, 0, 40, 40))
		btn.setTitle("选择", forState: UIControlState.Normal)
		btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
		btn.titleLabel?.font = UIFont.systemFontOfSize(14)
		btn.addTarget(self, action: #selector(EditOrderVC.selectPayType), forControlEvents: UIControlEvents.TouchUpInside)
		couponView.addSubview(btn)

		buildLineView(couponView, lineFrame: CGRectMake(0, 40 - 1, ScreenWidth, 1))
	}
	func selectBeisongType() {
		print("配送")
		let alert = UIAlertController.init(title: "选择配送方式", message: "", preferredStyle: .ActionSheet)

		let photo = UIAlertAction.init(title: "配送上门", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
			self.beisong = 0
			self.beisongLabel.text = "配送方式:   配送上门"
			self.getShipFreeAmount("\(self.beisong)")
		})

		let takephoto = UIAlertAction.init(title: "上门自提", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
			self.beisong = 1
			self.beisongLabel.text = "配送方式:   上门自提"
			self.getShipFreeAmount("\(self.beisong)")
		})

		alert.addAction(photo)
		alert.addAction(takephoto)

		self.presentViewController(alert, animated: true, completion: nil)
		return
	}
	func getShipFreeAmount(beisong: String) {
		let aid = receiptAdressView?.adress?.aid
		var list = ""
		for i in 0 ..< product_Data.count {
			if i == product_Data.count - 1 {
				list.appendContentsOf("0_\(product_Data[i].Id)")
			}
			else {
				list.appendContentsOf("0_\(product_Data[i].Id),")
			}
		}
		if let said = aid {
			manager.request(APIRouter.getShipFreeAmount("\(SysUtils.get("uid")!)", said, list, beisong)).responseJSON(completionHandler: {
				data in
				// print(data.result.value)
				switch data.result {

				case .Failure:
					ProgressHUDManager.showInfoStatus("网络异常,暂时无法获取运费信息,下拉刷新试试")
					break

				case .Success:
					let json: JSON = JSON(data.result.value!)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus("网络异常,暂时无法获取运费信息,下拉刷新试试")
						break
					}
					if "true" == json["result"].stringValue {
						let tempJson = json["data"]
						let price = tempJson["ProductAmount"].doubleValue
						let ship = tempJson["ShipFree"].doubleValue

						self.shifuLabel.text = "实付:￥\(price+ship) (会员价) 运费:￥\(ship)"
						SVProgressHUD.dismiss()
						break
					}
				}
			})
		} else {
			ProgressHUDManager.showInfoStatus("地址信息异常,请重新选择地址")
		}

	}
	private func beisongView() {
		let couponView2 = UIView(frame: CGRectMake(0, 160, ScreenWidth, 40))
		couponView2.backgroundColor = UIColor.whiteColor()
		tableHeaderView.addSubview(couponView2)

		let couponImageView = UIImageView(image: UIImage(named: "ship_icon"))
		couponImageView.frame = CGRectMake(15, 10, 20, 20)
		couponView2.addSubview(couponImageView)

		beisongLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(couponImageView.frame) + 10, 0, ScreenWidth * 0.4, 40))
		beisongLabel.text = "配送方式"
		beisongLabel.textColor = UIColor.redColor()
		beisongLabel.font = UIFont.systemFontOfSize(14)
		couponView2.addSubview(beisongLabel)

		let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
		arrowImageView.frame = CGRectMake(ScreenWidth - 10 - 5, 15, 5, 10)
		couponView2.addSubview(arrowImageView)

		let btn2 = UIButton(frame: CGRectMake(ScreenWidth - 65, 0, 40, 40))
		btn2.setTitle("选择", forState: UIControlState.Normal)
		btn2.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
		btn2.titleLabel?.font = UIFont.systemFontOfSize(14)
		btn2.userInteractionEnabled = true
		btn2.addTarget(self, action: #selector(EditOrderVC.selectBeisongType), forControlEvents: UIControlEvents.TouchUpInside)
		couponView2.addSubview(btn2)

		buildLineView(couponView2, lineFrame: CGRectMake(0, 40 - 1, ScreenWidth, 1))
	}

	func selectPayType() {
		payActionSheet.showActionSheetViewShowInView(view) { (payType) -> () in
			print(payType.rawValue)
			self.payType = payType.rawValue
			if payType.rawValue == 1 {
				self.payName = "alipay"
				self.couponLabel.text = "支付方式   在线支付"
			}
			if payType.rawValue == 2 {
				self.payName = "creditpay"
				self.couponLabel.text = "支付方式   余额支付"
			}
			if payType.rawValue == 3 {

			}
		}
	}
	private func buildCarefullyView() {
		let carefullyView = UIView(frame: CGRectMake(0, 210, ScreenWidth, 30))
		carefullyView.backgroundColor = UIColor.whiteColor()
		tableHeaderView.addSubview(carefullyView)

		buildLabel(CGRectMake(15, 0, 100, 30), textColor: BMInfoLabelTextHintColor, font: UIFont.systemFontOfSize(13), addView: carefullyView, text: "订单商品信息")

		let goodsView = ShopCartGoodsListView(frame: CGRectMake(0, CGRectGetMaxY(carefullyView.frame), ScreenWidth, 300), goodses: product_Data)
		goodsView.frame.size.height = goodsView.goodsHeight
		scrollView.addSubview(goodsView)

//		let costDetailView = CostDetailView(frame: CGRectMake(0, CGRectGetMaxY(goodsView.frame) + 10, ScreenWidth, 135))
//		scrollView.addSubview(costDetailView)
//
		scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(goodsView.frame) + 15)

		bottomView.backgroundColor = UIColor.whiteColor()
		buildLineView(bottomView, lineFrame: CGRectMake(0, 0, ScreenWidth, 1))
		bottomView.addSubview(shifuLabel)
		view.addSubview(bottomView)

		if SysUtils.get("zhekou") != nil && SysUtils.get("zhekoutitle") != nil {
			let p = SysUtils.get("zhekou") as! NSString
			print("zhekou \(p.doubleValue*10/100)")
			let p1 = Double.init((totalPay(product_Data)))

			let price = p1! * ((p.doubleValue * 10) / 100)

			shifuLabel.text = "实付:￥\(price.format())  (\(SysUtils.get("zhekoutitle")!))"
		} else {

			shifuLabel.text = "实付:￥\(totalPay(product_Data))"
		}

////		var priceText = costDetailView.coupon == "0" ? UserShopCarTool.sharedUserShopCar.getAllProductsPrice() : "\((UserShopCarTool.sharedUserShopCar.getAllProductsPrice() as NSString).floatValue - 5)"
////		if (priceText as NSString).floatValue < 30 {
////			priceText = "\((priceText as NSString).floatValue + 8)".cleanDecimalPointZear()
////		}
//		// buildLabel(CGRectMake(85, 0, 150, 50), textColor: UIColor.redColor(), font: UIFont.systemFontOfSize(14), addView: bottomView, text: "$" + priceText)
//
		let payButton = UIButton(frame: CGRectMake(ScreenWidth - 80, 1, 80, 45))
		payButton.titleLabel?.font = UIFont.systemFontOfSize(12)
		payButton.setTitle("提交订单", forState: UIControlState.Normal)
		payButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		payButton.backgroundColor = UIColor(red: 0.99, green: 0.20, blue: 0.20, alpha: 1.00)
		payButton.addTarget(self, action: #selector(EditOrderVC.postOrder), forControlEvents: UIControlEvents.TouchUpInside)
		bottomView.addSubview(payButton)

	}

	func postOrder() {
		if receiptAdressView?.adress?.address.characters.count == 0 || receiptAdressView?.adress?.name.characters.count == 0 || receiptAdressView?.adress?.mobile.characters.count == 0 {
			ProgressHUDManager.showInfoStatus("请完善地址信息")
			return
		}

		if 0 == payType {
			ProgressHUDManager.showInfoStatus("请选择支付方式")
			return
		}
		if -1 == beisong {
			ProgressHUDManager.showInfoStatus("请选择备送方式")
			return
		}
		ProgressHUDManager.showWithStatus("正在提交订单")

		var list = ""
		for i in 0 ..< product_Data.count {
			if i == product_Data.count - 1 {
				list.appendContentsOf("0_\(product_Data[i].Id)")
			}
			else {
				list.appendContentsOf("0_\(product_Data[i].Id),")
			}
		}
		print(list)
		// 请求开始
		manager.request(APIRouter.CreateOrder(uid: "\(SysUtils.get("uid")!)", said: (self.receiptAdressView!.adress?.aid)!, productList: list, payname: payName, remark: "", "\(self.beisong)")).responseJSON(completionHandler: {
			data in

			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				print(json)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					break
				}

				if "true" == json["result"].stringValue {

					NSNotificationCenter.defaultCenter().postNotificationName("CreateOrder", object: nil, userInfo: nil)

					print(json["data"])

					if self.payName == "cod" {
						ProgressHUDManager.showInfoStatus("成功提交订单")
						self.performSelector("back", withObject: nil, afterDelay: 2.2)
						return
					}
					ProgressHUDManager.showInfoStatus("成功提交订单")
					// self.navigationController?.popViewControllerAnimated(true)
//					if SysUtils.get("zhekou") != nil && SysUtils.get("zhekoutitle") != nil {
//						let p = SysUtils.get("zhekou") as! NSString
//						print("zhekou \(p.doubleValue*10/100)")
//						let p1 = json["data"]["OrderAmount"].doubleValue
//
//						let price = (p1 * ((p.doubleValue * 10) / 100))
//
//						let vc = PayVC()
//						vc.order = MyOrder.init(id: json["data"]["Oid"].intValue, title: json["data"]["OSN"].stringValue, content: json["data"]["StoreName"].stringValue, url: "", createdAt: "", price: price, paid: true, productID: json["data"]["Oid"].intValue)
//						self.navigationController!.pushViewController(vc, animated: true)
//
//					} else {
					ProgressHUDManager.showInfoStatus("成功提交订单")
					self.performSelector("toOrderVC", withObject: nil, afterDelay: 1.5)

//					let vc = PayVC()
//					vc.order = MyOrder.init(id: json["data"]["Oid"].intValue, title: json["data"]["OSN"].stringValue, content: json["data"]["StoreName"].stringValue, url: "", createdAt: "", price: json["data"]["Surplusmoney"].doubleValue, paid: true, productID: json["data"]["Oid"].intValue)
//					self.navigationController!.pushViewController(vc, animated: true)
					// }

					break
				}
				// order = MyOrder(id: 2, title: "测试订单标题", content: "订单描述内容", url: "", createdAt: "", price: 0.1, paid: true, productID: 100);
			}
		})
	}
	func toOrderVC() {
		self.navigationController?.popViewControllerAnimated(true)
		let vc = OrderViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	func back() {
		self.navigationController?.popViewControllerAnimated(true)
	}
	func totalPay(goodses: [ShopCar]) -> String {
		var count = 0.0
		for i in 0 ... (goodses.count - 1) {
			count += (Double.init(goodses[i].shopPrice)! * Double.init(goodses[i].buyCount)!)
		}
		return String.init(count)
	}

	private func buildLabel(labelFrame: CGRect, textColor: UIColor, font: UIFont, addView: UIView, text: String) {
		let label = UILabel(frame: labelFrame)
		label.textColor = textColor
		label.font = font
		label.text = text
		addView.addSubview(label)
	}

	private func buildLineView(addView: UIView, lineFrame: CGRect) {
		let lineView = UIView(frame: lineFrame)
		lineView.backgroundColor = UIColor.blackColor()
		lineView.alpha = 0.1
		addView.addSubview(lineView)
	}

	private func buildReceiptAddress() {

		receiptAdressView = ReceiptAddressView(frame: CGRectMake(0, 10, view.width, 85), modifyButtonClickCallBack: { () -> () in
			let vc = MyAdressViewController()
			vc.isSelectVC = true
			vc.editVC = self
			self.navigationController?.pushViewController(vc, animated: true)
		})

		tableHeaderView.addSubview(receiptAdressView!)
		manager.request(APIRouter.MyAddressList(uid: "\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
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
					let jsonArray = tempJson["ShipAddressList"].arrayValue
					if jsonArray.count == 0 {
						SVProgressHUD.dismiss()
						self.receiptAdressView?.adress = Address.init(Uid: "", Aid: "", Name: "", RegionId: "", Address: "", Mobile: "", Phone: "", ZipCode: "", Email: "", IsDefault: "", ProvinceName: "", CityName: "", CountyName: "", Provinceid: "", Cityid: "", Countyid: "")
						break
					}

					if jsonArray.count >= 1 {

						// print(itemArray[j]["Item"]["OrderProductInfo"].description)
						let uid = jsonArray[0]["Uid"].stringValue
						let aid = jsonArray[0]["SAId"].stringValue
						let name = jsonArray[0]["Consignee"].stringValue
						let regionId = jsonArray[0]["RegionId"].stringValue
						let mobile = jsonArray[0]["Mobile"].stringValue
						let address = jsonArray[0]["Address"].stringValue
						let phone = jsonArray[0]["Phone"].stringValue
						let zipcode = jsonArray[0]["ZipCode"].stringValue
						let email = jsonArray[0]["Email"].stringValue
						let isDefault = jsonArray[0]["IsDefault"].stringValue
						let addr = Address.init(Uid: uid, Aid: aid, Name: name, RegionId: regionId, Address: address, Mobile: mobile, Phone: phone, ZipCode: zipcode, Email: email, IsDefault: isDefault, ProvinceName: "", CityName: "", CountyName: "", Provinceid: "", Cityid: "", Countyid: "")
						self.receiptAdressView?.adress = addr
						if -1 == self.beisong {
							self.getShipFreeAmount("0")
						}
						SVProgressHUD.dismiss()
					}
					break
				}
			}
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
