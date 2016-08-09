//
//  File.swift
//  BrnMall
//
//  Created by luoyp on 16/4/21.
//  Copyright © 2016年 luoyp. All rights reserved.
//

import Foundation
import CryptoSwift

class WXPayUtils{
    static var xiadanUrl = "https://api.mch.weixin.qq.com/pay/unifiedorder";
   static var appid = "";// 公众账号ID
	static var mch_id = "";// 商户号
	static var nonce_str = "";// 随机字符串
	static var sign = "";// 签名
	static var body = "";// 商品描述
	static var out_trade_no = "";// 商户订单号
	static var total_fee: Int = 0;// 总金额 单位为分
	static var spbill_create_ip = "";// 终端IP
	static var notify_url = "";// 通知地址
	static var trade_type = "JSAPI";// 交易类型

    ///获取随机数 包括from  包括to
    static func getRandomNum(from:Int,to:Int) -> Int{
        let result = Int(from + (Int(arc4random()) % (to - from + 1)));
        return result;
    }

    static func getSign(dic:Dictionary<String,String>,key:String) -> String{
        var sign = "";
        let dicNew = dic.sort { (a, b) -> Bool in
            return a.0 < b.0;
        }

        sign = getQueryStrByDic(dicNew);
        sign += "&key=\(key)";
        sign = sign.md5().uppercaseString;
        return sign;
    }

    static func getQueryStrByDic(dic:[(String,String)])->String{
        var pars = "";
        for (index, element) in dic.enumerate() {
            if(index == 0){
                pars += "\(element.0)=\(element.1)";
            }else{
                pars += "&\(element.0)=\(element.1)";
            }
        }
        return pars;
    }

}