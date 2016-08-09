//
//  ReViewVC.swift
//  BrnMall
//
//  Created by luoyp on 16/7/7.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import SVProgressHUD

class ReViewVC: BaseViewController {

	var order: Order!
	var goodsImage: OrderImageViews = OrderImageViews()
	var scrollView = UIScrollView()
	var containerView = UIView()
	var goodsStar = CosmosView()
	var goodsDesStar = CosmosView()
	var storeStar = CosmosView()
	var shipStar = CosmosView()
	var commentText = UITextView()

	override func viewDidLoad() {
		super.viewDidLoad()
		buildNavigationItem("评   价")
		navigationController?.setNavigationBarHidden(false, animated: true)
		goodsImage.frame = CGRect.init(x: 0, y: 5, width: ScreenWidth, height: 60)
		scrollView.backgroundColor = UIColor.whiteColor()
		scrollView.bounces = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.userInteractionEnabled = true
		scrollView.exclusiveTouch = true
		scrollView.canCancelContentTouches = true
		scrollView.delaysContentTouches = true
		scrollView.keyboardDismissMode = .OnDrag
		view.addSubview(scrollView)

		scrollView.addSubview(containerView)
		initview()
		goodsImage.order_goods = order.proList
		// Do any additional setup after loading the view.
	}

	func initview() {
		scrollView.snp_makeConstraints(closure: { (make) -> Void in
			make.width.equalTo(view.bounds.width)
			make.top.equalTo(view)
			make.height.equalTo(view.bounds.height)
		})
		containerView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(scrollView)
			make.width.equalTo(view.bounds.width)
			make.height.equalTo(ScreenHeight + 100)
		}

