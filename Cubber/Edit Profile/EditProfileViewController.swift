//
//  EditProfileViewController.swift
//  Cubber
//
//  Created by dnk on 02/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController, VKAlertActionViewDelegate, VKDatePopoverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AppNavigationControllerDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtDOB: UITextField!
    @IBOutlet var btnGenderCollection: [UIButton]!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var lblLoginInfo_name : UILabel!
    @IBOutlet var imageViewProfile: UIImageView!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var userInfo = typeAliasDictionary()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate let obj_OperationWeb = OperationWeb()
    var _VKDatePopover = VKDatePopOver()
    fileprivate var _vkAlertActionView = VKAlertActionView()
    fileprivate let DOB_DATE_FORMATE = "yyyy-MM-dd"
    var dateFromSelected, selectedToDate: String!
    var profileImage = UIImage()
    var stImage = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        _vkAlertActionView.delegate = self
        self.setLoginInfo()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: EDITPROFILE)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
        self.SetScreenName(name: F_EDITPROFILE, stclass: F_EDITPROFILE)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_EDITPROFILE, stclass: F_ACCOUNT)
    }
    
    //MARK: KEYBOARD
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal func keyboardWasShown(_ aNotification: Notification) {
        let info: [AnyHashable: Any] = (aNotification as NSNotification).userInfo!;
        var keyboardRect: CGRect = ((info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
        keyboardRect = self.view.convert(keyboardRect, from: nil);
        
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardRect.size.height
        scrollView.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollView.contentInset = UIEdgeInsets.zero
        }, completion: nil)
    }

    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Edit Profile")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setRighButton("Done")
        obj_AppDelegate.navigationController.navigationDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func appNavigationController_RightMenuAction() {
        
        self.hideKeyboard()
        let stFirstName: String = txtFirstName.text!.trim()
        let stLastName: String = txtLastName.text!.trim()
        let stEmailId: String = txtEmail.text!.trim()
        let stMobileNo: String = txtMobileNo.text!.trim()
        let stDob: String = txtDOB.text!.trim()
        let stGender: String = btnMale.isSelected == true ? "0" : "1"
        
        if stFirstName.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_FIRST_NAME, messageType: MESSAGE_TYPE.WARNING); return;
        }
        //if !stEmailId.characters.isEmpty && !DataModel.validateEmail(stEmailId) { VKToast.showToast(MSG_TXT_EMAIL_VALID, toastType: VKTOAST_TYPE.FAILURE); return; }
        if stMobileNo.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: MESSAGE_TYPE.WARNING); return;
        }
        else if !DataModel.validateMobileNo(stMobileNo) { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.WARNING); return;
        }
        
        let params = [RES_userId:DataModel.getUserInfo()[RES_userID]!,
                      FIR_SELECT_CONTENT:"Edit Profile"] as [String : Any]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: params as! [String : NSObject])
        self.callUpdateProfileService(stMobileNo, emailId: stEmailId, fname: stFirstName, lname: stLastName, dob: stDob, gender: stGender)
    }
    
    fileprivate func setLoginInfo() {
        userInfo = DataModel.getUserInfo()
        txtMobileNo.text = userInfo[RES_userMobileNo] as! String?
        let stDOB: String = userInfo[RES_userDOB] as! String
        txtDOB.text = stDOB == "0000-00-00" ? "" : stDOB
        let gender : String = userInfo[RES_userSex] as! String
        btnMale.isSelected = gender == "0" ? true : false
        btnFemale.isSelected = gender == "0" ? false : true
        
        if !(userInfo[RES_userProfileImage] as! String).isEmpty{
            let sturl = userInfo[RES_userProfileImage] as! String
            imageViewProfile.sd_setImage(with: NSURL.init(string: sturl) as URL!, placeholderImage: UIImage(named: "icon_user"))
            imageViewProfile.isHidden = false
            lblLoginInfo_name.isHidden = true
        }
        else{
            lblLoginInfo_name.isHidden = false
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
        lblLoginInfo_name.text = stFN + stLN
        txtFirstName.text = stFirstName
        txtLastName.text = stLastName
        
        if userInfo[RES_userEmailId] as! String == "" {
            txtEmail.isUserInteractionEnabled = true
        }
        else{
            txtEmail.isUserInteractionEnabled = true
        }
        txtEmail.text = userInfo[RES_userEmailId] as! String?
        
    }

    
    
    @IBAction func btnGender_Action(_ sender: UIButton) {
        for btn in btnGenderCollection { btn.isSelected = false }
        sender.isSelected = true
    }
    
    fileprivate func hideKeyboard() {
        txtMobileNo.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtFirstName.resignFirstResponder()
        txtDOB.resignFirstResponder()
        
    }
    
    fileprivate func callUpdateProfileService(_ mobileNo: String, emailId: String, fname: String, lname: String, dob: String, gender: String) {
        
        
        let userId : String = userInfo[RES_userID] as! String
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_FNAME:fname,
                      REQ_U_LNAME:lname,
                      REQ_U_EMAIL:emailId,
                      REQ_GENDER:gender,
                      REQ_U_MOBILE:mobileNo,
                      REQ_USER_DOB:dob,
                      REQ_USER_ID:userId,
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_U_IMAGE:stImage]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_updateProfile, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            
            var dictUserInfo: typeAliasDictionary = dict[RES_EditProfile]![RES_user_info] as! typeAliasDictionary
            dictUserInfo[RES_userID] = dictUserInfo["userId"]
            dictUserInfo.removeValue(forKey: "userId")
            DataModel.setUserInfo(dictUserInfo)
            let _ = self.navigationController?.popViewController(animated: true)
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.FAILURE); return;
        }) {
             self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        }
    }
    
    @IBAction func btnUpdateProfileImageAction(_ sender: UIButton) {
        _vkAlertActionView.showAlertView(["Take Photo","Photo Library","Cancel"], message: "", isIncludeCancelButton: true, alertType: ALERT_TYPE.DUMMY)
        _vkAlertActionView.delegate = self

    }
    
    
    @IBAction func btnUpdateProfileImageAction(sender:UIButton) {
        
            }

    
    //MARK: UITEXTFIELD DELEGATE

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName { txtLastName.becomeFirstResponder() }
        else if textField == txtLastName {
            if txtEmail.isUserInteractionEnabled { txtEmail.becomeFirstResponder()  }
            else{txtLastName.resignFirstResponder() } }
        else if textField == txtEmail { txtEmail.resignFirstResponder()}
        else { textField.resignFirstResponder()}
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == txtDOB {
            self.hideKeyboard()
            self.showDateSelectionPopover(txtDOB)
            return false
        }
        return true
    }

    
    func showDateSelectionPopover(_ textField: UITextField) {
        
        let date = NSDate()
        let stdate : String = textField.text != nil ? textField.text! : VKDatePopOver.getDate(VKDateFormat.YYYYMMDD, date: date as Date)
        let maxDate:String = VKDatePopOver.getDate(VKDateFormat.YYYYMMDD, date: Date())
        self._VKDatePopover.initSetFrame(stdate, mininumDate: "", maximumDate: maxDate, dateFormat: VKDateFormat.YYYYMMDD, dateType: DATE_TYPE.DATE_BIRTHDATE, isOutSideClickedHidden: false , isShowCancel:false)
        
        self._VKDatePopover.delegate = self
        self.navigationController!.view.addSubview(_VKDatePopover)
    }
    
    //MARK: VKDATEPOPOVER DELEGATE
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String, dateType: DATE_TYPE, dateFormat: DateFormatter) {
        txtDOB.text = strDate
        dateFromSelected = strDate
    }
    
    func vkDatePopoverClearDate(_ dateType: DATE_TYPE) {
        txtDOB.text = ""
        dateFromSelected = ""
    }
    
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String) {
        txtDOB.text = strDate
        selectedToDate = strDate
    }
    
    //MARK: VK ALERT ACTION DELEGATE
    
    func vkActionSheetAction(_ actionSheetType: ACTION_SHEET_TYPE, buttonIndex: Int, buttonTitle: String) {
        
    }
    
    func vkYesNoAlertAction(_alertType: ALERT_TYPE, buttonIndex: Int, buttonTitle: String) {
        
        switch buttonTitle {
        case "Take Photo":
            let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true, completion: { (image, asset) in
                if image != nil{
                    self.imageViewProfile.image = image
                    self.profileImage = image!
                    self.imageViewProfile.isHidden = false
                    self.lblLoginInfo_name.isHidden = true
                    self.stImage = (self.profileImage.base64(format: ImageFormat.JPEG(0.5)))
                }
                self.dismiss(animated: true, completion: nil)
            })
                
           
            present(cameraViewController, animated: true, completion: nil)
            break
        case "Photo Library":
           
            let imagePickerViewController = CameraViewController.imagePickerViewController(croppingEnabled: true, completion: { (image, asset) in
                if image != nil{
                    self.imageViewProfile.image = image
                    self.profileImage = image!
                    self.imageViewProfile.isHidden = false
                    self.lblLoginInfo_name.isHidden = true
                    self.stImage = (self.profileImage.base64(format: ImageFormat.JPEG(0.5)))
                }
                self.dismiss(animated: true, completion: nil)
            })
                
                /*CameraViewController.imagePickerViewController(croppingParameters: CroppingParameters.init(isEnabled: true, allowResizing: false, allowMoving: false, minimumSize: CGSize(width: 100, height: 100)), completion: { (image, asset) in
                if image != nil{
                    self.imageViewProfile.image = image
                    self.profileImage = image!
                    self.imageViewProfile.isHidden = false
                    self.lblLoginInfo_name.isHidden = true
                    self.stImage = (self.profileImage.base64(format: ImageFormat.JPEG(0.5)))
                }
                self.dismiss(animated: true, completion: nil)
            })*/
            present(imagePickerViewController, animated: true, completion: nil)
            
            break
        default:
            break
        }
    }

    
}
