//
//  PaymentViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 05/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UIWebViewDelegate, AppNavigationControllerDelegate, KDAlertViewDelegate {

    //MARK: PROPERTIES
    @IBOutlet var _webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK: VARIABLES
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
    internal var orderId: String = ""
    internal var dictOrderInfo = typeAliasDictionary()
    internal var eventVenue = "Not Defined"
    internal var _RECHARGE_TYPE: RECHARGE_TYPE = .DUMMY
    internal var paymentUrl: URL!
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        _KDAlertView.alertDelegate = self
        if self.orderId.count == 0 {
            let _ = self.navigationController?.popViewController(animated: true)
            _KDAlertView.showMessage(message: MSG_ERR_SOMETING_WRONG, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        let params:typeAliasStringDictionary = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID:dictUserInfo[RES_userID]! as! String,
                      REQ_ORDER_ID:self.orderId,
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_RANDOM:DataModel.generateRandomDigits(6)]
        
        var stJson = params.convertToJSonString()
        stJson = DataModel.encrypt(key: KEY_FOR_PAYU, iv: IV_FOR_PAYU, String: stJson.removeSpecialCharsFromString())
        activityIndicator.startAnimating()
        let stPaymentUrl: String = "\(JPaymentGateway)?details=\(stJson)"
        paymentUrl = URL(string: stPaymentUrl)
        print("Payment : \(paymentUrl)")
        
        let theRrequest: URLRequest = URLRequest(url: paymentUrl, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 999999999999999999)
        self._webView.loadRequest(theRrequest)
        self._webView.scrollView.bounces = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: SCREEN_COMPLETEPAYMENT)
        self.SetScreenName(name: F_INVOICE, stclass: F_INVOICE) 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func showOrderDetail(dict:typeAliasDictionary) {

        let dictUser = DataModel.getUserInfo()
        if dictUser[RES_userID]as! String != dict[REQ_USER_ID] as! String{
            obj_AppDelegate.performLogout()
        }
        else{
            DataModel.setUserWalletResponse(dict: typeAliasDictionary())
            DataModel.setUsedWalletResponse(dict: typeAliasDictionary())
        let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
        orderDetailVC.dictOrderDetail = dictOrderInfo
        orderDetailVC.orderId = dict[REQ_ORDER_ID] as! String
        orderDetailVC.isOrderDetailFromOrderHistory = false
        orderDetailVC._RECHARGE_TYPE = self._RECHARGE_TYPE
        orderDetailVC.isShowAppReview = true
        orderDetailVC.eventVenue = self.eventVenue
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Payment Process")
        obj_AppDelegate.navigationController.setOrderCancelButton()
        obj_AppDelegate.navigationController.navigationDelegate = self
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func appNavigationController_BackAction() {
        _KDAlertView.showMessage(message: MSG_QUE_PAYMENT, messageType: MESSAGE_TYPE.PAYMENT)
        return
    }
    
    //MARK: UIWEBVIEW DELEGATE
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        print("\(String(describing: webView.request?.url?.absoluteURL))")
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("URL : \(String(describing: request.url))")
        if (request as NSURLRequest).url?.scheme?.uppercased() == SCHEME_CUBBER && (request as NSURLRequest).url?.host?.uppercased() == HOST_ORDER_DETAIL{
            if self._RECHARGE_TYPE == RECHARGE_TYPE.MEMBERSHIP_FEES {
                dictUserInfo[RES_isMemberFeesPay] = "1" as AnyObject?
                dictUserInfo[RES_memberShipFees] = DataModel.getMemberShipFees() as AnyObject?
                DataModel.setUserInfo(dictUserInfo)
                NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_MEMBERSHIP_FEE_PAID), object: nil) //POST NOTIFICATION
            }
            let dictOrderInfo: typeAliasStringDictionary = (request.url?.getDataFromQueryString())!
            print(dictOrderInfo)
            
            self.showOrderDetail(dict:dictOrderInfo as typeAliasDictionary
            )
        }
        return true
    }
    
    func loadURL(url: NSURL!) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let muableRequest = NSMutableURLRequest(url: url as URL)
        muableRequest.setValue("WhateverYouWant", forHTTPHeaderField: "x-YourHeaderField")
        
        let task = session.dataTask(with: muableRequest as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                print("We have an error :( \(error)")
                self.loadURL(url: self.paymentUrl as NSURL!)
                return
            }
            
            if let response = response {
                var mimeType = ""
                if response.mimeType != nil {
                    mimeType = response.mimeType!
                }
                
                var encoding = ""
                if response.textEncodingName != nil {
                    encoding = response.textEncodingName!
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status code is \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        self.loadURL(url: self.paymentUrl as NSURL!)
                    }
                }
                
                self._webView.load(data!, mimeType: mimeType, textEncodingName: encoding, baseURL: url as URL)
            }
        }
        task.resume()
    }
    
    
    //MARK: KD ALERT DELEGATE
    func messageYesAction() {
        
        let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
        orderDetailVC.orderId = self.orderId
        orderDetailVC.isOrderDetailFromOrderHistory = false
        orderDetailVC._RECHARGE_TYPE = self._RECHARGE_TYPE
        orderDetailVC.isShowAppReview = true
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func messageNoAction() { }
    func messageOkAction() { }
}
