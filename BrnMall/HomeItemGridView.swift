//
//  HomeItemGridView.swift
//  BrnMall
//
//  Created by luoyp on 16/7/11.
//  Copyright © 2016年 luoyp. All rights reserved.
//

class HomeItemGridView: UIView {
	override func willMoveToSuperview(newSuperview: UIView?) {
		self.frame = newSuperview!.bounds
		let gradientLayer = CAGradientLayer()
		gradientLayer.bounds = newSuperview!.bounds
		gradientLayer.position = newSuperview!.center
		gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
		self.layer.addSublayer(gradientLayer)
		self.alpha = 0.5
	}
}
