//
//  PayVC.swift
//  BrnMall
//
//  Created by luoyp on 16/4/12.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import SVProgressHUD

enum PaymentType {
	case Alipay, Weichat
}

protocol PayMethodViewControllerDelegate: class {
	func paymentSuccess(paymentType paymentType: PaymentType)
	func paymentFail(paymentType paymentType: PaymentType)
}

class PayVC: BaseViewController {
	var order: MyOrder!

	var weixinButton: UIButton?
	var alipayButton: UIButton?
	var yueBtn: UIButton!
	var arrowImageView3: UIImageView!
	var image3: UIImageView!

	weak var delegate: PayMethodViewControllerDelegate?

	override func viewDidLoad() {
		self.view.backgroundColor = UIColor.whiteColor()

		buildNavigationItem("精生缘收银台")
		navigationController?.setNavigationBarHidden(false, animated: true)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PayVC.weixinPaySuccess(_:)), name: WXPaySuccessNotification, object: nil)

		// 通常是请求服务器 API 生成订单，这里为测试方便直接将测试数据hardcode
		// order = MyOrder(id: 23, title: "测试订单标题", content: "订单描述内容", url: "", createdAt: "", price: 0.1, paid: true, productID: 100);

		let lable = UILabel.init(frame: CGRectMake(20, 20, ScreenWidth - 40, 20))
		lable.text = "请选择支付方式"
		lable.font = UIFont.systemFontOfSize(14)
		lable.textAlignment = NSTextAlignment.Center
		lable.textColor = BMInfoLabelTextHintColor

		self.view.addSubview(lable)
		self.weixinButton = UIButton.init(frame: CGRect.init(x: 0, y: 60, width: ScreenWidth, height: 50))
		self.weixinButton?.setBackgroundImage(UIImage.imageWithColor(UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)), forState: UIControlState.Highlighted)
		self.weixinButton!.titleLabel!.font = UIFont.systemFontOfSize(20)
		self.weixinButton!.layer.cornerRadius = 3;
		self.weixinButton?.layer.masksToBounds = true
		// self.weixinButton?.enabled = false
		self.view.addSubview(self.weixinButton!);

		let image = UIImageView.init(frame: CGRectMake(15, 70, 100, 35))
		image.image = UIImage.init(named: "wxpay")
		self.view.addSubview(image)

		let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
		arrowImageView.frame = CGRectMake(ScreenWidth - 20, 80, 5, 10)
		self.view.addSubview(arrowImageView)

		let line1 = UIView.init(frame: CGRectMake(10, 111, ScreenWidth - 20, 1))
		line1.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
		self.view.addSubview(line1)

		self.alipayButton = UIButton.init(frame: CGRect.init(x: 0, y: 112, width: ScreenWidth, height: 50))
		self.alipayButton?.setBackgroundImage(UIImage.imageWithColor(UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)), forState: UIControlState.Highlighted)
		self.alipayButton!.titleLabel!.font = UIFont.systemFontOfSize(20)
		self.alipayButton!.layer.cornerRadius = 3;
		self.alipayButton?.layer.masksToBounds = true

		self.view.addSubview(self.alipayButton!);

		let image2 = UIImageView.init(frame: CGRectMake(15, 118, 100, 35))
		image2.image = UIImage.init(named: "zfbpay")
		self.view.addSubview(image2)

		let arrowImageView2 = UIImageView(image: UIImage(named: "icon_go"))
		arrowImageView2.frame = CGRectMake(ScreenWidth - 20, 128, 5, 10)
		self.view.addSubview(arrowImageView2)

		let line2 = UIView.init(frame: CGRectMake(10, 163, ScreenWidth - 20, 1))
		line2.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
		self.view.addSubview(line2)

		yueBtn = UIButton.init(frame: CGRect.init(x: 0, y: 165, width: ScreenWidth, height: 50))
		yueBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)), forState: UIControlState.Highlighted)
		yueBtn.titleLabel!.font = UIFont.systemFontOfSize(15)
		yueBtn.setTitle("余额支付", forState: UIControlState.Normal)
		yueBtn.setTitleColor(BMNavigationBarColor, forState: UIControlState.Normal)
		yueBtn.layer.cornerRadius = 3;
		yueBtn.layer.masksToBounds = true
		yueBtn.hidden = true
		self.view.addSubview(yueBtn);

		image3 = UIImageView.init(frame: CGRectMake(15, 172, 100, 35))
		image3.image = UIImage.init(named: "yuezhif")
		image3.hidden = true
		self.view.addSubview(image3)

		arrowImageView3 = UIImageView(image: UIImage(named: "icon_go"))
		arrowImageView3.frame = CGRectMake(ScreenWidth - 20, 182, 5, 10)
		arrowImageView3.hidden = true
		self.view.addSubview(arrowImageView3)

		weixinButton?.addTarget(self, action: #selector(createPrePay), forControlEvents: UIControlEvents.TouchUpInside)
		alipayButton?.addTarget(self, action: #selector(alipayAction), forControlEvents: UIControlEvents.TouchUpInside)
		yueBtn.addTarget(self, action: #selector(yueAction), forControlEvents: UIControlEvents.TouchUpInside)

		ProgressHUDManager.showWithStatus("正在初始化支付信息,稍等!")
		getpayInfo()

	}
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	func yueAction() {
		let alertController = UIAlertController(title: "支付密码", message: "请输入您的支付密码", preferredStyle: UIAlertControllerStyle.Alert)

		let saveAction = UIAlertAction(title: "支付", style: UIAlertActionStyle.Default, handler: {
			alert -> Void in
			let firstTextField = alertController.textFields![0] as UITextField

			let pwd = firstTextField.text
			self.cretiPay(pwd!)

		})

		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: {
			(action: UIAlertAction!) -> Void in

		})

		alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
			textField.secureTextEntry = true
			textField.placeholder = "支付密码"
		}
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)

		self.presentViewController(alertController, animated: true, completion: nil)
	}

	func cretiPay(pwd: String) {
		ProgressHUDManager.showWithStatus("正在支付...")
		manager.request(APIRouter.CreditPayOrder("\(SysUtils.get("uid")!)", pwd, "\(order.id)")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus("支付失败,请稍后再试或更换其他支付方式")
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
					self.dismissViewControllerAnimated(true, completion: nil)

				}

				break
			}
		})
	}
	func getpayInfo() {

		manager.request(APIRouter.GetPayPluginList("\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
			data in
			SVProgressHUD.dismiss()
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()

				break

			case .Success:
				let json: JSON = JSON(data.result.value!)

				if "true" == json["result"].stringValue {
					let num = json["data"]["UserAmount"].doubleValue
					if num > self.order.price {
						self.yueBtn.hidden = false
						self.image3.hidden = false
						self.arrowImageView3.hidden = false
						self.yueBtn.setTitle("余额支付 (" + "\(num)" + ")", forState: UIControlState.Normal)
					}
				}

				break
			}
		})
	}
	func createPrePay() {
		let price = (Int64)(order.price * 100)
		if price == 0 {
			let alert = UIAlertView.init(title: "提示", message: "价格小于 0.01, 无法支付", delegate: nil, cancelButtonTitle: "知道了")
			alert.show()
			return
		}
		if !WXApi.isWXAppInstalled() && !WXApi.isWXAppSupportApi() {

			let alert = UIAlertView.init(title: "提示", message: "未发现微信, 是否已安装微信？", delegate: nil, cancelButtonTitle: "取消")
			alert.show()
			return
		}

		ProgressHUDManager.showWithStatus("正在请求数据")

		var sign = ""
		let noncesty = SysUtils.getRandomStringOfLength(10)
		var stringA = "appid=wxfdf3999c0206cbba&body=精生缘电子商城APP购物&mch_id=1336327901&nonce_str=\(noncesty)&notify_url=\(WxpayNotifyURL)&out_trade_no=" + "\(order.id)A\(noncesty)&spbill_create_ip=192.168.1.109" + "&total_fee=\(price)&trade_type=APP&key=oJC5nGxuom2e1vJL03EQcH7CloxewnRP"

		sign = stringA.md5().uppercaseString

		var prepay = "<xml>" +
			"<appid>wxfdf3999c0206cbba</appid>" +
			"<mch_id>1336327901</mch_id>" +
			"<nonce_str>\(noncesty)</nonce_str>" +
			"<sign>" + sign + "</sign>" +
			"<body>精生缘电子商城APP购物</body>" +
			"<out_trade_no>" + "\(order.id)A\(noncesty)</out_trade_no>" +
			"<total_fee>" + "\(price)" + "</total_fee>" +
			"<spbill_create_ip>192.168.1.109</spbill_create_ip>" +
			"<notify_url>" + WxpayNotifyURL + "</notify_url>" +
			"<trade_type>APP</trade_type>" +
			"</xml>"

		print("xml " + prepay)

		Alamofire.request(.POST, "https://api.mch.weixin.qq.com/pay/unifiedorder", parameters: [:], encoding: .Custom({
			(convertible, params) in
			let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
			mutableRequest.HTTPBody = prepay.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
			return (mutableRequest, nil)
			}))
			.response { request, response, data, error in
				let prePayStr = String(data: data!, encoding: NSUTF8StringEncoding)
				print("pre req return: \(prePayStr)")
				SVProgressHUD.dismiss()

				if prePayStr == nil || prePayStr!.characters.count == 0 {
					let alert = UIAlertView.init(title: "提示", message: "抱歉,微信支付服务异常,请稍后再试吧！", delegate: nil, cancelButtonTitle: "好的")
					alert.show()
					return
				}

				self.wechatPayAction(prePayStr!)

		}
	}
	override func leftNavigitonItemClick() {

		let alert = UIAlertController.init(title: "确认要离开收银台？", message: "下单后24小时订单将被取消, 请尽快完成支付", preferredStyle: .Alert)

		let ok = UIAlertAction.init(title: "继续支付", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
		})
		let cancel = UIAlertAction.init(title: "确认离开", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in

			self.dismissViewControllerAnimated(true, completion: nil)
		})

		alert.addAction(ok)
		alert.addAction(cancel)
		self.presentViewController(alert, animated: true, completion: nil)
	}

	func alipayAction() {
		if order.price < 0.01 {
			let alert = UIAlertView.init(title: "提示", message: "价格小于 0.01,无法支付", delegate: nil, cancelButtonTitle: "知道了")
			alert.show()
			return
		}
		let aliOrder = AlipayOrder(partner: AlipayPartner, seller: AlipaySeller, tradeNO: "\(order.id)A\(SysUtils.getRandomStringOfLength(10))", productName: "精生缘电子商城APP购物", productDescription: order.title, amount: order.price, notifyURL: AlipayNotifyURL, service: "mobile.securitypay.pay", paymentType: "1", inputCharset: "utf-8", itBPay: "10m", showUrl: "m.alipay.com", rsaDate: nil, appID: nil)

		let orderSpec = aliOrder.description.stringByReplacingOccurrencesOfString(" ", withString: "") // orderA.description

		let signer = RSADataSigner(privateKey: AlipayPrivateKey)

		let signedString = signer.signString(orderSpec)

		let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""

		print("支付宝提交信息: " + orderString)

		AlipaySDK.defaultService().payOrder(orderString, fromScheme: AppScheme, callback: { [weak self] resultDic in
			if let strongSelf = self {
				print("Alipay result = \(resultDic as Dictionary)")
				let resultDic = resultDic as Dictionary
				print(JSON.init(resultDic))
				if let resultStatus = resultDic["resultStatus"] as? String {
					if resultStatus == "9000" {
						strongSelf.delegate?.paymentSuccess(paymentType: .Alipay)
						// 支付成功,重新获取订单列表
						NSNotificationCenter.defaultCenter().postNotificationName("paySuccessreloadorder", object: nil, userInfo: nil)

						let alert = UIAlertController.init(title: "支付成功", message: "提示:订单状态可能会有延迟,请勿重复支付,在[我的订单]查看最新订单状态", preferredStyle: .Alert)

						let ok = UIAlertAction.init(title: "好的", style: .Default, handler: {
							(action: UIAlertAction!) -> Void in
							self!.dismissViewControllerAnimated(true, completion: nil)
						})

						alert.addAction(ok)
						self!.presentViewController(alert, animated: true, completion: nil)
						// strongSelf.navigationController?.popViewControllerAnimated(true)
					} else {
						strongSelf.delegate?.paymentFail(paymentType: .Alipay)
						let alert = UIAlertView(title: nil, message: "支付失败，请您重新支付！", delegate: nil, cancelButtonTitle: "好的")
						alert.show()
					}
				}
			}
		})
	}

	func wechatPayAction(prePay: String) {

		// 微信生成预付返回xml
		var returnxml = SWXMLHash.parse(prePay)

		print((returnxml["xml"]["return_code"].element?.text!)!)
//		print((returnxml["xml"]["result_code"].element?.text!)!)
//		print((returnxml["xml"]["prepay_id"].element?.text!)!)
//		print((returnxml["xml"]["return_msg"].element?.text!)!)

		let return_code = (returnxml["xml"]["return_code"].element?.text!)!

		if return_code != "SUCCESS" {
			let alert = UIAlertView(title: "提示", message: "支付失败,请稍后再试,或者更换支付方式", delegate: nil, cancelButtonTitle: "好的")
			alert.show()
			return
		}

		let prepay_id = (returnxml["xml"]["prepay_id"].element?.text!)!

		let req = PayReq()
		req.openID = WX_APPID
		req.partnerId = WX_MCH_ID

		req.prepayId = prepay_id
		req.nonceStr = "xyxbetter"
		req.timeStamp = UInt32.init(NSDate().timeIntervalSince1970)
		req.package = "Sign=WXPay"
		var sign = ""

		var stringA = "appid=" + WX_APPID + "&noncestr=" + req.nonceStr + "&package=" + req.package + "&partnerid=" + WX_MCH_ID + "&prepayid=" + req.prepayId + "&timestamp=\(req.timeStamp)" + "&key=oJC5nGxuom2e1vJL03EQcH7CloxewnRP"

		sign = stringA.md5().uppercaseString

		req.sign = sign
		WXApi.sendReq(req)

		print("appid=\(req.openID)\npartid=\(req.partnerId)\nprepayid=\(req.prepayId)\nnoncestr=\(req.nonceStr)\ntimestamp=\(req.timeStamp)\npackage=\(   req.package)\nsign=\(req.sign)");
// } else {
// strongSelf.delegate?.paymentFail(paymentType: .Weichat)
// let alert = UIAlertView(title: nil, message: "获取支付信息失败，请重新支付！", delegate: nil, cancelButtonTitle: "好的")
// alert.show()
// }
// DataService.wxPrePay(order.id) { [weak self](prepay, error) -> () in
// if let strongSelf = self {
// if let prepay = prepay {
// let req = PayReq()
// req.openID = WX_APPID
// req.partnerId = WX_MCH_ID
// req.prepayId = "wx20160425142358208a9a36a80914399029"
// req.nonceStr = "3w5ROQvPsTdHZP72"
// req.timeStamp = UInt32(prepay.timestamp)
// req.package = WX_APPID
// req.sign = "AFAFDAF1ABB5AA87B2A2CE1E2EBE11B0"
// WXApi.sendReq(req)
//
// print("appid=\(req.openID)\npartid=\(req.partnerId)\nprepayid=\(req.prepayId)\nnoncestr=\(req.nonceStr)\ntimestamp=\(req.timeStamp)\npackage=\(req.package)\nsign=\(req.sign)");
// } else {
// strongSelf.delegate?.paymentFail(paymentType: .Weichat)
// let alert = UIAlertView(title: nil, message: "获取支付信息失败，请重新支付！", delegate: nil, cancelButtonTitle: "好的")
// alert.show()
// }
// }
// }
	}

	func weixinPaySuccess(notification: NSNotification) {

		print("wx pay success")
		let alert = UIAlertController.init(title: "支付成功", message: "提示:订单状态可能会有延迟,请勿重复支付,在[我的订单]查看最新订单状态", preferredStyle: .Alert)

		let ok = UIAlertAction.init(title: "好的", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
			// 支付成功,重新获取订单列表
			NSNotificationCenter.defaultCenter().postNotificationName("paySuccessreloadorder", object: nil, userInfo: nil)

			self.dismissViewControllerAnimated(true, completion: nil)
		})

		alert.addAction(ok)
		self.presentViewController(alert, animated: true, completion: nil)
	}
}
