//
//  NSObject+Extension.swift
//  BrnMall
//
//  Created by luoyp on 16/6/14.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation

extension NSObject {
	class var nameOfClass: String {
		return NSStringFromClass(self).componentsSeparatedByString(".").last! as String
	}

}