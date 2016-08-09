
import UIKit
import SVProgressHUD

class ProgressHUDManager {
	
	class func setForegroundColor(color: UIColor) {
		SVProgressHUD.setForegroundColor(color)
	}
	
	class func setSuccessImage(image: UIImage) {
		SVProgressHUD.setSuccessImage(image)
	}
	
	class func setErrorImage(image: UIImage) {
		SVProgressHUD.setErrorImage(image)
	}
	
	class func setFont(font: UIFont) {
		SVProgressHUD.setFont(UIFont.systemFontOfSize(12))
	}
	
	class func showImage(image: UIImage, status: String) {
		SVProgressHUD.showImage(image, status: status)
	}
	
	class func show() {
		SVProgressHUD.show()
	}
	
	class func dismiss() {
		let delay = 1.8
		let delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
		let mainQueue = dispatch_get_main_queue()
		
		dispatch_after(delayInNanoSeconds, mainQueue, {
			
			if isVisible() {
				SVProgressHUD.dismiss()
			}
		})
	}
	
	class func showWithStatus(status: String) {
		SVProgressHUD.setDefaultStyle(.Custom)
		SVProgressHUD.setDefaultMaskType(.Clear)
		SVProgressHUD.setFont(UIFont.systemFontOfSize(14))
		SVProgressHUD.setBackgroundColor(UIColor.colorWithCustom(230, g: 230, b: 230))
		SVProgressHUD.showWithStatus(status)
	}
	
	class func isVisible() -> Bool {
		return SVProgressHUD.isVisible()
	}
	
	class func showSuccessWithStatus(string: String) {
		SVProgressHUD.showSuccessWithStatus(string)
		dismiss()
	}
	class func showInfoStatus(string: String) {
		SVProgressHUD.showInfoWithStatus(string)
		dismiss()
	}
}
