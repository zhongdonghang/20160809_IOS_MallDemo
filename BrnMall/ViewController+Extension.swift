//
//  ViewController+Extension.swift
//  BrnMall
//
//  Created by luoyp on 16/3/19.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

extension UIViewController {

	func buildNavigationItem(title: String) {

		let titleView = UILabel(frame: CGRectMake(0, 0, 100, 35))
		titleView.text = title

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			titleView.font = UIFont.boldSystemFontOfSize(16)
		} else {
			titleView.font = UIFont.boldSystemFontOfSize(14)
		}
		titleView.textAlignment = NSTextAlignment.Center
		titleView.textColor = UIColor.whiteColor()
		navigationItem.titleView = titleView

		navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(UIImage(named: "v2_goback")!, target: self, action: #selector(leftNavigitonItemClick))
		self.navigationController?.navigationBar.barTintColor = BMNavigationBarColor
	}

	func showProgressHUD() {
		view.backgroundColor = UIColor.whiteColor()
		if !ProgressHUDManager.isVisible() {
			ProgressHUDManager.showWithStatus(Loading)
		}
	}

	// MARK: -  Action
	func leftNavigitonItemClick() {
		// NSNotificationCenter.defaultCenter().postNotificationName(LFBShopCarBuyProductNumberDidChangeNotification, object: nil, userInfo: nil)
		self.navigationController?.popViewControllerAnimated(true)
	}
	func leftItemClick() {
		// let qrCode = QRCodeViewController()
		// navigationController?.pushViewController(qrCode, animated: true)
	}

	func rightItemClick() {
		let searchVC = SearchProductViewController()
		navigationController!.pushViewController(searchVC, animated: false)
	} // Dispose of any resources that can be recreated.
}
