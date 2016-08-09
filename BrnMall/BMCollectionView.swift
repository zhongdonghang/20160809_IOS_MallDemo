//
//  BMCollectionView.swift
//  BrnMall
//
//  Created by luoyp on 16/4/19.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class BMCollectionView: UICollectionView {
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		
		delaysContentTouches = false
		canCancelContentTouches = true
		
		let wrapView = subviews.first
		
		if wrapView != nil && NSStringFromClass((wrapView?.classForCoder)!).hasPrefix("WrapperView") {
			
			for gesture in wrapView!.gestureRecognizers! {
				if (NSStringFromClass(gesture.classForCoder).containsString("DelayedTouchesBegan")) {
					gesture.enabled = false
					break
				}
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesShouldCancelInContentView(view: UIView) -> Bool {
		if view.isKindOfClass(UIControl) {
			return true
		}
		
		return super.touchesShouldCancelInContentView(view)
	}
}