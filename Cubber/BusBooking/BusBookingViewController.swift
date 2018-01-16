//
//  BusBookingViewController.swift
//  Cubber
//
//  Created by dnk on 27/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class BusBookingViewController: UIViewController, AppNavigationControllerDelegate , UITextFieldDelegate , stationViewDelegate ,VKDatePopoverDelegate{

    //MARK: PROPERTIES
    
    @IBOutlet var txtOrigin: UITextField!
    @IBOutlet var txtDestination: UITextField!
    @IBOutlet var btnReverse: UIButton!
    @IBOutlet var btnDateOfJourney: UIButton!
    @IBOutlet var btnToday: UIButton!
    @IBOutlet var btnTomorrow: UIButton!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let _KDAlertView = KDAlertView()
    var dateOfJourney:Date = Date()
    let dateFormatter = DateFormatter()
    var _VKDatePopover = VKDatePopOver()
    let dateTomorrow :Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    internal var dictSource = typeAliasStringDictionary()
    internal var dictDestination = typeAliasStringDictionary()
    internal var stSource:String = ""
    internal var stDestination:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.btnToday_TomorrowAction(btnToday)
        if !dictSource.isEmpty && !dictDestination.isEmpty{
            self.setSourceDestination()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_BUS_BOOKING)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_BUS_BOOKING, stclass: F_BUS_BOOKING)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    
    fileprivate func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Bus Booking")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK: BUTTON METHODS
    
    @IBAction func btnReverse_Source_Desti_Action() {
        
        stSource = (txtOrigin.text?.trim())!
        stDestination = (txtDestination.text?.trim())!
        if stSource.isEmpty || stDestination.isEmpty {
            _KDAlertView.showMessage(message: MSG_SEL_ORIGIN_DEST, messageType: .WARNING)
            return
        }
        txtDestination.text = stSource
        txtOrigin.text = stDestination
        let dictTemp = dictSource
        dictSource[RES_sourceId] = dictDestination[RES_destinationId]
        dictSource[RES_sourceName] = dictDestination[RES_destinationName]
        dictDestination[RES_destinationId] = dictTemp[RES_sourceId]
        dictDestination[RES_destinationName] = dictTemp[RES_sourceName]
       UIView.animate(withDuration: 0.3, animations: {
        let transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        self.btnReverse.transform = transform;
       }) { (completed) in
            let transform = CGAffineTransform(rotationAngle: 0);
            self.btnReverse.transform = transform;
        }
    }
    
    @IBAction func btnDateOfJourneyAction() {
        
        self._VKDatePopover.initSetFrame(dateFormatter.string(from: dateOfJourney), mininumDate: dateFormatter.string(from: Date()), maximumDate: "", dateFormat: VKDateFormat.DDMMYYYY, dateType: DATE_TYPE.DATE_OF_JOURNEY, isOutSideClickedHidden: false , isShowCancel:false)
        self._VKDatePopover.delegate = self
        self.navigationController!.view.addSubview(_VKDatePopover)
    }
    
    @IBAction func btnToday_TomorrowAction(_ sender: UIButton) {
        
        if sender.isEqual(btnToday){
            btnToday.isSelected = true
            btnTomorrow.isSelected = false
            dateOfJourney = Date()
            btnToday.layer.borderColor = COLOUR_DARK_GREEN.cgColor
            btnTomorrow.layer.borderColor = UIColor.darkGray.cgColor
        }
        else{
            btnToday.isSelected = false
            btnTomorrow.isSelected = true
            dateOfJourney = dateTomorrow
            btnTomorrow.layer.borderColor = COLOUR_DARK_GREEN.cgColor
            btnToday.layer.borderColor = UIColor.darkGray.cgColor
        }
        btnDateOfJourney.setTitle(dateFormatter.string(from: dateOfJourney), for: .normal)
    }
    @IBAction func btnSearchBusesAction() {
        
        DataModel.setBusFilter([typeAliasStringDictionary]())
        stSource = (txtOrigin.text?.trim())!
        stDestination = (txtDestination.text?.trim())!
        if stSource.isEmpty{
            _KDAlertView.showMessage(message: MSG_SEL_ORIGIN, messageType: .WARNING)
           return
        }
        else if stDestination.isEmpty{
             _KDAlertView.showMessage(message: MSG_SEL_DESTINATION, messageType: .WARNING)
            return
        }
        let params = [RES_userId : DataModel.getUserInfo()[RES_userID] as! String,
                      FIR_SELECT_CONTENT:"Search Busses",
                      RES_sourceName:dictSource[RES_sourceName]!,
                      RES_destinationName:dictDestination[RES_destinationName]!] as [String : Any]
        self.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])
        DataModel.setDateOfJourney(dateOfJourney)
        let serachBusResultVC = SearchBusResultViewController(nibName: "SearchBusResultViewController", bundle: nil)
        serachBusResultVC.dateOfJourney = dateOfJourney
        serachBusResultVC.dictSource = self.dictSource
        serachBusResultVC.dictDestination = self.dictDestination
        self.navigationController?.pushViewController(serachBusResultVC, animated: true)
    }
    
    //MAK: CUSTOM METHODS
    
    fileprivate func setSourceDestination(){
        txtOrigin.text = stSource
        txtDestination.text = stDestination
    }
    
    fileprivate func showSelectSourcesViewController(isOrigin:Bool) {
        let stationVC = StationViewController(nibName: "StationViewController", bundle: nil)
        stationVC.isOrigin = isOrigin
        stationVC.delegate = self
        stationVC.stSourceID = isOrigin ? "" : dictSource[RES_sourceId]! 
        self.navigationController?.pushViewController(stationVC, animated: true) }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(txtOrigin){
            let params = [RES_userId : DataModel.getUserInfo()[RES_userID] as! String,
                          FIR_SELECT_CONTENT:"Select Source"] as [String : Any]
            self.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])
            self.showSelectSourcesViewController(isOrigin: true);return false;
        }
        else if textField.isEqual(txtDestination) {
            if !dictSource.isEmpty {
                let params = [RES_userId : DataModel.getUserInfo()[RES_userID] as! String,
                              FIR_SELECT_CONTENT:"Select Destination",
                              RES_sourceName:dictSource[RES_sourceName]!] as [String : Any]
                self.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])
            self.showSelectSourcesViewController(isOrigin: false) }
            else {   self.showSelectSourcesViewController(isOrigin: true) }
            return false }
        return true
    }
    
    //MARK: STATIONVIEW DELEGATE
    
    func selectedSourceAndDestination(dict: typeAliasDictionary, isOrigin: Bool) {
        
        if isOrigin {
            dictSource = dict as! typeAliasStringDictionary
            dictDestination = typeAliasStringDictionary()
            txtOrigin.text = dict[RES_sourceName] as? String
            txtDestination.text = ""
        }
        else { dictDestination = dict as! typeAliasStringDictionary
            txtDestination.text = dict[RES_destinationName] as? String
        }
    }
    
    //MARK: DATEPOPOVER DELEGATE
    
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String, dateType: DATE_TYPE, dateFormat: DateFormatter) {
        
        if strDate == dateFormat.string(from:Date()) {self.btnToday_TomorrowAction(btnToday)}
        else if strDate == dateFormat.string(from:dateTomorrow) {self.btnToday_TomorrowAction(btnTomorrow)}
        else {
            dateOfJourney = vkDate
            btnDateOfJourney.setTitle(strDate, for: .normal)
            btnTomorrow.isSelected = false
            btnToday.isSelected = false
            btnTomorrow.layer.borderColor = UIColor.darkGray.cgColor
            btnToday.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    func vkDatePopoverClearDate(_ dateType: DATE_TYPE) {
    }
    
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String) {
    }
}
