import Foundation
import Alamofire

let manager: Manager = {
	// var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
	// defaultHeaders["User-Agent"] = "MyUserAgentString"
	let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
	// configuration.HTTPAdditionalHeaders = defaultHeaders
	configuration.timeoutIntervalForRequest = 20
	let manager = Manager(configuration: configuration)

	return manager
}()

enum APIRouter: URLRequestConvertible
{
	// 登录
	case login(String, String)

	// 注册
	case registNewUser(String, String, String, String)

	// 商品评论
	case getProductComment(String, String, String)

	// 获取1级列表
	case getCategoryLay1

	// 根据一级目录ID获取商品
	case getProductListByCategoryID(id: String, pageIndex: String, pageSize: String)
	// 根据品牌ID获取商品
	case getProductListByBrandID(id: String, pageIndex: String, pageSize: String, brandId: String)
	// 根据一级目录ID获取品牌
	case getBrandByCategoryID(id: String)

	// 根据id获取商品详细信息
	case getProductByID(id: String)

	// 加入购物车
	case AddProductToCart(uid: String, pid: String, count: String)

	// 获取购物车
	case GetShopCart(uid: String)

	// 获取商品收藏列表
	case FavoriteProductList(uid: String)
	case FavoriteStoreList(uid: String)
	// 删除收藏的商品
	case deleteFavoritetProduct(uid: String, pid: String)

	// 删除收藏的店铺
	case deleteFavoritetStore(uid: String, storeid: String)

	// 添加收藏的商品
	case addFavoritetProduct(uid: String, pid: String)

	// 删除购物车商品
	case deleteCartProduct(uid: String, pid: String)

	// 获取地址列表
	case MyAddressList(uid: String)

	// 提交地址信息
	case saveAddress(address: Address)
	// 商品搜索
	case MallSearch(String, String)

	// 删除地址
	case deleteAddress(uid: String, aid: String)

	// 订单列表
	case GetMyOrderList(uid: String, pageIndex: String, pageSize: String, state: String)

	// 订单详情
	case OrderDetail(uid: String, oid: String)

	// 评价订单
	case ReviewOrder(String, String, String, String, String, String, String, String)
	// 获取广告图片
	case getAdByID(adId: String)

	// 根据省份id获取市级
	case getCityByID(Id: String)

	// 根据市级id获取县级
	case getCountryByID(Id: String)

	// 获取用户等级
	case getUserLevel(Id: String)

	// 获取店铺信息
	case GetStoreInfo(Id: String)
	// 获取店铺商品
	case GetStoreGoods(Id: String)
	// 取消订单
	case CancelOrder(uid: String, oid: String)

	// 重置密码
	case resetPwd(String, String, String)

	case UserPayPasswordEdit(String, String, String)

	// 获取验证码
	case getPhoneVerifyCode(String, String)
	// 生成订单
	case CreateOrder(uid: String, said: String, productList: String, payname: String, remark: String, String)

	// 获取用户信息
	case getUserInfo(String)

	case GetPayPluginList(String)

	// 获取关系人信息
	case GetIntroducers(String)

	// 资金记录
	case payCreditList(String, String)

	// 提现记录
	case withdrawlList(String, String)

	// 更新头像
	case updateAvatar(String, String)
	// 提现申请
	case withdrawlApply(String, String, String, String, String, String)

	// 更新头像
	case getShipFreeAmount(String, String, String, String)

	case CreditPayOrder(String, String, String)

