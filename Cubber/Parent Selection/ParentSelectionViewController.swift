//
//  ParentSelectionViewController.swift
//  Cubber
//
//  Created by dnk on 02/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import AddressBookUI
import Contacts

protocol ParentSelectionDelegate {
    func onParentSelection(_ stParentMobileNo: String)
}

class ParentSelectionViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , AppNavigationControllerDelegate, RequestedContactCellDelegate, PhoneContactCellDelegate{
    
    //MARK: PROPERTIES
    @IBOutlet var btnSegment_ContactBook: UIButton!
    @IBOutlet var btnSegment_RequestContact: UIButton!
    @IBOutlet var viewContactBook: UIView!
    @IBOutlet var viewRequestContact: UIView!
    @IBOutlet var tableViewPhoneContact: UITableView!
    @IBOutlet var tableViewRequested_Friend: UITableView!
    @IBOutlet var lblRequested_NotAvailable: UILabel!
    @IBOutlet var lblPhoneContact_NotAvailable: UILabel!
    @IBOutlet var activityIndicatorRequested_Progress: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorPhoneContact_Progress: UIActivityIndicatorView!
    var delegate: ParentSelectionDelegate! = nil
    var stMobileNo: String = ""

    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var arrMenu = [typeAliasDictionary]()
    fileprivate var dictAdmin: typeAliasDictionary!
    fileprivate var arrRequestedContact = [typeAliasDictionary]()
    fileprivate var arrRequestedContactSelected = [typeAliasDictionary]()
    fileprivate var arrPhoneContact = [typeAliasDictionary]()
    fileprivate var arrPhoneContactInCubber = [typeAliasDictionary]()
    fileprivate var arrPhoneContactInCubberSelected = [typeAliasDictionary]()
    fileprivate var isContactSyncServiceCall: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewRequested_Friend.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewRequested_Friend.register(UINib.init(nibName: CELL_IDENTIFIER_REQUESTED_CONTACT, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_REQUESTED_CONTACT)
        
        self.tableViewPhoneContact.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewPhoneContact.register(UINib.init(nibName: CELL_IDENTIFIER_PHONE_CONTACT, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_PHONE_CONTACT)
        self.segment_contactBook_RequestContactAction(btnSegment_ContactBook)
        self.callRequestContactService()
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
        self.SetScreenName(name: F_SELECTPARENT, stclass: F_SELECTPARENT)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {

        obj_AppDelegate.navigationController.setCustomTitle("Select Parent")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func appNavigationController_RightMenuAction() {
        if btnSegment_ContactBook.isSelected {
            if arrPhoneContactInCubberSelected.isEmpty { return }
            self.delegate.onParentSelection(self.arrPhoneContactInCubberSelected.last![LIST_ID] as! String)
        }
        else{
            if arrRequestedContactSelected.isEmpty { return }
            self.delegate.onParentSelection(self.arrRequestedContactSelected.last![RES_mobileNo] as! String)
            
        }
        let _ = self.navigationController?.popViewController(animated: true)
    }


    @IBAction func segment_contactBook_RequestContactAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            btnSegment_ContactBook.isSelected = true
            btnSegment_RequestContact.isSelected = false
            btnSegment_ContactBook.backgroundColor = COLOUR_ORANGE
            btnSegment_ContactBook.setTitleColor(UIColor.white, for: .normal)
            btnSegment_RequestContact.backgroundColor = UIColor.white
            btnSegment_RequestContact.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
            viewContactBook.isHidden = false
            viewRequestContact.isHidden = true
            
                let contacts: [CNContact] = {
                    let contactStore = CNContactStore()
                    let keysToFetch = [
                        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                        CNContactImageDataKey,
                        CNContactPhoneNumbersKey] as [Any]
                    
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
                self.arrPhoneContactInCubberSelected.removeAll()
                tableViewPhoneContact.reloadData()
            
        }
        else{
            btnSegment_ContactBook.isSelected = false
            btnSegment_RequestContact.isSelected = true
            btnSegment_RequestContact.backgroundColor = COLOUR_ORANGE
            btnSegment_RequestContact.setTitleColor(UIColor.white, for: .normal)
            btnSegment_ContactBook.backgroundColor = UIColor.white
            btnSegment_ContactBook.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
            viewContactBook.isHidden = true
            viewRequestContact.isHidden = false
             self.arrRequestedContactSelected.removeAll()
            tableViewRequested_Friend.reloadData()
        }

    }
    
    fileprivate func callRequestContactService() {
        self.activityIndicatorRequested_Progress.startAnimating()
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_MOBILE:stMobileNo]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_InvitedFriendList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: UIView.init(), onSuccess: { (dict) in
            self.activityIndicatorRequested_Progress.stopAnimating()
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.dictAdmin = dict[RES_default_user] as! typeAliasDictionary
            // self.lblRequested_AdminName.text = self.dictAdmin[RES_fullName] as? String
            // self.lblRequested_AdminContact.text = self.dictAdmin[RES_mobileNo] as? String
            self.arrRequestedContact = dict[RES_data] as! Array<typeAliasDictionary>
            self.tableViewRequested_Friend.reloadData()
            self.lblRequested_NotAvailable.isHidden = true
        }, onFailure: { (code, dict) in
            self.activityIndicatorRequested_Progress.stopAnimating()
        }) { self.activityIndicatorRequested_Progress.stopAnimating()
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        }
    }
    
