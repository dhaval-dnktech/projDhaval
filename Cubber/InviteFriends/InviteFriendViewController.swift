//
//  InviteFriendViewController.swift
//  Cubber
//
//  Created by dnk on 31/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import AddressBookUI
import Contacts
import MessageUI
import Social

class InviteFriendViewController: UIViewController , UITextFieldDelegate , AppNavigationControllerDelegate , UITableViewDataSource , UITableViewDelegate ,InviteFriendContactCellDelegate, UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate{
    
    //MARK: CONSTANTS
    let CONTACT_NAME                = "CONTACT_NAME"
    let CONTACT_NUMBER              = "CONTACT_NUMBER"
    let CONTACT_EMAIL               = "CONTACT_EMAIL"
    let CONTACT_IMAGE               = "CONTACT_IMAGE"
    let IS_INVITED                  = "IS_INVITED"
    let TIME_STAMP                  = "TIME_STAMP"
    let IS_INVITED_ONCE             = "IS_INVITED_ONCE"
    
    //MARK: PROPERTIES
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewFriends: UIView!
    @IBOutlet var tableViewContacts: UITableView!
    @IBOutlet var lblInviteLink: UILabel!
    @IBOutlet var txtSearchContact: UITextField!
    @IBOutlet var lblSharingTitle: UILabel!
    @IBOutlet var lblShareDescription: UILabel!
    @IBOutlet var imageViewShareImage: UIImageView!
    @IBOutlet var constraintMainViewTopToSuperView: NSLayoutConstraint!
    @IBOutlet var constraintMainViewHeight: NSLayoutConstraint!
    @IBOutlet var viewFacebook: UIView!
    @IBOutlet var viewWhatsApp: UIView!
    @IBOutlet var viewMail: UIView!
    @IBOutlet var viewMore: UIView!
    @IBOutlet var constraintViewWhatsAppWidth: NSLayoutConstraint!
    @IBOutlet var constraintViewMailWidth: NSLayoutConstraint!
    @IBOutlet var constraintViewFacebookWidth: NSLayoutConstraint!
    @IBOutlet var constraintViewMoreWidth: NSLayoutConstraint!
    @IBOutlet var constraintBtnSendHeight: NSLayoutConstraint!
    @IBOutlet var btnInviteFriends: UIButton!
    @IBOutlet var btnSelectAll: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var lblInviteContact: UILabel!
    @IBOutlet var lblNoContactFound: UILabel!
    
    var dictWalletResponse = typeAliasDictionary()
    var isReloadView:Bool = true
    
    //MARK: VARIABLES
    fileprivate var contactList:String = ""
    fileprivate var arrContacts = [typeAliasDictionary]()
    fileprivate var arrContactSelected = [typeAliasDictionary]()
    fileprivate var arrCuberContacts = [String]()
    fileprivate var arrDisplayContacts = [typeAliasDictionary]()
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_DatabaseModel = DatabaseModel()
    fileprivate var isRefresh:Bool = false
    fileprivate var isFBInstalled:Bool = UIApplication.shared.canOpenURL(URL.init(string: "fb://")!)
    fileprivate var isWPInstalled:Bool = UIApplication.shared.canOpenURL(URL.init(string: "whatsapp://")!)
    fileprivate var dateFormatter:DateFormatter = DateFormatter()
    
    
    fileprivate var stMobileNo:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.alpha = 0
        if isFBInstalled { constraintViewFacebookWidth.constant = 60 }
        else { constraintViewFacebookWidth.constant = 0 }
        
        if isWPInstalled { constraintViewWhatsAppWidth.constant = 60 }
        else { constraintViewWhatsAppWidth.constant = 0 }
        
