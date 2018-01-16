//
//  PaymentViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 05/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
//import CryptoSwift

class TreeViewController: UIViewController, UIWebViewDelegate, AppNavigationControllerDelegate, VKToastDelegate , KDAlertViewDelegate{

    //MARK: PROPERTIES
    @IBOutlet var _webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var viewBGWithOutLogin: UIView!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_Operationweb = OperationWeb()
    fileprivate var dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
    fileprivate var _VKSideMenu = VKSideMenu()
    internal var treeUrl: URL!
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !DataModel.getUserInfo().isEmpty {
            activityIndicator.startAnimating()
            var params:typeAliasStringDictionary = [REQ_USER_ID:dictUserInfo[RES_userID] as! String,
                          REQ_HEADER:DataModel.getHeaderToken(),
                          REQ_RANDOM:DataModel.generateRandomDigits(6)]
            
            for(pKey , pValue) in params { params[pKey] = obj_Operationweb.getcodeforkeys(pValue)}
            var stJson = params.convertToJSonString()
            stJson = DataModel.encrypt(key: KEY_FOR_TREE, iv: IV_FOR_TREE, String: stJson.removeSpecialCharsFromString())
            let stTreeUrl: String = "\(JTree)?details=\(stJson)"
            treeUrl = stTreeUrl.convertToUrl() as URL!
            //UIApplication.shared.openURL(treeUrl)
            print(treeUrl)
            let theRrequest: URLRequest = URLRequest(url: treeUrl, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 999999999999999999)
            self._webView.loadRequest(theRrequest)
            self._webView.scrollView.bounces = false
          //  viewBGWithOutLogin.isHidden = true
            _webView.isHidden = false
        }
        else {
             _webView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
         self.setUserProperty(propertyName: F_MemberTree_Tab, PropertyValue:"")
        self.sendScreenView(name: TREEPOSITION)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_TREE_POSITION, stclass: F_TREE_POSITION)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Connects")
        obj_AppDelegate.navigationController.setSideMenuButton()
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_SideMenuAction() {
        _VKSideMenu = VKSideMenu()
        self.navigationController?.view.addSubview(self._VKSideMenu)
    }
    
    //MARK: UIBUTTON ACTION
    
    func performLogout(){
        let _KDAlertView = KDAlertView.init()
        _KDAlertView.showMessage(message: DataModel.getLogoutNote(), messageType: .WARNING)
        _KDAlertView.alertDelegate = self
    }

    
    //MARK: UIWEBVIEW DELEGATE
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("\(webView.request?.url?.absoluteURL)")
        activityIndicator.stopAnimating()
        self.view.bringSubview(toFront: _webView)
        _webView.isUserInteractionEnabled = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        //VKToast.showToast(MSG_TXT_MOBILE_NO, toastType: VKTOAST_TYPE.FAILURE);
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("URL : \(request.url)")
        if (request as NSURLRequest).url?.scheme?.uppercased() == SCHEME_CUBBER && (request as NSURLRequest).url?.host?.uppercased() == "PERFORMLOGOUT"{
            self.performLogout()
        }
        return true
        
    }
    
    //MARK: KD ALERT DELEGATE
    func messageYesAction() {
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        obj_AppDelegate.performLogout()
    }
    
    func messageNoAction() {
        print("Back Action")
    }
    func messageOkAction() {
        print("OK Action")
    }
   
}
