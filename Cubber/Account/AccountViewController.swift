
//
//  AccountViewController.swift
//  Cubber
//
//  Created by dnk on 01/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import MessageUI

class AccountViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , AppNavigationControllerDelegate, MFMailComposeViewControllerDelegate , KDAlertViewDelegate {

    //MARK: PROPERTIES
    
    @IBOutlet var imageViewProfile: UIImageView!
    @IBOutlet var tableViewAccount: UITableView!
    @IBOutlet var btnPrimeMember: UIButton!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var btnFeedback: UIButton!
    @IBOutlet var lblUserSortName: UILabel!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var constraintLblUserNameBottomToBtnPrimeMember: NSLayoutConstraint!
    @IBOutlet var constraintLblUserNameBottomToSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintTableViewAccountHeight: NSLayoutConstraint!
    
    //MARK: VARIABLES
    
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var _VKSideMenu = VKSideMenu()
    fileprivate var arrMenu = [typeAliasDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAccount.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewAccount.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewAccount.register(UINib.init(nibName: CELL_IDENTIFIER_ACCOUNT, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_ACCOUNT)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.setLoginInfo()
        self.sendScreenView(name: SCREEN_ACCOUNT)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_MODULE_ACCOUNT, stclass: F_MODULE_ACCOUNT)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Account")
        obj_AppDelegate.navigationController.setSideMenuButton()
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_SideMenuAction() {
        _VKSideMenu = VKSideMenu()
        self.navigationController?.view.addSubview(self._VKSideMenu)
    }
    
    //MARK: CUSTOM METHODS
    
    @IBAction func btnBecomePrimeMemberAction() {
        obj_AppDelegate.onVKMenuAction(VK_MENU_TYPE.HOW_TO_EARN, categoryID: 12)
    }
    
    
    @IBAction func btnProfileAction() {
         self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: PROFILE, label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
        let editProfileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    
    internal func setLoginInfo() {
    
        if self.arrMenu.count > 3 {
            for dict in self.arrMenu {
                if dict[LIST_NSTIMER] != nil {
                    let timer = dict[LIST_NSTIMER] as! Timer
                    timer.invalidate();
                }
            }
        }
        
        let dict: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.ORDER.rawValue as AnyObject, LIST_TITLE: "Your Order" as AnyObject, LIST_FLAG: "" as AnyObject, LIST_SUB_TITLE: "" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
        let dict1: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.TREE.rawValue as AnyObject, LIST_TITLE: "Connects" as AnyObject, LIST_FLAG: "" as AnyObject, LIST_SUB_TITLE: "" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
        
        self.arrMenu = [dict, dict1]
        
        let dict6: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.SAVED_CARDS.rawValue as AnyObject, LIST_TITLE: "Saved Cards" as AnyObject, LIST_FLAG: "" as AnyObject, LIST_SUB_TITLE: "" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
        self.arrMenu.append(dict6)
        
        if !DataModel.getUserInfo().isEmpty {
            
            if  DataModel.getUserInfo()[RES_isMemLableDisplay] != nil && DataModel.getUserInfo()[RES_isMemLableDisplay] as! String == "1" {
                
                if DataModel.getUserInfo()[RES_isMemberFeesPay] as! String == "1" {
                    let dict2: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.MEMBERSHIP_FEES.rawValue as AnyObject, LIST_TITLE: "\(obj_AppDelegate.membershipTitle)" as AnyObject, LIST_FLAG: "0" as AnyObject , LIST_SUB_TITLE: "Paid" as AnyObject, LIST_NSTIMER:Timer.init()];
                    self.arrMenu.append(dict2)
                }
                else {
                    let dict2: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.MEMBERSHIP_FEES.rawValue as AnyObject, LIST_TITLE: "\(obj_AppDelegate.membershipTitle)" as AnyObject, LIST_FLAG: "1" as AnyObject, LIST_SUB_TITLE: "Click To Pay" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
                    self.arrMenu.append(dict2)
                }

            }
            
            else  if  DataModel.getUserInfo()[RES_isMemLableDisplay]  == nil {
                
                if DataModel.getUserInfo()[RES_isMemberFeesPay] as! String == "1" {
                    let dict2: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.MEMBERSHIP_FEES.rawValue as AnyObject, LIST_TITLE: "\(obj_AppDelegate.membershipTitle)" as AnyObject, LIST_FLAG: "0" as AnyObject , LIST_SUB_TITLE: "Paid" as AnyObject, LIST_NSTIMER:Timer.init()];
                    self.arrMenu.append(dict2)
                }
                else {
                    let dict2: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.MEMBERSHIP_FEES.rawValue as AnyObject, LIST_TITLE: "\(obj_AppDelegate.membershipTitle)" as AnyObject, LIST_FLAG: "1" as AnyObject, LIST_SUB_TITLE: "Click To Pay" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
                    self.arrMenu.append(dict2)
                }

            }
            
            let userInfo: typeAliasDictionary = DataModel.getUserInfo()
            
            if !(userInfo[RES_userProfileImage] as! String).isEmpty{
                self.activityIndicator.startAnimating()
                let sturl = userInfo[RES_userProfileImage] as! String
                imageViewProfile.sd_setImage(with: NSURL.init(string: sturl) as URL!, completed: { (image, error, type, url) in
                    if image != nil {
                        self.imageViewProfile.isHidden = false
                        self.lblUserSortName.isHidden = true
                    }
                    else {
                        self.imageViewProfile.isHidden = true
                        self.lblUserSortName.isHidden = false
                    }
                    self.activityIndicator.stopAnimating()
                })

            }
            else{
                lblUserSortName.isHidden = false
                imageViewProfile.isHidden = true
            }
            
            let stFirstName: String = userInfo[RES_userFirstName] as! String
            let stLastName: String = userInfo[RES_userLastName] as! String
            var userFullName:String = stFirstName
            
            let startIndex = stFirstName.characters.index(stFirstName.startIndex, offsetBy: 0)
            let range = startIndex..<stFirstName.characters.index(stFirstName.startIndex, offsetBy: 1)
            let stFN = stFirstName.substring( with: range )
            var stLN:String = ""
            if !stLastName.isEmpty { stLN = stLastName.substring( with: range ); userFullName += " " + stLastName; }
            lblUserSortName.text = (stFN + stLN).uppercased()
            lblUserName.text = (stFN + stLN).uppercased()
            self.lblUserName.text = userFullName
            if userInfo[RES_isReferrelActive] as! String == "0" {
                btnPrimeMember.isEnabled = true
                btnPrimeMember.isHidden = false
                constraintLblUserNameBottomToSuper.priority = PRIORITY_LOW
                constraintLblUserNameBottomToBtnPrimeMember.priority = PRIORITY_HIGH
            }
            else{
                btnPrimeMember.isEnabled = false
                btnPrimeMember.isHidden = true
                constraintLblUserNameBottomToSuper.priority = PRIORITY_HIGH
                constraintLblUserNameBottomToBtnPrimeMember.priority = PRIORITY_LOW
            }
            
        btnFeedback.setTitle("App Feedback ( V \(DataModel.getAppVersion()) )", for: UIControlState())
        }
        let dict4: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.HELP_FAQ.rawValue as AnyObject, LIST_TITLE: "Help & FAQ" as AnyObject, LIST_FLAG: "" as AnyObject, LIST_SUB_TITLE: "" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
        
        self.arrMenu.append(dict4)
        
        let dict5: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.CONTACT_US.rawValue as AnyObject, LIST_TITLE: "Contact Us" as AnyObject, LIST_FLAG: "" as AnyObject, LIST_SUB_TITLE: "" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
        self.arrMenu.append(dict5)
        
        let userWallet:typeAliasDictionary =  DataModel.getUserWalletResponse()
        
        if  !userWallet.isEmpty && userWallet[RES_isGiveupApp] as! String == "1" {
            let dict6: typeAliasDictionary = [LIST_ID:ACCOUNT_MENU.GIVE_UP_CASHBACK.rawValue as AnyObject, LIST_TITLE: userWallet[RES_isGiveupTitle] as! String as AnyObject, LIST_FLAG: "" as AnyObject, LIST_SUB_TITLE: "" as AnyObject, LIST_NSTIMER:Timer.init() as AnyObject];
            self.arrMenu.append(dict6)
        }
        
        self.view.layoutIfNeeded()
        btnFeedback.setTitle("App Feedback ( V \(DataModel.getAppVersion()) )", for: UIControlState())
        
        constraintTableViewAccountHeight.constant = CGFloat(arrMenu.count) * HEIGHT_ACCOUNT_CELL
        tableViewAccount.layoutIfNeeded()
        tableViewAccount.reloadData()
    }
 
    
    
