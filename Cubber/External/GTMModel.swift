//
//  GTMModel.swift
//  Cubber
//
//  Created by dnk on 23/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class GTMModel: NSObject {
    
    var ee_type: String = ""
    var ecommerce: String = ""
    var currencyCode: String = "INR"
    var detail: String = ""
    var actionField: String = ""
    var list: String = ""
    var products: String = ""
    var name: String = ""
    var id: String = ""
    var product_Id: String = ""
    var price: String = ""
    var brand: String = ""
    var variant: String = ""
    var category: String = ""
    var quantity: Int = 1
    var dimension3: String = ""
    var dimension4: String = ""
    var dimension5: String = ""
    var dimension6: String = ""
    var dimension7: String = ""
    var dimension10: String = ""
    var dimension11: String = ""
    var dimension12: String = ""
    var checkout: String = ""
    var step: Int = 1
    var option: String = ""
    var usedwallet: String = ""
    var cashback: String = ""
    var coupon:String = ""
    var impressions = [typeAliasDictionary]()
    var position:Int = 0
    var affiliation :String = ""
    var revenue:String = ""
    var tax:String = "0"
    var shipping:String = "0"
    var payment_method:String = ""
    var order_type :String = ""
    var user_type:String = ""
    var refundAmount:String = "10"
    
    
    override init() {
        super.init()
        
    }
    
    class func pushAddToCart(gtmModel:GTMModel) {
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "addToCart", "ee_type_dl" : gtmModel.ee_type , "ecommerce": ["currencyCode": gtmModel.currencyCode, "add": ["products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "dimension3":gtmModel.dimension3 , "dimension4":gtmModel.dimension4]]]]])
    }
    
    class func pushAddToCartBus(gtmModel:GTMModel) {
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "addToCart", "ee_type_dl" : gtmModel.ee_type , "ecommerce": ["currencyCode": gtmModel.currencyCode, "add": ["products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "dimension5":gtmModel.dimension5 , "dimension6":gtmModel.dimension6]]]]])
    }
    
    class func pushProductDetail(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "productdetail" ,"ee_type_dl" : gtmModel.ee_type, "ecommerce": ["currencyCode": gtmModel.currencyCode , "detail": ["actionField": ["list": gtmModel.list],                                                                                                                                                                    "products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "dimension3":gtmModel.dimension3 , "dimension4":gtmModel.dimension4]]]]])
    }
    
    class func pushProductDetailBus(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "productdetail" ,"ee_type_dl" : gtmModel.ee_type, "ecommerce": ["currencyCode": gtmModel.currencyCode , "detail": ["actionField": ["list": "Bus Section"],"products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "dimension5":gtmModel.dimension5 , "dimension6":gtmModel.dimension6]]]]])
    }
    
    class func pushProductDetailFlight(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "productdetail" ,"ee_type_dl" : gtmModel.ee_type, "ecommerce": ["currencyCode": gtmModel.currencyCode , "detail": ["actionField": ["list": "Flight Section"],"products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "dimension5":gtmModel.dimension5 , "dimension6":gtmModel.dimension6]]]]])
    }
    
    class func pushCheckout(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "checkout","ee_type_dl" : gtmModel.ee_type, "ecommerce": ["checkout": ["actionField": ["step": gtmModel.step, "option": gtmModel.option], "products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "quantity" : gtmModel.quantity , "dimension3":gtmModel.dimension3 , "dimension4":gtmModel.dimension4 ,"dimension10":gtmModel.dimension10 , "dimension11":gtmModel.dimension11 , "dimension12":gtmModel.dimension12 ]]]]])
    }
    
    class func pushCheckoutWallet(gtmModel:GTMModel) {

        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "checkout","ee_type_dl" : gtmModel.ee_type, "ecommerce": ["checkout": ["actionField": ["step": gtmModel.step, "option": gtmModel.option], "products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "quantity" : 1 , "dimension10":gtmModel.dimension10 , "dimension11":gtmModel.dimension11 , "dimension12":gtmModel.dimension12 ]]]]])
    }
    
    class func pushCheckoutBus(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "checkout","ee_type_dl" : gtmModel.ee_type, "ecommerce": ["checkout": ["actionField": ["step": gtmModel.step, "option": gtmModel.option], "products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant, "quantity" : gtmModel.quantity ,"dimension5":gtmModel.dimension5 , "dimension6":gtmModel.dimension6, "dimension10":gtmModel.dimension10 , "dimension11":gtmModel.dimension11 , "dimension12":gtmModel.dimension12 ]]]]])
    }
    
    class func pushProductImpressions(impressions:[typeAliasStringDictionary]) {
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event" :"productimpression" ,"ee_type_dl" : GTM_BUS, "ecommerce": ["currencyCode": "INR","impressions": impressions]])
    }
    
    class func pushProductClick(gtmModel:GTMModel) {
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "productClick","ee_type_dl" : GTM_BUS, "ecommerce": ["click": ["actionField": ["list": "Search Results"],"products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant,"list":"Bus Section" , "position":gtmModel.position, "dimension5":gtmModel.dimension5 , "dimension6":gtmModel.dimension6]]]]])
    }
    
    class func pushCheckOut_Complete(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "checkout-complete","ee_type_dl" : gtmModel.ee_type, "ecommerce": ["purchase": ["actionField": ["id": gtmModel.id,"affiliation": gtmModel.affiliation, "revenue": gtmModel.revenue,"tax": gtmModel.tax, "shipping": gtmModel.shipping, "coupon": gtmModel.coupon], "products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant,"quantity":gtmModel.quantity ,"dimension3":gtmModel.dimension3 ,"coupon": gtmModel.coupon, "dimension4":gtmModel.dimension4 ,"dimension10":gtmModel.dimension10 , "dimension11":gtmModel.dimension11 , "dimension12":gtmModel.dimension12 , "payment_method" :gtmModel.payment_method,  "order_type" : gtmModel.order_type , "user_type": gtmModel.user_type ]]]] , "payment_method" :gtmModel.payment_method,  "order_type" : gtmModel.order_type , "user_type": gtmModel.user_type ])
    }
    
    class func pushCheckOut_CompleteBus(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "checkout-complete","ee_type_dl" : gtmModel.ee_type, "ecommerce": ["purchase": ["actionField": ["id": gtmModel.id,"affiliation": gtmModel.affiliation, "revenue": gtmModel.revenue,"tax": gtmModel.tax, "shipping": gtmModel.shipping, "coupon": gtmModel.coupon], "products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant,"coupon": gtmModel.coupon, "quantity":gtmModel.quantity ,"dimension5":gtmModel.dimension5 , "dimension6":gtmModel.dimension6 ,"dimension10":gtmModel.dimension10 , "dimension11":gtmModel.dimension11 , "dimension12":gtmModel.dimension12 , "payment_method" :gtmModel.payment_method,  "order_type" : gtmModel.order_type , "user_type": gtmModel.user_type ]]]] , "payment_method" :gtmModel.payment_method,  "order_type" : gtmModel.order_type , "user_type": gtmModel.user_type ])
        
    }
    
    class func pushCheckOut_CompleteFlight(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event": "checkout-complete","ee_type_dl" : gtmModel.ee_type, "ecommerce": ["purchase": ["actionField": ["id": gtmModel.id,"affiliation": gtmModel.affiliation, "revenue": gtmModel.revenue,"tax": gtmModel.tax, "shipping": gtmModel.shipping, "coupon": gtmModel.coupon], "products": [["name": gtmModel.name, "id": gtmModel.product_Id, "price": gtmModel.price, "brand": gtmModel.brand, "category": gtmModel.category, "variant": gtmModel.variant,"coupon": gtmModel.coupon, "quantity":gtmModel.quantity ,"dimension5":gtmModel.dimension5 , "dimension6":gtmModel.dimension6 ,"dimension10":gtmModel.dimension10 , "dimension11":gtmModel.dimension11 , "dimension12":gtmModel.dimension12 ,"payment_method" :gtmModel.payment_method,  "order_type" : gtmModel.order_type , "user_type": gtmModel.user_type
            ]]]] , "payment_method" :gtmModel.payment_method,  "order_type" : gtmModel.order_type , "user_type": gtmModel.user_type ])
    }
    
    class func pushRefund(gtmModel:GTMModel) {
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event":"refund","ecommerce": ["refund": ["actionField": ["id": "\(gtmModel.id)"]]]])
    }
    
    class func pushPartialRefund(gtmModel:GTMModel){
        
        if !DataModel.getIsAllowGTM(){return}
        TAGManager.instance().dataLayer.push(["ecommerce":NSNull()])
        TAGManager.instance().dataLayer.push(["event":"refund","ecommerce": ["refund": ["actionField": ["id": "\(gtmModel.id)"], "products": [["price":gtmModel.price,"quantity":gtmModel.quantity ,"id":gtmModel.product_Id]]]]])
    }
}
