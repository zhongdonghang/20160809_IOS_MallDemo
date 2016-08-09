//
//  GoodsCommentVC.swift
//  BrnMall
//
//  Created by luoyp on 16/5/25.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class GoodsCommentVC: BaseViewController {
	var pid = ""

	var pageIndex: Int = 1
	let pageSize: String = "12"
	var commentTableView: BMTableView?
	private var comment_Data: [CommentModel] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
		navigationController?.navigationBar.barTintColor = BMNavigationBarColor
		buildNavigationItem("商品评价")

		buildProductsTableView()

	}

	// MARK: - Build UI
	private func buildProductsTableView() {
		commentTableView = BMTableView(frame: view.bounds, style: .Plain)
		commentTableView?.backgroundColor = UIColor.clearColor()
		commentTableView?.contentInset = UIEdgeInsetsMake(0, 0, 42, 0)
		commentTableView?.delegate = self
		commentTableView?.dataSource = self
		commentTableView?.rowHeight = UITableViewAutomaticDimension
		// commentTableView?.estimatedRowHeight = 100
		commentTableView?.showsVerticalScrollIndicator = false
		commentTableView?.mj_header = MJRefreshStateHeader.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.headRefresh))
		commentTableView?.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.footRefresh))
		view.addSubview(commentTableView!)

		headRefresh()

	}
	var isFootRefresh = false
	func footRefresh() {

		commentTableView?.mj_footer.endRefreshing()
		isFootRefresh = true
		getProductCommentById()
	}
	func headRefresh() {

		commentTableView?.mj_header.endRefreshing()
		self.pageIndex = 1
		comment_Data.removeAll()

		ProgressHUDManager.showWithStatus(Loading)
		getProductCommentById()
	}

	func getProductCommentById() {

		manager.request(APIRouter.getProductComment(pid, "\(pageIndex)", "15")).responseJSON(completionHandler: {
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
					let jsonArray = json["data"].arrayValue

					if jsonArray.count == 0 {
						if !self.isFootRefresh {
							ProgressHUDManager.showInfoStatus("暂时没有评论")
						}
						self.isFootRefresh = false
						break
					}

					for obj in jsonArray {
						let NickName = obj["NickName"].stringValue
						let ReviewTime = obj["ReviewTime"].stringValue
						let Content = obj["Content"].stringValue
						let UserImg = obj["UserImg"].stringValue
						let Star = obj["Star"].stringValue

						self.comment_Data.append(CommentModel.init(NickName: NickName, ReviewTime: ReviewTime, Content: Content, UserImg: userImgUrl + UserImg, Star: Star))
					}
					SVProgressHUD.dismiss()
					self.pageIndex += 1
					self.commentTableView?.reloadData()
				}
			}
		})
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GoodsCommentVC: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comment_Data.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = CommentCell.cellWithTableView(tableView)

		cell.comment = comment_Data[indexPath.row]
		return cell
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		return 105
	}
//	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		return 80
//	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

