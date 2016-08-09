//
//  MyConstants.swift
//  AppPayDemo
//
//  Created by Leon King on 1/29/16.
//  Copyright © 2016 QinYejun. All rights reserved.
//

import Foundation

let WXPaySuccessNotification = "WeixinPaySuccessNotification"

let WX_APPID = "wxfdf3999c0206cbba"
let WX_MCH_ID = "1336327901"
let WX_APP_SECRET = "d6daf2c5af70d061e6bdbb52db53bd3e"

let AppScheme: String = "brnmall"
let AlipayPartner: String = "2088221484266786"
let AlipaySeller: String = "qtb2016@163.com"

let AlipayPrivateKey: String = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALm2jbSa1rCpgyfsPTdkQsR1mMmG9WqSq2rhJn4LXu/s7tpSHSTmr00od93LjQA6JGykK80tcVq1fFnz0XRkpsDb8YP1y4QbE28Cgh9yiuFQx/W5HRfBHa/CQOqmF+PdHpanMsJCWEV71StTthClf6VctDOmgqKpb4rldfApDoahAgMBAAECgYEAihNWbE8rDBIcN5SHNyXOFm8wd7VlxiTiWgaoLdKadVv9gkjG7matM3rBFCCA5whTiIrPHi+JNd31ZJPIyPcEmt1ZOw9WUeqjQ4bYqWdYl/UHuwFhUQIC2RsW59NuzISn+3i9NpKPLVjVhKKU0iOdNwiwCsIqg0lpJXVaKz6GkCECQQDylDHwn7A+xZ/vt8skeFaDW0B9ReiBb2craOqweOgkTM4Ri/fRHHOkzcNBKVeCV/VCUXfbEGsM93/uKx1ItXS9AkEAw/zuRxxKYf+JL5Sfei8Vuipkt7bvLRU2I1JWLHUm+YNSU6NpMcSsRlU1Z1Q4JF3niCo0cYZXqQNMHICL8gtBtQJATSIwSwoL+bnPZGM11g/punT+qZbcGqQ40wXWcmzPrBM8BzpRf42jfAjtiD/EEq8zTnYnPWIYGBRu+mV9N0xzpQJAW2O2OLKYfNoLvoQvWWpbV1QtYv2Kyhr6A76BMHnwkqkJ2rZ4dxyeuK1DGcvL4ilnrbcAfW+HsOg4tZG7sEJPgQJBAOLf+Z62TNA94PFxq2MgsvwWXebDEdR+nEZqeUlOU7Rb0emZAmvnHcIDvPRNsoL8R+tIdR00iAcKB8N2Fo8fAlc="

//支付宝公钥,验证支付宝返回的信息

let AlipayPublicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB"
let AlipayNotifyURL: String = BaseIP + "/Alipay/Notify"
let WxpayNotifyURL: String = BaseIP + "/weixin/payresult"
let ServerURL = "http://jsy.nnbetter.com"