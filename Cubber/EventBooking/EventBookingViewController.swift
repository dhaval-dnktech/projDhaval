//
//  EventBookingViewController.swift
//  Cubber
//
//  Created by dnk on 13/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

let KEY_QUANTITY = "KEY_QUANTITY"

class EventBookingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EventPackageCellDelegate, AppNavigationControllerDelegate {
    
    //MARK:PROPERTIES
    
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblVenueTitle: UILabel!
    @IBOutlet var lblVenueAddress: UILabel!
    @IBOutlet var collectionViewDate: UICollectionView!
    @IBOutlet var collectionViewTime: UICollectionView!
    @IBOutlet var tableViewPackage: UITableView!
    @IBOutlet var constraintTableViewPackageHeight: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    internal var dictEventDetail = typeAliasDictionary()
    internal var arrPackageData = [typeAliasDictionary]()
    internal var arrPackageDataSelected = [typeAliasDictionary]()
    fileprivate var arrTimeList = [String]()
    fileprivate var timeSelected:String = ""
    internal var operatorID:String = ""
    fileprivate var arrPassData = [typeAliasDictionary]()
    var totalAmt : Double = Double()
    var stQty: String = ""
    var isReload:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isReload = true
        viewBG.alpha = 0
        
        self.collectionViewTime.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_BOOKTIME_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_EVENT_BOOKTIME_CELL)
        self.collectionViewDate.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_BOOKDATE_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_EVENT_BOOKDATE_CELL)
        tableViewPackage.tableFooterView = UIView.init(frame: CGRect.zero)
        tableViewPackage.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_PACKAGE_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_EVENT_PACKAGE_CELL)
        tableViewPackage.estimatedRowHeight = HEIGHT_EVENT_PACKAGE_CELL
        
        self.manageEventBookData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
           }
    
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Book Tickets")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func callCheckTicketService(){
        
        var arrTicketData:[typeAliasStringDictionary] = [typeAliasStringDictionary]()
        for dict in arrPassData {
            if dict[KEY_QUANTITY]as! String != "0" {
            var ticketData = typeAliasStringDictionary()
            ticketData[REQ_PACKAGE_ID] = dict[RES_packageID]! as? String
            ticketData[REQ_QUANTITY] = dict[KEY_QUANTITY]! as? String
                arrTicketData.append(ticketData)
            }
        }

        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_USER_ID] = DataModel.getUserInfo()[RES_userID]! as? String
        params[REQ_OPERATOR_ID] = self.operatorID
        params[REQ_TICKET_DATA] = arrTicketData.convertToJSonString()
        obj_OperationWeb.callRestApi(methodName: JMETHOD_CheckTickets, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            let eventBookInfoVC = EventBookInfoViewController(nibName: "EventBookInfoViewController", bundle: nil)
            eventBookInfoVC.arrPassData = self.arrPassData
            eventBookInfoVC.stVenue = self.self.lblVenueTitle.text!
            eventBookInfoVC.operatorID = self.operatorID
            eventBookInfoVC.dictEventDetail = self.dictEventDetail
            eventBookInfoVC.arrPackageDataSelected = self.arrPackageDataSelected
            eventBookInfoVC.selectedTime = self.timeSelected
            
            let _gtmModel = GTMModel()
            _gtmModel.ee_type = GTM_EVENT
            _gtmModel.name = GTM_EVENT_BOOKING
            _gtmModel.price = self.dictEventDetail[RES_price] as! String
            _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            _gtmModel.brand = self.dictEventDetail[RES_operatorName] as! String
            _gtmModel.category = self.dictEventDetail[RES_venue] as! String
            _gtmModel.variant = self.operatorID
            _gtmModel.dimension4 = "0"
            _gtmModel.dimension3 = "0"
            _gtmModel.list = "Event Section"
            GTMModel.pushAddToCart(gtmModel: _gtmModel)
            
            self.navigationController?.pushViewController(eventBookInfoVC, animated: true)
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
            return
        }) {
            self._KDAlertView.showMessage(message: MSG_ERR_CONNECTION, messageType: .WARNING)
            return
        }
    }
    
    func manageEventBookData() {
        lblVenueTitle.text = dictEventDetail[RES_venue] as? String
        lblVenueAddress.text = dictEventDetail[RES_address] as? String
        arrPackageDataSelected = [arrPackageData.first! as typeAliasDictionary]
        
        for dict in arrPackageDataSelected {
            arrTimeList.append(contentsOf: dict[RES_timeList] as! [String])
            timeSelected = arrTimeList.first!
            arrPassData.append(contentsOf: dict[RES_data] as! [typeAliasDictionary])
            arrPassData = arrPassData.filter({ (dict1) -> Bool in
                return (dict1[RES_time] as! String) == timeSelected
            })
            
            for i in 0..<arrPassData.count {
                var dict = arrPassData[i]
                dict[KEY_QUANTITY] = "0" as AnyObject?
                arrPassData[i] = dict
            }
        }
       
        collectionViewDate.reloadData()
        collectionViewTime.reloadData()
        constraintTableViewPackageHeight.constant = HEIGHT_EVENT_PACKAGE_CELL * CGFloat(arrPassData.count)
        self.view.layoutIfNeeded()
        tableViewPackage.reloadData()
        constraintTableViewPackageHeight.constant = (tableViewPackage.visibleCells.first?.frame.size.height)! * CGFloat(arrPassData.count)
        self.view.layoutIfNeeded()
        if isReload {
            viewBG.alpha = 1
            isReload = false
        }
    }
    
    //MARK: COLLECTION VIEW DATA SOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case collectionViewDate:
            return arrPackageData.count
        case collectionViewTime:
            return arrTimeList.count
        default: break
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case collectionViewDate:
            let cell: EventBookDateCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_EVENT_BOOKDATE_CELL, for: indexPath) as! EventBookDateCell
            
            let dict:typeAliasDictionary = arrPackageData[indexPath.item]
            cell.lblDay.text = dict[RES_day] as? String
            cell.lblMonth.text = dict[RES_month] as? String
            cell.lblDate.text = dict[RES_date] as? String
            
            if !self.arrPackageDataSelected.isEmpty {
                let dictSelected: typeAliasDictionary = self.arrPackageDataSelected.last!
                
                if dictSelected[RES_date] as! String == dict[RES_date] as! String{
                    cell.viewBG.setViewBorder(COLOUR_DARK_GREEN, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
                    cell.lblMonth.textColor = UIColor.white
                    cell.lblMonth.backgroundColor = COLOUR_DARK_GREEN
                    cell.lblDay.textColor = COLOUR_DARK_GREEN
                    cell.lblDate.textColor = COLOUR_DARK_GREEN
                    
                }
                else {
                    cell.viewBG.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
                    cell.lblMonth.textColor = COLOUR_TEXT_GRAY
                    cell.lblMonth.backgroundColor = UIColor.lightGray
                    cell.lblDay.textColor = COLOUR_TEXT_GRAY
                    cell.lblDate.textColor = COLOUR_TEXT_GRAY
                }
            }
            else {
                cell.viewBG.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
                cell.lblMonth.textColor = COLOUR_TEXT_GRAY
                cell.lblMonth.backgroundColor = UIColor.lightGray
                cell.lblDay.textColor = COLOUR_TEXT_GRAY
                cell.lblDate.textColor = COLOUR_TEXT_GRAY
            }

            return cell

        case collectionViewTime:
            let cell: EventBookTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_EVENT_BOOKTIME_CELL, for: indexPath) as! EventBookTimeCell
            
           cell.lblTime.text = arrTimeList[indexPath.item]
            if timeSelected == arrTimeList[indexPath.item] {
                cell.lblTime.textColor = COLOUR_DARK_GREEN
                cell.lblTime.layer.borderColor = COLOUR_DARK_GREEN.cgColor
            }
            else {
                cell.lblTime.textColor = COLOUR_TEXT_GRAY
                cell.lblTime.layer.borderColor = COLOUR_TEXT_GRAY.cgColor
            }
                        
            return cell

        default:
            break
        }
        return UICollectionViewCell()
}
    
    //MARK: COLLECTON VIEW DELEGATE FLOW LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case collectionViewDate:
            return CGSize.init(width: CGFloat(80), height: CGFloat(collectionViewDate.frame.height))
        case collectionViewTime:
           return CGSize.init(width:  CGFloat(100), height: CGFloat(collectionViewTime.frame.height))
        default:
            break
        }
       return CGSize.init(width:  CGFloat(80), height: CGFloat(60))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case collectionViewTime:
            
                arrPassData.removeAll()
                let dict = arrPackageDataSelected.first!
                timeSelected = arrTimeList[indexPath.row]
                arrPassData.append(contentsOf: dict[RES_data] as! [typeAliasDictionary])
                arrPassData = arrPassData.filter({ (dict1) -> Bool in
                    return (dict1[RES_time] as! String) == timeSelected
                })
                
                for i in 0..<arrPassData.count {
                    var dict = arrPassData[i]
                    dict[KEY_QUANTITY] = "0" as AnyObject?
                    arrPassData[i] = dict
                }
            
            collectionViewDate.reloadData()
            collectionViewTime.reloadData()
            constraintTableViewPackageHeight.constant = HEIGHT_EVENT_PACKAGE_CELL * CGFloat(arrPassData.count)
            self.view.layoutIfNeeded()
            tableViewPackage.reloadData()
            constraintTableViewPackageHeight.constant = (tableViewPackage.visibleCells.first?.frame.size.height)! * CGFloat(arrPassData.count)
            self.view.layoutIfNeeded()

        case collectionViewDate:
            arrPackageDataSelected.removeAll()
            arrPassData.removeAll()
            arrTimeList.removeAll()
            arrPackageDataSelected = [arrPackageData[indexPath.row]]
            
            for dict in arrPackageDataSelected {
                arrTimeList.append(contentsOf: dict[RES_timeList] as! [String])
                timeSelected = arrTimeList.first!
                arrPassData.append(contentsOf: dict[RES_data] as! [typeAliasDictionary])
                arrPassData = arrPassData.filter({ (dict1) -> Bool in
                    return (dict1[RES_time] as! String) == timeSelected
                })
                
                for i in 0..<arrPassData.count {
                    var dict = arrPassData[i]
                    dict[KEY_QUANTITY] = "0" as AnyObject?
                    arrPassData[i] = dict
                }
            }

            collectionViewDate.reloadData()
            collectionViewTime.reloadData()
            constraintTableViewPackageHeight.constant = HEIGHT_EVENT_PACKAGE_CELL * CGFloat(arrPassData.count)
            self.view.layoutIfNeeded()
            tableViewPackage.reloadData()
            constraintTableViewPackageHeight.constant = (tableViewPackage.visibleCells.first?.frame.size.height)! * CGFloat(arrPassData.count)
             self.view.layoutIfNeeded()
            
        default:
            break
        }
    }

    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPassData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventPackageCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_PACKAGE_CELL) as! EventPackageCell;
        cell.delegate = self
        let dict: typeAliasDictionary = arrPassData[(indexPath as NSIndexPath).row]
        cell.btnPlus.accessibilityIdentifier = String(indexPath.row)
        cell.btnMinus.accessibilityIdentifier = String(indexPath.row)
        cell.lblPackageTitle.text = dict[RES_packageTitle] as? String
        cell.lblPackageAmount.text = "\(RUPEES_SYMBOL) \(dict[RES_price] as! String)"
        cell.lblPackageDescription.text = dict[RES_packageDescription] as? String
        cell.lblPerson.text = dict[KEY_QUANTITY] as? String
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* let dict = arrEvent[indexPath.row]
        let eventDetailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
        eventDetailVC.operatorID = dict[RES_operatorID] as! String
        obj_AppDelegate.navigationController.pushViewController(eventDetailVC, animated: true)*/
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func btnEventPackageMinus_Action(_ button: UIButton) {
     
        let row: Int = Int(button.accessibilityIdentifier!)!
        let indexPath: IndexPath = IndexPath(item: row, section: 0)
        let cell: EventPackageCell = tableViewPackage.cellForRow(at: indexPath) as! EventPackageCell
        stQty = cell.lblPerson.text!
        var qty: String = "0"
        if stQty != "0" {
            qty = "\(Int(cell.lblPerson.text!)! - 1)"
            cell.lblPerson.text = qty
        }
        if qty == "0" { cell.lblPerson.layer.borderColor = UIColor.lightGray.cgColor }
        
        var dictInfo: typeAliasDictionary = arrPassData[row]
        dictInfo[KEY_QUANTITY] = qty as AnyObject?
        arrPassData[row] = dictInfo

    }
    
    func btnEventPackagePlus_Action(_ button: UIButton) {
        
        let row: Int = Int(button.accessibilityIdentifier!)!
        let indexPath: IndexPath = IndexPath(item: row, section: 0)
        let cell: EventPackageCell = tableViewPackage.cellForRow(at: indexPath) as! EventPackageCell
        stQty = "\(Int(cell.lblPerson.text!)! + 1)"
        if Int(stQty)! > 10 { return }
        cell.lblPerson.layer.borderColor = COLOUR_DARK_GREEN.cgColor
        cell.lblPerson.text = stQty
        
        var dictInfo: typeAliasDictionary = arrPassData[row]
        dictInfo[KEY_QUANTITY] = stQty as AnyObject?
        arrPassData[row] = dictInfo
    }
    
    @IBAction func btnContinueAction() {
        var arrStringQty = [String]()
        var isQuantity:Bool = false
        for i in 0..<arrPassData.count {
            let dict: typeAliasDictionary = arrPassData[i]
            arrStringQty.append(dict[KEY_QUANTITY] as! String)
        }
        for st: String in arrStringQty {
            if Int(st)! > 0 { isQuantity = true;break }
            else { isQuantity = false }
        }
        
        if !isQuantity {
            _KDAlertView.showMessage(message: "please select atleast one ticket.", messageType: MESSAGE_TYPE.WARNING)
            return
         }
         else{ self.callCheckTicketService()}
    }

}
