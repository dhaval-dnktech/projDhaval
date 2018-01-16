//
//  HowToEarnViewController.swift
//  Cubber
//
//  Created by dnk on 02/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class HowToEarnViewController: UIViewController , UIWebViewDelegate, AppNavigationControllerDelegate{

    //MARK:PROPERTIES
    @IBOutlet var _imageView: UIImageView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webviewDecription: UIWebView!
    @IBOutlet var activityIndicatorWeb: UIActivityIndicatorView!
    @IBOutlet var btnShareApp: UIButton!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var dictHowToEarnPage = typeAliasDictionary()
    internal var categoryID :String = ""
    
    //MARK: VIEW METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        self.callHowToEarnService()
        if self.categoryID == "13"{btnShareApp.setTitle("Pay Now", for: .normal)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sendScreenView(name: F_HOWTOEARN)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_HOWTOEARN, stclass: F_HOWTOEARN)
    }
    
    //MARK: APP NAVIGATION DELEGATE
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    
    //MARK: CUSTOM METHODS
    
    fileprivate func callHowToEarnService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_CATEGORY_ID:self.categoryID]
        
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_howToEarnPage, methodType:  METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.dictHowToEarnPage = dict[RES_howtoearn_result] as! typeAliasDictionary
            self.obj_AppDelegate.navigationController.setCustomTitle((self.dictHowToEarnPage[RES_operatorCategoryName] as? String)!)
            self.setHowToEarnPageData()
            
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.FAILURE); return;

        }) {
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)
            self._KDAlertView.didClick(completion: { (isClicked) in
                self.obj_AppDelegate.navigationController.popViewController(animated: true)
            })
        }
    }
    
    fileprivate func setHowToEarnPageData() {
        
        _imageView.sd_setImage(with: (dictHowToEarnPage[RES_banner] as! String).convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
            { (receivedSize, expectedSize) in self.activityIndicator.startAnimating() ; self.activityIndicator.isHidden = false })
        { (image, error, cacheType, imageURL) in
            
            if image == nil { self._imageView.image = UIImage(named: "logo") }
            else { self._imageView.image = image! }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
        }
      webviewDecription.loadHTMLString(dictHowToEarnPage[RES_description] as! String, baseURL: nil)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    @IBAction func btnInviteFriendAction() {
       self.navigationController?.viewControllers.last?.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_SHARE_APP)", action: "Share App", label: "Share App performed", value: nil)
        if self.categoryID == "13" {
            obj_AppDelegate.jumpToPayMemberShipFeesPage()   
        }
        else {
            let inviteFriendsVC = InviteFriendViewController(nibName: "InviteFriendViewController", bundle: nil)
            self.navigationController?.pushViewController(inviteFriendsVC, animated: true)
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
         activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
    }
}
