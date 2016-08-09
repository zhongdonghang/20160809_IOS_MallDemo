//
//  AppDelegate.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改         //
////////////////////////////////////////////////////////////////////

import UIKit
import SwiftyJSON

let kGtAppId: String = "Fotr476ZIE7moaX94k4LQ2"
let kGtAppKey: String = "FoDZIeBWIu5mvClZtubTk"
let kGtAppSecret: String = "Jxx0SbZNJA9gZ1pQOpH8e5"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate, GeTuiSdkDelegate, WXApiDelegate {

	public var cateIndex = -1
	var window: UIWindow?
	var adViewController: ADViewController?
	var openUrl = ""
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.

		// 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
		GeTuiSdk.startSdkWithAppId(kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self);

		WXApi.registerApp(WX_APPID, withDescription: "jsyWeChatPay")

		// 注册Apns
		self.registerUserNotification(application);

		NSThread.sleepForTimeInterval(1.0)

		setAppSubject()

		addNotification()

		buildKeyWindow()

		checkVersion()
		// ication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES]
		application.setStatusBarStyle(.LightContent, animated: true)
		return true
	}

	// MARK: - 用户通知(推送) _自定义方法

	/** 注册用户通知(推送) */
	func registerUserNotification(application: UIApplication) {
		let result = UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch)
		if (result != NSComparisonResult.OrderedAscending) {
			UIApplication.sharedApplication().registerForRemoteNotifications()

			let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
			UIApplication.sharedApplication().registerUserNotificationSettings(userSettings)
		} else {
			UIApplication.sharedApplication().registerForRemoteNotificationTypes([.Alert, .Sound, .Badge])
		}
	}

	// MARK: - 远程通知(推送)回调

	/** 远程通知注册成功委托 */
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"));
		token = token.stringByReplacingOccurrencesOfString(" ", withString: "")

		// [3]:向个推服务器注册deviceToken
		GeTuiSdk.registerDeviceToken(token);

		NSLog("\n>>>[DeviceToken Success]:%@\n\n", token);
	}

	/** 远程通知注册失败委托 */
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		NSLog("\n>>>[DeviceToken Error]:%@\n\n", error.description);
	}

	// MARK: - APP运行中接收到通知(推送)处理

	/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
		application.applicationIconBadgeNumber = 0; // 标签

		NSLog("\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
	}

	// MARK: - GeTuiSdkDelegate

	/** SDK启动成功返回cid */
	func GeTuiSdkDidRegisterClient(clientId: String!) {
		// [4-EXT-1]: 个推SDK已注册，返回clientId
		NSLog("\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
	}

	/** SDK遇到错误回调 */
	func GeTuiSdkDidOccurError(error: NSError!) {
		// [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
		NSLog("\n>>>[GeTuiSdk error]:%@\n\n", error.localizedDescription);
	}

	/** SDK收到sendMessage消息回调 */
	func GeTuiSdkDidSendMessage(messageId: String!, result: Int32) {
		// [4-EXT]:发送上行消息结果反馈
		let msg: String = "sendmessage=\(messageId),result=\(result)";
		NSLog("\n>>>[GeTuiSdk DidSendMessage]:%@\n\n", msg);
	}

	func GeTuiSdkDidReceivePayloadData(payloadData: NSData!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {

		var payloadMsg = "";
		if ((payloadData) != nil) {
			payloadMsg = String.init(data: payloadData, encoding: NSUTF8StringEncoding)!;
		}

		let msg: String = "Receive Payload: \(payloadMsg), taskId:\(taskId), messageId:\(msgId)";

		NSLog("\n>>>[GeTuiSdk DidReceivePayload]:%@\n\n", msg);
	}

	private func buildKeyWindow() {

		window = UIWindow(frame: ScreenBounds)
		window!.makeKeyAndVisible()

		let isFristOpen = NSUserDefaults.standardUserDefaults().objectForKey("isFristOpenApp")

		if isFristOpen == nil {
			// window?.rootViewController = GuideViewController()
			// NSUserDefaults.standardUserDefaults().setObject("isFristOpenApp", forKey: "isFristOpenApp")
			loadADRootViewController()
		} else {
			loadADRootViewController()
		}
	}

	func loadADRootViewController() {
		adViewController = ADViewController()

		weak var tmpSelf = self
		// MainAD.loadADData { (data, error) -> Void in
		// if data?.data?.img_name != nil {
		tmpSelf!.adViewController!.imageName = "http://papers.co/wallpaper/papers.co-ms54-brunch-cuba-food-city-art-vacation-33-iphone6-wallpaper.jpg"
		tmpSelf!.window?.rootViewController = self.adViewController
		// }
	}

	// MARK: - Action
	func showMainTabbarControllerSucess(noti: NSNotification) {
		let adImage = noti.object as! UIImage
		let mainTabBar = MainTabBarController()
		mainTabBar.adImage = adImage
		window?.rootViewController = mainTabBar
	}

	func showMainTabbarControllerFale() {
		window!.rootViewController = MainTabBarController()
	}

	func addNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMainTabbarControllerSucess), name: ADImageLoadSecussed, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMainTabbarControllerFale), name: ADImageLoadFail, object: nil)
	}

	// MARK:主题设置
	private func setAppSubject() {
		let tabBarAppearance = UITabBar.appearance()
		tabBarAppearance.backgroundColor = UIColor.whiteColor()
		tabBarAppearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

		let navBarnAppearance = UINavigationBar.appearance()
		navBarnAppearance.translucent = false
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		print("openURL:\(url.absoluteString)")

		if url.scheme == WX_APPID {
			return WXApi.handleOpenURL(url, delegate: self)
		}

		// 跳转支付宝钱包进行支付，处理支付结果
		AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDict: [NSObject: AnyObject]!) -> Void in
			print("openURL result: \(resultDict)")
		})

		return true
	}

	func onResp(resp: BaseResp!) {
		var strTitle = "支付结果"
		var strMsg = "\(resp.errCode)"
		if resp.isKindOfClass(PayResp) {
			switch resp.errCode {
			case 0:
				NSNotificationCenter.defaultCenter().postNotificationName(WXPaySuccessNotification, object: nil)
				// strMsg = "支付成功,即将为你发货!"
			default:
				strMsg = "支付失败，请您重新支付!"
				let alert = UIAlertView(title: nil, message: strMsg, delegate: nil, cancelButtonTitle: "好的")
				alert.show()
				print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
			}
		}
	}
	func checkVersion() {
		let version = ""
		var curVersion = ""
		if let text = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
			curVersion = text
			print("当前版本 " + curVersion)
		}

		manager.request(.GET, "http://itunes.apple.com/lookup?id=1111147392").responseJSON(completionHandler: {
			data in

			switch data.result {

			case .Failure:
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				print(json)
				let remoteVersion = json["results"][0]["version"].stringValue
				self.openUrl = json["results"][0]["trackViewUrl"].stringValue
				let updateInfo = json["results"][0]["releaseNotes"].stringValue
				print(json["results"][0]["trackViewUrl"])

				let curV = Double.init(curVersion)
				let remoteV = Double.init(remoteVersion)
				if curV < remoteV {
					print("有新版本")
					let alertView = UIAlertView()
					alertView.title = "新版本提示"
					alertView.message = "更新: " + updateInfo
					alertView.addButtonWithTitle("下次再说")
					alertView.addButtonWithTitle("现在更新")
					alertView.cancelButtonIndex = 0
					alertView.delegate = self;
					alertView.show()

				}
			}
		})
	}
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		if (buttonIndex == alertView.cancelButtonIndex) {
			print("点击了取消")
		}
		else
		{
			UIApplication.sharedApplication().openURL(NSURL.init(string: self.openUrl)!)
		}
	}
}
