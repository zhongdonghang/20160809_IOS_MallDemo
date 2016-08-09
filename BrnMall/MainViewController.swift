

import UIKit

class MainTabBarController: AnimationTabBarController, UITabBarControllerDelegate {

	private var fristLoadMainTabBarController: Bool = true
	private var adImageView: UIImageView?
	var adImage: UIImage? {
		didSet {
			weak var tmpSelf = self
			adImageView = UIImageView(frame: UIScreen.mainScreen().bounds)
			adImageView!.image = adImage!
			self.view.addSubview(adImageView!)

			UIImageView.animateWithDuration(2.0, animations: { () -> Void in
				tmpSelf!.adImageView!.transform = CGAffineTransformMakeScale(1.2, 1.2)
				tmpSelf!.adImageView!.alpha = 0
			}) { (finsch) -> Void in
				tmpSelf!.adImageView!.removeFromSuperview()
				tmpSelf!.adImageView = nil
			}
		}
	}

	// MARK:- view life circle
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		buildMainTabBarChildViewController()
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		if fristLoadMainTabBarController {
			let containers = createViewContainers()

			createCustomIcons(containers)
			fristLoadMainTabBarController = false
		}
	}

	// MARK: - Method
	// MARK: 初始化tabbar
	private func buildMainTabBarChildViewController() {
		tabBarControllerAddChildViewController(HomeViewController(), title: "首页", imageName: "v2_home", selectedImageName: "v2_home_r", tag: 0)
		tabBarControllerAddChildViewController(BrandViewController(), title: "品牌", imageName: "v2_brand", selectedImageName: "v2_brand_r", tag: 1)
		tabBarControllerAddChildViewController(CategoryViewController(), title: "分类", imageName: "v2_order", selectedImageName: "v2_order_r", tag: 2)
		tabBarControllerAddChildViewController(ShopCartViewController(), title: "购物车", imageName: "shopCart", selectedImageName: "shopCart", tag: 3)
		tabBarControllerAddChildViewController(MineViewController(), title: "我的", imageName: "v2_my", selectedImageName: "v2_my_r", tag: 4)
	}

	private func tabBarControllerAddChildViewController(childView: UIViewController, title: String, imageName: String, selectedImageName: String, tag: Int) {
		let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
		vcItem.tag = tag
		vcItem.animation = RAMBounceAnimation()
		childView.tabBarItem = vcItem

		let navigationVC = BaseNavigationController(rootViewController: childView)
		addChildViewController(navigationVC)
	}

	func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
		// let childArr = tabBarController.childViewControllers as NSArray
		// let index = childArr.indexOfObject(viewController)

//		if index == 2 {
//			return false
//		}

		return true
	}
}
