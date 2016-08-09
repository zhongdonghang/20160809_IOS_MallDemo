//
//  HomeTableHeadView.swift
//  BrnMall
//
//  Created by luoyp on 16/4/19.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class HomeTableHeadView: UIView {

	private var pageScrollView: PageScrollView?
	private var hotView: HotView?
	weak var delegate: HomeTableHeadViewDelegate?
	var tableHeadViewHeight: CGFloat = 0 {
		willSet {
			NSNotificationCenter.defaultCenter().postNotificationName(HomeTableHeadViewHeightDidChange, object: newValue)
			frame = CGRectMake(0, -newValue, ScreenWidth, newValue)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		buildPageScrollView()

		buildHotView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: 模型的set方法
	var headData: [HeadResources]? {
		didSet {
			pageScrollView?.headData = headData
			hotView!.headData = headData
		}
	}
	// MARK: 初始化子控件
	func buildPageScrollView() {
		weak var tmpSelf = self
		pageScrollView = PageScrollView(frame: CGRectZero, placeholder: UIImage.init(named: "product_default_img")!, focusImageViewClick: { (index) -> Void in
			if tmpSelf!.delegate != nil && ((tmpSelf!.delegate?.respondsToSelector("tableHeadView:focusImageViewClick:")) != nil) {
				tmpSelf!.delegate!.tableHeadView!(tmpSelf!, focusImageViewClick: index)
			}
		})

		addSubview(pageScrollView!)
	}

	func buildHotView() {
		weak var tmpSelf = self
		hotView = HotView(frame: CGRect(x: 50, y: 0, width: ScreenWidth - 10 * 2, height: 0), iconClick: { (index) -> Void in
			if tmpSelf!.delegate != nil && ((tmpSelf!.delegate?.respondsToSelector("tableHeadView:iconClick:")) != nil) {
				tmpSelf!.delegate!.tableHeadView!(tmpSelf!, iconClick: index)
			}
		})
		hotView?.backgroundColor = UIColor.whiteColor()
		addSubview(hotView!)
	}

	// MARK: 布局子控件
	override func layoutSubviews() {
		super.layoutSubviews()

		pageScrollView?.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 0.46)

		hotView?.frame.origin = CGPointMake(0, CGRectGetMaxY((pageScrollView?.frame)!))

		tableHeadViewHeight = CGRectGetMaxY(hotView!.frame)
	}
}

// - MARK: Delegate
@objc protocol HomeTableHeadViewDelegate: NSObjectProtocol {
	optional func tableHeadView(headView: HomeTableHeadView, focusImageViewClick index: Int)
	optional func tableHeadView(headView: HomeTableHeadView, iconClick index: Int)
}
