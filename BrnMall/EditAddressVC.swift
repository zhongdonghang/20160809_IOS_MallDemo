//
//  EditAddressVC.swift
//  BrnMall
//
//  Created by luoyp on 16/4/7.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire

enum EditAdressViewControllerType: Int {
	case Add
	case Edit
}
struct RegionModel {
	private var id = ""
	private var name = ""
}

class EditAddressVC: BaseViewController {

	private let deleteView = UIView()
	private let scrollView = UIScrollView()
	private let adressView = UIView()
	private var contactsTextField: UITextField?
	private var phoneNumberTextField: UITextField?
	private var cityTextField: UITextField?
	private var areaTextField: UITextField?
	private var regionTextField: UITextField?
	private var adressTextField: UITextField?
	private var selectCityPickView: UIPickerView?
	private var currentSelectedCityIndex = 0
	weak var topVC: MyAdressViewController?
	var vcType: EditAdressViewControllerType?
	var currentAdressRow: Int = -1

	private var provinceid = "1"
	private var cityid = "35"
	private var countryid = "-1"
	private var regionid = "-1"

	private var curTextTag = -1

	private var cityArray: [RegionModel] = []
	private var countryArray: [RegionModel] = []

	private lazy var provinceArray: [String]? = {
		let array = ["北京市", "天津市", "河北省", "山西省", "内蒙古自治区", "辽宁省", "吉林省", "黑龙江省", "上海市", "江苏省", "浙江省", "安徽省", "福建省", "江西省", "山东省", "河南省", "湖北省", "湖南省", "广东省", "广西", "海南省", "重庆市", "四川省", "贵州省", "云南省", "西藏自治区", "陕西省", "甘肃省", "青海省", "宁夏自治区", "新疆自治区", "台湾省", "香港行政区", "澳门行政区"]
		return array
	}()

	// MARK: - Lift Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		let rightItemButton = UIBarButtonItem.barButton("保存", titleColor: UIColor.whiteColor(), target: self, action: #selector(EditAddressVC.saveButtonClick))
		navigationItem.rightBarButtonItem = rightItemButton

		buildScrollView()

		buildAdressView()

		buildDeleteAdressView()

		if currentAdressRow != -1 && vcType == .Edit {
			let adress = topVC!.adresses[currentAdressRow]

			provinceid = adress.Provinceid
			cityid = adress.Cityid
			countryid = adress.Countyid
			regionid = adress.regionId

			cityTextField?.text = adress.ProvinceName
			areaTextField?.text = adress.CityName
			regionTextField?.text = adress.CountyName
		}

