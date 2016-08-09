//
//  BrandListViewController.swift
//  BrnMall
//
//  Created by luoyp on 16/5/24.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class BrandListViewController: BaseViewController {
	var curID: String = ""

	var collectionView: BMCollectionView?
	private var brand_Data: [BrandModel] = []
	override func viewDidLoad() {
		super.viewDidLoad()

		view = UIView(frame: CGRectMake(ScreenWidth * 0.25, 0, ScreenWidth * 0.75, ScreenHeight - NavigationH))

		buildCollectionView()
	}

	// MARK: - Build UI
	private func buildCollectionView() {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 5
		layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
		layout.headerReferenceSize = CGSizeMake(0, HomeCollectionViewCellMargin)
		layout.footerReferenceSize = CGSizeMake(0, HomeCollectionViewCellMargin)

		collectionView = BMCollectionView(frame: CGRectMake(0, 0, ScreenWidth * 0.75, ScreenHeight - 64), collectionViewLayout: layout)
		collectionView!.delegate = self
		collectionView!.dataSource = self
		collectionView!.backgroundColor = UIColor.whiteColor()
		collectionView?.showsVerticalScrollIndicator = false
		collectionView!.registerClass(BrandCell.self, forCellWithReuseIdentifier: "Cell")
//		collectionView!.registerClass(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
//		collectionView!.registerClass(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
		view.addSubview(collectionView!)
		//
		// let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: "headRefresh")
		// refreshHeadView.gifView?.frame = CGRectMake(0, 30, 100, 100)
		collectionView!.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: "headRefresh")
	}

	func clickCategotyItem() {
		brand_Data.removeAll()
		self.collectionView?.reloadData()
		print("刷新商品分类ID \(curID)....")
		ProgressHUDManager.showWithStatus(Loading)
		getBrandListByCategoryId()
	}
	var isFootRefresh = false

	func headRefresh() {
		collectionView?.mj_header.endRefreshing()
		brand_Data.removeAll()
		print("刷新商品分类ID \(curID)....")
		ProgressHUDManager.showWithStatus(Loading)
		getBrandListByCategoryId()
	}
	/**
	 根据一级目录id获取品牌
	 */
	func getBrandListByCategoryId() {

		manager.request(APIRouter.getBrandByCategoryID(id: curID)).responseJSON(completionHandler: {
			data in
			// print(data.result.value)
			switch data.result {

			case .Failure:
				ProgressHUDManager.showInfoStatus(NetFail)
				break

			case .Success:
				let json: JSON = JSON(data.result.value!)

				if "false" == json["result"].stringValue {
					ProgressHUDManager.showInfoStatus(ReturnFalse)
					break
				}
				if "true" == json["result"].stringValue {
					let tempJson = json["data"]
					let jsonArray = tempJson["BrandList"].arrayValue
					print("返回品牌json \(jsonArray)")
					if jsonArray.count == 0 {
						if !self.isFootRefresh {
							ProgressHUDManager.showInfoStatus(NoData)
						}
						self.isFootRefresh = false
						break
					}

					for obj in jsonArray {
						let imgUrl = obj["Logo"].stringValue
						let name = obj["Name"].stringValue
						let Id = obj["BrandId"].stringValue

						self.brand_Data.append(BrandModel.init(ImgUrl: brandImgUrl + imgUrl, Name: name, ID: Id))
					}
					SVProgressHUD.dismiss()
					self.collectionView?.reloadData()
				}
			}
		})
	}
}

// MARK:- UICollectionViewDelegate UICollectionViewDataSource
extension BrandListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		return brand_Data.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! BrandCell

		cell.brand = brand_Data[indexPath.row]

		return cell
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

		return 1
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		var itemSize = CGSizeZero

		itemSize = CGSizeMake((ScreenWidth * 0.75 - HomeCollectionViewCellMargin * 2) * 0.33 - 4, 120)

		return itemSize
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

		return CGSizeMake(ScreenWidth * 0.75, 20)

	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

		return CGSizeMake(ScreenWidth, 20)
	}

	func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
		// if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
		// startAnimation(view, offsetY: 60, duration: 0.8)
		// }
	}
//
//	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//		if indexPath.section == 1 && kind == UICollectionElementKindSectionHeader {
//			let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! HomeCollectionHeaderView
//			// headView.frame = CGRect.init(x: 10, y: 10, width: ScreenWidth, height: <#T##CGFloat#>)
//			return headView
//		}
//
//		let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", forIndexPath: indexPath) as! HomeCollectionFooterView
//
//		if indexPath.section == 1 && kind == UICollectionElementKindSectionFooter {
//			footerView.showLabel()
//			footerView.tag = 100
//		} else {
//			footerView.hideLabel()
//			footerView.tag = 1
//		}
//		let tap = UITapGestureRecognizer(target: self, action: "moreGoodsClick:")
//		footerView.addGestureRecognizer(tap)
//
//		return footerView
//	}

	// MARK: 查看更多商品被点击
	func moreGoodsClick(tap: UITapGestureRecognizer) {
		if tap.view?.tag == 100 {
			let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController
			tabBarController.setSelectIndex(from: 0, to: 1)
		}
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		collectionView.deselectItemAtIndexPath(indexPath, animated: true)
		let vc = ProductsViewController()
		vc.curID = curID
		vc.brandId = brand_Data[indexPath.row].brandId
		vc.isViewBrand = true
		vc.titlename = brand_Data[indexPath.row].name
		self.navigationController?.pushViewController(vc, animated: true)
	}

}