		let label1 = UILabel()
		label1.backgroundColor = UIColor.lightGrayColor()
		label1.font = UIFont.systemFontOfSize(14)
		label1.text = " 商品评价"
		label1.textAlignment = .Left
		label1.numberOfLines = 0
		label1.sizeToFit()
		containerView.addSubview(label1)
		label1.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(10)
			make.top.equalTo(10)
			make.right.equalTo(containerView).offset(-10)
			make.height.equalTo(35)
		})

		containerView.addSubview(goodsImage)
		goodsImage.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(10)
			make.right.equalTo(containerView).offset(-10)
			make.top.equalTo(label1.snp_bottom).offset(10)
			make.height.equalTo(65)
		})

		let lineView1 = UIView()
		lineView1.backgroundColor = UIColor.colorWithCustom(225, g: 225, b: 225)
		containerView.addSubview(lineView1)
		lineView1.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(15)
			make.right.equalTo(containerView).offset(-15)
			make.top.equalTo(goodsImage.snp_bottom).offset(20)
			make.height.equalTo(1)
		})

		goodsStar.settings.textFont = UIFont.systemFontOfSize(14)
		goodsStar.settings.starSize = 20
		goodsStar.rating = 3
		goodsStar.settings.starMargin = 2
		goodsStar.text = "商品满意度 "
		goodsStar.settings.updateOnTouch = true
		goodsStar.settings.fillMode = .Full

		containerView.addSubview(goodsStar)
		goodsStar.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(15)
			make.right.equalTo(containerView).offset(-15)
			make.top.equalTo(lineView1.snp_bottom).offset(10)
			make.height.equalTo(15)
		})

		let label2 = UILabel()
		containerView.addSubview(label2)
		label2.font = UIFont.systemFontOfSize(14)
		label2.text = " 评论"
		label2.textAlignment = .Left
		label2.numberOfLines = 0
		label2.sizeToFit()

		label2.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(10)
			make.top.equalTo(goodsStar.snp_bottom).offset(10)
			make.right.equalTo(containerView).offset(-10)
			make.height.equalTo(20)
		})

		commentText.textAlignment = .Left
		commentText.layer.cornerRadius = 3
		commentText.layer.borderWidth = 1
		commentText.layer.borderColor = UIColor.colorWithCustom(225, g: 225, b: 225).CGColor
		containerView.addSubview(commentText)
		commentText.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(10)
			make.top.equalTo(label2.snp_bottom)
			make.right.equalTo(containerView).offset(-10)
			make.height.equalTo(65)
		})

		let label3 = UILabel()
		label3.backgroundColor = UIColor.lightGrayColor()
		label3.font = UIFont.systemFontOfSize(14)
		label3.text = " 店铺评价"
		label3.textAlignment = .Left
		label3.numberOfLines = 0
		label3.sizeToFit()
		containerView.addSubview(label3)
		label3.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(10)
			make.top.equalTo(commentText.snp_bottom).offset(15)
			make.right.equalTo(containerView).offset(-10)
			make.height.equalTo(35)
		})

		goodsDesStar.settings.textFont = UIFont.systemFontOfSize(14)
		goodsDesStar.settings.starSize = 20
		goodsDesStar.rating = 3
		goodsDesStar.settings.starMargin = 2
		goodsDesStar.text = "商品描述满意度 "
		goodsDesStar.settings.updateOnTouch = true
		goodsDesStar.settings.fillMode = .Full

		containerView.addSubview(goodsDesStar)
		goodsDesStar.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(15)
			make.right.equalTo(containerView).offset(-15)
			make.top.equalTo(label3.snp_bottom).offset(20)
			make.height.equalTo(15)
		})

		storeStar.settings.textFont = UIFont.systemFontOfSize(14)
		storeStar.settings.starSize = 20
		storeStar.rating = 3
		storeStar.settings.starMargin = 2
		storeStar.text = "商家服务满意度 "
		storeStar.settings.updateOnTouch = true
		storeStar.settings.fillMode = .Full

		containerView.addSubview(storeStar)
		storeStar.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(15)
			make.right.equalTo(containerView).offset(-15)
			make.top.equalTo(goodsDesStar.snp_bottom).offset(15)
			make.height.equalTo(15)
		})
		shipStar.settings.textFont = UIFont.systemFontOfSize(14)
		shipStar.settings.starSize = 20
		shipStar.rating = 3
		shipStar.settings.starMargin = 2
		shipStar.text = "商品配送满意度 "
		shipStar.settings.updateOnTouch = true
		shipStar.settings.fillMode = .Full

		containerView.addSubview(shipStar)
		shipStar.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(containerView).offset(15)
			make.right.equalTo(containerView).offset(-15)
			make.top.equalTo(storeStar.snp_bottom).offset(15)
			make.height.equalTo(15)
		})
		let btn = UIButton()

		btn.setTitle("提交评论", forState: .Normal)
		btn.setBackgroundImage(UIImage.imageWithColor(BMNavigationBarColor), forState: UIControlState.Normal)
		btn.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 180, b: 136)), forState: UIControlState.Highlighted)

		btn.addTarget(self, action: #selector(ReViewVC.post), forControlEvents: .TouchUpInside)

		btn.titleLabel!.font = UIFont.systemFontOfSize(16)
		btn.layer.cornerRadius = 3;
		btn.layer.masksToBounds = true

		containerView.addSubview(btn)

		btn.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(shipStar.snp_bottom).inset(-40)
			make.centerX.equalTo(containerView)
			make.width.equalTo(self.view.bounds.width - 20)
			make.height.equalTo(30)
		}

	}
	// (let oid, let uid, let stars, let messages, let opids, let descriptionStar, let serviceStar, let shipStar):
	func post() {
		ProgressHUDManager.showWithStatus("正在提交评论")
		var s1 = ""
		var s2 = ""
		var s3 = ""
		for obj in order.proList {
			s1 = s1 + "\(Int.init(goodsStar.rating))#"
			s2 = s2 + commentText.text + "#"
			s3 = s3 + "\(obj.pid)#"
		}
		print(s3)
		let s4 = Int.init(goodsDesStar.rating)
		let s5 = Int.init(storeStar.rating)
		let s6 = Int.init(shipStar.rating)

		manager.request(APIRouter.ReviewOrder(order.oid, "\(SysUtils.get("uid")!)", s1, "\(s2)", s3, "\(s4)", "\(s5)", "\(s6)")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus("信息提交失败,请稍后再试")
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus("\(json["data"][0]["msg"].stringValue)")
					break
				}
				if "true" == json["result"].stringValue {
					NSNotificationCenter.defaultCenter().postNotificationName("paySuccessreloadorder", object: nil, userInfo: nil)
					ProgressHUDManager.showInfoStatus("\(json["data"][0]["msg"].stringValue)")
					self.navigationController?.popViewControllerAnimated(true)

				}

				break
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
