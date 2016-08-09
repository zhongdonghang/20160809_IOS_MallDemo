//
//  SecondViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/3/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import SVProgressHUD

class CategoryViewController: BaseViewController, TitleViewProtocol {

	private var categoryLay1_Data: [CategoryLay1] = []
	private var categoryTableView: BMTableView!
	private var productsVC: ProductsViewController!

	private let shopImageView = UIImageView()
	private let emptyLabel = UILabel()
	private let emptyButton = UIButton()

	// flag
	private var categoryTableViewIsLoadFinish = false
	private var productTableViewIsLoadFinish = false

	override func viewDidLoad() {
		super.viewDidLoad()
		print("CategoryViewController viewDidLoad")
		navigationController?.navigationBar.barTintColor = BMNavigationBarColor

		// buildNavigationBar("商品分类")

		let titleView = UILabel(frame: CGRectMake(10, 0, 100, 35))
		titleView.text = "商品分类"
        if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
            titleView.font = UIFont.boldSystemFontOfSize(16)
        } else {
            titleView.font = UIFont.boldSystemFontOfSize(14)
        }
		titleView.textAlignment = NSTextAlignment.Center
		titleView.textColor = UIColor.whiteColor()
		navigationItem.titleView = titleView

		bulidCategoryTableView()

		bulidProductsViewController()
		buildEmptyUI()

