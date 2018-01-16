//
//  NotificationDetailViewController.swift
//  Cubber
//
//  Created by dnk on 19/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class NotificationDetailViewController: UIViewController , UIWebViewDelegate , AppNavigationControllerDelegate{

    //MARK: PROPERTIES
    
    @IBOutlet var viewBg: UIView!
    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var lblNotificationTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var viewOfferDetail: UIView!
    @IBOutlet var webViewRemark: UIWebView!
    @IBOutlet var webViewVideo: UIWebView!
    @IBOutlet var activityIndicatorRemark: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorVideo: UIActivityIndicatorView!
    
    @IBOutlet var btnGet: UIButton!
    @IBOutlet var constraintScrollViewTopToSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintWebViewRemarkHeight: NSLayoutConstraint!
    @IBOutlet var constraintScrollViewTopWebViewVideo: NSLayoutConstraint!
    
    @IBOutlet var constraintImageViewIconHeight: NSLayoutConstraint!
    @IBOutlet var constraintViewBtnGetHeight: NSLayoutConstraint!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    internal var dictNotification = typeAliasDictionary()
    internal var notificationID:String = ""
    internal var couponID:String = ""
    internal var isCoupon:Bool  = false
    var keyTitle = ""
    var keyDesc = ""
    var keyImage = ""
    var isReload = false
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        
        super.viewDidLoad()
        keyTitle =  isCoupon ? RES_couponTitle : RES_notificationTitle
        keyDesc = isCoupon ? RES_couponDescription : RES_notificationDescription
        keyImage = isCoupon ? RES_bigBanner : RES_image
        isReload = true
        self.viewBg.alpha = 0
        if notificationID != "" || couponID != "" {
            if isCoupon { self.callCouponListService() }
            else{ self.callGetNotificationDetailService()}
        }
        else { self.showNotificationDetail() }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.SetScreenName(name: F_NOTIFICATIONDETAIL, stclass: F_NOTIFICATIONDETAIL)
    }
    
    //MARK: NAVIGATION DELEGATE
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        
        self.navigationController?.isNavigationBarHidden = false
        obj_AppDelegate.navigationController.navigationDelegate = self
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOM METHODS
    
    fileprivate func callCouponListService() {
    
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_PAGE_NO:"1",
                      REQ_COUPON_ID:couponID]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_CouponList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
            self.dictNotification = arrData.first!
            self.showNotificationDetail()
            //POST NOTIFICATION
            
        }, onFailure: { (code, dict) in
            
        }) { let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return }

    }
    
    fileprivate func callGetNotificationDetailService() {
    
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_NOTIFICATION_DETAIL_ID:notificationID]
                
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetuserNotificationDetail, methodType:  METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasDictionary> = dict[RES_notification] as! Array<typeAliasDictionary>
            self.dictNotification = arrData.first!
            self.showNotificationDetail()
            
        }, onFailure: { (code, dict) in
            
        }) {  let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return      }

    }
    
    fileprivate func showNotificationDetail(){
        
        obj_AppDelegate.navigationController.setCustomTitle((dictNotification[keyTitle] as? String)!)
        if dictNotification[RES_isExternal] as! String == "0" {
        
            if dictNotification[RES_redirectScreen] as! String == "" || dictNotification[RES_redirectScreen] as! String == "0" {
                btnGet.isHidden = true ; constraintViewBtnGetHeight.constant = 0 ;
            }
            else{ btnGet.isHidden = false ; constraintViewBtnGetHeight.constant = 45 ;}
            
        }
        else if dictNotification[RES_isExternal] as! String == "1" {
            if dictNotification[RES_link] as! String == "" {
                btnGet.isHidden = true; constraintViewBtnGetHeight.constant = 0 ;
            }
            else{ btnGet.isHidden = false ; constraintViewBtnGetHeight.constant = 45 ;}
        }
        else if dictNotification[RES_isExternal] as! String == "2" {
            if dictNotification[RES_link] as! String == "" {
                btnGet.isHidden = true; constraintViewBtnGetHeight.constant = 0 ;
            }
            else{ btnGet.isHidden = false ; constraintViewBtnGetHeight.constant = 45 ;}
        }
        
        if !(dictNotification[RES_button] as! String).isEmpty {
                btnGet.setTitle((dictNotification[RES_button] as! String?), for: .normal)
        }
        
        let stImageUrl: String = dictNotification[keyImage] as! String
        
        if stImageUrl != "" || stImageUrl != "0" {
            imageViewIcon.sd_setImage(with: stImageUrl.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in self.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                if image == nil { self.imageViewIcon.image = UIImage(named: "logo") }
                else { self.imageViewIcon.image = image! }
               self.activityIndicator.stopAnimating()
            }
            constraintImageViewIconHeight.constant = imageViewIcon.frame.width / 1.80
            imageViewIcon.isHidden = false
            activityIndicator.isHidden = true
        }
        else { imageViewIcon.image = UIImage(named: "logo")
              constraintImageViewIconHeight.constant = 0
                imageViewIcon.isHidden = true
                activityIndicator.isHidden = true
        }
        
        lblNotificationTitle.text = dictNotification[keyTitle] as! String?
        let stDesc:String = dictNotification[keyDesc] as! String
        
        if stDesc.characters.count != 0 {
            lblDescription.isHidden = false
            lblDescription.text = dictNotification[keyDesc] as! String?
        }
        else{lblDescription.isHidden = true}
        
        var stRemark:String = dictNotification[RES_remark] as! String
        if stRemark.characters.count != 0 || stRemark != "0" {
            
            viewOfferDetail.isHidden = false
            webViewRemark.loadHTMLString(stRemark, baseURL: nil)
            webViewRemark.scrollView.isScrollEnabled = false
            activityIndicatorRemark.startAnimating()
           
        }
        else{viewOfferDetail.isHidden = true}
        let stVideo = dictNotification[RES_video] as! String
        
        if stVideo.isEmpty || stVideo == "0" {
            
            constraintScrollViewTopWebViewVideo.priority = PRIORITY_LOW
            constraintScrollViewTopToSuper.priority = PRIORITY_HIGH
        
        }
        else{
            
            let request:URLRequest = URLRequest.init(url: stVideo.convertToUrl())
            webViewVideo.loadRequest(request as URLRequest)
            webViewVideo.scrollView.isScrollEnabled = false
            activityIndicatorVideo.startAnimating()
            constraintScrollViewTopWebViewVideo.priority = PRIORITY_HIGH
            constraintScrollViewTopToSuper.priority = PRIORITY_LOW
          
        }
        if isReload { self.viewBg.alpha = 1 }
        isReload = false
    }
    
    @IBAction func btngetAction() {
        
        if dictNotification[RES_isExternal] as! String == "0" {
            if dictNotification[RES_redirectScreen] as! String == "0" {
                let _ = self.navigationController?.popViewController(animated: true)
            }
            else {
               if REDIRECT_SCREEN_TYPE(rawValue: dictNotification[RES_redirectScreen] as! String) != nil {
                    obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue: dictNotification[RES_redirectScreen] as! String)! , dict:dictNotification)
                }
            }
        }
        else if dictNotification[RES_isExternal] as! String == "1" {
            
            let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
            webPreviewVC.isShowToolBar = false
            webPreviewVC.stUrl = dictNotification[RES_link] as! String
            webPreviewVC.stTitle = dictNotification[keyTitle] as! String
            webPreviewVC.isShowSave = false
            self.navigationController?.pushViewController(webPreviewVC, animated: true)
        }
        else if dictNotification[RES_isExternal] as! String == "2" {
            UIApplication.shared.openURL((dictNotification[RES_link] as! String).convertToUrl())
        }
       
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if webView == webViewVideo {
            activityIndicatorVideo.stopAnimating()
            activityIndicatorVideo.isHidden = true
        }
        else if webView == webViewRemark {
            activityIndicatorRemark.stopAnimating()
            activityIndicatorRemark.isHidden = true
            let size:CGSize = webView.sizeThatFits(.zero)
            constraintWebViewRemarkHeight.constant = size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if webView == webViewVideo {
            activityIndicatorVideo.stopAnimating()
            activityIndicatorVideo.isHidden = true
        }
        else if webView == webViewRemark {
            activityIndicatorRemark.stopAnimating()
            activityIndicatorRemark.isHidden = true
            
        }
    }
}
