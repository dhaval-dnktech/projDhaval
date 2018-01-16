//
//  FlightBookingViewController.swift
//  Cubber
//
//  Created by dnk on 03/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class FlightBookingViewController: UIViewController, UITextFieldDelegate, AppNavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ClassListCellDelegate, UITableViewDataSource, UITableViewDelegate , EPCalendarPickerDelegate{

    //MARK:PROPERTIES
    @IBOutlet var viewOnWayRoundTrip: UIView!
    @IBOutlet var viewTravellorDetail: UIView!
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var txtDepartureDate: UITextField!
    @IBOutlet var txtReturnDate: UITextField!
    @IBOutlet var txtTraveller: UITextField!
    @IBOutlet var txtClass: UITextField!
    @IBOutlet var btnFlightNonStop: UIButton!
    @IBOutlet var btnOneWay: UIButton!
    @IBOutlet var btnRoundTrip: UIButton!
    @IBOutlet var btnOriginDestination: UIButton!
    @IBOutlet var viewPersonTravellor: UIView!
    @IBOutlet var viewClassTravellor: UIView!
    
    @IBOutlet var lblOriginAirportCode: UILabel!
    @IBOutlet var lblOriginAirportRegionName: UILabel!
    @IBOutlet var lblDestinationAirportCode: UILabel!
    @IBOutlet var lblDestinationAirportRegionName: UILabel!
    
    @IBOutlet var constraintViewTravellorTopToSuperView: NSLayoutConstraint!
    @IBOutlet var constraintTableViewClassHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintMainViewTopToSuperView: NSLayoutConstraint!
    @IBOutlet var constraintMainViewHeight: NSLayoutConstraint!
    
    @IBOutlet var collectionViewAdult: UICollectionView!
    @IBOutlet var collectionViewChildren: UICollectionView!
    @IBOutlet var tableViewClass: UITableView!
    
    @IBOutlet var tableViewAirportList: UITableView!
    @IBOutlet var collectionViewInfants: UICollectionView!
    @IBOutlet var lblTravellorMessage: UILabel!
    @IBOutlet var viewAirport: UIView!
    @IBOutlet var lblSourceDestination: UILabel!
    @IBOutlet var txtSearchAirport: UITextField!
    
    //MARK: VARIABLES
    
    fileprivate var arrAdults:Array = [String]()
    fileprivate var arrClassData:Array = [typeAliasDictionary]()
    fileprivate var arrAutoSuggestionData:Array = [typeAliasDictionary]()
    fileprivate var arrPopularCities:Array = [typeAliasDictionary]()
    fileprivate var arrAutoSuggestionRecentData:Array = [typeAliasDictionary]()
    fileprivate var arrClassDataSelected = [typeAliasDictionary]()
    fileprivate var arrChildrens:Array = [String]()
    fileprivate var arrInfants:Array = [String]()
    var dictOpertaorCategory:typeAliasDictionary!
    var Adult:Int = 0
    var Children:Int = 0
    var Infants:Int = 0
    var isOrigin:Bool = false
    var isSearch:Bool = false
    internal var dictOrigin = typeAliasDictionary()
    internal var dictDestination = typeAliasDictionary()
    internal var subCatID = ""
    var stOriginCode:String = ""
    var stDestinationCode:String = ""
    var stOriginName:String = ""
    var stDestinationName:String = ""
    var txtDate:UITextField?
    var journeyDate = Date()
    var returnDate = Date()
    
    @IBOutlet var lblNoSuggestionFound: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintViewTravellorTopToSuperView.constant = self.view.frame.height + 100
        viewClassTravellor.isHidden = true
        viewPersonTravellor.isHidden = true
        arrAdults =  ParameterModel.getAdultList()
        Adult = Int(arrAdults.first!)!
        arrChildrens = ParameterModel.getChildrenList()
         Children = Int(arrChildrens.first!)!
        arrInfants = ParameterModel.getInfantsList()
         Infants = Int(arrInfants.first!)!
        
        self.collectionViewAdult.register(UINib.init(nibName: CELL_IDENTIFIER_TRAVELLOR_LIST, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_TRAVELLOR_LIST)
        self.collectionViewChildren.register(UINib.init(nibName: CELL_IDENTIFIER_TRAVELLOR_LIST, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_TRAVELLOR_LIST)
        self.collectionViewInfants.register(UINib.init(nibName: CELL_IDENTIFIER_TRAVELLOR_LIST, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_TRAVELLOR_LIST)
        
        self.tableViewClass.register(UINib.init(nibName: CELL_IDENTIFIER_CLASS_LIST, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_CLASS_LIST)
        tableViewClass.rowHeight = HEIGHT_CLASS_LIST_CELL
        tableViewClass.tableFooterView = UIView.init(frame: CGRect.zero)
        
        self.tableViewAirportList.register(UINib.init(nibName: CELL_AIRPORT_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_AIRPORT_LIST_CELL)
        tableViewClass.rowHeight = HEIGHT_AIRPORT_LIST_CELL
        
        if  !dictDestination.isEmpty && !dictOrigin.isEmpty {
            lblOriginAirportCode.text = dictOrigin[RES_AirportCode] as? String
            lblOriginAirportRegionName.text = dictOrigin[RES_regionName] as? String
            lblDestinationAirportCode.text = dictDestination[RES_AirportCode] as? String
            lblDestinationAirportRegionName.text = dictDestination[RES_regionName] as? String
        }
        self.getFlightClassList()
        self.btnDonePersonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setNavigationBar()
        let dictUserWallet:typeAliasDictionary = DataModel.getUserWalletResponse()
        if dictUserWallet[RES_iosFlightUnderMaintenance] != nil && dictUserWallet[RES_iosFlightUnderMaintenance] as! String == "1" {
            self._KDAlertView.showMessage(message: "Flight ticket booking service is under maintenace. Please try after some time.", messageType: .WARNING)
            self._KDAlertView.didClick(completion: { (completed) in
                let _ = self.navigationController?.popViewController(animated: true)
            })
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewOnWayRoundTrip.setViewBorder(COLOUR_LIGHT_GRAY, borderWidth: 1, isShadow: false, cornerRadius: 20, backColor: UIColor.white)
       self.SetScreenName(name: F_FLIGHT_BOOKING, stclass: F_FLIGHT_BOOKING)
       self.sendScreenView(name: F_FLIGHT_BOOKING)
       self.registerForKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
    
    func setNavigationBar() {
        
        if dictOpertaorCategory == nil ||  dictOpertaorCategory.isEmpty{
            obj_AppDelegate.navigationController.setCustomTitle("Flight")
        }
        else{obj_AppDelegate.navigationController.setCustomTitle("\(dictOpertaorCategory[RES_operatorCategoryName] as! String)")
        }
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func hideKeyboard(){
        txtDepartureDate.resignFirstResponder()
        txtReturnDate.resignFirstResponder()
        txtTraveller.resignFirstResponder()
        txtClass.resignFirstResponder()
        txtSearchAirport.resignFirstResponder()
    }

    //MARK: BUTTON METHODS
    
    @IBAction func btnOneWayRoundTripAction(_ sender: UIButton) {
        if sender.tag == 0 {
            btnOneWay.isSelected = true
            btnRoundTrip.isSelected = false
            btnOneWay.backgroundColor = COLOUR_ORANGE
            btnOneWay.setTitleColor(UIColor.white, for: .normal)
            btnRoundTrip.backgroundColor = UIColor.white
            btnRoundTrip.setTitleColor(UIColor.black, for: .normal)
            txtReturnDate.text = ""
            txtReturnDate.isEnabled = false
        }
        else{
            btnOneWay.isSelected = false
            btnRoundTrip.isSelected = true
            btnRoundTrip.backgroundColor = COLOUR_ORANGE
            btnRoundTrip.setTitleColor(UIColor.white, for: .normal)
            btnOneWay.backgroundColor = UIColor.white
            btnOneWay.setTitleColor(UIColor.black, for: .normal)
            txtReturnDate.isEnabled = true
        }
    }
    
    @IBAction func btnFlightNonStopAction() {
        self.btnFlightNonStop.isSelected = !self.btnFlightNonStop.isSelected
    }
    
    @IBAction func btnOriginDestinationAction() {
        
        stOriginCode = (lblOriginAirportCode.text?.trim())!
        stDestinationCode = (lblDestinationAirportCode.text?.trim())!
        stOriginName = (lblOriginAirportRegionName.text?.trim())!
        stDestinationName = (lblDestinationAirportRegionName.text?.trim())!
        
        if stOriginCode.isEmpty || stDestinationCode.isEmpty {
            _KDAlertView.showMessage(message: MSG_SEL_ORIGIN_DEST, messageType: .WARNING)
            return
        }
        
        lblOriginAirportCode.text = stDestinationCode
        lblOriginAirportRegionName.text = stDestinationName
        lblDestinationAirportCode.text = stOriginCode
        lblDestinationAirportRegionName.text = stOriginName
        
        let dictTemp = dictOrigin
        dictOrigin  = dictDestination
        dictDestination = dictTemp
        
        UIView.animate(withDuration: 0.3, animations: {
            let transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            self.btnOriginDestination.transform = transform;
        }) { (completed) in
            let transform = CGAffineTransform(rotationAngle: 0);
            self.btnOriginDestination.transform = transform;
        }
    }
    @IBAction func btnProcessAction() {
        
        let stOrigin = lblOriginAirportCode.text!
        let stDestination = lblDestinationAirportCode.text!
        let stDeptDate = txtDepartureDate.text!.trim()
        let stReturnDate = txtReturnDate.text!.trim()
        let stTravellor = txtTraveller.text!.trim()
        let stClass = txtClass.text!.trim()
        
        if stOrigin.isEmpty {
            _KDAlertView.showMessage(message: "Select Origin", messageType: MESSAGE_TYPE.WARNING)
            return
        }
        if stDestination.isEmpty {
            _KDAlertView.showMessage(message: "Select Destination", messageType: MESSAGE_TYPE.WARNING)
            return
        }
        if stDeptDate.isEmpty {
            _KDAlertView.showMessage(message: "Select DepartureDate", messageType: MESSAGE_TYPE.WARNING)
            return
        }
        if btnRoundTrip.isSelected && stReturnDate.isEmpty {
            _KDAlertView.showMessage(message: "Select ReturnDate", messageType: MESSAGE_TYPE.WARNING)
            return
        }
        if stTravellor.isEmpty {
            _KDAlertView.showMessage(message: "Select Travellor", messageType: MESSAGE_TYPE.WARNING)
            return
        }
        if stClass.isEmpty {
            _KDAlertView.showMessage(message: "Select Class", messageType: MESSAGE_TYPE.WARNING)
            return
        }
        
        arrAutoSuggestionRecentData = [dictOrigin , dictDestination]
        DataModel.setRecentFlightData(arr: arrAutoSuggestionRecentData)
        self.tableViewAirportList.reloadData()

        let flightListVC = FlightListViewController(nibName: "FlightListViewController", bundle: nil)
        flightListVC.isRoundTrip = btnRoundTrip.isSelected
        flightListVC.dictSource = self.dictOrigin
        flightListVC.dictDestination = self.dictDestination
        flightListVC.dictClass = self.arrClassDataSelected.first!
        flightListVC.noOfInfants = self.Infants
        flightListVC.noOfChild = self.Children
        flightListVC.noOfAdults = self.Adult
        flightListVC.journeyDate  = self.journeyDate
        flightListVC.returnDate  = self.returnDate
        flightListVC.isNonStopsOnly = self.btnFlightNonStop.isSelected
        self.navigationController?.pushViewController(flightListVC, animated: true)
       
    }
    
    @IBAction func btnCloseViewAirportAction() {
        
        constraintMainViewTopToSuperView.constant = 900
        self.isSearch = false
        arrAutoSuggestionData = self.arrPopularCities
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            self.viewAirport.alpha = 0
            }) { (completed) in
            self.viewAirport.removeFromSuperview()
        }
    }
    
    @IBAction func btnAirportOriginAction() {
        isOrigin = true
        lblSourceDestination.text = "Select Origin"
        isSearch = false
        self.showAirportView()
    }
    
    @IBAction func btnAirportDestinationAction() {
        if lblOriginAirportCode.text!.isEmpty {
            self._KDAlertView.showMessage(message: "First Select Origin", messageType: MESSAGE_TYPE.WARNING)
        }
        else{
            isOrigin = false
            isSearch = false
            lblSourceDestination.text = "Select Destination"
            self.showAirportView()
        }
    }
    
    
    @IBAction func btnDonePersonAction() {
        
        if Infants > Adult {
            self.lblTravellorMessage.text = "No. of infants cannot exceed the no. of adults"
        }
        else if (Infants + Adult + Children) > 9 {
            self.lblTravellorMessage.text = "Total number of passenger cannot exceed 9"
        }
        else {
            var str = "\(Adult) Adult"
            if Children > 0 {
                str += ", \(Children) Child"
            }
            if Infants > 0 {
                str += ", \(Infants) Infant"
            }
           txtTraveller.text = str
            constraintViewTravellorTopToSuperView.constant = self.view.frame.height + 50
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.lblTravellorMessage.text = ""
        }
    }
    
    @IBAction func btnDoneClassAction() {
        
        constraintViewTravellorTopToSuperView.constant = self.view.frame.height + 50
        txtClass.text = arrClassDataSelected.first?[RES_operatorCategoryName] as? String
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func getFlightClassList(){
        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_GetFlightClassList) || DataModel.getFlightClassList().isEmpty {
        
            
            let userInfo: typeAliasDictionary = DataModel.getUserInfo()
            let params = [REQ_HEADER:DataModel.getHeaderToken(),
                          REQ_USER_ID: userInfo[RES_userID] as! String]
            
            obj_OperationWeb.callRestApi(methodName: JMETHOD_GetFlightClassList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
                DataModel.setHeaderToken(dict[RES_token] as! String)
                self.arrClassData = dict[RES_flightClassList] as! [typeAliasDictionary]
                DataModel.setFlightClassList(array: self.arrClassData)
                self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_GetFlightClassList)
                self.tableViewClass.reloadData()
                self.constraintTableViewClassHeight.constant = CGFloat(self.tableViewClass.rowHeight) * CGFloat(self.arrClassData.count)
                
                self.getAutoSuggestionData()
                
                if self.subCatID != "" && self.subCatID != "0" {
                    for dict in self.arrClassData {
                        if dict[RES_subCategoryId] as! String == self.subCatID{
                            self.arrClassDataSelected.append(dict)
                            self.txtClass.text = dict[RES_operatorCategoryName]! as? String
                        }
                    }
                }
                else {
                    self.arrClassDataSelected.append(self.arrClassData.first!)
                    self.txtClass.text = self.arrClassData.first![RES_operatorCategoryName]! as? String
                }
                
                self.tableViewClass.layoutIfNeeded()
            }, onFailure: { (code, dict) in
                
            }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
        }
        else {
            
            self.arrClassData = DataModel.getFlightClassList()
            print(self.arrClassData)
            self.tableViewClass.reloadData()
            self.constraintTableViewClassHeight.constant = CGFloat(self.tableViewClass.rowHeight) * CGFloat(self.arrClassData.count)
            if self.subCatID != "" && self.subCatID != "0"{
                for dict in self.arrClassData {
                    if dict[RES_subCategoryId] as! String == self.subCatID{
                        self.arrClassDataSelected.append(dict)
                        self.txtClass.text = dict[RES_operatorCategoryName]! as? String
                    }
                }
            }
            else {
                self.arrClassDataSelected.append(self.arrClassData.first!)
                self.txtClass.text = self.arrClassData.first![RES_operatorCategoryName]! as? String
            }
            self.getAutoSuggestionData()
            self.tableViewClass.layoutIfNeeded()
            self.tableViewClass.reloadData()
        }
    }
    
    func getAutoSuggestionData() {
        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_getAutoSuggestData) || DataModel.getFlightAirpostList().isEmpty {
            self.callAutoSuggestData("")
        }
        else {
          self.arrPopularCities = DataModel.getFlightAirpostList()
        }
    }
    
    func callAutoSuggestData(_ serachTerm:String) {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_SEARCH_TERM:serachTerm]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_getAutoSuggestData, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.arrAutoSuggestionData = dict[RES_airportList] as! [typeAliasDictionary]
            if self.arrPopularCities.isEmpty {
                self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_getAutoSuggestData)
                DataModel.setFlightAirpostList(array:  self.arrAutoSuggestionData)
                self.arrPopularCities = self.arrAutoSuggestionData
            }
            if serachTerm == "" {
                self.isSearch = false
            }
            self.tableViewAirportList.reloadData()
            self.tableViewAirportList.isHidden = false
            self.lblNoSuggestionFound.isHidden = true
            
        }, onFailure: { (code, dict) in
            
            self.lblNoSuggestionFound.text = dict[RES_message] as? String
            self.tableViewAirportList.isHidden = true
            self.lblNoSuggestionFound.isHidden = false
            self.tableViewAirportList.reloadData()

        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }

    }
    
    func showAirportView() {
        
        self.SetScreenName(name: F_FLIGHT_SELECT_JOURNEYLOCATION, stclass: F_MODULE_FLIGHT)
        self.sendScreenView(name: F_FLIGHT_SELECT_JOURNEYLOCATION)
        if arrAutoSuggestionData.isEmpty{
            arrAutoSuggestionData = arrPopularCities
        }
        self.arrAutoSuggestionRecentData = DataModel.getRecentFlightData()
        txtSearchAirport.text = ""
        let frame:CGRect = CGRect.init(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.width), height: CGFloat(self.view.frame.height))
        viewAirport.frame = frame
        viewAirport.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.6)
        self.view.addSubview(viewAirport)
        let _ = DesignModel.setScrollSubViewConstraint(viewAirport, superView: self.view, toView: self.view, leading: 0, trailing: 0, top: 0, bottom: 0, width: 0, height: 0)
        self.view.layoutIfNeeded()
        viewAirport.alpha = 0
        constraintMainViewTopToSuperView.constant = 900
        constraintMainViewTopToSuperView.constant = self.view.frame.height/2
        constraintMainViewHeight.constant = self.view.frame.height/2
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.viewAirport.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.tableViewAirportList.isHidden = false
        self.tableViewAirportList.reloadData()
        self.txtSearchAirport.becomeFirstResponder()
    }
    
    func showDatePicker(isOrigin:Bool , text:UITextField) {
        
        self.txtDate = text
        var selectedDate = [Date]()
        if txtDepartureDate.text != "" {
            selectedDate.append(journeyDate)
        }
        if txtReturnDate.text != "" && !isOrigin {
            selectedDate.append(returnDate)
        }
        
        let calendarPicker = EPCalendarPicker(startYear: Date().year(), endYear:  Date().year() + 1, multiSelection: true, selectedDates: selectedDate)
        calendarPicker.calendarDelegate = self
        calendarPicker.startDate =  Date() 
        calendarPicker.minimumDate = isOrigin ? Date() : journeyDate
        calendarPicker.hightlightsToday = true
        calendarPicker.showsTodaysButton = false
        calendarPicker.hideDaysFromOtherMonth = false
        calendarPicker.tintColor = UIColor.black
        calendarPicker.monthTitleColor = UIColor.black
        calendarPicker.weekdayTintColor = UIColor.darkGray
        calendarPicker.weekendTintColor =  UIColor.darkGray
        calendarPicker.multiSelectEnabled   = false
        calendarPicker.isDateTo = !isOrigin
        calendarPicker.dayDisabledTintColor = UIColor.lightGray
        calendarPicker.title = isOrigin ? "Pick Boarding Date" : "Pick Return Date"
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: COLLECTION VIEW DATA SOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case collectionViewAdult:
            return arrAdults.count
            case collectionViewChildren:
            return arrChildrens.count
            case collectionViewInfants:
            return arrInfants.count
            default: break
        }
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: TravellorListCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_TRAVELLOR_LIST, for: indexPath) as! TravellorListCell
        
        switch collectionView {
        case collectionViewAdult:
             cell.lblTravellorTitle.text = arrAdults[indexPath.item]
             if Adult == Int(arrAdults[indexPath.item])! { cell.viewBG.backgroundColor = COLOUR_DARK_GREEN ; cell.lblTravellorTitle.textColor = UIColor.white }
             else { cell.viewBG.backgroundColor = COLOUR_TRAVELLOR_BG ; cell.lblTravellorTitle.textColor = UIColor.black  }
            return cell
            
        case collectionViewChildren:
            cell.lblTravellorTitle.text = arrChildrens[indexPath.item]
            if Children == Int(arrChildrens[indexPath.item])! { cell.viewBG.backgroundColor = COLOUR_DARK_GREEN ; cell.lblTravellorTitle.textColor = UIColor.white}
            else { cell.viewBG.backgroundColor = COLOUR_TRAVELLOR_BG ; cell.lblTravellorTitle.textColor = UIColor.black }
            
            return cell
        case collectionViewInfants:
            cell.lblTravellorTitle.text = arrInfants[indexPath.item]
            if Infants == Int(arrInfants[indexPath.item])! { cell.viewBG.backgroundColor = COLOUR_DARK_GREEN ; cell.lblTravellorTitle.textColor = UIColor.white }
            else { cell.viewBG.backgroundColor = COLOUR_TRAVELLOR_BG ; cell.lblTravellorTitle.textColor = UIColor.black}
        
            return cell
            
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    //MARK: COLLECTON VIEW DELEGATE FLOW LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case collectionViewAdult:
            return CGSize.init(width: CGFloat(50), height: CGFloat(collectionViewAdult.frame.height))
            
        case collectionViewChildren:
            return CGSize.init(width: CGFloat(50), height: CGFloat(collectionViewChildren.frame.height))
            
        case collectionViewInfants:
            return CGSize.init(width: CGFloat(50), height: CGFloat(collectionViewInfants.frame.height))
        default:
            break
        }
        return CGSize.init(width: CGFloat(50), height: CGFloat(50))

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewAdult:
            Adult = Int(arrAdults[indexPath.row])!
            collectionViewAdult.reloadData()
            break
        case collectionViewChildren:
            Children = Int(arrChildrens[indexPath.row])!
            collectionViewChildren.reloadData()
            break
        case collectionViewInfants:
            Infants = Int(arrInfants[indexPath.row])!
            collectionViewInfants.reloadData()
            break
        default:
            break
        }
        self.lblTravellorMessage.text = ""
    }
    
    //MARK: UITABLEVIEW DATA SOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.isEqual(tableViewClass) { return 1 }
        if self.isSearch  { return 1 }
        if !arrAutoSuggestionRecentData.isEmpty { return 2 }
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(tableViewClass) { return arrClassData.count }
        else {
            if self.isSearch  { return arrAutoSuggestionData.count }
            if !arrAutoSuggestionRecentData.isEmpty {
                if section == 0 { return arrAutoSuggestionRecentData.count}
                if section == 1 { return arrPopularCities.count }
            }
            return arrPopularCities.count
          }
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(tableViewClass) {
            let cell:ClassListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_CLASS_LIST, for: indexPath) as! ClassListCell
            
            cell.delegate = self
            cell.btnRadioClass.accessibilityIdentifier = String(indexPath.row)
            let dictClass = arrClassData[indexPath.row]
            if !self.arrClassDataSelected.isEmpty {
                let dictSelected: typeAliasDictionary = self.arrClassDataSelected.last!
                if dictSelected[RES_subCategoryId] as! String == dictClass[RES_subCategoryId] as! String{ cell.btnRadioClass.isSelected = true }
                else { cell.btnRadioClass.isSelected = false }
            }
            else { cell.btnRadioClass.isSelected = false }
            
            cell.lblClass.text = dictClass[RES_operatorCategoryName] as! String?
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell:AirportListCell = tableView.dequeueReusableCell(withIdentifier: CELL_AIRPORT_LIST_CELL, for: indexPath) as! AirportListCell
            
            if isSearch {
                let dict = arrAutoSuggestionData[indexPath.row] as typeAliasDictionary
                cell.lblAirportTitle.text = dict[RES_AirportName] as! String?
            }
            else  if !arrAutoSuggestionRecentData.isEmpty {
                if indexPath.section == 0 {
                    let dict = arrAutoSuggestionRecentData[indexPath.row] as typeAliasDictionary
                    cell.lblAirportTitle.text = dict[RES_AirportName] as! String?
                }
                if indexPath.section == 1 {
                    let dict = arrPopularCities[indexPath.row] as typeAliasDictionary
                    cell.lblAirportTitle.text = dict[RES_AirportName] as! String?
                }
            }
            else {
                let dict = arrPopularCities[indexPath.row] as typeAliasDictionary
                cell.lblAirportTitle.text = dict[RES_AirportName] as! String?
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEqual(tableViewClass){
            
            let cell: ClassListCell = tableView.cellForRow(at: indexPath) as! ClassListCell
            self.btnClassListCell_RadioAction(cell.btnRadioClass)
        }
        else {
            if isSearch {
                
                if isOrigin {
                    dictOrigin = arrAutoSuggestionData[indexPath.row]
                    if !dictDestination.isEmpty && dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                        _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                        return
                    }
                    lblOriginAirportCode.text = dictOrigin[RES_AirportCode] as? String
                    lblOriginAirportRegionName.text = dictOrigin[RES_regionName] as? String
                    isOrigin = false
                    isSearch = false
                    self.btnCloseViewAirportAction()

                }
                else{
                    dictDestination = arrAutoSuggestionData[indexPath.row]
                    if dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                        _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                        return
                    }
                    else {
                        lblDestinationAirportCode.text = dictDestination[RES_AirportCode] as? String
                        lblDestinationAirportRegionName.text = dictDestination[RES_regionName] as? String
                        isOrigin = false
                        self.btnCloseViewAirportAction()
                        isSearch = false
                    }
                }
            }
            
            else if !arrAutoSuggestionRecentData.isEmpty {
                if indexPath.section == 0 {
                    if isOrigin {
                        dictOrigin = arrAutoSuggestionRecentData[indexPath.row]
                        if !dictDestination.isEmpty && dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                            _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                            return
                        }
                        lblOriginAirportCode.text = dictOrigin[RES_AirportCode] as? String
                        lblOriginAirportRegionName.text = dictOrigin[RES_regionName] as? String
                        isOrigin = false
                      //  lblSourceDestination.text = "Select Destination"
                        self.btnCloseViewAirportAction()

                    }
                    else{
                        dictDestination = arrAutoSuggestionRecentData[indexPath.row]
                        if dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                            _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                            return
                        }
                        else {
                            lblDestinationAirportCode.text = dictDestination[RES_AirportCode] as? String
                            lblDestinationAirportRegionName.text = dictDestination[RES_regionName] as? String
                            isOrigin = false
                            self.btnCloseViewAirportAction()
                            
                        }
                    }
                }
                else if indexPath.section == 1 {
                    if isOrigin {
                        dictOrigin = arrPopularCities[indexPath.row]
                        if !dictDestination.isEmpty && dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                            _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                            return
                        }
                        lblOriginAirportCode.text = dictOrigin[RES_AirportCode] as? String
                        lblOriginAirportRegionName.text = dictOrigin[RES_regionName] as? String

                        isOrigin = false
                        self.btnCloseViewAirportAction()
//                        lblSourceDestination.text = "Select Destination"
                    }
                    else {
                        dictDestination = arrPopularCities[indexPath.row]
                        if dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                            _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                            return
                        }
                        else {
                            lblDestinationAirportCode.text = dictDestination[RES_AirportCode] as? String
                            lblDestinationAirportRegionName.text = dictDestination[RES_regionName] as? String
                            isOrigin = false
                            self.btnCloseViewAirportAction()
                            
                        }
                    }
                }
            }
            
         else {
                
                if isOrigin {
                    dictOrigin = arrPopularCities[indexPath.row]
                    if !dictDestination.isEmpty && dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                        _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                        return
                    }
                    lblOriginAirportCode.text = dictOrigin[RES_AirportCode] as? String
                    lblOriginAirportRegionName.text = dictOrigin[RES_regionName] as? String
                    isOrigin = false
                    //lblSourceDestination.text = "Select Destination"
                    self.btnCloseViewAirportAction()

                }
                else {
                    dictDestination = arrPopularCities[indexPath.row]
                    if dictOrigin[RES_AirportCode] as! String == dictDestination[RES_AirportCode] as! String {
                        _KDAlertView.showMessage(message: "Origin and Destination can not be same.", messageType: MESSAGE_TYPE.WARNING)
                        return
                    }
                    else {
                        lblDestinationAirportCode.text = dictDestination[RES_AirportCode] as? String
                        lblDestinationAirportRegionName.text = dictDestination[RES_regionName] as? String
                        isOrigin = false
                        self.btnCloseViewAirportAction()
                        isSearch = false
                    }
                }
            }
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if tableView.isEqual(tableViewClass) { return HEIGHT_CLASS_LIST_CELL }
        else { return HEIGHT_AIRPORT_LIST_CELL }
    
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableViewAirportList.frame.size.width, height: HEIGHT_AIRPORT_LIST_CELL))
        
        view.backgroundColor = COLOUR_TRAVELLOR_BG
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width, height: view.frame.height))
        label.font = UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 15)
        
        if tableView.isEqual(tableViewClass) { return UIView.init(frame: CGRect.zero) }
        else {
            if isSearch {
                return UIView.init()
            }
            else if !arrAutoSuggestionRecentData.isEmpty{
                if section == 0 {
                    label.text = "Recent Search"
                }
                if section == 1 {
                    label.text = "Popular Cities"
                }
                label.textColor = COLOUR_TEXT_GRAY
            }
            else{
                label.text = "Popular Cities"
            }
            view.addSubview(label)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView.isEqual(tableViewClass) { return 0.01}
        if isSearch { return 0.01 }
        else {  return HEIGHT_AIRPORT_LIST_CELL }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func btnClassListCell_RadioAction(_ button:UIButton){
        let index: Int = Int(button.accessibilityIdentifier!)!
        self.arrClassDataSelected.removeAll()
        self.arrClassDataSelected = [arrClassData[index]]
        tableViewClass.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    // MARK: SCROLLVIEW DELAGATE
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableViewAirportList.contentOffset.y > 0 {
            constraintMainViewTopToSuperView.constant = 0
            constraintMainViewHeight.constant = self.view.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if tableViewAirportList.contentOffset.y < 0{
            constraintMainViewTopToSuperView.constant = self.view.frame.height/2
            constraintMainViewHeight.constant = self.view.frame.height/2
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    
    //MARK: UITEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        if textField == txtTraveller {
            self.viewClassTravellor.isHidden = true
            self.viewPersonTravellor.isHidden = false
            constraintViewTravellorTopToSuperView.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)

            return false
        }
        else if textField == txtClass {
           
            self.viewClassTravellor.isHidden = false
            self.viewPersonTravellor.isHidden = true
            constraintViewTravellorTopToSuperView.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            return false
        }
        
        else if textField == txtSearchAirport{
            txtSearchAirport.text = ""
            constraintMainViewTopToSuperView.constant = 0
            constraintMainViewHeight.constant = self.view.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if textField == txtDepartureDate {
            self.showDatePicker(isOrigin: true, text: txtDepartureDate)
            return false
        }
        else if textField == txtReturnDate {
            self.btnOneWayRoundTripAction(btnRoundTrip)
            self.showDatePicker(isOrigin: false, text: txtReturnDate)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == txtDepartureDate { txtReturnDate.becomeFirstResponder() }
        else if textField == txtReturnDate { txtTraveller.becomeFirstResponder() }
        else if textField == txtTraveller { txtClass.becomeFirstResponder() }
        else if textField == txtClass { txtClass.resignFirstResponder() }
        else if textField == txtSearchAirport { txtSearchAirport.resignFirstResponder()
        
            constraintMainViewTopToSuperView.constant = self.view.frame.height/2
            constraintMainViewHeight.constant = self.view.frame.height/2
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }

        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
         
        if textField.isEqual(txtSearchAirport){
            if !resultingString.characters.isEmpty && resultingString.characters.count >= 3 {
                self.callAutoSuggestData(resultingString)
                self.isSearch = true
            }
            else if resultingString.characters.isEmpty{
                self.isSearch = true
                self.callAutoSuggestData("")
                self.arrAutoSuggestionData = self.arrPopularCities
                self.tableViewAirportList.reloadData()
                self.tableViewAirportList.isHidden = false
                self.lblNoSuggestionFound.isHidden = true
            }
        }
        
        return true
        }

    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError) {
        
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : Date) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        if self.txtDate == txtDepartureDate {
            journeyDate = date
            if txtReturnDate.text != "" && returnDate.timeIntervalSince(journeyDate).sign == .minus {
                txtReturnDate.text = ""
                //self.showDatePicker(isOrigin: false, text: txtReturnDate)
            }
        }
        else if self.txtDate == txtReturnDate {
            returnDate = date
        }
        self.txtDate?.text = dateFormat.string(from: date)
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [Date]) {
       
    }

}