		loadCategotyLay1Data()
	}

	override func viewWillAppear(animated: Bool) {
		if cateIndex != -1 && cateIndex < self.categoryLay1_Data.count {
			self.categoryTableView.selectRowAtIndexPath(NSIndexPath.init(forRow: cateIndex, inSection: 0), animated: true, scrollPosition: .Bottom)
			if self.productsVC != nil {
				print(self.categoryLay1_Data[cateIndex].cateId)
				self.productsVC.curID = self.categoryLay1_Data[cateIndex].cateId
				self.productsVC.clickCategotyItem()
			}
			cateIndex = -1
		}
	}
	private func buildEmptyUI() {
		shopImageView.image = UIImage(named: "reload")
		shopImageView.contentMode = UIViewContentMode.Center
		shopImageView.hidden = true
		view.addSubview(shopImageView)

		shopImageView.snp_makeConstraints(closure: {
			(make) -> Void in
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).inset(-80)
		})

		emptyLabel.text = "亲,数据迷路了,点击再试试"
		emptyLabel.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
		emptyLabel.textAlignment = NSTextAlignment.Center
		emptyLabel.font = UIFont.systemFontOfSize(16)
		emptyLabel.hidden = true
		view.addSubview(emptyLabel)
		emptyLabel.snp_makeConstraints(closure: {
			(make) -> Void in
			make.top.equalTo(shopImageView.snp_bottom).inset(-10)
			make.width.equalTo(ScreenWidth)
		})

		emptyButton.addTarget(self, action: #selector(CategoryViewController.loadCategotyLay1Data), forControlEvents: UIControlEvents.TouchUpInside)
		emptyButton.hidden = true
		view.addSubview(emptyButton)

		emptyButton.snp_makeConstraints(closure: {
			(make) -> Void in
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).inset(-80)
			make.height.equalTo(120)
			make.width.equalTo(120)
		})
	}

	private func showEmptyUI() {
		shopImageView.hidden = false
		emptyButton.hidden = false
		emptyLabel.hidden = false
		self.categoryTableView.hidden = true
		self.productsVC.view.hidden = true
	}

	private func hideEmptyUI() {
		shopImageView.hidden = true
		emptyButton.hidden = true
		emptyLabel.hidden = true
		self.categoryTableView.hidden = false
		self.productsVC.view.hidden = false
	}
	// MARK:- Creat UI
	private func bulidCategoryTableView() {
		categoryTableView = BMTableView(frame: CGRectMake(0, 0, ScreenWidth * 0.25, ScreenHeight), style: .Plain)
		categoryTableView.backgroundColor = BMGreyBackgroundColor
		categoryTableView.delegate = self
		categoryTableView.dataSource = self
		categoryTableView.showsHorizontalScrollIndicator = false
		categoryTableView.showsVerticalScrollIndicator = false
		categoryTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: NavigationH, right: 0)
		categoryTableView.hidden = true;
		view.addSubview(categoryTableView)
	}

	private func bulidProductsViewController() {
		productsVC = ProductsViewController()
		// productsVC.delegate = self
		productsVC.view.hidden = true
		addChildViewController(productsVC)
		view.addSubview(productsVC.view)

		weak var tmpSelf = self
//		productsVC.refreshUpPull = {
//			let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.2 * Double(NSEC_PER_SEC)))
//			dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
//				Supermarket.loadSupermarketData { (data, error) -> Void in
//					if error == nil {
//						tmpSelf!.supermarketData = data
//						tmpSelf!.productsVC.supermarketData = data
//						tmpSelf?.productsVC.productsTableView?.mj_header.endRefreshing()
//						tmpSelf!.categoryTableView.reloadData()
//						tmpSelf!.categoryTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .Top)
//					}
//				}
//			})
//		}
	}

	/**
	 加载一级商品列表
	 */
	func loadCategotyLay1Data() {
		ProgressHUDManager.showWithStatus(Loading)
		categoryLay1_Data.removeAll()
		manager.request(APIRouter.getCategoryLay1).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			// ProgressHUDManager.dismiss()
			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				self.showEmptyUI()
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)
				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(ReturnFalse)
					self.showEmptyUI()
					break
				}
				if "true" == json["result"].stringValue {
					self.categoryTableView.hidden = false
					self.productsVC.view.hidden = false
					let jsonArray = json["data"].arrayValue

					if jsonArray.count == 0 {
						ProgressHUDManager.showInfoStatus(NoData)
						self.showEmptyUI()
						break
					}
					for obj in jsonArray {
						let cateId = obj["cateId"].stringValue
						let cateName = obj["cateName"].stringValue
						self.categoryLay1_Data.append(CategoryLay1.init(ID: cateId, Name: cateName))
					}
					self.hideEmptyUI()
					SVProgressHUD.dismiss()
					self.categoryTableView.reloadData()
				}
				// 加载完一级列表,默认选择第一行
				print("cateindex = \(cateIndex)")
				if cateIndex == -1 {
					self.categoryTableView.selectRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), animated: true, scrollPosition: .Bottom)
					if self.productsVC != nil {
						print(self.categoryLay1_Data[0].cateId)
						self.productsVC.curID = self.categoryLay1_Data[0].cateId
						self.productsVC.clickCategotyItem()
					}
				}
				else {
					if cateIndex < self.categoryLay1_Data.count {
						self.categoryTableView.selectRowAtIndexPath(NSIndexPath.init(forRow: cateIndex, inSection: 0), animated: true, scrollPosition: .Bottom)
						if self.productsVC != nil {
							print(self.categoryLay1_Data[cateIndex].cateId)
							self.productsVC.curID = self.categoryLay1_Data[cateIndex].cateId
							self.productsVC.clickCategotyItem()
						}
						cateIndex = -1
					}
				}

			}
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoryLay1_Data.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = CategoryCell.cellWithTableView(tableView, index: indexPath)
		cell.categorie = categoryLay1_Data[indexPath.row].cateName
		if indexPath.row == 0 {
			cell.img = "bjp"
		}
		if indexPath.row == 1 {
			cell.img = "bjsp"
		}
		if indexPath.row == 2 {
			cell.img = "bjqc"
		}
		if indexPath.row == 3 {
			cell.img = "hzp"
		}
		if indexPath.row == 4 {
			cell.img = "xhyp"
		}
		if indexPath.row == 5 {
			cell.img = "qxyp"
		}
		if indexPath.row == 6 {
			cell.img = "bjlp"
		}

		return cell
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		return 55
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if productsVC != nil {
			print(categoryLay1_Data[indexPath.row].cateId)
			productsVC.curID = categoryLay1_Data[indexPath.row].cateId
			productsVC.clickCategotyItem()
		}
	}
}
