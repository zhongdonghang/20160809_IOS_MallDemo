//
//  OrderDetailVC.swift
//  BrnMall
//
//  Created by luoyp on 16/4/8.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import MJRefresh

class OrderDetailVC: BaseViewController {

	var order: Order!
	var proList: [OrderDetailPro] = []
	private var scrollView: UIScrollView?
	private let orderDetailView = OrderDetailView()
	private let orderUserDetailView = OrderUserDetailView()
	private let orderGoodsListView = OrderGoodsListView()
	private let evaluateView = UIView()
	private let evaluateLabel = UILabel()
	var bottomView: UIView!

	private lazy var starImageViews: [UIImageView] = {
		var starImageViews: [UIImageView] = []
		for i in 0 ... 4 {
			let starImageView = UIImageView(image: UIImage(named: "v2_star_no"))
			starImageViews.append(starImageView)
		}
		return starImageViews
	}()

	var orderDetail: OrderDetail? {
		didSet {
			orderDetailView.order = orderDetail
			orderUserDetailView.order = orderDetail
			orderGoodsListView.order = orderDetail

			let btnWidth: CGFloat = 80
			let btnHeight: CGFloat = 30
			var btncount = 1

//			if "10" == orderDetail?.orderstate {
//				btncount = 1
//			}
			if "30" == orderDetail?.orderstate {
				btncount = 2
			}
//			if "50" == orderDetail?.orderstate {
//
//			}
//			if "70" == orderDetail?.orderstate {
//
//			}
//			if "90" == orderDetail?.orderstate {
//
//			}
			if "110" == orderDetail?.orderstate {
				btncount = 2
			}
			if "140" == orderDetail?.orderstate {
				btncount = 2
			}
			if "160" == orderDetail?.orderstate {
				btncount = 2
			}
//			if "180" == orderDetail?.orderstate {
//				statusTextLabel?.text = "锁定"
//			}
//			if "200" == orderDetail?.orderstate {
//				statusTextLabel?.text = "取消"
//			}

			for i in 0 ..< btncount {
				var btn: UIButton!
				if i == 0 {
					continue
					btn = UIButton(frame: CGRectMake(10, view.height - 40, btnWidth, btnHeight))
					btn.setTitle("删除订单", forState: UIControlState.Normal)
					btn.backgroundColor = BMNavigationBarColor
				}
				if i == 1 {
					btn = UIButton(frame: CGRectMake(view.width - (10 + CGFloat(1) * (btnWidth + 10)), view.height - 40, btnWidth, btnHeight))
					btn.hidden = true
					if "110" == orderDetail?.orderstate && orderDetail!.paymode == "1" {
						btn.hidden = false
						btn.setTitle("确认收货", forState: UIControlState.Normal)
					}
					if "30" == orderDetail?.orderstate {
						btn.hidden = false
						btn.setTitle("去 付 款", forState: UIControlState.Normal)
					}
					if "140" == orderDetail?.orderstate {

						if orderDetail?.isreview == "0" {
							btn.hidden = false
							btn.setTitle("评  价", forState: UIControlState.Normal)

						}
					}
					if "160" == orderDetail?.orderstate {

						if orderDetail?.isreview == "0" {
							btn.hidden = false
							btn.setTitle("评  价", forState: UIControlState.Normal)
						}
					}
					btn.backgroundColor = UIColor.clearColor()
				}

				btn.setTitleColor(UIColor.redColor(), forState: .Normal)
				btn.titleLabel?.font = UIFont.systemFontOfSize(13)
				btn.layer.cornerRadius = 5;
				btn.layer.borderWidth = 0.5
				btn.layer.borderColor = UIColor.redColor().CGColor
				btn.tag = i
				btn.addTarget(self, action: #selector(OrderDetailVC.detailButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
				view.addSubview(btn)
			}

//			if -1 != order?.star {
//				for i in 0 ..< order!.star {
//					let imageView = starImageViews[i]
//					imageView.image = UIImage(named: "v2_star_on")
//				}
//			}
//
//			evaluateLabel.text = order?.comment
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		buildNavigationItem("订单详情")
		print(order.oid + "  " + order.uid)
		navigationController?.setNavigationBarHidden(false, animated: true)

		buildScrollView()

		buildOrderDetailView()

		buildOrderUserDetailView()

		buildOrderGoodsListView()

		bulidEvaluateView()
		buildDetailButtonsView()
		loadOderData()
	}

	private func buildScrollView() {
		scrollView = UIScrollView(frame: view.bounds)
		scrollView?.alwaysBounceVertical = true
		scrollView?.showsVerticalScrollIndicator = false
		scrollView?.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		scrollView?.contentSize = CGSizeMake(ScreenWidth, 1000)
		scrollView!.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		view.addSubview(scrollView!)
	}

	func headRefresh() {
		scrollView!.mj_header.endRefreshing()
		proList.removeAll()
		loadOderData()
	}

	private func buildOrderDetailView() {
		orderDetailView.frame = CGRectMake(0, 10, ScreenWidth, 185)

		scrollView?.addSubview(orderDetailView)
	}

	private func buildOrderUserDetailView() {
		orderUserDetailView.frame = CGRectMake(0, CGRectGetMaxY(orderDetailView.frame) + 10, ScreenWidth, 110)

		scrollView?.addSubview(orderUserDetailView)
	}

	private func buildDetailButtonsView() {
		bottomView = UIView(frame: CGRectMake(0, view.height - 50 - NavigationH, view.width, 1))
		bottomView.backgroundColor = UIColor.grayColor()
		bottomView.alpha = 0.1
		view.addSubview(bottomView)

		let bottomView1 = UIView(frame: CGRectMake(0, view.height - 49 - NavigationH, view.width, 49))
		bottomView1.backgroundColor = UIColor.whiteColor()
		view.addSubview(bottomView1)
	}

	func detailButtonClick(sender: UIButton) {
		print("点击了底部按钮 类型是" + "\(sender.tag)")

		if "140" == orderDetail!.orderstate || "160" == orderDetail!.orderstate {
			let vc = ReViewVC()
			vc.order = order
			navigationController?.pushViewController(vc, animated: true)
			return
		}

		if "110" == orderDetail!.orderstate {
			let alert = UIAlertController.init(title: "提示", message: "确认收货吗？", preferredStyle: .Alert)

			let ok = UIAlertAction.init(title: "取消", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in

			})

			let cancel = UIAlertAction.init(title: "确认收货", style: .Default, handler: {
				(action: UIAlertAction!) -> Void in
				let oid = self.orderDetail!.oid
				print(oid)
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
		// }
	}

	private func buildOrderGoodsListView() {
		orderGoodsListView.frame = CGRectMake(0, CGRectGetMaxY(orderUserDetailView.frame) + 10, ScreenWidth, 350)
		orderGoodsListView.delegate = self
		scrollView?.addSubview(orderGoodsListView)
	}

	private func bulidEvaluateView() {
		evaluateView.frame = CGRectMake(0, CGRectGetMaxY(orderGoodsListView.frame) + 10, ScreenWidth, 80)
		evaluateView.backgroundColor = UIColor.whiteColor()
		scrollView?.addSubview(evaluateView)

		let myEvaluateLabel = UILabel()
		myEvaluateLabel.text = "我的评价"
		myEvaluateLabel.textColor = BMTextBlackColor
		myEvaluateLabel.font = UIFont.systemFontOfSize(14)
		myEvaluateLabel.frame = CGRectMake(10, 5, ScreenWidth, 25)
		// evaluateView.addSubview(myEvaluateLabel)

		for i in 0 ... 4 {
			let starImageView = starImageViews[i]
			starImageView.frame = CGRectMake(10 + CGFloat(i) * 30, CGRectGetMaxY(myEvaluateLabel.frame) + 5, 25, 25)
			evaluateView.addSubview(starImageView)
		}

		evaluateLabel.font = UIFont.systemFontOfSize(14)
		evaluateLabel.frame = CGRectMake(10, CGRectGetMaxY(starImageViews[0].frame) + 10, ScreenWidth - 20, 25)
		evaluateLabel.textColor = BMTextBlackColor
		evaluateView.addSubview(evaluateLabel)
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
						NSNotificationCenter.defaultCenter().postNotificationName("paySuccessreloadorder", object: nil, userInfo: nil)
						// self.loadOderData()
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
						self.navigationController?.popViewControllerAnimated(true)

					}
					break
				}
				ProgressHUDManager.showInfoStatus("服务器繁忙,请稍后再试吧")
				// ProgressHUDManager.dismiss()
				break
			}
		})
	}
	private func loadOderData() {
		ProgressHUDManager.showWithStatus(Loading)
		manager.request(APIRouter.OrderDetail(uid: order.uid, oid: order.oid)).responseJSON(completionHandler: {
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
				SVProgressHUD.dismiss()
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let orderInfo = tempJson["OrderInfo"]

					let OId = orderInfo["Oid"].stringValue
					print("OId \(OId)")
					let UId = orderInfo["Uid"].stringValue

					let OSN = orderInfo["OSN"].stringValue
					let OrderState = orderInfo["OrderState"].stringValue
					let ProductAmount = orderInfo["ProductAmount"].stringValue

					let OrderAmount = orderInfo["OrderAmount"].stringValue
					let SurplusMoney = orderInfo["SurplusMoney"].stringValue
					let AddTime = orderInfo["AddTime"].stringValue
					let StoreId = orderInfo["StoreId"].stringValue
					let StoreName = orderInfo["StoreName"].stringValue
					let ShipSN = orderInfo["ShipSN"].stringValue
					let ShipTime = orderInfo["ShipTime"].stringValue
					let ShipCoName = orderInfo["ShipCoName"].stringValue
					let PayFriendName = orderInfo["PayFriendName"].stringValue
					let PayTime = orderInfo["PayTime"].stringValue
					let Consignee = orderInfo["Consignee"].stringValue
					let Mobile = orderInfo["Mobile"].stringValue
					let Address = orderInfo["Address"].stringValue
					let BuyerRemark = orderInfo["BuyerRemark"].stringValue
					let paymode = orderInfo["PayMode"].stringValue
					let IsReview = orderInfo["IsReview"].stringValue
					let orderProList = tempJson["OrderProductList"]

					if orderProList.count >= 1 {
						for j in 0 ... (orderProList.count - 1) {

							let Oid = orderProList[j]["Oid"].stringValue
							let Uid = orderProList[j]["Uid"].stringValue
							let img = orderProList[j]["ShowImg"].stringValue
							let Name = orderProList[j]["Name"].stringValue
							let RealCount = orderProList[j]["RealCount"].stringValue
							let BuyCount = orderProList[j]["BuyCount"].stringValue
							let pid = orderProList[j]["Pid"].stringValue
							self.proList.append(OrderDetailPro.init(Pid: pid, PName: Name, Img: img, StoreId: StoreId, RealCount: RealCount))
						}
					}
					self.orderDetail = OrderDetail.init(Oid: OId, Uid: UId, OrderState: OrderState, OrderAmount: OrderAmount, AddTime: AddTime, StoreId: StoreId, PayName: PayFriendName, ShipTime: ShipTime, Address: Address, BuyerRemark: BuyerRemark, ShipSN: ShipSN, Consignee: Consignee, Mobile: Mobile, OSN: OSN, SurplusMoney: SurplusMoney, StoreName: StoreName, ShipCoName: ShipCoName, Paymode: paymode, Isreview: IsReview, ProList: self.proList)

					break
				}
			}
		})
	}
}

extension OrderDetailVC: OrderGoodsListViewDelegate {

	func orderGoodsListViewHeightDidChange(height: CGFloat) {
		orderGoodsListView.frame = CGRectMake(0, CGRectGetMaxY(orderUserDetailView.frame) + 10, ScreenWidth, height)
		evaluateView.frame = CGRectMake(0, CGRectGetMaxY(orderGoodsListView.frame) + 10, ScreenWidth, 100)
		scrollView?.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(evaluateView.frame) + 10 + 50 + NavigationH)
	}
}
