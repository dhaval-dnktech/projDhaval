//
//  PaymentViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 05/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class WebPreviewViewController: UIViewController, UIWebViewDelegate, AppNavigationControllerDelegate, VKToastDelegate, UIDocumentInteractionControllerDelegate {

    //MARK: PROPERTIES
    @IBOutlet var _webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var viewToolBar: UIView!
    @IBOutlet var btnViewToolBar_GoBack: UIButton!
    @IBOutlet var btnViewToolBar_GoForward: UIButton!
    @IBOutlet var constraintViewToolBarBottomWithSuperView: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var stDocType: String = ""
    fileprivate var docController = UIDocumentInteractionController()
    
    //MARK: VARIABLES SHARING
    internal var isShowToolBar: Bool = false
    internal var stUrl: String = ""
    internal var stTitle:String?
    internal var isShowSave: Bool = false
    internal var stDocName: String = ""
    internal var isHelpAndFaq: Bool = false
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        btnViewToolBar_GoBack.isEnabled = false
        btnViewToolBar_GoForward.isEnabled = false
        constraintViewToolBarBottomWithSuperView.constant = isShowToolBar ? 0 : -viewToolBar.frame.height
        
        var header: String = DataModel.getHeaderToken()
        header = header.encode()
        
        activityIndicator.startAnimating()
        let theRrequest: URLRequest = URLRequest(url: stUrl.convertToUrl(), cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 999999999999999999)
        self._webView.loadRequest(theRrequest)
        self._webView.scrollView.bounces = false
        if isHelpAndFaq {self._webView.scalesPageToFit = false}
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.setNavigationBar();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isHelpAndFaq {self.SetScreenName(name: F_HELPANDFAQ, stclass: F_HELPANDFAQ)}
        else{ self.SetScreenName(name: F_INVOICE, stclass: F_INVOICE) }
    }
    
    @IBAction func btnViewToolBar_GoBackAction() { _webView.goBack() }
    
    @IBAction func btnViewToolBar_GoForwardAction() { _webView.goForward() }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        
        self.setStatusBarBackgroundColor(color: UIColor.clear)
        if self.stTitle != nil && self.stTitle != "" {
            obj_AppDelegate.navigationController.setCustomTitle(self.stTitle!)
        }
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
        if isShowSave { obj_AppDelegate.navigationController.setRighButton("Save"); obj_AppDelegate.navigationController.btnRight.isHidden = true }
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }

    
    func appNavigationController_BackAction() {
        if _webView.canGoBack{_webView.goBack()}
        else{let _ = navigationController?.popViewController(animated: true)}
    }
    
    func appNavigationController_RightMenuAction() {
        activityIndicator.startAnimating()
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        var fileName: String = PREFIX_DOCUMENT
        stDocName = !stDocName.isEmpty ? stDocName : self.stUrl.components(separatedBy: "/").last!
        fileName = stDocName.isEmpty ? fileName : "\(fileName)\(stDocName)"
        let filePath = "\(paths[0])\(fileName.trim())"
        
        if fileManager.fileExists(atPath: filePath) { do { try fileManager.removeItem(at: filePath.convertToUrl()) } catch { } }
        else
        {
            let response = URLCache.shared.cachedResponse(for: _webView.request!)
            let docData = response?.data
            do { try
                docData?.write(to: filePath.convertToUrl(), options: Data.WritingOptions.atomic)
                docController = UIDocumentInteractionController.init(url: filePath.convertToUrl())
                docController.delegate = self
                let _ = docController.presentOptionsMenu(from: CGRect.zero, in: self.view, animated: true)
                activityIndicator.stopAnimating();
            }
            catch { _KDAlertView.showMessage(message: MSG_ERR_DOWNLOAD, messageType: MESSAGE_TYPE.WARNING); return;
            }
        }
    }
    
    //MARK: UIWEBVIEW DELEGATE
    func webViewDidStartLoad(_ webView: UIWebView) { activityIndicator.startAnimating() }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("\(webView.request?.url?.absoluteURL)")
        activityIndicator.stopAnimating()
        
        let cachedResponse = URLCache.shared.cachedResponse(for: webView.request!)
        if cachedResponse != nil {
            let contentType: String = (cachedResponse?.response.mimeType)!
            stDocType = contentType.components(separatedBy: "/").last!
            stDocType = stDocType.isEmpty ? "" : stDocType
            
            let httpResponse: HTTPURLResponse = cachedResponse?.response as! HTTPURLResponse
            let statusCode: Int = httpResponse.statusCode
            
            if isShowSave { obj_AppDelegate.navigationController.btnRight.isHidden = false }
            else { obj_AppDelegate.navigationController.btnRight.isHidden = true }
            
            if statusCode == 404 && !_webView.isHidden {
                _webView.isHidden = true
                let _ = self.navigationController?.popViewController(animated: true)
                obj_AppDelegate.navigationController.btnRight.isHidden = true
                self._KDAlertView.showMessage(message: MSG_ERR_DOWNLOAD, messageType: .FAILURE)
                return
            }
            else { obj_AppDelegate.navigationController.btnRight.isHidden = false }
        }
        else { obj_AppDelegate.navigationController.btnRight.isHidden = true }
        
        btnViewToolBar_GoBack.isEnabled = webView.canGoBack
        btnViewToolBar_GoForward.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.startAnimating()
        //VKToast.showToast(MSG_TXT_MOBILE_NO, toastType: VKTOAST_TYPE.FAILURE);
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
