//
//  File.swift
//  BrnMall
//
//  Created by luoyp on 16/4/15.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class BMSegmentedControl: UISegmentedControl {
	
	var segmentedClick: ((index: Int) -> Void)?
	
	override init(items: [AnyObject]?) {
		super.init(items: items)
		tintColor = UIColor.whiteColor()
		setTitleTextAttributes([NSForegroundColorAttributeName: BMTextBlackColor], forState: UIControlState.Selected)
		setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
		addTarget(self, action: #selector(BMSegmentedControl.segmentedControlDidValuechange(_:)), forControlEvents: UIControlEvents.ValueChanged)
		selectedSegmentIndex = 0
	}
	
	convenience init(items: [AnyObject]?, didSelectedIndex: (index: Int) -> ()) {
		self.init(items: items)
		
		segmentedClick = didSelectedIndex
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	func segmentedControlDidValuechange(sender: UISegmentedControl) {
		if segmentedClick != nil {
			segmentedClick!(index: sender.selectedSegmentIndex)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
