//
//  TitleViewProtocol.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//
import UIKit

protocol TitleViewProtocol {
}

extension TitleViewProtocol where Self: UIViewController {

	func buildNavigationBar(title: String) {

		navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("", titleColor: UIColor.whiteColor(),
			image: UIImage(named: "icon_search")!, hightLightImage: nil,
			target: self, action: Selector("rightItemClick"), type: ItemButtonType.Right)

		let titleView = UILabel(frame: CGRectMake(10, 0, 100, 35))
		titleView.text = title

		if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
			titleView.font = UIFont.boldSystemFontOfSize(16)
		} else {
			titleView.font = UIFont.boldSystemFontOfSize(14)
		}
		titleView.textAlignment = NSTextAlignment.Center
		titleView.textColor = UIColor.whiteColor()
		navigationItem.titleView = titleView

		// let tap = UITapGestureRecognizer(target: self, action: "titleViewClick")
		// navigationItem.titleView?.addGestureRecognizer(tap)
	}
}