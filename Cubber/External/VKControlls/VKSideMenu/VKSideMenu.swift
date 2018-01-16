
//
//  VKSideMenu.swift
//  Cubber
//
//  Created by dnk on 17/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//
let VK_SIDE_MENU_DURATION               = 0.3

let SELECTION_SUPER_VIEW_TAG            = 10001
let SELECTION_SUB_VIEW_TAG              = 110001

let COLOUR_BG                           = RGBCOLOR(255, g: 255, b: 255)
let COLOUR_BLACK_TRANSPARENT            = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)

let TEXT_COLOUR                         = RGBCOLOR(26, g: 90, b: 90)
let TAG_TITLE                           = 1001
let TAG_IMAGE                           = 1004
let TAG_ICON                            = 1002
let TAG_SUB_TITLE                       = 1003

let TEXT_SUB:CGFloat                    = 13
let TEXT_MAIN:CGFloat                   = 14

let CELL_FONT:UIFont                    = UIFont.systemFont(ofSize: 14)
let IS_EXAPANDABLE:String                   = "IS_EXAPANDABLE"
let IS_EXPANDED:String                      = "IS_EXPANDED"

import UIKit

class VKSideMenu: UIView , UIGestureRecognizerDelegate , UITableViewDelegate , UITableViewDataSource , KDAlertViewDelegate {
    
    //MARK: CONSTANT
    internal let TAG_SUPPER: Int = 10000
    
    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    let _KDAlertView = KDAlertView()
    var width:CGFloat = 0
    var arrList = [typeAliasDictionary]()
    var arrSections = NSIndexSet()
    var constrintLeading:NSLayoutConstraint!
    var selectedSection:Int = -1
    var selectedUnExpandedSection:Int = -1
    
