//
//  ProductDetailViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import ObjectMapper
import MJRefresh
import SVProgressHUD
import WebKit

class ProductDetailViewController: BaseViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
	var pid = ""
	var name = ""
	var price2 = "0"

	var goods: ProductDetailModel?
	var isFromFavorite = false

	private let shopImageView = UIImageView()
	private let emptyLabel = UILabel()
	private let emptyButton = UIButton()
	let viewComment = UILabel()
	// private let mainImg = UIImageView()
	var pageScrollView: PageScrollView = PageScrollView()
	private let infoView = UIView()
	let brandLabel = UILabel()
	let infoDetailLabel = UILabel()
	let nameLabel = UILabel()
	let attrLabel = UILabel()

	let price1 = UILabel()
	let marketprice = UILabel()
	let vipprice = UILabel()
	let priceView = UIView()

	let storeBtn = UIButton()
	let showCarBtn = UIButton()

	var shopCar: ShopCarView?

	private var bottomView: UIView?
	private var scrollView: UIScrollView = UIScrollView()

	let containerView = UIView()
	let collectBtn = UIButton()
	let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
	let goodsInfo = UIWebView()

	override func viewDidLoad() {
		super.viewDidLoad()
		print("ProductDetailViewController viewDidLoad")
		buildNavigationItem(name)

		bottomView = UIView(frame: CGRectMake(0, ScreenHeight - 50 - NavigationH, ScreenWidth, 50))
		bottomView?.backgroundColor = BMGreyBackgroundColor
		view.addSubview(bottomView!)

		scrollView.backgroundColor = UIColor.whiteColor()
		scrollView.bounces = true
		scrollView.showsVerticalScrollIndicator = false
		scrollView.userInteractionEnabled = true
		scrollView.exclusiveTouch = true
		scrollView.canCancelContentTouches = true
		scrollView.delaysContentTouches = true

		goodsInfo.scrollView.scrollEnabled = false
		goodsInfo.scalesPageToFit = true
		goodsInfo.delegate = self
		goodsInfo.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
		pageScrollView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth - 20)

		view.addSubview(scrollView)

		scrollView.addSubview(containerView)

		containerView.addSubview(pageScrollView)

		getProductById(pid)

		if isFromFavorite {
			storeBtn.hidden = true
			collectBtn.hidden = true
		}
		// Do any additional setup after loading the view.
	}
	func webViewDidFinishLoad(webView: UIWebView) {
		self.webViewResizeToContent(webView)

	}

	func webViewResizeToContent(webView: UIWebView) {
		webView.layoutSubviews()

		// Set to smallest rect value
		var frame: CGRect = webView.frame
		frame.size.height = 1.0
		webView.frame = frame

		var height: CGFloat = webView.scrollView.contentSize.height
		print("UIWebView.height: \(height)")

		webView.frame.size.height = height - 10
		webView.frame.size.width = ScreenWidth

		let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: height)

		webView.addConstraint(heightConstraint)

		webView.window?.setNeedsUpdateConstraints()
		webView.window?.setNeedsLayout()
	}

	func initBottomView() {
//		shopCar = ShopCarView(frame: CGRectMake(ScreenWidth - 70, 50 - 61 - 10, 61, 61), shopViewClick: { () -> () in
//			let shopCarVC = ShopCartViewController()
//			let nav = BaseNavigationController(rootViewController: shopCarVC)
//			self.presentViewController(nav, animated: true, completion: nil)
//		})
//		bottomView?.addSubview(shopCar!)
		let addToCar = UIButton()
		addToCar.setTitle("加入购物车", forState: .Normal)
		addToCar.titleLabel?.font = UIFont.systemFontOfSize(13)
		addToCar.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 0.99, green: 0.20, blue: 0.20, alpha: 1.00)), forState: UIControlState.Normal)
		addToCar.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 130, b: 136)), forState: UIControlState.Highlighted)
		addToCar.addTarget(self, action: #selector(self.addToCar), forControlEvents: UIControlEvents.TouchUpInside)
		addToCar.titleLabel?.textAlignment = NSTextAlignment.Center
		bottomView?.addSubview(addToCar)
		addToCar.snp_makeConstraints { (make) -> Void in
			make.height.right.equalTo(bottomView!)
			make.centerY.equalTo(bottomView!)
			make.width.equalTo(ScreenWidth * 3 / 10)
		}

		let buynow = UIButton()
		buynow.setTitle("立即购买", forState: .Normal)
		buynow.titleLabel?.font = UIFont.systemFontOfSize(13)
		buynow.setBackgroundImage(UIImage.imageWithColor(UIColor.init(red: 0.98, green: 0.45, blue: 0.16, alpha: 1.0)), forState: UIControlState.Normal)
		buynow.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithCustom(0, g: 130, b: 136)), forState: UIControlState.Highlighted)
		buynow.addTarget(self, action: #selector(self.buynow), forControlEvents: UIControlEvents.TouchUpInside)
		buynow.titleLabel?.textAlignment = NSTextAlignment.Center
		bottomView?.addSubview(buynow)
		buynow.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(bottomView!)
			make.right.equalTo(addToCar.snp_left)
			make.centerY.equalTo(bottomView!)
			make.width.equalTo(ScreenWidth * 3 / 10 - 10)
		}

		storeBtn.set(image: UIImage.init(named: "store"), title: "店   铺", titlePosition: .Bottom, additionalSpacing: 14, state: UIControlState.Normal)
		storeBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
		storeBtn.setTitleColor(BMInfoLabelTextColor, forState: UIControlState.Normal)
		storeBtn.addTarget(self, action: #selector(self.showStore), forControlEvents: UIControlEvents.TouchUpInside)
		bottomView?.addSubview(storeBtn)
		storeBtn.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(bottomView!)
			make.top.equalTo(bottomView!.snp_top).inset(14)
			make.width.equalTo(ScreenWidth * 1 / 5)
		}

		collectBtn.set(image: UIImage.init(named: "star"), title: "收   藏", titlePosition: .Bottom, additionalSpacing: 14, state: UIControlState.Normal)
		collectBtn.addTarget(self, action: #selector(self.addFavoriteProduct), forControlEvents: UIControlEvents.TouchUpInside)
		collectBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
		collectBtn.setTitleColor(BMInfoLabelTextColor, forState: UIControlState.Normal)
		bottomView?.addSubview(collectBtn)
		collectBtn.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(storeBtn.snp_right)
			make.top.equalTo(bottomView!.snp_top).inset(14)
			make.width.equalTo(ScreenWidth * 1 / 5)
		}

		showCarBtn.set(image: UIImage.init(named: "shopcar"), title: "购物车", titlePosition: .Bottom, additionalSpacing: 14, state: UIControlState.Normal)
		showCarBtn.setTitleColor(BMInfoLabelTextColor, forState: UIControlState.Normal)
		showCarBtn.addTarget(self, action: #selector(self.showShopCar), forControlEvents: UIControlEvents.TouchUpInside)
		showCarBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
//		bottomView?.addSubview(showCarBtn)
//		showCarBtn.snp_makeConstraints { (make) -> Void in
//			make.left.equalTo(collectBtn.snp_right)
//			make.top.equalTo(bottomView!.snp_top).inset(14)
//			make.right.equalTo(addToCar.snp_left)
//			make.width.equalTo(ScreenWidth * 1 / 5)
//		}
	}

	var isbuynow = false

	func buynow() {
		isbuynow = true

		print("立即购买")
		addToCar(true)
		// navigationController?.popToRootViewControllerAnimated(true)

	}
	func showShopCar() {
		let shopCarVC = ShopCartViewController()
		let nav = BaseNavigationController(rootViewController: shopCarVC)
		self.presentViewController(nav, animated: true, completion: nil)
	}

	func addFavoriteProduct() {
		if SysUtils.get("uid") == nil {
			let vc = LoginViewController()
			let nvc = BaseNavigationController.init(rootViewController: vc)
			self.navigationController?.presentViewController(nvc, animated: true, completion: nil)
			return
		}
		ProgressHUDManager.showWithStatus("正在收藏")

		manager.request(APIRouter.addFavoritetProduct(uid: "\(SysUtils.get("uid")!)", pid: pid)).responseJSON(completionHandler: {
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
					// print(json)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
						break
					}
					if "true" == json["result"].stringValue {

						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
					}

					break
				}
			}
		})
	}

	func addToCar(isbuy: Bool) {
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
					if self.isbuynow {
						let shopCarVC = ShopCartViewController()
						shopCarVC.isFromDetail = true
						self.isbuynow = false
						self.navigationController?.pushViewController(shopCarVC, animated: true)
						break

					}
					NSNotificationCenter.defaultCenter().postNotificationName("ShopCarDidChange", object: nil, userInfo: nil)
					if !isbuy {
						ProgressHUDManager.showSuccessWithStatus(json["data"][0]["msg"].stringValue)
					}

				}
				break
			}
		})
	}

	func showStore() {
//		if SysUtils.get("uid") == nil {
//			let vc = LoginViewController()
//			let nvc = BaseNavigationController.init(rootViewController: vc)
//			self.navigationController?.presentViewController(nvc, animated: true, completion: nil)
//			return
//		}
		let vc = StoreVC()
		vc.storeid = "\((goods?.data?.store?.StoreId)!)"
		vc.storename = (goods?.data?.store?.Name)!

		// let nav = BaseNavigationController(rootViewController: shopCarVC)
		self.navigationController?.pushViewController(vc, animated: true)
	}
	func initInfoView() {
		infoView.backgroundColor = UIColor.whiteColor()
		infoView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(pageScrollView.snp_bottom).inset(-11)
			make.width.equalTo(view.bounds.width)
		}

		nameLabel.backgroundColor = UIColor.whiteColor()
		nameLabel.textColor = BMInfoLabelTextColor
		nameLabel.lineBreakMode = .ByWordWrapping
		nameLabel.numberOfLines = 0
		nameLabel.font = UIFont.systemFontOfSize(15)
		nameLabel.text = " " + (goods?.data?.product?.name)!
		infoView.addSubview(nameLabel)
		nameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(infoView)
			make.width.equalTo(infoView)
			make.height.equalTo(36)
		}
		addLine(nameLabel)
		infoView.addSubview(priceView)

		priceView.backgroundColor = UIColor.whiteColor()
		priceView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nameLabel.snp_bottom).inset(0)
			make.width.equalTo(infoView)
			make.height.equalTo(64)
		}

		price1.backgroundColor = UIColor.whiteColor()
		price1.textColor = UIColor(red: 0.47, green: 0.48, blue: 0.48, alpha: 1.00)
		price1.font = UIFont.systemFontOfSize(14)
		price1.lineBreakMode = .ByCharWrapping
		price1.numberOfLines = 0

		marketprice.backgroundColor = UIColor.whiteColor()
		marketprice.textColor = UIColor(red: 0.72, green: 0.73, blue: 0.73, alpha: 1.00)
		marketprice.font = UIFont.italicSystemFontOfSize(12)
		marketprice.lineBreakMode = .ByCharWrapping
		marketprice.numberOfLines = 0

		vipprice.backgroundColor = UIColor.whiteColor()
		vipprice.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.53, alpha: 1.0)
		vipprice.font = UIFont.italicSystemFontOfSize(13)
		vipprice.lineBreakMode = .ByCharWrapping
		vipprice.numberOfLines = 0

		priceView.addSubview(price1)
		priceView.addSubview(marketprice)
		priceView.addSubview(vipprice)

