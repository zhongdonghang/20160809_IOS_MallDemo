//
//  File.swift
//  BrnMall
//
//  Created by luoyp on 16/4/8.
//  Copyright © 2016年 luoyp. All rights reserved.
//

enum PayType: Int {
	case WeiXinPay = 2
	case ZhifubaoPay = 1
	case Huodaofukuan = 3
}

class PayActionSheet: NSObject, UIActionSheetDelegate {

	private var selectedShaerType: ((shareType: PayType) -> ())?
	private var actionSheet: UIActionSheet?

	func showActionSheetViewShowInView(inView: UIView, selectedShaerType: ((shareType: PayType) -> ())) {

		actionSheet = UIActionSheet(title: "选择支付方式",
			delegate: self, cancelButtonTitle: "取消",
			destructiveButtonTitle: nil,
			otherButtonTitles: "在线支付")

		self.selectedShaerType = selectedShaerType

		actionSheet?.showInView(inView)
	}

	func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
		print(buttonIndex)
		if selectedShaerType != nil {

			switch buttonIndex {

			case PayType.ZhifubaoPay.rawValue:
				selectedShaerType!(shareType: .ZhifubaoPay)
				break

			case PayType.WeiXinPay.rawValue:
				selectedShaerType!(shareType: .WeiXinPay)
				break

			case PayType.Huodaofukuan.rawValue:
				selectedShaerType!(shareType: .Huodaofukuan)
				break

			default:
				break
			}
		}
	}
}
