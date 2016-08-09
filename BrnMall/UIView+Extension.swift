

import UIKit

/// 对UIView的扩展
extension UIView {
	/// X值
	var x: CGFloat {
		return self.frame.origin.x
	}
	/// Y值
	var y: CGFloat {
		return self.frame.origin.y
	}
	/// 宽度
	var width: CGFloat {
		return self.frame.size.width
	}
	/// 高度
	var height: CGFloat {
		return self.frame.size.height
	}
	var size: CGSize {
		return self.frame.size
	}
	var point: CGPoint {
		return self.frame.origin
	}
	class func NibObject() -> UINib {
		let hasNib: Bool = NSBundle.mainBundle().pathForResource(self.nameOfClass, ofType: "nib") != nil
		guard hasNib else {
			assert(!hasNib, "Invalid parameter") // assert
			return UINib()
		}
		return UINib(nibName: self.nameOfClass, bundle: nil)
	}
}