    //MARK: VIEW METHODS
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadXIB(){
        let view = Bundle.main.loadNibNamed(String(describing: type (of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.layoutIfNeeded()
    }
    
    override init(frame :CGRect){
        super.init(frame: frame)
        self.loadXIB()
        let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
        let frame:CGRect = CGRect(x: 0, y: statusBarHeight, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - statusBarHeight)
        self.frame = frame
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        self.loadData()
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideMenuAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.tag = SELECTION_SUPER_VIEW_TAG
        gestureTap.delegate = self
        self.addGestureRecognizer(gestureTap)
        width = frame.width * 0.8
        
        let dict:typeAliasDictionary = DesignModel.setConstraint_ConWidth_ConHeight_Leading_Top(viewBG, superView: self, leading: -width, top: 0, width: width, height: self.frame.height)
        constrintLeading = dict[CONSTRAINT_LEADING] as! NSLayoutConstraint
        self.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {() -> Void in
            self.alpha = 1
            }, completion: {(finished: Bool) -> Void in
                self.constrintLeading.constant = 0
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {() -> Void in
                    self.layoutIfNeeded()
                    }, completion: nil)
        })
    }
    
   internal func loadData() {
    
        self.getSideMenuList()
        arrSections = NSIndexSet.init(indexesIn: NSRange.init(location: 0, length: arrList.count))
        tableViewList.register(UINib.init(nibName: CELL_IDENIFIER_SIDE_MENU_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENIFIER_SIDE_MENU_CELL)
        tableViewList.tableFooterView = UIView(frame: CGRect.zero)
        tableViewList.separatorStyle = .singleLine
        tableViewList.separatorColor = UIColor.lightGray
        tableViewList.rowHeight = 46
        tableViewList.bounces = false
        tableViewList.backgroundColor = COLOUR_BG
        tableViewList.allowsSelection = true
    
    }

    func getSideMenuList(){
        
      if  obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_GetMenuList) {
            self.callGetMenuListService()
        }
      else {self.setJsonArray()}
       
    }
    
    func callGetMenuListService(){

        self.activityIndicator.startAnimating()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID]] as [String : Any]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetMenuList, methodType: .POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: UIView.init(), onSuccess: { (dict) in
             self.activityIndicator.stopAnimating()
            DataModel.setArrSideMenu(array: dict[RES_data] as! [typeAliasDictionary])
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_GetMenuList)
            self.setJsonArray()
        }, onFailure: { (dict ,code) in self.activityIndicator.startAnimating()}) {
            self.activityIndicator.stopAnimating() }
    }
    
    internal func hideMenuAction() {
        constrintLeading.constant = -width
        UIView.animate(withDuration: 0.3, delay: 0.0, options:UIViewAnimationOptions.beginFromCurrentState, animations: {() -> Void in
            self.layoutIfNeeded()
            }, completion: {(finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3, delay: 0.0, options:UIViewAnimationOptions.beginFromCurrentState, animations: {() -> Void in
                    self.alpha = 0
                    }, completion: {(finished: Bool) -> Void in
                        self.removeFromSuperview()
                        self.layer.removeAllAnimations()
                })
        })
    }
    
    @objc fileprivate func viewHeaderTapAction() {
        
        if selectedUnExpandedSection == -1 {
            var dict = arrList[selectedSection]
            if dict[IS_EXAPANDABLE] as! Bool {
                let isExapanded = dict[IS_EXPANDED] as! Bool
                selectedSection = isExapanded ? -1 : selectedSection
                for i in 0..<arrList.count {
                    var dict = arrList[i]
                    if i == selectedSection {dict[IS_EXPANDED] = !isExapanded as AnyObject?}
                    else {dict[IS_EXPANDED] = false as AnyObject?}
                    arrList[i] = dict
                }
                tableViewList.reloadData()
            }
                
            else {
                self.hideMenuAction()
                var isPaidFees:Bool = false
                if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
                    isPaidFees = true;
                }
                else{
                    if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
                    else { isPaidFees = false }
                }
                
                 if dict[RES_isBrowser] as! String == "1" && isPaidFees {
                    let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
                    webPreviewVC.stUrl = dict["url"] as! String
                    webPreviewVC.stTitle =  dict[RES_menuName] as! String
                    obj_AppDelegate.navigationController.pushViewController(webPreviewVC, animated: true)
                }
                    
                else if dict[RES_isBrowser] as! String == "1" && !isPaidFees {
                    _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                    return
                }
                    
                else if dict[RES_isBrowser] as! String == "2" && isPaidFees {
                    let url:String = dict["url"] as! String
                    UIApplication.shared.openURL(url.convertToUrl())
                }
                    
                else if dict[RES_isBrowser] as! String == "2" && !isPaidFees {
                    _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                    return
                }
                    
                else if VK_MENU_TYPE(rawValue: Int(dict[RES_menuID] as! String)!) != nil
                {
                    let _VK_MENU_TYPE =  VK_MENU_TYPE(rawValue: Int(dict[RES_menuID] as! String)!)
                    if _VK_MENU_TYPE == VK_MENU_TYPE.LOGOUT {
                        _KDAlertView.showMessage(message: "Are you sure you want to logout ?", messageType: .QUESTION)
                        _KDAlertView.alertDelegate = self
                    }
                    else if (_VK_MENU_TYPE == .RECHARGE || _VK_MENU_TYPE == .BILL || _VK_MENU_TYPE == .TICKET || _VK_MENU_TYPE == .GALLERY) && !isPaidFees  {
                        _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                        return
                    }
                    else{
                        obj_AppDelegate.onVKMenuAction(_VK_MENU_TYPE!,categoryID: 0)
                    }
                }
            }
        }
        else {
            self.hideMenuAction()
            var dict = arrList[selectedUnExpandedSection]
            let _VK_MENU_TYPE =  VK_MENU_TYPE(rawValue: Int(dict[RES_menuID] as! String)!)
            obj_AppDelegate.onVKMenuAction(_VK_MENU_TYPE! , categoryID: 0)
        }
    }
    
    func onMenuAction(dict:typeAliasDictionary , menuId:Int) {
        self.hideMenuAction()

        var isPaidFees:Bool = false
        if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
            isPaidFees = true;
        }
        else {
            if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if dict[RES_isBrowser] as! String == "1" && isPaidFees {
            let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
            webPreviewVC.stUrl = dict["url"] as! String
            webPreviewVC.stTitle =  dict[RES_menuName] as! String
            obj_AppDelegate.navigationController.pushViewController(webPreviewVC, animated: true)
        }
        if dict[RES_isBrowser] as! String == "1" && !isPaidFees {
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
            return
        }
        else if VK_MENU_TYPE(rawValue: menuId) != nil
        {
            let _VK_MENU_TYPE =  VK_MENU_TYPE(rawValue: menuId)
            if _VK_MENU_TYPE == VK_MENU_TYPE.LOGOUT {
                obj_AppDelegate.callLogOutService()
            }
            else{
                obj_AppDelegate.onVKMenuAction(_VK_MENU_TYPE!,categoryID: 0)
            }
        }
    }
    
    @objc func buttonHeaderAction(button:UIButton) {
        print(button.tag)
        selectedSection = button.tag
        self.viewHeaderTapAction()
    }
    
    //MARK: TABLE VIEW DATA SOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !arrList.isEmpty{
            if selectedSection == section{
                return (arrList[section][RES_categoryList] as! [typeAliasDictionary]).count
            }
            else {return 0}
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:SideMenuCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENIFIER_SIDE_MENU_CELL) as! SideMenuCell
        let dict: typeAliasDictionary = arrList[indexPath.section] as typeAliasDictionary
        var stTitle = ""
        var stShortOffer = ""
        var txtColor = UIColor.darkGray
        var stImageUrl = ""
        
        
        if indexPath.section == selectedSection   {
            
            let arrChild = dict[RES_categoryList] as! [AnyObject]
            let dictChild = arrChild[indexPath.row]
            stTitle = dictChild[RES_operatorCategoryName] as! String
                txtColor = UIColor.darkGray
            stImageUrl = dictChild[RES_image] as! String
            if  dictChild[RES_offerShortTitle] != nil {
                stShortOffer = dictChild[RES_offerShortTitle] as! String
            }
        }
       else {
            txtColor = UIColor.darkGray
            stTitle = dict[RES_menuName] as! String
            stImageUrl = dict[RES_image] as! String
        }
        
        
        if !stShortOffer.isEmpty{
          cell.lblShortOffer.text = stShortOffer
          cell.lblShortOffer.isHidden = false
            cell.viewLblShortTitleBG.isHidden = false
        }
        else{
            cell.lblShortOffer.text = ""
            cell.lblShortOffer.isHidden = true
            cell.viewLblShortTitleBG.isHidden = true
        }
        
        //TITLE
        
        cell.lblTitle.text = stTitle
        cell.lblTitle.textColor = txtColor
        
        //ICON 
        
       
        cell.imageViewIcon.sd_setImage(with: stImageUrl.convertToUrl())
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: TABLE VIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sideMenuHeader = SideMenuHeader.init(frame:  CGRect.init(x: 0, y: 0, width: tableViewList.frame.width, height: 52), dictMenu: arrList[section])
        if section != selectedSection {
            sideMenuHeader.setBottomBorder(.lightGray, borderWidth: 0.5)
        }
        sideMenuHeader.btnHeader.tag = section
        sideMenuHeader.btnHeader.addTarget(self, action: #selector(buttonHeaderAction), for: .touchUpInside)
        return sideMenuHeader
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideMenuAction()
        let dictMenu = arrList[indexPath.section]
        let arrSub = dictMenu[RES_categoryList]  as![typeAliasDictionary]
        let dictSub = arrSub[indexPath.row]
        
        if dictSub[RES_isBrowser] != nil && dictSub[RES_isBrowser] as! String == "1" {
            let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
            webPreviewVC.stUrl = dictSub["url"] as! String
            webPreviewVC.stTitle =  dictSub[RES_operatorCategoryName] as! String
            obj_AppDelegate.navigationController.pushViewController(webPreviewVC, animated: true)
        }
       else if dictSub[RES_isBrowser] != nil && dictSub[RES_isBrowser] as! String == "2" {
            let url:String = dictSub["url"] as! String
            UIApplication.shared.openURL(url.convertToUrl())
        }
            
        else if VK_MENU_TYPE(rawValue: Int(dictMenu[RES_menuID] as! String)!) != nil {
            let _VK_MENU_TYPE =  VK_MENU_TYPE(rawValue: Int(dictMenu[RES_menuID] as! String)!)
            obj_AppDelegate.onVKMenuAction(_VK_MENU_TYPE!,categoryID: Int(dictSub[RES_operatorCategoryId] as! String)! )
        }
        
       else {
            obj_AppDelegate.onVKMenuAction(.HOW_TO_EARN,categoryID: Int(dictSub[RES_operatorCategoryId] as! String)! )
        }
     }
        
    private func setJsonArray() {
        
        var arrMenu = DataModel.getArrSideMenu()
        
        for i in 0..<arrMenu.count {
            
            var dictMenu = arrMenu[i]
            let arrSub = dictMenu[RES_categoryList] as! [typeAliasDictionary]
            if !arrSub.isEmpty{
                dictMenu[IS_EXAPANDABLE] = true as AnyObject?
                dictMenu[IS_EXPANDED] =   false as AnyObject?
                arrMenu[i] = dictMenu
            }
            else{
                dictMenu[IS_EXAPANDABLE] = false as AnyObject?
                dictMenu[IS_EXPANDED] =   false as AnyObject?
                arrMenu[i] = dictMenu

            }
        }
        arrList = arrMenu
        self.tableViewList.reloadData()
     }
    
    //MARK: UI GESTURE RRECOGNIZER
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view: UIView = touch.view!
        let viewTag: Int = Int(view.tag)
        if viewTag == SELECTION_SUB_VIEW_TAG {
            let dict = arrList[Int(view.accessibilityIdentifier!)!]
            if dict[IS_EXAPANDABLE] as! Bool {
                selectedSection = Int(view.accessibilityIdentifier!)!
                selectedUnExpandedSection = -1
                return true
            }
            else{
             selectedUnExpandedSection = Int(view.accessibilityIdentifier!)!
                return true
            }
           
        }
        if viewTag != SELECTION_SUPER_VIEW_TAG{
            return false
        }
        return true
    }
    //MARK: KDALERT DELEGATE
    func messageYesAction() {
        obj_AppDelegate.callLogOutService()
    }
    
    func messageNoAction() {
    }
}
