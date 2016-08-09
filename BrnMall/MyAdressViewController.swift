//
//  MyAdressViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class MyAdressViewController: BaseViewController {

	private var addAdressButton: UIButton?
	private var nullImageView = UIView()
	var editVC: EditOrderVC?

	var selectedAdressCallback: ((adress: Address) -> ())?
	var isSelectVC = false
	var adressTableView: BMTableView?
	var adresses: [Address] = []

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	convenience init(selectedAdress: ((adress: Address) -> ())) {
		self.init(nibName: nil, bundle: nil)
		selectedAdressCallback = selectedAdress
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		buildNavigationItem()

		buildAdressTableView()

		buildNullImageView()
		buildBottomAddAdressButtom()

		ProgressHUDManager.showWithStatus(Loading)
		loadAdressData()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}

	private func buildNavigationItem() {
		buildNavigationItem("我的收货地址")
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	private func buildAdressTableView() {
		adressTableView = BMTableView(frame: view.bounds, style: UITableViewStyle.Plain)
		adressTableView?.frame.origin.y += 10;
		adressTableView?.backgroundColor = UIColor.clearColor()
		adressTableView?.rowHeight = 80
		adressTableView?.delegate = self
		adressTableView?.dataSource = self
		adressTableView?.showsVerticalScrollIndicator = false
		adressTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		view.addSubview(adressTableView!)
	}

	func headRefresh() {
		adressTableView?.mj_header.endRefreshing()
		adresses.removeAll()
		ProgressHUDManager.showWithStatus(Loading)
		loadAdressData()
	}

	private func buildNullImageView() {
		nullImageView.backgroundColor = UIColor.clearColor()
		nullImageView.frame = CGRectMake(0, 0, 200, 200)
		nullImageView.center = view.center
		nullImageView.center.y -= 100
		view.addSubview(nullImageView)

		let imageView = UIImageView(image: UIImage(named: "v2_address_empty"))
		imageView.center.x = 100
		imageView.center.y = 100
		nullImageView.addSubview(imageView)

		let label = UILabel(frame: CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, 200, 20))
		label.textColor = UIColor.lightGrayColor()
		label.textAlignment = NSTextAlignment.Center
		label.font = UIFont.systemFontOfSize(14)
		label.text = "你还没有地址哦~"
		nullImageView.hidden = true
		nullImageView.addSubview(label)
	}

	private func loadAdressData() {

		manager.request(APIRouter.MyAddressList(uid: "\(SysUtils.get("uid")!)")).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				print("返回地址json \(json)")
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(ReturnFalse)
					break
				}
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let jsonArray = tempJson["ShipAddressList"].arrayValue
					if jsonArray.count == 0 {
						SVProgressHUD.dismiss()
						self.adressTableView?.hidden = true
						self.nullImageView.hidden = false

						break
					}

					if jsonArray.count >= 1 {

						for j in 0 ... (jsonArray.count - 1) {
							// print(itemArray[j]["Item"]["OrderProductInfo"].description)
							let uid = jsonArray[j]["Uid"].stringValue
							let aid = jsonArray[j]["SAId"].stringValue
							let name = jsonArray[j]["Consignee"].stringValue
							let regionId = jsonArray[j]["RegionId"].stringValue
							let mobile = jsonArray[j]["Mobile"].stringValue
							let address = jsonArray[j]["Address"].stringValue
							let phone = jsonArray[j]["Phone"].stringValue
							let zipcode = jsonArray[j]["ZipCode"].stringValue
							let email = jsonArray[j]["Email"].stringValue
							let isDefault = jsonArray[j]["IsDefault"].stringValue

							let ProvinceName = jsonArray[j]["ProvinceName"].stringValue
							let CityName = jsonArray[j]["CityName"].stringValue
							let CountyName = jsonArray[j]["CountyName"].stringValue

							let ProvinceId = jsonArray[j]["ProvinceId"].stringValue
							let CityId = jsonArray[j]["CityId"].stringValue
							let CountyId = jsonArray[j]["CountyId"].stringValue

							self.adresses.append(Address.init(Uid: uid, Aid: aid, Name: name, RegionId: regionId, Address: address, Mobile: mobile, Phone: phone, ZipCode: zipcode, Email: email, IsDefault: isDefault, ProvinceName: ProvinceName, CityName: CityName, CountyName: CountyName, Provinceid: ProvinceId, Cityid: CityId, Countyid: CountyId))
						}

						SVProgressHUD.dismiss()
						self.adressTableView?.hidden = false
						self.nullImageView.hidden = true
						self.adressTableView?.reloadData()
						break
					}
				}
			}
		})
	}

	private func buildBottomAddAdressButtom() {
		let bottomView = UIView(frame: CGRectMake(0, ScreenHeight - 60 - 64, ScreenWidth, 60))
		bottomView.backgroundColor = UIColor.whiteColor()
		view.addSubview(bottomView)

		addAdressButton = UIButton(frame: CGRectMake(ScreenWidth * 0.15, 12, ScreenWidth * 0.7, 60 - 12 * 2))
		addAdressButton?.backgroundColor = BtnBg
		addAdressButton?.setTitle("+ 新增地址", forState: UIControlState.Normal)
		addAdressButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		addAdressButton?.layer.masksToBounds = true
		addAdressButton?.layer.cornerRadius = 8
		addAdressButton?.titleLabel?.font = UIFont.systemFontOfSize(15)
		addAdressButton?.addTarget(self, action: #selector(MyAdressViewController.addAdressButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
		bottomView.addSubview(addAdressButton!)
	}

	// MARK: - Action
	func addAdressButtonClick() {
		let editVC = EditAddressVC()
		editVC.topVC = self
		editVC.vcType = EditAdressViewControllerType.Add
		navigationController?.pushViewController(editVC, animated: true)
	}
}

extension MyAdressViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return adresses.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		weak var tmpSelf = self
		let cell = AdressCell.adressCell(tableView, indexPath: indexPath) { (cellIndexPathRow) -> Void in
			let editAdressVC = EditAddressVC()
			editAdressVC.topVC = tmpSelf
			editAdressVC.vcType = EditAdressViewControllerType.Edit
			editAdressVC.currentAdressRow = indexPath.row
			tmpSelf!.navigationController?.pushViewController(editAdressVC, animated: true)
		}

		cell.adress = adresses[indexPath.row]

		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if isSelectVC {
			let addr = adresses[indexPath.row]
			self.editVC!.receiptAdressView?.adress = addr
			navigationController?.popViewControllerAnimated(true)
		}
	}
}