    fileprivate func callSynchronizeContactService() {
        if !isContactSyncServiceCall {
            self.activityIndicatorPhoneContact_Progress.startAnimating()
            
            let arrContact: NSArray = self.arrPhoneContact as NSArray
            let stMobileNo: String = ((arrContact.value(forKey: LIST_ID) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            
            let params = [REQ_HEADER:DataModel.getHeaderToken(),
                          REQ_CONCAT_LIST:stMobileNo]
            
            obj_OperationWeb.callRestApi(methodName: JMETHOD_SynchronizeBook, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: UIView.init(), onSuccess: { (dict) in
                DataModel.setHeaderToken(dict[RES_token] as! String)
                
                let arrCubberContact: Array<String> = dict[RES_cubberContact] as! Array<String>
                
                for stConactNo in arrCubberContact {
                    for i in 0..<self.arrPhoneContact.count {
                        if stConactNo as String == self.arrPhoneContact[i][LIST_ID] as! String {
                            self.arrPhoneContactInCubber.append(self.arrPhoneContact[i])
                            self.arrPhoneContact.remove(at: i)
                            break
                        }
                    }
                }
                self.tableViewPhoneContact.reloadData()
                self.lblPhoneContact_NotAvailable.isHidden = true
                self.activityIndicatorPhoneContact_Progress.stopAnimating()
            }, onFailure: { (code, dict) in
                self.activityIndicatorPhoneContact_Progress.stopAnimating()
                 self.lblPhoneContact_NotAvailable.isHidden = false
                self.lblPhoneContact_NotAvailable.text = dict[RES_message] as? String
            }, onTokenExpire: {   self.activityIndicatorPhoneContact_Progress.stopAnimating()
                let _KDAlertView = KDAlertView()
                _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
            })
            isContactSyncServiceCall = true
        }
    }

    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  return tableView == tableViewRequested_Friend ? self.arrRequestedContact.count : self.arrPhoneContactInCubber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewRequested_Friend {
            let cell: RequestedContactCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_REQUESTED_CONTACT) as! RequestedContactCell;
            cell.delegate = self
            
            let dict: typeAliasDictionary = self.arrRequestedContact[(indexPath as NSIndexPath).row]
            
            /*if !self.arrRequestedContactSelected.isEmpty {
                let dictSelected: typeAliasDictionary = self.arrRequestedContactSelected.last!
                if dictSelected[RES_userID] as! String == dict[RES_userID] as! String{ cell.btnCheckBox.isSelected = true }
                else { cell.btnCheckBox.isSelected = false }
            }
            else { cell.btnCheckBox.isSelected = false }*/
            
            cell.btnCheckBox.accessibilityIdentifier = String((indexPath as NSIndexPath).row)
            
            cell.lblMobileNo.text = dict[RES_mobileNo] as? String
            cell.lblName.text = dict[RES_fullName] as? String
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if tableView == tableViewPhoneContact {
            let cell: PhoneContactCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PHONE_CONTACT) as! PhoneContactCell;
            cell.delegate = self;
            
            let dict: typeAliasDictionary = self.arrPhoneContactInCubber[(indexPath as NSIndexPath).row]
            
           /* if !self.arrPhoneContactInCubberSelected.isEmpty {
                let dictSelected: typeAliasDictionary = self.arrPhoneContactInCubberSelected.last!
                if dictSelected[LIST_ID] as! String == dict[LIST_ID] as! String{ cell.btnCheckBox.isSelected = true }
                else { cell.btnCheckBox.isSelected = false }
            }
            else { cell.btnCheckBox.isSelected = false }*/
            
            cell.btnCheckBox.accessibilityIdentifier = String((indexPath as NSIndexPath).row)
            
            cell.lblMobileNo.text = dict[LIST_ID] as? String
            cell.lblName.text = dict[LIST_TITLE] as? String
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        return UITableViewCell.init()
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return tableView == tableViewRequested_Friend ? HEIGHT_PHONE_CONTACT_CELL : HEIGHT_PHONE_CONTACT_CELL
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewRequested_Friend {
            let cell: RequestedContactCell = tableView.cellForRow(at: indexPath) as! RequestedContactCell
            self.btnRequestedContactCell_CheckBoxAction(cell.btnCheckBox)
        }
        else {
            let cell: PhoneContactCell = tableView.cellForRow(at: indexPath) as! PhoneContactCell
            self.btnPhoneContactCell_CheckBoxAction(cell.btnCheckBox)
        }
    }
    
    //MARK: REQUESTED CONTACT CELL DELEGATE
    func btnRequestedContactCell_CheckBoxAction(_ button: UIButton) {
        let index: Int = Int(button.accessibilityIdentifier!)!
        self.arrRequestedContactSelected.removeAll()
        self.arrRequestedContactSelected = [arrRequestedContact[index]]
        self.appNavigationController_RightMenuAction()
    }
    
    //MARK: PHONE CONTACT CELL DELEGATE
    func btnPhoneContactCell_CheckBoxAction(_ button: UIButton) {
        let index: Int = Int(button.accessibilityIdentifier!)!
        self.arrPhoneContactInCubberSelected.removeAll()
        self.arrPhoneContactInCubberSelected = [arrPhoneContactInCubber[index]]
        self.appNavigationController_RightMenuAction()
    }
    
    
    //MARK: CUSTOM METHODS
    @available(iOS 9.0, *)
    fileprivate func setContactsData(contacts:[CNContact]) {
        
        for i in 0..<contacts.count {
            var dictContact = typeAliasDictionary()
            let con = contacts[i]
            var stPhoneNo = ""
            if con.givenName != "SPAM" {
                for label in con.phoneNumbers {
                    stPhoneNo = label.value.stringValue
                    if !stPhoneNo.isEmpty {
                        dictContact[LIST_ID] = stPhoneNo.extractPhoneNo() as AnyObject?
                        dictContact[LIST_TITLE] = "\(con.givenName as String) \(con.familyName)" as AnyObject?
                        arrPhoneContact.append(dictContact)
                        break
                    }
                }
            }
        }
        self.callSynchronizeContactService()
    }

}
