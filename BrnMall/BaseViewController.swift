//
//  BaseViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = BMGlobalBackgroundColor
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func checkLogin() -> Bool {
		if SysUtils.get("uid") == nil {
			let vc = LoginViewController()
			let nvc = BaseNavigationController.init(rootViewController: vc)
			self.navigationController?.presentViewController(nvc, animated: true, completion: nil)
			return false
		}
		return true
	}
	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */
}
