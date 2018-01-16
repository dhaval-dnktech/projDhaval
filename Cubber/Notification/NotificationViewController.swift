//
//  NotificationViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 02/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, AppNavigationControllerDelegate , NotificationCellDelegate, KDAlertViewDelegate{

    //MARK: PROPERTIES
    @IBOutlet var tableViewNotifications: UITableView!
    @IBOutlet var _VKFooterView: VKFooterView!
    @IBOutlet var viewBGWithOutLogin: UIView!
    @IBOutlet var viewBG_NA: UIView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var btnClearAll: UIButton!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var arrNotifications = [typeAliasDictionary]()
      var refresher = UIRefreshControl()
    fileprivate var isPullToRefresh:Bool = false
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        _KDAlertView.alertDelegate = self
        self.setLoginInfo()
        self.viewTop.setBottomBorder(UIColor.gray, borderWidth: 1)
        self.tableViewNotifications.rowHeight = UITableViewAutomaticDimension
        self.tableViewNotifications.estimatedRowHeight = HEIGHT_NOTIFICATION_CELL
        self.tableViewNotifications.tableFooterView = UIView(frame: CGRect.zero)
        refresher.addTarget(self, action:  #selector(pullToRefresh), for: .valueChanged)
        refresher.tintColor = COLOUR_ORANGE
        self.tableViewNotifications!.addSubview(refresher)
        self.tableViewNotifications.register(UINib.init(nibName: CELL_IDENTIFIER_NOTIFICATION, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_NOTIFICATION)
        
        //LISTEN NOTIFICATION
       // NotificationCenter.default.addObserver(self, selector: #selector(setLoginInfo), name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGGED_IN), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: SCREEN_NOTIFICATION)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_NOTIFICATIONLIST, stclass: F_NOTIFICATIONLIST)
    }
    
    //MARK: UIBUTTON ACTION
    
    func pullToRefresh(){
        isPullToRefresh = true
        self.currentPage = 1
        self.callUserNotificationService()
    }
    
    @IBAction func btnClearAllAction() { _KDAlertView.showMessage(message: MSG_QUE_CLEAR_ALL_NOTFICATION, messageType: MESSAGE_TYPE.QUESTION)
        return
    }
    
    @IBAction func btnNotificationSettingAction() {
        
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_NOTIFICATION)", action: "Notification Setting", label: "notification Settings Changed", value: nil)
        _ = NotificationView.init(frame: UIScreen.main.bounds)
        
         }
    
    
    @IBAction func btnLoginAction() {
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_NOTIFICATION)", action: SCREEN_LOGIN, label: "User Not Logged In", value: nil)
        obj_AppDelegate.showLoginView();
    }
    
    @IBAction func btnSignUpAction() {
        let sigupVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(sigupVC, animated: true)
    }
    
    //MARK: CUSTOME METHODS
    internal func setLoginInfo() {
        if !DataModel.getUserInfo().isEmpty {
            self.currentPage = 1
            self.callUserNotificationService()
            tableViewNotifications.isHidden = false
        }
        else {
            tableViewNotifications.isHidden = true
        }
    }
    
   @objc fileprivate func callUserNotificationService() {
   
       let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_PAGE_NO: "\(currentPage)"]
        
    obj_OperationWeb.callRestApi(methodName: JMETHOD_UserNotification, methodType:  METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: isPullToRefresh ? UIView.init() : self.navigationController!.view, onSuccess: { (dict) in
            
            if self.isPullToRefresh {
               self.arrNotifications = [typeAliasDictionary]()
               self.refresher.endRefreshing()
                self.isPullToRefresh = false
            }
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.pageSize = Int(dict[RES_par_page] as! String)!
            self.totalPages = Int(dict[RES_total_pages] as! String)!
            self.totalRecords = Int(dict[RES_total_items] as! String)!
            let arrData: Array<typeAliasDictionary> = dict[RES_notification] as! Array<typeAliasDictionary>
            self.arrNotifications += arrData
            self.viewBG_NA.isHidden = self.arrNotifications.isEmpty ? false : true
            self.tableViewNotifications.isHidden = self.arrNotifications.isEmpty ? true : false
            self.btnClearAll.isHidden = false
            DataModel.setNotificationBadge(dict[RES_notification_count] as! String)
            self.tableViewNotifications.reloadData()
            
        }, onFailure: { (code, dict) in
            if self.isPullToRefresh {
                self.refresher.endRefreshing()
                self.isPullToRefresh = false
            }
            self.tableViewNotifications.isHidden = true
            self.viewBG_NA.isHidden = false
            self.btnClearAll.isHidden = true
            DataModel.setNotificationBadge("0")
            
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)
            _KDAlertView.didClick(completion: { (isClicked) in
                self.obj_AppDelegate.navigationController.popViewController(animated: true)
            })
        }
    }
    
    fileprivate func callReasdNotificationService(_ indexPath: IndexPath , isDeleteAll:Bool , isDelete:Bool) {
        
        let index: Int = (indexPath as NSIndexPath).row
        var dictNotification: typeAliasDictionary = self.arrNotifications[index]
        let isNotificationRead: String = dictNotification[RES_isRead] as! String
        if (isNotificationRead == "1") && !isDelete &&  !isDeleteAll { self.navigateToNotificationDetail(indexpath: indexPath) }
        else{
            
            let notificatinID: String = dictNotification[RES_notificationID] as! String
            let userInfo: typeAliasDictionary = DataModel.getUserInfo()
            let params = [REQ_HEADER: DataModel.getHeaderToken(),
                          REQ_USER_ID: userInfo[RES_userID] as! String,
                          REQ_NOTIFICATION_ID: isDeleteAll ? "" : notificatinID,
                          REQ_IS_DELETE: isDelete ? "1" : "0",
                          REQ_DELETE_ALL: isDeleteAll ? "1" : "0"]
            
            obj_OperationWeb.callRestApi(methodName: JMETHOD_ReadNotification, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
                
                if isDeleteAll || isDelete {
                    self.currentPage = 1
                    self.arrNotifications = [typeAliasDictionary]()
                    self.callUserNotificationService()
                }
                else {
                    DataModel.setHeaderToken(dict[RES_token] as! String)
                    dictNotification[RES_isRead] = "1" as AnyObject
                    self.arrNotifications[index] = dictNotification
                    self.tableViewNotifications.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                    DataModel.setNotificationBadge(dict[RES_notification_count] as! String)
                    self.navigateToNotificationDetail(indexpath: indexPath)
                }
                
            }, onFailure: { (code, dict) in
                
            }, onTokenExpire: { let _KDAlertView = KDAlertView()
                _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return  })
        }
}
    
    fileprivate func callGetUserWalletService() {
                
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetUserWallet, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let walletListVC = WalletListViewController(nibName: "WalletListViewController", bundle: nil)
            walletListVC.walletAmount = "\(RUPEES_SYMBOL) \(dict[RES_wallet]!)"
            self.navigationController?.pushViewController(walletListVC, animated: true)
            
        }, onFailure: { (code, dict) in
            
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return }
    }
    fileprivate func navigateToNotificationDetail(indexpath:IndexPath){

        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_NOTIFICATION)", action: "NOTIFICATION_DETAIL", label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
        
        let dictNotification = self.arrNotifications[indexpath.row]
        if dictNotification[RES_nTypeID] as! String == "2" || dictNotification[RES_nTypeID] as! String == "1" {
            DataModel.setUserWalletResponse(dict: typeAliasDictionary())
            DataModel.setUsedWalletResponse(dict: typeAliasDictionary())
            NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_RELOAD_WALLET), object: nil) //POST NOTIFICATION
        }
        if dictNotification[RES_isRedirect] as! String == "1" {
            
            if REDIRECT_SCREEN_TYPE(rawValue: dictNotification[RES_redirectScreen] as! String) != nil {
                obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue: dictNotification[RES_redirectScreen] as! String)! , dict:dictNotification)
            }
          
        }
        else if dictNotification[RES_isShowDetail] as! String == "1" {
            let notificDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
            notificDetailVC.dictNotification = self.arrNotifications[indexpath.row]
            notificDetailVC.notificationID = self.arrNotifications[indexpath.row][RES_PushNotificationId] as! String
            notificDetailVC.isCoupon = false
            self.navigationController?.pushViewController(notificDetailVC, animated: true)
        }
        
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Notification")
        obj_AppDelegate.navigationController.navigationDelegate = self
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrNotifications.count }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_NOTIFICATION) as! NotificationCell;
        cell.delegate = self
        let dict: typeAliasDictionary = arrNotifications[(indexPath as NSIndexPath).row]
        cell.lblDate.text = dict[RES_notificationDate] as? String
        cell.lblNotificationTitle.text = dict[RES_notificationTitle] as? String
        cell.lblNotificationDescription.text = dict[RES_notificationDescription] as? String
        cell.btnDelete.accessibilityIdentifier = String(indexPath.row)
        let stImageUrl: String = dict[RES_icon] as! String
        if stImageUrl.characters.count != 0 {
            cell.imageViewLogo.sd_setImage(with: stImageUrl.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                if image == nil { cell.imageViewLogo.image = UIImage(named: "logo") }
                else { cell.imageViewLogo.image = image!}
                cell.activityIndicator.stopAnimating()
            }
        }
        else { cell.imageViewLogo.image = UIImage(named: "logo") }
        
        if (indexPath as NSIndexPath).row == self.arrNotifications.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages { currentPage = page; self.callUserNotificationService(); }
        }
        cell.viewBG.backgroundColor = dict[RES_isRead] as? String == "0" ? RGBCOLOR(250, g: 197, b: 127 , alpha : 0.7) : UIColor.clear
        cell.viewBG.layer.borderWidth = 1
        cell.viewBG.layer.borderColor = UIColor.gray.cgColor
         cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.callReasdNotificationService(indexPath,isDeleteAll: false,isDelete: false)
       
    }
    //MARK: NOTIFICATION CELL DELEGATE
    
    func btnNotificationCell_DeleteAction(_ button: UIButton) {
        
        let index = Int(button.accessibilityIdentifier!)
        self.callReasdNotificationService(IndexPath.init(row: index!, section: 0), isDeleteAll: false, isDelete: true)
    }
    
    //MARK: KD ALERT DELEGATE
    func messageYesAction() {
         self.callReasdNotificationService(IndexPath.init(row: 0, section: 0),isDeleteAll: true,isDelete: true)
    }
    
    func messageNoAction() {
        print("No Action")
    }
    func messageOkAction() {
        print("OK Action")
    }

}