        tableViewContacts.tableFooterView = UIView(frame: CGRect.zero)
        tableViewContacts.rowHeight = HEIGHT_INVITEFRIEND_CONTACT_CELL
        tableViewContacts.register(UINib.init(nibName: CELL_IDENTIFIER_INVITEFRIEND_CONTACT_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_INVITEFRIEND_CONTACT_CELL)
        constraintBtnSendHeight.constant = 0
        self.setShareData()
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
        if isReloadView {
            scrollView.alpha = 1
        }
        isReloadView = false
        self.promptForAddressBookRequestAccess()
        self.SetScreenName(name: F_INVITEFRIEND, stclass: F_INVITEFRIEND)
        lblInviteLink.addDashedBorder(color: COLOUR_ORANGE)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isRefresh {
            self.appNavigationController_BackAction()
        }
    }
    
    //MARK: APPNAVIGATION METHODS
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Invite Friends")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
        self.sendScreenView(name: SCREEN_INVITEFRIEND)
    }
    
    func appNavigationController_BackAction() {
        if isRefresh {
            isRefresh = false
            self.navigationItem.setLeftBarButton(nil, animated: false)
            self.setNavigationBar()
        }
        else{
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func setShareData(){
        
        dictWalletResponse = DataModel.getUserWalletResponse()
        lblInviteLink.text = dictWalletResponse[RES_sharingLink] as? String
        lblSharingTitle.text = dictWalletResponse[RES_sharingTitle] as? String
        lblShareDescription.text = dictWalletResponse[RES_sharingDescription] as? String
        imageViewShareImage.sd_setImage(with: URL.init(string: dictWalletResponse[RES_sharingScreenImage] as! String), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, catchType, url) in
            if image == nil { self.imageViewShareImage.image = UIImage(named: "logo")}
            else { self.imageViewShareImage.image = image! }
        })
    }
    
    //MARK: CUSTOM METHODS
    
    func showContactView() {
        
        txtSearchContact.text = ""
        let frame:CGRect = CGRect.init(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.scrollView.frame.width), height: CGFloat(self.scrollView.frame.height))
        viewFriends.frame = frame
        viewFriends.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.6)
        self.view.addSubview(viewFriends)
        let _ = DesignModel.setScrollSubViewConstraint(viewFriends, superView: self.view, toView: self.view, leading: 0, trailing: 0, top: 0, bottom: 0, width: 0, height: 0)
        
        self.view.layoutIfNeeded()
        viewFriends.alpha = 0
        constraintMainViewTopToSuperView.constant = 800
        constraintMainViewTopToSuperView.constant = self.view.frame.height/2
        constraintMainViewHeight.constant = self.view.frame.height/2
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.viewFriends.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if arrDisplayContacts.filter({ (dict) -> Bool in
            return dict[IS_INVITED] as! String == "0" && dict[IS_INVITED_ONCE] as! String == "0"
        }).count == 0 {
            self.btnSelectAll.isHidden = true
        }
        self.tableViewContacts.reloadData()
    }
    
    fileprivate func setContactsData(contacts:[CNContact]) {
        
        for i in 0..<contacts.count {
            var dictContact = typeAliasDictionary()
            let con = contacts[i]
            var stPhoneNo = ""
            if !con.emailAddresses.isEmpty {
                dictContact[CONTACT_EMAIL] = con.emailAddresses.first!.value
            }
            else{ dictContact[CONTACT_EMAIL] = "" as AnyObject? }
            if con.givenName != "SPAM" {
                for label in con.phoneNumbers {
                    stPhoneNo = label.value.stringValue
                    if !stPhoneNo.isEmpty {
                        dictContact[CONTACT_NUMBER] = stPhoneNo.extractPhoneNo() as AnyObject?
                        dictContact[CONTACT_NAME] = "\(con.givenName as String) \(con.familyName)" as AnyObject?
                        contactList  = contactList == "" ? stPhoneNo : "\(contactList),\(stPhoneNo)"
                        dictContact[IS_INVITED] = "0" as AnyObject
                        dictContact[TIME_STAMP] = "0" as AnyObject
                        dictContact[IS_INVITED_ONCE] = "0" as AnyObject
                        arrContacts.append(dictContact)
                        break
                    }
                }
            }
        }
        arrDisplayContacts = arrContacts
    }
    
    func getContactFromPhoneBook() {
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactImageDataKey,
                CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
        
        if contacts.count > 0 { self.setContactsData(contacts: contacts) }
    }
    
    func getContactFromDatabase() {
        
        self.arrContacts = obj_DatabaseModel.getContactsFromContactSync()
        self.arrDisplayContacts = self.arrContacts
        if arrDisplayContacts.filter({ (dict) -> Bool in
            return dict[IS_INVITED] as! String == "0" && dict[IS_INVITED_ONCE] as! String == "0"
        }).count == 0 {
            self.btnSelectAll.isHidden = true
        }
        self.btnInviteContactAction()
    }
    
    func syncContact() {
        
        self.getContactFromPhoneBook()
        if !arrContacts.isEmpty && obj_DatabaseModel.openDatabaseConnection() {
            for dictContact in arrContacts {
                //IF CONTACT EXIST AND NOT INVITED UPDATE ALL DATA
                
                var dictContactDB: typeAliasDictionary =  obj_DatabaseModel.isContactExistInSync(stPhoneNo: dictContact[CONTACT_NUMBER] as! String)
                
                if !dictContactDB.isEmpty {
                    dictContactDB[CONTACT_NUMBER] = dictContact[CONTACT_NUMBER]
                    dictContactDB[CONTACT_EMAIL] = dictContact[CONTACT_EMAIL]
                    dictContactDB[CONTACT_NAME] = dictContact[CONTACT_NAME]
                    let timeStamp:String = dictContactDB[TIME_STAMP]! as! String
                    
                    if timeStamp != "0" && timeStamp != "" {
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.timeZone = TimeZone.current
                        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a z"
                        let date:Date = dateFormatter.date(from: timeStamp)!
                        if Calendar.current.dateComponents([.hour], from: date, to: Date()).hour! >= 24 {
                            dictContactDB[TIME_STAMP] = "0" as AnyObject
                            dictContactDB[IS_INVITED] = "0" as AnyObject
                        }
                    }
                    obj_DatabaseModel.updateUserSync(dictContact: dictContactDB)
                }
                    //INSERT CONTACT IN SYNC
                else {
                    obj_DatabaseModel.insertInContactSync(dictContact: dictContact)
                }
            }
            self.obj_DatabaseModel.closeDatabaseConnection()
        }
    }
    
    func updateInvitedContact() {
        
        if !arrContactSelected.isEmpty && obj_DatabaseModel.openDatabaseConnection() {
            for dict in arrContactSelected {
                var dictContactDB = obj_DatabaseModel.getSingleContactFromContactSync(stPhoneNo: dict[CONTACT_NUMBER]! as! String)
                dictContactDB[IS_INVITED] = "1" as AnyObject
                dictContactDB[IS_INVITED_ONCE] = "1" as AnyObject
                
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a z"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone.current
                dictContactDB[TIME_STAMP] = dateFormatter.string(from: Date()) as AnyObject
                obj_DatabaseModel.updateUserSync(dictContact: dictContactDB)
            }
            self.getContactFromDatabase()
            self.tableViewContacts.reloadData()
        }
    }
    
    func callInviteFriendService() {
        
        let arrNumbers : NSArray = arrContactSelected as NSArray
        stMobileNo = ((arrNumbers.value(forKey: CONTACT_NUMBER) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
        
        var stEmail:String = ""
        
        for dict in arrContactSelected {
            
            if dict[CONTACT_EMAIL] as! String != "" {
                stEmail = stEmail == "" ?  "\(dict[CONTACT_NUMBER]!)|\(dict[CONTACT_EMAIL]!)"  : stEmail + "," + "\(dict[CONTACT_NUMBER]!)|\(dict[CONTACT_EMAIL]!)"
            }
        }
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_INVITEFRIEND)", action: "Invite friend", label: "(UserID:\(userInfo[RES_userID] as! String),Mobile:\(stMobileNo))", value: nil)
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_USER_ID] = userInfo[RES_userID] as? String
        params[REQ_U_MOBILE] = stMobileNo
        params[REQ_U_EMAIL] = stEmail
        params[REQ_DEVICE_TYPE] = VAL_DEVICE_TYPE
        
        let parameters = params as [String : NSObject]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: parameters )
        obj_OperationWeb.callRestApi(methodName: JMETHOD_InviteFriend, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token]! as! String)
            self.updateInvitedContact()
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .SUCCESS)
            self.arrContactSelected = [typeAliasDictionary]()
            self.tableViewContacts.reloadData()
            self.updateBtnInviteContactTitle()
            return
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .FAILURE)
            return
            
        }) {   self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return  }
    }
    
    @IBAction func btnSyncContactAction() {
        DesignModel.startActivityIndicator(self.navigationController!.view)
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.syncContact()
            self.tableViewContacts.reloadData()
            self.activityIndicator.stopAnimating()
            DesignModel.stopActivityIndicator()
        }
    }
    
    
    fileprivate func filterContacts() {
        arrDisplayContacts = arrContacts
        tableViewContacts.reloadData()
    }
    
    fileprivate func serachContact(name:String) {
        self.filterContacts()
        if !name.isEmpty{
            var arrSearchedContact = [typeAliasDictionary]()
            for dict in arrContacts {
                if (dict[CONTACT_NAME] as! String).isContainString(name){arrSearchedContact.append(dict)}
            }
            arrDisplayContacts = arrSearchedContact
            tableViewContacts.reloadData()
        }
        else{ self.filterContacts() }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    func updateCounter(_ timer: Timer) {
        
        let indexPath:IndexPath = timer.userInfo as! IndexPath
        //CHECK IF ARRAY NOT OUT OF RANGE
        if arrDisplayContacts.indices ~= indexPath.row
        {
            let dictContact = self.arrDisplayContacts[indexPath.row]
            if dictContact[TIME_STAMP] as! String != "0" {
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a z"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone.current
                let dateInvited:Date = dateFormatter.date(from:  dictContact[TIME_STAMP] as! String)!
                let ti:Int = Int(Date().timeIntervalSince(dateInvited))
                let minutes:Int = 59 - ((ti / 60) % 60)
                let hours:Int = 23 - (((ti / 3600))%24)
                let seconds:Int = 59 - (ti % 60)
                
                if (hours == 0 && minutes == 0 && seconds == 0 ) || Calendar.current.dateComponents([.hour], from: dateInvited, to: Date()).hour! >= 24 { //UPDATE DATABSE AND RELOAD CONTACTS
                    if obj_DatabaseModel.openDatabaseConnection() {
                        var dictCont = obj_DatabaseModel.getSingleContactFromContactSync(stPhoneNo: dictContact[CONTACT_NUMBER] as! String)
                        dictCont[IS_INVITED] = "0" as AnyObject
                        dictCont[TIME_STAMP] = "0" as AnyObject
                        obj_DatabaseModel.updateUserSync(dictContact: dictCont)
                        obj_DatabaseModel.closeDatabaseConnection()
                        self.getContactFromDatabase()
                        self.tableViewContacts.reloadData()
                    }
                }
                else {
                    if (tableViewContacts.indexPathsForVisibleRows?.contains(indexPath))! {
                        let cell:InviteFriendContactCell = tableViewContacts.cellForRow(at: indexPath) as! InviteFriendContactCell
                        let strTime:NSMutableAttributedString = NSMutableAttributedString(string: "Expires in \n \(hours)h \(minutes)m \(seconds)s")
                        strTime.setColorForText("Expires in", with: COLOUR_DARK_GREEN)
                        cell.lblInviteTimer.attributedText = strTime
                    }
                }
            }
            
        }
    }
    
    func updateBtnInviteContactTitle() {
        
        if !arrContactSelected.isEmpty {
            btnInviteFriends.isHidden = false
            self.lblInviteContact.isHidden = false
            constraintBtnSendHeight.constant = 40
            lblInviteContact.text = "Send Invite To (\(arrContactSelected.count)) Contacts"
            if !DataModel.getUserWalletResponse().isEmpty && DataModel.getUserWalletResponse()[RES_earningFlag] as! String != "" && DataModel.getUserWalletResponse()[RES_earningFlag] as! String != "0" {
                let earningAmount = Int(DataModel.getUserWalletResponse()[RES_earningFlag] as! String)! * (arrContactSelected.count)
                lblInviteContact.text = "Send Invite To  (\(arrContactSelected.count)) Contacts \n You can earn upto \(RUPEES_SYMBOL) \(earningAmount)"
                constraintBtnSendHeight.constant = 50
            }
        }
        else {
            lblInviteContact.text = "Invite"
            btnInviteFriends.isHidden = true
            self.lblInviteContact.isHidden = true
            constraintBtnSendHeight.constant = 0
        }
    }
    
    //MARK: BUTTON METHODS
    
    @IBAction func btnSelectAllAction() {
        
        btnSelectAll.isSelected = !btnSelectAll.isSelected
        arrContactSelected =  btnSelectAll.isSelected ? arrDisplayContacts.filter({ (dict) -> Bool in
            return dict[IS_INVITED] as! String == "0" && dict[IS_INVITED_ONCE] as! String == "0"
        }) : [typeAliasDictionary]()
        self.updateBtnInviteContactTitle()
        self.tableViewContacts.reloadData()
    }
    
    @IBAction func btnInviteContactAction() {
        
        // arrContacts = [typeAliasDictionary]()
        if !arrContacts.isEmpty {
            self.showContactView()
            return
        }
        
        if #available(iOS 9.0, *) {
            let contacts: [CNContact] = {
                let contactStore = CNContactStore()
                let keysToFetch = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactImageDataKey,
                    CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey] as [Any]
                
                // Get all the containers
                var allContainers: [CNContainer] = []
                do {
                    allContainers = try contactStore.containers(matching: nil)
                } catch {
                    print("Error fetching containers")
                }
                
                var results: [CNContact] = []
                
                // Iterate all containers and append their contacts to our results array
                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    
                    do {
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                        results.append(contentsOf: containerResults)
                    } catch {
                        print("Error fetching results for container")
                    }
                }
                
                return results
            }()
            
            if contacts.count > 0 {self.setContactsData(contacts: contacts)}
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @IBAction func btnCloseFriendsViewAction() {
        viewFriends.removeFromSuperview()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.viewFriends.alpha = 0
        }) { (completed) in
            self.viewFriends.removeFromSuperview()
        }
    }
    
    @IBAction func btnInviteAction() {
        self.callInviteFriendService()
    }
    
    @IBAction func btnInviteSocialMoreAction(_ sender: UIButton) {
        if sender.tag == 0 {
            
            if isFBInstalled {
                let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
                vc?.setInitialText("\(dictWalletResponse[RES_sharing_message]!)")
                // vc?.add(URL(string: "\(dictWalletResponse[RES_sharingLink]!)"))
                if dictWalletResponse[RES_app_share_image] as! String != ""
                {
                    let url = URL(string:dictWalletResponse[RES_app_share_image] as! String)
                    let data = try? Data(contentsOf: url!)
                    let image: UIImage = UIImage(data: data!)!
                    vc?.add(image)
                }
                self.present(vc!, animated: true, completion: nil)
            }
        }
        else if sender.tag == 1 {
            
            let stMessage:String = "whatsapp://send?text=\(dictWalletResponse[RES_sharing_message] as! String)"
            let  urlString = stMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            let whatsappURL : URL = URL.init(string:urlString!)!
            if isWPInstalled {
                UIApplication.shared.openURL(whatsappURL)
            }
            
        }
        else if sender.tag == 2 {
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                //mail.setToRecipients(["care@cubber.in"])
                mail.setSubject("Hurry Up! Offer valid for limited time period")
                mail.setMessageBody("\(dictWalletResponse[RES_sharing_message]!)",isHTML: false)
                self.present(mail, animated: true)
            } else {
                _KDAlertView.showMessage(message: "Mail service is not available", messageType: MESSAGE_TYPE.FAILURE)
                return
            }
        }
        else if sender.tag == 3 {
            
            let stringText:String =  lblInviteLink.text!
            let objectToShare:[Any] = [dictWalletResponse[RES_sharing_message]!]
            let activityVC = UIActivityViewController.init(activityItems: objectToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func btnCopyLinkAction() {
        
        let paste = UIPasteboard.general
        paste.string = lblInviteLink.text
        _KDAlertView.showMessage(message: "Copied to clipboard", messageType: .SUCCESS)
        return
    }
    
    //MARK: UITABLEVIEW DATA SOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return arrDisplayContacts.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:InviteFriendContactCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_INVITEFRIEND_CONTACT_CELL, for: indexPath) as! InviteFriendContactCell
        
        cell.timer.invalidate()
        cell.timer = Timer()
        cell.delegate = self
        cell.btnInvite.accessibilityIdentifier = String(indexPath.row)
        cell.btnRemind.accessibilityIdentifier = String(indexPath.row)
        let dictContact = arrDisplayContacts[indexPath.row]
        
        
        if dictContact[IS_INVITED_ONCE] as! String == "1" && dictContact[IS_INVITED] as! String == "0" {
            cell.btnRemind.isHidden = false
            cell.btnInvite.isHidden = true
            cell.lblInviteTimer.isHidden = true
            
        }
        else  if dictContact[IS_INVITED_ONCE] as! String == "0" && dictContact[IS_INVITED] as! String == "0" {
            cell.btnRemind.isHidden = true
            cell.btnInvite.isHidden = false
            cell.lblInviteTimer.isHidden = true
            
        }
        else  if dictContact[IS_INVITED_ONCE] as! String == "1" && dictContact[IS_INVITED] as! String == "1" {
            cell.btnRemind.isHidden = true
            cell.btnInvite.isHidden = true
            cell.lblInviteTimer.isHidden = false
        }
        else  if dictContact[IS_INVITED_ONCE] as! String == "0" && dictContact[IS_INVITED] as! String == "1" {
            cell.btnRemind.isHidden = true
            cell.btnInvite.isHidden = true
            cell.lblInviteTimer.isHidden = false
        }
        
        if !cell.lblInviteTimer.isHidden && dictContact[TIME_STAMP]as! String != "0" {
            cell.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: indexPath, repeats: true)
        }
        
        if self.isSelectedContactExist(dictContact) >= 0 { cell.btnInvite.isSelected = true }
        else { cell.btnInvite.isSelected = false }
        if dictContact[CONTACT_IMAGE] != nil {
            cell.imageViewIconUser.image = dictContact[CONTACT_IMAGE] as? UIImage
        }
        else{
            cell.imageViewIconUser.image = #imageLiteral(resourceName: "icon_user")
        }
        cell.lblContactName.text = dictContact[CONTACT_NAME] as! String?
        cell.lblContactNumber.text = dictContact[CONTACT_NUMBER] as! String?
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: InviteFriendContactCell = tableView.cellForRow(at: indexPath) as! InviteFriendContactCell
        let dictContact = arrDisplayContacts[indexPath.row]
        if dictContact[IS_INVITED] as! String == "0" && dictContact[IS_INVITED_ONCE] as! String == "0" {
            self.btnInviteFriendContactCell_InviteAction(buton: cell.btnInvite)
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{return HEIGHT_INVITEFRIEND_CONTACT_CELL}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    //MARK: INVITEFRIEND CELL DELEGATE
    
    func btnInviteFriendContactCell_InviteAction(buton: UIButton) {
        
        let row: Int = Int(buton.accessibilityIdentifier!)!
        let indexPath: IndexPath = IndexPath(row: row, section: 0)
        let c_Info: typeAliasDictionary = arrDisplayContacts[indexPath.row]
        let index: Int = self.isSelectedContactExist(c_Info)
        if index >= 0 {
            arrContactSelected.remove(at: index)
        }
        else {
            arrContactSelected.append(c_Info)
        }
        self.updateBtnInviteContactTitle()
        if arrContactSelected.count == arrDisplayContacts.filter({ (dict) -> Bool in
            return dict[IS_INVITED] as! String == "0" && dict[IS_INVITED_ONCE] as! String == "0"
        }).count {
            btnSelectAll.isSelected = true
        }
        else {
            btnSelectAll.isSelected = false
        }
        tableViewContacts.reloadRows(at: [indexPath], with: .none)
    }
    
    func btnRemindFriendContactCell_InviteAction(buton: UIButton) {
        
        let row: Int = Int(buton.accessibilityIdentifier!)!
        let indexPath: IndexPath = IndexPath(row: row, section: 0)
        let c_Info: typeAliasDictionary = arrDisplayContacts[indexPath.row]
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_USER_ID] = userInfo[RES_userID]! as? String
        params[REQ_U_MOBILE] = c_Info[CONTACT_NUMBER]! as? String
        params[REQ_U_EMAIL] =  "\(c_Info[CONTACT_NUMBER]!)|\(c_Info[CONTACT_EMAIL]!)"
        params[REQ_DEVICE_TYPE] = VAL_DEVICE_TYPE
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_InviteFriend, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            if self.obj_DatabaseModel.openDatabaseConnection() {
                
                var dictContactDB = self.obj_DatabaseModel.getSingleContactFromContactSync(stPhoneNo: c_Info[self.CONTACT_NUMBER]! as! String)
                dictContactDB[self.IS_INVITED] = "1" as AnyObject
                dictContactDB[self.IS_INVITED_ONCE] = "1" as AnyObject
                self.dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a z"
                dictContactDB[self.TIME_STAMP] = self.dateFormatter.string(from: Date()) as AnyObject
                self.obj_DatabaseModel.updateUserSync(dictContact: dictContactDB)
                self.getContactFromDatabase()
                self.tableViewContacts.reloadRows(at: [indexPath], with: .none)
            }
            
            DataModel.setHeaderToken(dict[RES_token]! as! String)
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .SUCCESS)
            return
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .FAILURE)
            return
            
        }) {   self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return  }
    }
    
    func isSelectedContactExist(_ dictContactInfo: typeAliasDictionary) -> Int {
        for i in 0..<arrContactSelected.count {
            var dict: typeAliasDictionary = arrContactSelected[i]
            if dict[CONTACT_NUMBER] as! String == dictContactInfo[CONTACT_NUMBER] as! String {
                return i
            }
        }
        return -1
    }
    
    
    //MARK: TEXTFEILD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSearchContact {
            constraintMainViewTopToSuperView.constant = 0
            constraintMainViewHeight.constant = self.view.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSearchContact {
            constraintMainViewTopToSuperView.constant = self.view.frame.height/2
            constraintMainViewHeight.constant = self.view.frame.height/2
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            txtSearchContact.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
         
        if textField.isEqual(txtSearchContact){self.serachContact(name: resultingString == "" ? ""  : resultingString)}
        
        return true
    }
    
    // MARK: SCROLLVIEW DELAGATE
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableViewContacts.contentOffset.y > 0 {
            constraintMainViewTopToSuperView.constant = 0
            constraintMainViewHeight.constant = self.view.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if tableViewContacts.contentOffset.y < 0 {
            constraintMainViewTopToSuperView.constant = self.view.frame.height/2
            constraintMainViewHeight.constant = self.view.frame.height/2
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    fileprivate func promptForAddressBookRequestAccess() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (granted, error) in
                if granted {
                    print("Permission allowed")
                    DispatchQueue.main.async { DesignModel.startActivityIndicator(self.navigationController!.view)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self.syncContact()
                            self.getContactFromDatabase()
                            self.tableViewContacts.reloadData()
                            DesignModel.stopActivityIndicator()
                        }
                        
                    }
                } else {
                    print("Permission denied")
                }
            }
        case .restricted, .denied:
            print("Unauthorized")
            
        case .authorized:
            print("Authorized")
            DispatchQueue.main.async { DesignModel.startActivityIndicator(self.navigationController!.view)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    if self.self.obj_DatabaseModel.getContactsFromContactSync().isEmpty {
                        self.syncContact()
                    }
                    self.getContactFromDatabase()
                    self.tableViewContacts.reloadData()
                    DesignModel.stopActivityIndicator()
                }
            }
        }
    }
    
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

