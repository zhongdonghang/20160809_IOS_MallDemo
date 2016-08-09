//
//  UIButton+Extension.swift
//  BrnMall
//
//  Created by luoyp on 16/3/31.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

extension UIButton {
	
	// This method sets an image and title for a UIButton and
	// repositions the titlePosition with respect to the button image.
	// Add additionalSpacing between the button image & title as required
	// For titlePosition, the function only respects UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft and UIViewContentModeRight
	// All other titlePositions are ignored
	@objc func set(image anImage: UIImage?, title: String!, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState) {
		self.imageView?.contentMode = .Center
		self.setImage(anImage, forState: state)
		
		positionLabelRespectToImage(title!, position: titlePosition, spacing: additionalSpacing)
		
		self.titleLabel?.contentMode = .Center
		self.setTitle(title, forState: state)
	}
	
	private func positionLabelRespectToImage(title: NSString, position: UIViewContentMode, spacing: CGFloat) {
		let imageSize = self.imageRectForContentRect(self.frame)
		let titleFont = self.titleLabel?.font!
		let titleSize = title.sizeWithAttributes([NSFontAttributeName: titleFont!])
		
		var titleInsets: UIEdgeInsets
		var imageInsets: UIEdgeInsets
		
		switch (position) {
		case .Top:
			titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
			imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
		case .Bottom:
			titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
			imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
		case .Left:
			titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
			imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
		case .Right:
			titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
			imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		default:
			titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
			imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
		
		self.titleEdgeInsets = titleInsets
		self.imageEdgeInsets = imageInsets
	}
}