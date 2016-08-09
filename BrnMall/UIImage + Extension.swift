

import UIKit

extension UIImage {
	
	class func imageWithColor(color: UIColor, size: CGSize, alpha: CGFloat) -> UIImage {
		let rect = CGRectMake(0, 0, size.width, size.height)
		
		UIGraphicsBeginImageContext(rect.size)
		let ref = UIGraphicsGetCurrentContext()
		CGContextSetAlpha(ref, alpha)
		CGContextSetFillColorWithColor(ref, color.CGColor)
		CGContextFillRect(ref, rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
	class func imageWithColor(color: UIColor) -> UIImage {
		let rect: CGRect = CGRectMake(0, 0, 1, 1)
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	
	class func createImageFromView(view: UIView) -> UIImage {
		UIGraphicsBeginImageContext(view.bounds.size);
		
		view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		
		let image = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		return image
	}
	
	func imageClipOvalImage() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
		let ctx = UIGraphicsGetCurrentContext()
		let rect = CGRectMake(0, 0, self.size.width, self.size.height)
		CGContextAddEllipseInRect(ctx, rect)
		
		CGContextClip(ctx)
		self.drawInRect(rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}
