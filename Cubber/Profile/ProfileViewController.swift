//
//  ProfileViewController.swift
//  Cubber
//
//  Created by dnk on 02/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OTPViewDelegate , AppNavigationControllerDelegate {

    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    
    //MARK: PROPERTIES
    
    @IBOutlet var viewMembershipFees: UIView!
    @IBOutlet var txtEmail: FloatLabelTextField!
    @IBOutlet var txtMobileNo: FloatLabelTextField!
    @IBOutlet var txtGender: FloatLabelTextField!
    @IBOutlet var txtMembershipFees: FloatLabelTextField!
    @IBOutlet var txtDOB: FloatLabelTextField!
    @IBOutlet var imageViewProfile: UIImageView!
    @IBOutlet var tableViewProfile: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblLoginInfo_name: UILabel!
    @IBOutlet var btnPrimeMember: UIButton!
    @IBOutlet var btnVerifyEmail: UIButton!
    @IBOutlet var imageIconVerified: UIImageView!
    @IBOutlet var constraintViewMobileTopToViewEmail: NSLayoutConstraint!
    @IBOutlet var constraintViewMobieTopToViewSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintLblUserNameBottomToBtnPrimeMember: NSLayoutConstraint!
    
    @IBOutlet var constraintLblUserNameBottomToSuper: NSLayoutConstraint!
    @IBOutlet var lblUserSortName: UILabel!

    @IBOutlet var constraintTableViewProfileHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintViewDOBTopToViewGender: NSLayoutConstraint!
    
    @IBOutlet var constraintViewDOBTopToViewMembershipFees: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.tableViewProfile.rowHeight = HEIGHT_EDITPROFILE_CELL
        self.tableViewProfile.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewProfile.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER_EDITPROFILE)
        constraintTableViewProfileHeight.constant = 1 * HEIGHT_EDITPROFILE_CELL
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.setLoginInfo()
        self.sendScreenView(name: SCREEN_PROFILE)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_PROFILE, stclass: F_PROFILE)
    }
    
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Profile")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setRighButton("Edit")
        obj_AppDelegate.navigationController.navigationDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func appNavigationController_RightMenuAction() {
        
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    func setLoginInfo() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        txtMobileNo.text = userInfo[RES_userMobileNo] as! String?
        
        if  DataModel.getUserInfo()[RES_isMemLableDisplay] != nil && DataModel.getUserInfo()[RES_isMemLableDisplay] as! String == "1" {
            let membershipFees : String = userInfo[RES_memberShipFees] as! String
            txtMembershipFees.placeholder = obj_AppDelegate.membershipTitle
            txtMembershipFees.text = membershipFees == "0" ? "Free \(obj_AppDelegate.membershipTitle)" : membershipFees
            constraintViewDOBTopToViewGender.priority = PRIORITY_LOW
            constraintViewDOBTopToViewMembershipFees.priority = PRIORITY_HIGH
            viewMembershipFees.isHidden = false
        }
        else {
            constraintViewDOBTopToViewGender.priority = PRIORITY_HIGH
            constraintViewDOBTopToViewMembershipFees.priority = PRIORITY_LOW
            viewMembershipFees.isHidden = true
        }
        let stDOB: String = userInfo[RES_userDOB] as! String
        txtDOB.text = stDOB == "0000-00-00" ? "-" : stDOB
        
        let gender : String = userInfo[RES_userSex] as! String
        txtGender.text = gender == "0" ? "Male" : "Female"
        
        if !(userInfo[RES_userProfileImage] as! String).isEmpty{
            let sturl = userInfo[RES_userProfileImage] as! String
            imageViewProfile.sd_setImage(with: NSURL.init(string: sturl) as URL!, placeholderImage: UIImage(named: "icon_user"))
            imageViewProfile.isHidden = false
            lblUserSortName.isHidden = true
        }
        else{
            imageViewProfile.isHidden = true
            lblUserSortName.isHidden = false
        }
        
        let stFirstName: String = userInfo[RES_userFirstName] as! String
        let stLastName: String = userInfo[RES_userLastName] as! String
        var userFullName:String = stFirstName
        
        let startIndex = stFirstName.characters.index(stFirstName.startIndex, offsetBy: 0)
        let range = startIndex..<stFirstName.characters.index(stFirstName.startIndex, offsetBy: 1)
        let stFN = stFirstName.substring( with: range )
        var stLN:String = ""
        if !stLastName.isEmpty { stLN = stLastName.substring( with: range ); userFullName += " " + stLastName; }
        lblName.text = userFullName
        lblUserSortName.text = (stFN + stLN).uppercased()
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

        
        
        if (userInfo[RES_userEmailId] as! String).isEmpty {
            constraintViewMobieTopToViewSuper.priority = PRIORITY_HIGH
            constraintViewMobileTopToViewEmail.priority = PRIORITY_LOW
        }
        else{
            
            if userInfo[RES_emailVerified] as! String == "0" {
                btnVerifyEmail.isHidden = false
                imageIconVerified.isHidden = true
            }
            else{
                btnVerifyEmail.isHidden = true
                imageIconVerified.isHidden = false
            }
            txtEmail.text = userInfo[RES_userEmailId]! as? String
            constraintViewMobieTopToViewSuper.priority = PRIORITY_LOW
            constraintViewMobileTopToViewEmail.priority = PRIORITY_HIGH
        }
    }

    
    @IBAction func btnBecomePrimeMemberAction() {
        obj_AppDelegate.onVKMenuAction(VK_MENU_TYPE.HOW_TO_EARN, categoryID: 12)
    }
    
    @IBAction func btnVerifyEmailAction() {
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_MOBILE:userInfo[RES_userMobileNo] as! String,
                      REQ_OTP_CODE:""]
        
        obj_OperationWeb.callRestApi(methodName: JEMTHOD_VerifyEmail, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            let _OTPView = OTPView(dictServicePara: params, otpType: OTP_TYPE.VERIFY_EMAIL)
            _OTPView.delegate = self
        }, onFailure: { (code, dict) in
            
        }) { let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return}
    }
    
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(CELL_IDENTIFIER_EDITPROFILE, owner: self, options: nil)?[0] as! EditProfileCell
        cell.lblTitle.text = "Change Password"
        cell.lblTitle.font = UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 15)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutIfNeeded()
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return HEIGHT_EDITPROFILE_CELL }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
        changePasswordVC.pageType = UPDATE_PASSWORD.CHANGE
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    func onOtpSuccess(_ otpType: OTP_TYPE, serviceResponse: typeAliasDictionary) {
        
        var dictUserInfo = DataModel.getUserInfo()
        dictUserInfo[RES_emailVerified] = "1" as AnyObject?
        DataModel.setUserInfo(dictUserInfo)
        btnVerifyEmail.isHidden = true
        imageIconVerified.isHidden = false
        self._KDAlertView.showMessage(message: serviceResponse[RES_message] as! String, messageType: MESSAGE_TYPE.WARNING); return;
    }

}
