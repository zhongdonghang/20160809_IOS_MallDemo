//
//  PageScrollView.swift
//  BrnMall
//
//  Created by luoyp on 16/4/19.
//  Copyright © 2016年 luoyp. All rights reserved.
//
import Kingfisher

class PageScrollView: UIView {

	private var imageViewMaxCount = 15
	private var imageScrollView: UIScrollView!
	private var pageControl: UIPageControl!
	private var timer: NSTimer?
	private var placeholderImage: UIImage?
	private var imageClick: ((index: Int) -> ())?
	var headData: [HeadResources]? {
		didSet {

			if timer != nil {
				timer!.invalidate()
				timer = nil
			}

			if headData?.count >= 0 {

				pageControl.numberOfPages = (headData?.count)!
				imageViewMaxCount = (headData?.count)!
				// pageControl.numberOfPages = 3
				pageControl.currentPage = 0
				updatePageScrollView()

				startTimer()
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		buildImageScrollView()

		buildPageControl()
	}

	convenience init(frame: CGRect, placeholder: UIImage, focusImageViewClick: ((index: Int) -> Void)) {
		self.init(frame: frame)
		placeholderImage = placeholder
		imageClick = focusImageViewClick
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		imageScrollView.frame = bounds
		imageScrollView.contentSize = CGSizeMake(CGFloat(imageViewMaxCount) * width, 0)
		if imageViewMaxCount == 1 {
			let imageView = imageScrollView.subviews[0] as! UIImageView
			imageView.userInteractionEnabled = true
			imageView.frame = CGRectMake(CGFloat(0) * imageScrollView.width, 0, imageScrollView.width, imageScrollView.height)
		}
		else {
			for i in 0 ... imageViewMaxCount - 1 {
				let imageView = imageScrollView.subviews[i] as! UIImageView
				imageView.userInteractionEnabled = true
				imageView.frame = CGRectMake(CGFloat(i) * imageScrollView.width, 0, imageScrollView.width, imageScrollView.height)
			}
		}
		let pageW: CGFloat = 80
		let pageH: CGFloat = 20
		let pageX: CGFloat = imageScrollView.width - pageW
		let pageY: CGFloat = imageScrollView.height - pageH
		pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH)

		updatePageScrollView()
	}

	// MARK: BuildUI
	private func buildImageScrollView() {
		imageScrollView = UIScrollView()
		imageScrollView.bounces = false
		imageScrollView.showsHorizontalScrollIndicator = false
		imageScrollView.showsVerticalScrollIndicator = false
		imageScrollView.pagingEnabled = true
		imageScrollView.delegate = self
		addSubview(imageScrollView)

		for _ in 0 ..< imageViewMaxCount {
			let imageView = UIImageView()
			let tap = UITapGestureRecognizer(target: self, action: "imageViewClick:")
			imageView.addGestureRecognizer(tap)
			imageScrollView.addSubview(imageView)
		}
	}

	private func buildPageControl() {
		pageControl = UIPageControl()
		pageControl.hidesForSinglePage = true
		pageControl.pageIndicatorTintColor = UIColor.init(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.0)
		pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
		addSubview(pageControl)
	}

	// MARK: 更新内容
	private func updatePageScrollView() {
		for var i = 0; i < imageScrollView.subviews.count; i++ {
			let imageView = imageScrollView.subviews[i] as! UIImageView
			var index = pageControl.currentPage

			if i == 0 {
				index--
			} else if 2 == i {
				index++
			}

			if index < 0 {
				index = self.pageControl.numberOfPages - 1
			} else if index >= pageControl.numberOfPages {
				index = 0
			}

			imageView.tag = index
			if headData?.count > 0 {
				// if true {
				// print("滚动图片 \(headData![index].img)")
				imageView.kf_setImageWithURL(NSURL.init(string: headData![index].img)!, placeholderImage: Image.init(named: "goodsdefault"), optionsInfo: [.Transition(.Fade(1))])
			}
		}

		imageScrollView.contentOffset = CGPointMake(imageScrollView.width, 0)
	}

	// MARK: Timer
	private func startTimer() {
		timer = NSTimer(timeInterval: 6.0, target: self, selector: "next", userInfo: nil, repeats: true)
		NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	func next() {
		imageScrollView.setContentOffset(CGPointMake(2.0 * imageScrollView.frame.size.width, 0), animated: true)
	}

	// MARK: ACTION
	func imageViewClick(tap: UITapGestureRecognizer) {
		if imageClick != nil {
			imageClick!(index: tap.view!.tag)
		}
	}
}

// MARK:- UIScrollViewDelegate
extension PageScrollView: UIScrollViewDelegate {

	func scrollViewDidScroll(scrollView: UIScrollView) {
		var page: Int = 0
		var minDistance: CGFloat = CGFloat(MAXFLOAT)
		for i in 0 ..< imageScrollView.subviews.count {
			let imageView = imageScrollView.subviews[i] as! UIImageView
			let distance: CGFloat = abs(imageView.x - scrollView.contentOffset.x)

			if distance < minDistance {
				minDistance = distance
				page = imageView.tag
			}
		}
		pageControl.currentPage = page
	}

	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		stopTimer()
	}

	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		startTimer()
	}

	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		updatePageScrollView()
	}

	func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
		updatePageScrollView()
	}
}
