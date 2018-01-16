//
//  RegisterProblemViewController.swift
//  Cubber
//
//  Created by dnk on 09/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class RegisterProblemViewController: UIViewController , UIImagePickerControllerDelegate , UITextFieldDelegate , UINavigationControllerDelegate, AppNavigationControllerDelegate ,  UITextViewDelegate  {

    //MARK: PROPERTIES
    
    @IBOutlet var viewLabel: UIView!
    
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var lblItemTitle: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewItem: UIImageView!
    @IBOutlet var btnStatus: UIButton!
    @IBOutlet var txtUploadImage: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtSelectPartner: UITextField!
    @IBOutlet var txtViewDescription: FloatLabelTextView!

    @IBOutlet var textFieldCollection: [UITextField]!
     @IBOutlet var viewOrderDetail: UIView!
    @IBOutlet var viewImageBG: UIView!
    @IBOutlet var constraintViewLabelBottom: NSLayoutConstraint!
    @IBOutlet var constraintViewOrderDetailBottom: NSLayoutConstraint!
    @IBOutlet var constraintLblQueryTopToSuper: NSLayoutConstraint!
    @IBOutlet var constraintLblQueryTopToSelectPartner: NSLayoutConstraint!
    @IBOutlet var viewSelectPartner: UIView!
    
    
    //MARK: VARIABLES
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _KDAlertView = KDAlertView()
    internal var OrderItems = typeAliasDictionary()
    internal var orderTypeId:String = ""
    var stDescription:String = ""
    var stEmail:String = ""
    var isExistingOrder:String = "1"
    var stOrderID:String = ""
    let imagePicker = UIImagePickerController()
    var descImage:UIImage!
    fileprivate var stPartnerID :String = ""
    fileprivate var stPartnerName:String = "Select Partner"
    fileprivate var arrPartnerListSelected = [typeAliasDictionary]()
    fileprivate var arrPartnerList = [typeAliasDictionary]()
    var dictSelectedPartner = typeAliasDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if orderTypeId != "11" && orderTypeId != "13" {
            
            self.viewImageBG.layer.borderWidth = 1.0
            self.viewImageBG.layer.cornerRadius = 30
            self.viewImageBG.layer.borderColor = COLOUR_DARK_GREEN.cgColor
            stOrderID = OrderItems[RES_orderID] as! String
            setOrderData()
            viewSelectPartner.isHidden = true
            txtSelectPartner.isHidden = true
            viewOrderDetail.isHidden = false
            viewLabel.isHidden = true
            constraintViewLabelBottom.priority = 850
            constraintViewOrderDetailBottom.priority = 950
        }
        else{
            
            if orderTypeId == "13" {
                if DataModel.getStatusList().isEmpty {
                 self.callOrderStatusList()
                }
                else {
                  arrPartnerList = DataModel.getPartnerList()
                }
                constraintLblQueryTopToSuper.priority = PRIORITY_LOW
                constraintLblQueryTopToSelectPartner.priority = PRIORITY_HIGH
                txtSelectPartner.isHidden = false
                viewSelectPartner.isHidden = false
                
               }
            else {
                viewSelectPartner.isHidden = true
                txtSelectPartner.isHidden = true
                constraintLblQueryTopToSuper.priority = PRIORITY_HIGH
                constraintLblQueryTopToSelectPartner.priority = PRIORITY_LOW
            }
            isExistingOrder="0"
            viewOrderDetail.isHidden = true
            viewLabel.isHidden = false
            constraintViewLabelBottom.priority = 950
            constraintViewOrderDetailBottom.priority = 850
           
        }
        let dictUser = DataModel.getUserInfo()
        txtEmail.text = dictUser[RES_userEmailId] as! String?
        self.view.layoutIfNeeded()
        
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: SCREEN_ORDERPROBLEM)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
        self.SetScreenName(name: F_ORDERPROBLEM, stclass: F_ORDERPROBLEM)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //MARK: KEYBOARD
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal func keyboardWasShown(_ aNotification: Notification) {
        let info: [AnyHashable: Any] = (aNotification as NSNotification).userInfo!;
        var keyboardRect: CGRect = ((info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
        keyboardRect = self.view.convert(keyboardRect, from: nil);
        
        var contentInset: UIEdgeInsets = scrollViewBG.contentInset
        contentInset.bottom = keyboardRect.size.height
        scrollViewBG.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollViewBG.contentInset = UIEdgeInsets.zero
            }, completion: nil)
    }

    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
       
        var title = ""
        if orderTypeId != "11" && orderTypeId != "13"{
            title = "Order #\(stOrderID)"
        }
        else{
            title = "Contact Us"
        }
        obj_AppDelegate.navigationController.setCustomTitle(title)
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setOrderData()
    {
        lblItemTitle.text = OrderItems[RES_title] as! String?
        btnStatus.setTitle(OrderItems[RES_orderStatus]?.uppercased , for: .normal
        )
        imageViewItem.sd_setImage(with: (OrderItems[RES_image] as! String).convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
            { (receivedSize, expectedSize) in self.activityIndicator.startAnimating() })
        { (image, error, cacheType, imageURL) in
            
            if image == nil { self.imageViewItem.image = UIImage(named: "logo") }
            else { self.imageViewItem.image = image! }
            self.activityIndicator.stopAnimating()
        }
        self.view.layoutIfNeeded()
        self.scrollViewBG.layoutIfNeeded()
        self.viewOrderDetail.layoutIfNeeded()
    }
    
    func callOrderStatusList()
    {
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken()]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateStatus_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            self.arrPartnerList = dict[RES_partnerList] as! [typeAliasDictionary]
            DataModel.setPartnerList(array: dict[RES_partnerList] as! [typeAliasDictionary])
            DataModel.setStatusList(array: dict[RES_statusList] as! [typeAliasDictionary])
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrPartnerList = DataModel.getPartnerList()
            
        }, onFailure: { (code, dict) in
        }, onTokenExpire: {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        })
        
    }
    
    fileprivate func hideKeyBoard() {
        for txt in textFieldCollection{txt.resignFirstResponder()}
        txtViewDescription.resignFirstResponder()
    }
    
    @IBAction func btnSubmitAction() {
        
        stDescription = (txtViewDescription.text?.trim())!
        stEmail = (txtEmail.text?.trim())!
        
        if orderTypeId == "13" &&  stPartnerID == "" {
        _KDAlertView.showMessage(message: MSG_SEL_PARTNER_ID, messageType: MESSAGE_TYPE.WARNING); return;
        }
        
        
        if stDescription == "Description" || stDescription == "" {
        _KDAlertView.showMessage(message: MSG_TXT_DESCRIPTION, messageType: MESSAGE_TYPE.WARNING); return;
        }
        
        if stEmail.isEmpty {
            if stEmail.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_EMAIL, messageType: MESSAGE_TYPE.WARNING); return;
            }
        }
        else {
            if stEmail.isNumeric() {
                if !DataModel.validateMobileNo(stEmail) { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.WARNING); return;
                }
            }
            else {
                if !stEmail.characters.isEmpty && !DataModel.validateEmail(stEmail) { _KDAlertView.showMessage(message: MSG_TXT_EMAIL_VALID, messageType: MESSAGE_TYPE.FAILURE); return;
                }
            }
        }
         self.hideKeyBoard()
        let para = [RES_userId:DataModel.getUserInfo()[RES_userID]!,
                    RES_emailId:stEmail,
                    FIR_SELECT_CONTENT:"Register Problem"] as [String : Any]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: para as! [String : NSObject])
            callRegisterProblemService()
       
    }
    
   
    
    fileprivate func callRegisterProblemService() {
        
        let dictUser = DataModel.getUserInfo()
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_PROBLEM_DESC:stDescription,
                      REQ_IS_EXISTING_ORDER:isExistingOrder,
                      REQ_ORDER_ID:stOrderID,
                      REQ_USER_ID:dictUser[RES_userID] as! String ,
                      REQ_U_EMAIL:stEmail,
                      REQ_ORDER_TYPE_ID:orderTypeId,
                      REQ_U_IMAGE:  descImage == nil ? "" : descImage.base64(format: .JPEG(0.5))
                      ] as [String : Any]
        if orderTypeId == "13" {
            params[REQ_PARTNER_ID] = stPartnerID
        }
        obj_OperationWeb.callRestApi(methodName: JMETHOD_registerProblem, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            for txt in self.textFieldCollection{txt.text = ""}
            self.txtViewDescription.text = ""
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: MESSAGE_TYPE.WARNING); return;
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.FAILURE); return;
        }) {   let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return     }
        
         }
    
    // MARK: - UIIMAGE PICKER DELEGATE
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            descImage = pickedImage
            let imagePath:URL = info["UIImagePickerControllerReferenceURL"] as! URL
            let imageName:String = imagePath.lastPathComponent
            txtUploadImage.text = imageName
        }
        dismiss(animated: true, completion: nil)
        txtUploadImage.layer.borderColor = UIColor.gray.cgColor
    }
    
   //MARK:TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtSelectPartner {
            self.hideKeyBoard()
            let dkSelection:DKSelectionView = DKSelectionView.init(frame:  UIScreen.main.bounds, arrRegion: arrPartnerList, title: "Partner", dictKey: [VK_UNIQUE_KEY:RES_partnerId,VK_VALUE_KEY:RES_partnerName])
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                self.dictSelectedPartner = dictOption
                self.txtSelectPartner.text = dictOption[RES_partnerName] as! String?
                self.stPartnerName = (self.txtSelectPartner.text?.trim())!
                    self.stPartnerID = self.dictSelectedPartner[RES_partnerId] as! String
                }
            })
            return false
        }
        
        if (textField.isEqual(txtUploadImage))
         {
            self.hideKeyBoard()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
            return false;
        }
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         if textField.isEqual(txtEmail){
            txtEmail.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField.isEqual(txtEmail){
            txtEmail.resignFirstResponder()
        }
        return true
    }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
   }
