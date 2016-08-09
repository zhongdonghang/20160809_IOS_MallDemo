//
//  Double+Extension.swift
//  BrnMall
//
//  Created by luoyp on 16/5/18.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
extension Double {
	func format() -> String {
		return String(format: "%.2f", self)
	}
}