    internal func blinkView(_ timer: Timer) {
        let label: UILabel = timer.userInfo as! UILabel
        label.isHidden = !label.isHidden
    }
    
    
    @IBAction func btnLogOutAction() {
        
        _KDAlertView.showMessage(message: "Are you sure you want to logout ?", messageType: .QUESTION)
        _KDAlertView.alertDelegate = self
    }
    
    @IBAction func btnAppFeedBackAction() {
        
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: APPFEEDBACK, label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["care@cubber.in"])
            mail.setSubject("Feedback")
            mail.setMessageBody("Cubber \(DataModel.getAppVersion()) On \(DataModel.getDeviceName()) running \(UIDevice.current.systemVersion)",isHTML: false)
            self.present(mail, animated: true)
        } else {
            _KDAlertView.showMessage(message: "Mail service is not available", messageType: .WARNING)
            return
        }
    }
    
    @IBAction func btnTermsAndConditionAction() {
         let _ = TermsAndCondView.init(typeAliasDictionary() , isSignUP:true, isPrivacyPolicy:false)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //MARK: KDALERT DELEGATE
    func messageYesAction() {
        
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: LOGOUT, label: "User ID:\(dictUserInfo[RES_userID]!)", value: nil)
        let params: typeAliasStringDictionary = [REQ_HEADER: DataModel.getHeaderToken(),
                                                 REQ_LOGIN_TYPE:
                                                    (dictUserInfo[RES_login_type] as? String) == nil ? "0" : dictUserInfo[RES_login_type] as! String,
                                                 REQ_USER_ID: dictUserInfo[RES_userID] as! String]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_UserLogout, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            self.obj_AppDelegate.performLogout()
        }, onFailure: { (code, dict) in
            
        }) {   self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.FAILURE); return      }
    }
    
    func messageNoAction() {
        
    }

    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrMenu.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AccountCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_ACCOUNT) as! AccountCell;
        var dict: typeAliasDictionary = self.arrMenu[(indexPath as NSIndexPath).row]
        cell.lblTitle.text = dict[LIST_TITLE] as? String
        cell.lblBlink.text = dict[LIST_SUB_TITLE] as? String
        cell.lblBlink.isHidden = false
        
        let isBlink:String = dict[LIST_FLAG] as! String
        
        if isBlink == "1" {
            var timer: Timer!
            if dict[LIST_NSTIMER] != nil {
                timer = dict[LIST_NSTIMER] as! Timer
                timer.invalidate();
            }
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(blinkView), userInfo: cell.lblBlink, repeats: true)
            dict[LIST_NSTIMER] = timer
            self.arrMenu[(indexPath as NSIndexPath).row] = dict
            cell.lblBlink.textColor = UIColor.white;
            cell.lblBlink.textAlignment = .center
        }
        else{
            cell.lblBlink.textAlignment = .right
            cell.lblBlink.backgroundColor = UIColor.clear
            cell.lblBlink.textColor = COLOUR_DARK_GREEN
            cell.imageIconArrow.image = isBlink == "0" ? #imageLiteral(resourceName: "icon_checked")  : #imageLiteral(resourceName: "icon_right_arrow_s")
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return HEIGHT_ACCOUNT_CELL }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict: typeAliasDictionary = self.arrMenu[(indexPath as NSIndexPath).row]
        let menuType: ACCOUNT_MENU = ACCOUNT_MENU(rawValue: dict[LIST_ID] as! Int)!
        self.setUserProperty(propertyName: F_ACCOUNT, PropertyValue: dict[LIST_TITLE] as! String)
        switch menuType {
        case .ORDER:
            if obj_AppDelegate.isMemberShipFeesPaid(){
                self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: YOURORDERS, label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
                let orderVC = OrderViewController(nibName: "OrderViewController", bundle: nil)
                self.navigationController?.pushViewController(orderVC, animated: true)
            }
            else{
                self._KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.MEMBERSHIP_WARNING); return;            }
            
            
            break
        case .TREE:
            if obj_AppDelegate.isMemberShipFeesPaid(){
                self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: TREEPOSITION, label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
                let treeVC = TreeViewController(nibName: "TreeViewController", bundle: nil)
                self.navigationController?.pushViewController(treeVC, animated: true)}
            else{
                self._KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.MEMBERSHIP_WARNING); return;
            }
        
            break
            
        case .MEMBERSHIP_FEES:
            
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: PAY_MEMBERSHIPFEES, label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
            if !DataModel.getUserInfo().isEmpty {
                let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
                if dictUserInfo[RES_isMemberFeesPay] as! String == "1" { return }
            }
           /* let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
             rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.MEMBERSHIP_FEES
             rechargeVC.cart_TotalAmount = DataModel.getMemberShipFees()
             self.navigationController?.pushViewController(rechargeVC, animated: true)*/
            obj_AppDelegate.onVKMenuAction(.HOW_TO_EARN, categoryID: 13)
            break
        case .HELP_FAQ:
            if obj_AppDelegate.isMemberShipFeesPaid(){
                self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: SCREEN_HELP, label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
                let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
                webPreviewVC.isShowToolBar = true
                webPreviewVC.stUrl = JHelpAndFaq
                webPreviewVC.stTitle = "Help & FAQ"
                webPreviewVC.isHelpAndFaq = true
            self.navigationController?.pushViewController(webPreviewVC, animated: true)}
            else{
                self._KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.MEMBERSHIP_WARNING); return;
            }
            
            break
        case .CONTACT_US:
            if obj_AppDelegate.isMemberShipFeesPaid(){
                self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_ACCOUNT)", action: CONTACTUS, label: "User ID:\(DataModel.getUserInfo()[RES_userID]!)", value: nil)
                let contactUsVC = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
                self.navigationController?.pushViewController(contactUsVC, animated: true)}
            else {
                self._KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.MEMBERSHIP_WARNING); return;
            }
            
            break
        case .HOW_EARN:
            if obj_AppDelegate.isMemberShipFeesPaid(){
                let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                self.navigationController?.pushViewController(howToEarnVC, animated: true)}
            else{ self._KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.MEMBERSHIP_WARNING); return;
            }
            break
        case .GIVE_UP_CASHBACK:
            if obj_AppDelegate.isMemberShipFeesPaid(){
                let giveUpVC = GiveUpCashBackViewController(nibName: "GiveUpCashBackViewController", bundle: nil)
                if  DataModel.getUserWalletResponse()[RES_isGiveupTitle] != nil {
                        giveUpVC.giveUpTitle = DataModel.getUserWalletResponse()[RES_isGiveupTitle] as! String
                }
            
                self.navigationController?.pushViewController(giveUpVC, animated: true)}
            else{ self._KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.MEMBERSHIP_WARNING); return;
            }
            break
        case .SAVED_CARDS:
            if obj_AppDelegate.isMemberShipFeesPaid(){
                let savedCardVC = SavedCardsViewController(nibName: "SavedCardsViewController", bundle: nil)
                self.navigationController?.pushViewController(savedCardVC, animated: true)}
            else{ self._KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.MEMBERSHIP_WARNING); return;
            }
            break
        default:
            break
        }
        
    }
}