		getCityById(provinceid)
		getRegionById(cityid)
	}

	func getCityById(id: String) {
		cityArray.removeAll()

		Alamofire.request(.POST, BaseIP + "/tool/citylist?provinceId=\(provinceid)").responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				break

			case .Success:
				if let returnJson = data.result.value {

					let json: JSON = JSON.init(returnJson)
					print("根据省份id返回json \(json)")
					if "success" == json["state"].stringValue {
						let content = json["content"].arrayValue
						if content.count <= 0 {
							return
						}

						for i in 0 ... (content.count - 1) {
							self.cityArray.append(RegionModel.init(id: content[i]["id"].stringValue, name: content[i]["name"].stringValue))
						}

					}

					break
				}
			}
		})

	}
	func getRegionById(id: String) {
		countryArray.removeAll()

		Alamofire.request(.POST, BaseIP + "/tool/countylist?cityId=\(cityid)").responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				break

			case .Success:
				if let returnJson = data.result.value {

					let json: JSON = JSON.init(returnJson)
					print("根据城市id返回json \(json)")
					if "success" == json["state"].stringValue {
						let content = json["content"].arrayValue
						if content.count <= 0 {
							return
						}
						for i in 0 ... (content.count - 1) {
							self.countryArray.append(RegionModel.init(id: content[i]["id"].stringValue, name: content[i]["name"].stringValue))
						}

					}

					break
				}
			}
		})

	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if vcType == .Edit {
			buildNavigationItem("修改地址")
		}
		if vcType == .Add {
			buildNavigationItem("新增地址")
		}
		if currentAdressRow != -1 && vcType == .Edit {
			let adress = topVC!.adresses[currentAdressRow]

			contactsTextField?.text = adress.name

			phoneNumberTextField?.text = adress.mobile

			adressTextField?.text = adress.address

			deleteView.hidden = false
		}
	}

	private func buildDeleteAdressView() {
		deleteView.frame = CGRectMake(0, CGRectGetMaxY(adressView.frame) + 10, view.width, 50)
		deleteView.backgroundColor = UIColor.whiteColor()
		scrollView.addSubview(deleteView)

		let deleteLabel = UILabel(frame: CGRectMake(10, 0, view.width - 20, 50))
		deleteLabel.text = "删除当前地址"
		deleteLabel.textColor = UIColor.whiteColor()
		deleteLabel.textAlignment = NSTextAlignment.Center
		deleteLabel.font = UIFont.systemFontOfSize(15)
		deleteLabel.backgroundColor = BtnBg
		deleteView.addSubview(deleteLabel)

		let tap = UITapGestureRecognizer(target: self, action: #selector(EditAddressVC.deleteViewClick))
		deleteView.addGestureRecognizer(tap)
		deleteView.hidden = true
	}

	private func buildScrollView() {
		scrollView.frame = view.bounds
		scrollView.backgroundColor = UIColor.clearColor()
		scrollView.alwaysBounceVertical = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		view.addSubview(scrollView)
	}

	private func buildAdressView() {
		adressView.frame = CGRectMake(0, 10, view.width, 300)
		adressView.backgroundColor = UIColor.whiteColor()
		scrollView.addSubview(adressView)

		let viewHeight: CGFloat = 50
		let leftMargin: CGFloat = 15
		let labelWidth: CGFloat = 70
		buildUnchangedLabel(CGRectMake(leftMargin, 0, labelWidth, viewHeight), text: "收货人")
		buildUnchangedLabel(CGRectMake(leftMargin, 1 * viewHeight, labelWidth, viewHeight), text: "手机号码")
		buildUnchangedLabel(CGRectMake(leftMargin, 2 * viewHeight, labelWidth, viewHeight), text: "所在省份")
		buildUnchangedLabel(CGRectMake(leftMargin, 3 * viewHeight, labelWidth, viewHeight), text: "所在城市")
		buildUnchangedLabel(CGRectMake(leftMargin, 4 * viewHeight, labelWidth, viewHeight), text: "所在区域")
		buildUnchangedLabel(CGRectMake(leftMargin, 5 * viewHeight, labelWidth, viewHeight), text: "详细地址")

		let lineView = UIView(frame: CGRectMake(leftMargin, 49, view.width - 10, 1))
		lineView.alpha = 0.15
		lineView.backgroundColor = UIColor.lightGrayColor()
		adressView.addSubview(lineView)

		let textFieldWidth = view.width * 0.7
		let x = leftMargin + labelWidth + 10
		contactsTextField = UITextField()
		buildTextField(contactsTextField!, frame: CGRectMake(x, 0, textFieldWidth, viewHeight), placeholder: "收货人姓名", tag: 1)

		phoneNumberTextField = UITextField()
		buildTextField(phoneNumberTextField!, frame: CGRectMake(x, 1 * viewHeight, textFieldWidth, viewHeight), placeholder: "你的手机号", tag: 2)

		cityTextField = UITextField()
		buildTextField(cityTextField!, frame: CGRectMake(x, 2 * viewHeight, textFieldWidth, viewHeight), placeholder: "请选择省份", tag: 3)

		areaTextField = UITextField()
		buildTextField(areaTextField!, frame: CGRectMake(x, 3 * viewHeight, textFieldWidth, viewHeight), placeholder: "请选择你的城市", tag: 4)
		regionTextField = UITextField()
		buildTextField(regionTextField!, frame: CGRectMake(x, 4 * viewHeight, textFieldWidth, viewHeight), placeholder: "请选择你的区域", tag: 6)

		adressTextField = UITextField()
		buildTextField(adressTextField!, frame: CGRectMake(x, 5 * viewHeight, textFieldWidth, viewHeight), placeholder: "请输入楼号门牌号等详细信息", tag: 5)
	}

	private func buildUnchangedLabel(frame: CGRect, text: String) {
		let label = UILabel(frame: frame)
		label.text = text
		label.font = UIFont.systemFontOfSize(15)
		label.textColor = BMInfoLabelTextColor
		adressView.addSubview(label)

		let lineView = UIView(frame: CGRectMake(15, frame.origin.y - 1, view.width - 10, 1))
		lineView.alpha = 0.15
		lineView.backgroundColor = UIColor.lightGrayColor()
		adressView.addSubview(lineView)
	}

	private func buildTextField(textField: UITextField, frame: CGRect, placeholder: String, tag: Int) {
		textField.frame = frame

//		if 2 == tag {
//			textField.keyboardType = UIKeyboardType.NumberPad
//		}

		if 3 == tag || 4 == tag || 6 == tag {
			selectCityPickView = UIPickerView()
			selectCityPickView!.delegate = self
			selectCityPickView!.dataSource = self
			textField.inputView = selectCityPickView
			textField.inputAccessoryView = buildInputView()
		}

		textField.tag = tag
		textField.autocorrectionType = UITextAutocorrectionType.No
		textField.autocapitalizationType = UITextAutocapitalizationType.None
		textField.placeholder = placeholder
		textField.font = UIFont.systemFontOfSize(15)
		textField.delegate = self
		textField.textColor = BMInfoLabelTextColor
		adressView.addSubview(textField)
	}

	private func buildInputView() -> UIView {
		let toolBar = UIToolbar(frame: CGRectMake(0, 0, view.width, 40))
		toolBar.backgroundColor = UIColor.whiteColor()

		let lineView = UIView(frame: CGRectMake(0, 0, view.width, 1))
		lineView.backgroundColor = UIColor.blackColor()
		lineView.alpha = 0.1
		toolBar.addSubview(lineView)

		let titleLabel = UILabel()
		titleLabel.font = UIFont.systemFontOfSize(15)
		titleLabel.textColor = UIColor.lightGrayColor()
		titleLabel.alpha = 0.8
		titleLabel.text = "选择省份"
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.frame = CGRectMake(0, 0, view.width, toolBar.height)
		toolBar.addSubview(titleLabel)

		let cancleButton = UIButton(frame: CGRectMake(0, 0, 80, toolBar.height))
		cancleButton.tag = 10
		cancleButton.addTarget(self, action: #selector(EditAddressVC.selectedCityTextFieldDidChange(_:)), forControlEvents: .TouchUpInside)
		cancleButton.setTitle("取消", forState: .Normal)
		cancleButton.setTitleColor(UIColor.colorWithCustom(82, g: 188, b: 248), forState: .Normal)
		toolBar.addSubview(cancleButton)

		let determineButton = UIButton(frame: CGRectMake(view.width - 80, 0, 80, toolBar.height))
		determineButton.tag = 11
		determineButton.addTarget(self, action: #selector(EditAddressVC.selectedCityTextFieldDidChange(_:)), forControlEvents: .TouchUpInside)
		determineButton.setTitleColor(UIColor.colorWithCustom(82, g: 188, b: 248), forState: .Normal)
		determineButton.setTitle("确定", forState: .Normal)
		toolBar.addSubview(determineButton)

		return toolBar
	}

	// MARK: - Action
	func saveButtonClick() {
		if contactsTextField?.text?.characters.count <= 1 {
			ProgressHUDManager.showInfoStatus("我们需要你的大名~")
			return
		}

		if phoneNumberTextField!.text?.characters.count != 11 {
			ProgressHUDManager.showInfoStatus("没电话,怎么联系你~")
			return
		}

		if cityTextField?.text?.characters.count <= 0 {
			ProgressHUDManager.showInfoStatus("你在哪个城市啊~空空的~")
			return
		}

		if areaTextField?.text?.characters.count <= 2 {
			ProgressHUDManager.showInfoStatus("你的位置啊~")
			return
		}

		if adressTextField?.text?.characters.count <= 2 {
			ProgressHUDManager.showInfoStatus("在哪里呢啊~上哪找你去啊~")
			return
		}

		if vcType == .Add {
			let addr = Address.init(Uid: "\(SysUtils.get("uid")!)", Aid: "", Name: (contactsTextField?.text)!, RegionId: regionid, Address: (adressTextField?.text)!, Mobile: phoneNumberTextField!.text!, Phone: "", ZipCode: "", Email: "", IsDefault: "0", ProvinceName: "", CityName: "", CountyName: "", Provinceid: "", Cityid: "", Countyid: "")
			postAddress(addr)
		}

		if vcType == .Edit {
			let adress = topVC!.adresses[currentAdressRow]
			adress.name = (contactsTextField?.text)!
			adress.mobile = (phoneNumberTextField?.text)!
			adress.address = (adressTextField?.text)!
			adress.regionId = regionid

			postAddress(adress)
		}
	}

	func postAddress(address: Address) {
		ProgressHUDManager.showWithStatus("正在提交信息")
		manager.request(APIRouter.saveAddress(address: address)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				if let returnJson = data.result.value {

					let json: JSON = JSON.init(returnJson)
					// print(json)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
						break
					}
					if "true" == json["result"].stringValue {
						// ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
						SVProgressHUD.dismiss()
						self.navigationController?.popViewControllerAnimated(true)
						self.topVC?.headRefresh()
					}

					break
				}
			}
		})
	}

	func selectedCityTextFieldDidChange(sender: UIButton) {

		if curTextTag == 4 {
			if cityTextField?.text?.characters.count == 0 {

				ProgressHUDManager.showInfoStatus("请先选择省份")
				areaTextField?.endEditing(true)
				return
			}
			if cityArray.count != 0 {
				areaTextField?.text = cityArray[currentSelectedCityIndex].name
				cityid = cityArray[currentSelectedCityIndex].id
			}
			areaTextField?.endEditing(true)
			getRegionById(cityid)
			regionTextField?.text = ""
			regionid = "-1"
			return
		}

		if curTextTag == 6 {
			if cityTextField?.text?.characters.count == 0 {
				ProgressHUDManager.showInfoStatus("请先选择省份")
				regionTextField?.endEditing(true)
				return
			}
			if areaTextField?.text?.characters.count == 0 {
				ProgressHUDManager.showInfoStatus("请先选择城市")
				regionTextField?.endEditing(true)
				return
			}
			if countryArray.count != 0 {
				regionTextField?.text = countryArray[currentSelectedCityIndex].name
				regionid = countryArray[currentSelectedCityIndex].id
			}
			regionTextField?.endEditing(true)

			return
		}

		if sender.tag == 11 {
			getCityById(provinceid)
			if currentSelectedCityIndex != -1 {

				cityTextField?.text = provinceArray![currentSelectedCityIndex]
				areaTextField?.text = ""
				regionTextField?.text = ""
				regionid = "-1"
				cityid = "-1"
			}
		}
		cityTextField!.endEditing(true)
	}

	func deleteViewClick() {
		let alert = UIAlertController.init(title: "提示", message: "确认删除地址吗？", preferredStyle: .Alert)

		let ok = UIAlertAction.init(title: "删除", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
			self.deleteAddr()
		})
		let cancel = UIAlertAction.init(title: "取消", style: .Default, handler: {
			(action: UIAlertAction!) -> Void in
		})

		alert.addAction(ok)
		alert.addAction(cancel)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	func deleteAddr() {
		print("删除地址")
		let adress = topVC!.adresses[currentAdressRow]
		ProgressHUDManager.showWithStatus("正在删除")
		manager.request(APIRouter.deleteAddress(uid: adress.uid, aid: adress.aid)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				// ProgressHUDManager.dismiss()
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				if let returnJson = data.result.value {

					let json: JSON = JSON.init(returnJson)
					print(json)
					if "false" == json["result"].stringValue {
						ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
						break
					}
					if "true" == json["result"].stringValue {
						// ProgressHUDManager.showInfoStatus(json["data"][0]["msg"].stringValue)
						SVProgressHUD.dismiss()
						self.navigationController?.popViewControllerAnimated(true)
						self.topVC?.headRefresh()
					}

					break
				}
			}
		})
	}
}

extension EditAddressVC: UITextFieldDelegate {

	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

		return true
	}
	func textFieldDidBeginEditing(textField: UITextField) {
		currentSelectedCityIndex = 0
		curTextTag = textField.tag
	}
}

extension EditAddressVC: UIPickerViewDataSource, UIPickerViewDelegate {

	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if curTextTag == 4 {
			return cityArray.count
		}
		if curTextTag == 6 {
			return countryArray.count
		}
		return provinceArray!.count
	}

	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if curTextTag == 4 {
			return cityArray[row].name
		}
		if curTextTag == 6 {
			return countryArray[row].name
		}
		return provinceArray![row]
	}

	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentSelectedCityIndex = row
		if curTextTag == 4 {
			cityid = cityArray[row].id
			return
		}
		if curTextTag == 6 {
			countryid = countryArray[row].id
			regionid = countryArray[row].id
			return
		}

		provinceid = "\(row.advancedBy(1))"
		print("id \(row.advancedBy(1))   name \(provinceArray![row])")
	}
}
