

import UIKit

class UpImageDownTextButton: UIButton {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		titleLabel?.sizeToFit()
		titleLabel?.frame = CGRectMake(0, height - 15, width, (titleLabel?.height)!)
		titleLabel?.textAlignment = .Center
		
		imageView?.frame = CGRectMake(width / 2 - 12, 0, 24, 24)
		// imageView?.contentMode = UIViewContentMode.Center
	}
}

class ItemLeftButton: UIButton {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let Offset: CGFloat = 15
		
		titleLabel?.sizeToFit()
		titleLabel?.frame = CGRectMake(-Offset, height - 15, width - Offset, (titleLabel?.height)!)
		titleLabel?.textAlignment = .Center
		
		imageView?.frame = CGRectMake(-Offset, 0, width - Offset, height - 15)
		imageView?.contentMode = UIViewContentMode.Center
	}
}

class ItemRightButton: UIButton {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let Offset: CGFloat = 15
		
		titleLabel?.sizeToFit()
		titleLabel?.frame = CGRectMake(Offset, height - 15, width + Offset, (titleLabel?.height)!)
		titleLabel?.textAlignment = .Center
		
		imageView?.frame = CGRectMake(Offset, 0, width + Offset, height - 15)
		imageView?.contentMode = UIViewContentMode.Center
	}
}

class ItemLeftImageButton: UIButton {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		imageView?.frame = bounds
		imageView?.frame.origin.x = -15
	}
}