//		if SysUtils.get("zhekou") != nil && SysUtils.get("zhekoutitle") != nil {
//			let p = SysUtils.get("zhekou") as! NSString
//			print("zhekou \(p.doubleValue*10/100)")
//			let p1 = Double.init(price2)
//
//			let price = p1! * ((p.doubleValue * 10) / 100)
//
//			price1.text = " ￥ \(price.format())  (\(SysUtils.get("zhekoutitle")!))"
//
//		} else {
//			price1.text = " ￥ \(price2)"
//		}

		price1.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(priceView)
			make.width.equalTo(priceView)
			make.height.equalTo(20)

		}
		vipprice.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(price1.snp_bottom).inset(-2)
			make.width.equalTo(priceView)
			make.height.equalTo(20)
		}
		marketprice.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(vipprice.snp_bottom).inset(-2)
			make.width.equalTo(priceView)
			make.height.equalTo(20)
		}

		addLine(priceView)

		brandLabel.backgroundColor = UIColor.whiteColor()
		brandLabel.textColor = BMInfoLabelTextHintColor
		brandLabel.text = " 品 牌   " + (goods?.data?.brand?.name)!
		brandLabel.font = UIFont.systemFontOfSize(14)
		brandLabel.tag = 1001

		infoView.addSubview(brandLabel)
		brandLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(priceView.snp_bottom).inset(-1)
			make.width.equalTo(infoView)
			make.height.equalTo(38)
		}
		addLine(brandLabel)

		attrLabel.backgroundColor = UIColor.whiteColor()
		attrLabel.textColor = BMInfoLabelTextHintColor
		attrLabel.font = UIFont.systemFontOfSize(13)
		attrLabel.text = " 规 格"
		infoView.addSubview(attrLabel)
		attrLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(brandLabel.snp_bottom).inset(-1)
			make.width.equalTo(infoView)
			make.height.equalTo(38)
		}

		addLine(attrLabel)

		infoDetailLabel.backgroundColor = UIColor.whiteColor()
		infoDetailLabel.textColor = BMInfoLabelTextHintColor
		infoDetailLabel.text = " 商品详情"
		infoDetailLabel.font = UIFont.systemFontOfSize(14)
		infoView.addSubview(infoDetailLabel)
		addLine(infoDetailLabel)
		// goodsInfo.backgroundColor = UIColor.blueColor()

	}
	func toComnent() {
		let vc = GoodsCommentVC()
		vc.pid = pid
		self.navigationController?.pushViewController(vc, animated: true)

	}

	func addLine(view: UIView) {
		let lineView1 = UIView()
		lineView1.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)

		infoView.addSubview(lineView1)
		lineView1.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(view.snp_bottom).inset(0)
			make.width.equalTo(ScreenWidth)
			make.height.equalTo(1)
		})
	}
	func layoutWithContainer() {
		initBottomView()
		containerView.backgroundColor = scrollView.backgroundColor

		/**
		 *  对scrollView添加约束
		 *  Add constraints to scrollView
		 */

		scrollView.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(view.bounds.width)
			make.top.equalTo(view)
			make.height.equalTo(view.bounds.height - NavigationH + 20)
		}

		containerView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(scrollView)
			make.width.equalTo(view.bounds.width)
		}

		/**
		 *  对containerView添加约束，接下来只要确定containerView的高度即可
		 *  Add constraints to containerView, the only thing we will do
		 *  is to define the width of containerView
		 */

		if let storeId = goods?.data?.store?.StoreId {
//			containerView.addSubview(pageScrollView)
//
//			pageScrollView.snp_makeConstraints(closure: { (make) -> Void in
//				make.top.equalTo(containerView.snp_top).inset(10)
//				make.centerX.equalTo(containerView)
//				make.width.equalTo(230)
//				make.height.equalTo(230)
//			})

			// mainImg.sd_setImageWithURL(NSURL(string: BaseImgUrl1 + "\(storeId)" + BaseImgUrl800 + (goods?.data?.product?.img)!), placeholderImage: UIImage(named: "goodsdefault"))
			// print(BaseImgUrl1 + "\(storeId)" + BaseImgUrl800 + (goods?.data?.product?.img)!)
		}

		// 1

		let lineView1 = UIView()
		lineView1.backgroundColor = UIColor.colorWithCustom(225, g: 225, b: 225)

		containerView.addSubview(lineView1)
		lineView1.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(pageScrollView.snp_bottom).inset(-10)
			make.width.equalTo(ScreenWidth)
			make.height.equalTo(1)
		})

		// 2
		containerView.addSubview(infoView)
		initInfoView()

		viewComment.backgroundColor = UIColor.whiteColor()
		viewComment.textColor = BMInfoLabelTextHintColor
		viewComment.font = UIFont.systemFontOfSize(14)
		viewComment.text = " 评 价"
		containerView.addSubview(viewComment)
		viewComment.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(attrLabel.snp_bottom).inset(-1)
			make.width.equalTo(infoView)
			make.height.equalTo(38)
		}
		viewComment.userInteractionEnabled = true
		let tapGesture = UITapGestureRecognizer(target: self, action: "toComnent")
		viewComment.addGestureRecognizer(tapGesture)

		containerView.addSubview(arrowImageView)
		arrowImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(viewComment.snp_centerY)
			make.right.equalTo(infoView.snp_right).inset(15)
			make.width.equalTo((arrowImageView.image?.size.width)!)
			make.height.equalTo((arrowImageView.image?.size.height)!)
		}

		addLine(viewComment)
		// containerView.addSubview(infoDetailLabel)
		infoDetailLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(viewComment.snp_bottom).inset(-1)
			make.width.equalTo(infoView)
			make.height.equalTo(38)
		}
		containerView.addSubview(goodsInfo)
		// goodsInfo.lineBreakMode = .ByWordWrapping
		// goodsInfo.numberOfLines = 0
		goodsInfo.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(infoDetailLabel.snp_bottom).inset(-1)
			make.width.equalTo(ScreenWidth)

		}
		price1.text = " 商城价￥ \((goods?.data?.product?.shopPrice)!)"
		vipprice.text = " 会员价￥ \((goods?.data?.product?.vipPrice)!)"
		marketprice.text = " 市场价￥ \((goods?.data?.product?.marketPrice)!)"

		// 1
		let string = marketprice.text! as NSString
		var attributedString = NSMutableAttributedString(string: string as String)

		// 2

		let secondAttributes = [NSForegroundColorAttributeName: UIColor.grayColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSStrikethroughStyleAttributeName: 1]

		// 3
		attributedString.addAttributes(secondAttributes, range: string.rangeOfString(string as String))

		// 4
		marketprice.attributedText = attributedString

		print("\((goods?.data?.product?.description)!)")
		goodsInfo.loadHTMLString("<html>" + "\((goods?.data?.product?.description)!)" + "</html>", baseURL: NSURL(string: "www.google.com")!)

		// self.price1.text = " ￥ \((goods?.data?.product?.shopPrice)!)"

		containerView.snp_makeConstraints(closure: { (make) -> Void in

			make.bottom.equalTo(goodsInfo.snp_bottom).inset(-10)
		})
		return

	}

	private func buildEmptyUI() {
		shopImageView.image = UIImage(named: "reload")
		shopImageView.contentMode = UIViewContentMode.Center
		shopImageView.hidden = true
		view.addSubview(shopImageView)

		shopImageView.snp_makeConstraints(closure: {
			(make) -> Void in
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).inset(-80)
		})

		emptyLabel.text = "亲, 数据迷路了, 点击再试试吧"
		emptyLabel.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
		emptyLabel.textAlignment = NSTextAlignment.Center
		emptyLabel.font = UIFont.systemFontOfSize(16)
		emptyLabel.hidden = true
		view.addSubview(emptyLabel)
		emptyLabel.snp_makeConstraints(closure: {
			(make) -> Void in
			make.top.equalTo(shopImageView.snp_bottom).inset(-10)
			make.width.equalTo(ScreenWidth)
		})

		emptyButton.addTarget(self, action: #selector(ProductDetailViewController.reload), forControlEvents: UIControlEvents.TouchUpInside)
		emptyButton.hidden = true
		view.addSubview(emptyButton)

		emptyButton.snp_makeConstraints(closure: {
			(make) -> Void in
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).inset(-80)
			make.height.equalTo(120)
			make.width.equalTo(120)
		})
	}

	func reload() {
		getProductById(pid)
	}
	private func showEmptyUI() {
		shopImageView.hidden = false
		emptyButton.hidden = false
		emptyLabel.hidden = false
	}
	private func hideEmptyUI() {
		shopImageView.hidden = true
		emptyButton.hidden = true
		emptyLabel.hidden = true
	}

	func getProductById(id: String) {
		ProgressHUDManager.showWithStatus(Loading)
		manager.request(APIRouter.getProductByID(id: pid)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				ProgressHUDManager.dismiss()
				// ProgressHUDManager.showInfoStatus(NetFail)
				self.showEmptyUI()
				break

			case .Success:
				if let returnJson = data.result.value {
					print("商品详情 \(returnJson)")
					let value = Mapper<ProductDetailModel>().map(returnJson)
					if let res = value?.result where res == false {

						self.showEmptyUI()
						ProgressHUDManager.showInfoStatus(NoData)
						break
					}

					self.goods = value
					// print(self.goods?.data?.product?.marketPrice)
					var imgs: [HeadResources] = []

					for obj in (self.goods?.data?.imgList)! {
						let img = BaseImgUrl1 + "\(obj.StoreId)" + BaseImgUrl800 + "\(obj.ShowImg)"

						imgs.append(HeadResources.init(Img: img.stringByReplacingOccurrencesOfString(" ", withString: ""), Pid: "", Title: ""))

					}

					self.layoutWithContainer()
					self.pageScrollView.headData = imgs
				}

				SVProgressHUD.dismiss()
				// ProgressHUDManager.showInfoStatus(NetFail)

				self.viewComment.text = " 评 价  (" + "\(self.goods!.data!.product!.ReviewCount)" + ") "
				self.showEmptyUI()
				break
			}
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