	// 确认收货
	case OrderReceive(String, String)
	case UserEdit(String, String, String, String, String, String, String, String, String)
	var URLRequest: NSMutableURLRequest {

		var path: String {
			switch self {

			case .login:
				return "Login"

			case .GetPayPluginList:
				return "GetPayPluginList"

			case .registNewUser:
				return "Register"

			case .CreditPayOrder:
				return "CreditPayOrder"

			case .getCategoryLay1:
				return "GetCategoryLay1"

			case .getProductListByCategoryID:
				return "GetProductListByCateId"

			case .getProductListByBrandID:
				return "GetProductListByCateId"

			case .getProductByID:
				return "Product"

			case .AddProductToCart:
				return "AddProductToCart"

			case .GetShopCart:
				return "GetMyCart"

			case .MyAddressList:
				return "MyShipAddressList"

			case .saveAddress:
				return "EditShipAddress"

			case deleteAddress:
				return "DeleteShipAddress"

			case .deleteCartProduct:
				return "DeleteCartProduct"

			case .deleteFavoritetStore:
				return "DeleteFavoriteStore"

			case .UserPayPasswordEdit:
				return "UserPayPasswordEdit"

			case .GetMyOrderList:
				return "GetMyOrderList"

			case .OrderDetail:
				return "OrderDetail"

			case .CancelOrder:
				return "OrderCancel"

			case .ReviewOrder:
				return "ReviewOrder"

			case .CreateOrder:
				return "OrderCreateNew"

			case .FavoriteProductList:
				return "FavoriteProductList"
			case .FavoriteStoreList:
				return "FavoriteStoreList"
			case .deleteFavoritetProduct:
				return "DeleteFavoriteProduct"

			case .addFavoritetProduct:
				return "AddProductToFavorite"

			case .getAdByID:
				return "GetAdvertList"

			case .getCityByID:
				return "tool/citylist"

			case .getCountryByID:
				return "tool/countylist"
			case .getUserLevel:
				return "GetUserRank"

			case .GetStoreInfo:
				return "GetStoreInfo"
			case .GetStoreGoods:
				return "StoreProductSearch"
			case .resetPwd:
				return "ReSetPassword"
			case .getPhoneVerifyCode:
				return "SendPhoneVerifyCode"
			case .getBrandByCategoryID:
				return "GetCateBrandList"

			case .getProductComment:
				return "ProductReviewList"
			case .MallSearch:
				return "MallSearch"
			case .getUserInfo:
				return "GetUserById"
			case .updateAvatar:
				return "UserAvatarEdit"

			case .UserEdit:
				return "UserEdit"
			case .GetIntroducers:
				return "GetIntroducers"
			case .payCreditList:
				return "PayCreditList"
			case .withdrawlList:
				return "WithdrawlList"
			case .withdrawlApply:
				return "WithdrawlApply"
			case .getShipFreeAmount:
				return "GetShipFreeAmount"
			case OrderReceive:
				return "OrderReceive"
			}
		}

		var parameters: [String: AnyObject] {
			switch self {

			case .MallSearch(let keyword, let index):
				let params = ["keyword": keyword, "uid": "", "cateid": "", "brandid": "", "filterprice": "", "sortcolumn": "", "sortdirection": "", "pagenumber": index, "pagesize": "10", "type": "1"]
				return params

			case .login(let userName, let password):
				let params = ["accountName": userName, "password": password, "returnUrl": ""]
				return params

			case .CreditPayOrder(let uid, let psw, let oidList):
				let params = ["uid": uid, "psw": psw, "oidList": oidList]
				return params

			case .UserPayPasswordEdit(let uid, let psw, let psw2):
				let params = ["uid": uid, "password": psw, "confirmpwd": psw2]
				return params

			case .registNewUser(let name, let pwd1, let pwd2, let introducePhone):
				let params = ["accountName": name, "password": pwd1, "confirmPwd": pwd2, "introduceName": introducePhone]
				return params

			case .ReviewOrder(let oid, let uid, let stars, let messages, let opids, let descriptionStar, let serviceStar, let shipStar):
				let params = ["oid": oid, "uid": uid, "stars": stars, "messages": messages, "opids": opids, "descriptionStar": descriptionStar, "serviceStar": serviceStar, "shipStar": shipStar]
				return params

			case .getCategoryLay1:
				return [:]

			case .getProductListByCategoryID(let id, let pageIndex, let pageSize):
				let params = ["cateId": id, "pageNumber": pageIndex, "pageSize": pageSize, "brandid": "", "filterprice": "", "onlystock": "", "sortcolumn": "", "sortdirection": ""]
				return params
			case .getProductListByBrandID(let id, let pageIndex, let pageSize, let brandId):
				let params = ["cateId": id, "pageNumber": pageIndex, "pageSize": pageSize, "brandid": brandId, "filterprice": "", "onlystock": "", "sortcolumn": "", "sortdirection": ""]
				return params
			case .getProductByID(let pid):
				let params = ["pid": pid]
				return params

			case .GetPayPluginList(let uid):
				let params = ["uid": uid]
				return params

			case .AddProductToCart(let uid, let pid, let count):
				let params = ["uid": uid, "pid": pid, "count": count]
				return params

			case .GetShopCart(let uid):
				let params = ["uid": uid]
				return params

			case .MyAddressList(let uid):
				let params = ["uid": uid]
				return params

			case .GetIntroducers(let uid):
				let params = ["uid": uid]
				return params

			case .saveAddress(let address):
				let params = ["uid": address.uid, "aid": address.aid, "name": address.name, "regionId": address.regionId, "address": address.address, "mobile": address.mobile, "phone": "", "zipcode": "", "email": address.email, "isDefault": "0"]
				return params

			case .deleteAddress(let uid, let aid):
				let params = ["uid": uid, "saId": aid]
				return params

			case .deleteCartProduct(let uid, let pid):
				let params = ["uid": uid, "pid": pid]
				return params

			case .deleteFavoritetStore(let uid, let storeId):
				let params = ["uid": uid, "storeId": storeId]
				return params

			case .deleteFavoritetProduct(let uid, let pid):
				let params = ["uid": uid, "pid": pid]
				return params

			case .addFavoritetProduct(let uid, let pid):
				let params = ["uid": uid, "pid": pid]
				return params

			case .GetMyOrderList(let uid, let pageIndex, let pageSize, let state):
				let params = ["uid": uid, "pageNumber": pageIndex, "pageSize": pageSize, "state": state]
				return params

			case .OrderDetail(let uid, let oid):
				let params = ["uid": uid, "oid": oid]
				return params

			case .CancelOrder(let uid, let oid):
				let params = ["uid": uid, "oid": oid]
				return params

			case .CreateOrder(let uid, let said, let list, let payname, let remark, let shipmode):
				let params = ["uid": uid, "saId": said, "selectedCartItemKeyList": list, "payName": payname, "buyerRemark": remark, "paycreditcount": "", "couponidlist": "", "couponsnlist": "", "fullcut": "", "bestTime": "", "ip": "", "shipmode": shipmode]
				return params

			case .FavoriteProductList(let uid):
				let params = ["uid": uid]
				return params

			case .FavoriteStoreList(let uid):
				let params = ["uid": uid]
				return params

			case .getUserLevel(let uid):
				let params = ["uid": uid]
				return params

			case .getUserInfo(let uid):
				let params = ["uid": uid]
				return params

			case .getCityByID(let id):
				let params = ["provinceId": id]
				return params

			case .getCountryByID(let id):
				let params = ["cityId": id]
				return params

			case .getAdByID(let adid):
				let params = ["adPosId": adid]
				return params
			case .GetStoreInfo(let id):
				let params = ["storeId": id]
				return params

			case .GetStoreGoods(let id):
				let params = ["storeId": id, "pageSize": "150", "pageNumber": "1", "storecid": "", "keyword": "", "sortcolumn": "", "sortdirection": ""]
				return params
			case .resetPwd(let username, let p1, let p2):
				let params = ["userName": username, "password": p1, "confirmPwd": p2]
				return params
			case .getPhoneVerifyCode(let phone, let type):
				let params = ["phoneNumber": phone, "type": type]
				return params
			case .getBrandByCategoryID(let id):
				let params = ["cateId": id]
				return params

			case .getProductComment(let id, let index, let pagesize):
				let params = ["pid": id, "pageNumber": index, "pageSize": pagesize]
				return params

			case .updateAvatar(let uid, let base64Str):
				let params = ["uid": uid, "avatar": base64Str]
				return params

			case .UserEdit(let uid, let nickName, let realName, let gender, let idCard, let birthDay, let regionId, let bio, let address):
				let params = ["uid": uid, "nickName": nickName, "realName": realName, "gender": gender, "idCard": idCard, "birthDay": "", "regionId": regionId, "bio": bio, "address": address]
				return params
			case .payCreditList(let uid, let pageNumber):
				let params = ["uid": uid, "pageSize": "10", "pageNumber": pageNumber]
				return params
			case .withdrawlList(let uid, let pageNumber):
				let params = ["uid": uid, "pageSize": "10", "pageNumber": pageNumber]
				return params
			case .withdrawlApply(let uid, let applyAmount, let payAccount, let amountRemark, let payType, let phone):
				let params = ["uid": uid, "applyAmount": applyAmount, "payAccount": payAccount, "amountRemark": amountRemark, "payType": payType, "phone": phone]
				return params
			case .getShipFreeAmount(let uid, let saId, let selectedCartItemKeyList, let shipmode):
				let params = ["uid": uid, "saId": saId, "selectedCartItemKeyList": selectedCartItemKeyList, "shipmode": shipmode]
				return params
			case .OrderReceive(let uid, let oid):
				let params = ["uid": uid, "oid": oid]
				return params
			}
		}

		let URL = NSURL(string: BaseURL)
		let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
		let encoding = Alamofire.ParameterEncoding.URL

		print("请求接口 : \(encoding.encode(URLRequest, parameters: parameters).0.description)")
		return encoding.encode(URLRequest, parameters: parameters).0
	}
}
