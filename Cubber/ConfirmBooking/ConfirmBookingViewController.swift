//
//  ConfirmBookingViewController.swift
//  Cubber
//
//  Created by dnk on 01/05/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ConfirmBookingViewController: UIViewController , VKPopoverDelegate , UITableViewDelegate , UITableViewDataSource, AppNavigationControllerDelegate  {

    //MARK: PROPERTY
    @IBOutlet var lblSource: UILabel!
    @IBOutlet var lblDestination: UILabel!
    @IBOutlet var lblDateOfJourney: UILabel!
    @IBOutlet var lblBusOperator: UILabel!
    @IBOutlet var lblBusType: UILabel!
    @IBOutlet var lblSeatNumbers: UILabel!
    @IBOutlet var lblBoardingPoints: UILabel!
    @IBOutlet var lblBoardingTime: UILabel!
    @IBOutlet var lblTotalFareTitle: UILabel!
    @IBOutlet var lblTotalFareValue: UILabel!
    @IBOutlet var viewBoardingPoint: UIView!
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var viewCancellationPolicy: UIView!
    @IBOutlet var tableViewBoardingPoint: UITableView!
    
    @IBOutlet var lblNote: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKPopOver = VKPopover()
    fileprivate let _KDAlertView = KDAlertView()
    internal var arrSelecteSeats = [typeAliasStringDictionary]()
    internal var dictRoute = typeAliasDictionary()
    internal var arrPassengerDetail = [typeAliasStringDictionary]()
    internal var dictBoardingPoint = typeAliasStringDictionary()
    fileprivate var arrBoardingPoints = [typeAliasStringDictionary]()
    internal var arrCancellationPolicy = [typeAliasStringDictionary]()
    internal var fare:Double = 0.00
    internal var stU_Mobile:String = ""
    internal var stU_Email:String = ""
    var totalBaseFare = 0.00
    var totalServiceTax = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setJourneyInfo()
        self.calculateBaseFareAndServiceTax()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        self.sendScreenView(name: F_BUS_CONFIRMBOOKING)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_BUS_CONFIRMBOOKING, stclass: F_BUS_CONFIRMBOOKING)
    }

    //MARK: APPNAVIGATION CONTROLLER METHOD
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Confirm Booking")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setJourneyInfo () {
    
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy"
            lblSource.text = dictRoute[RES_FromCityName] as! String?
            lblDestination.text = dictRoute[RES_ToCityName] as? String
            lblBusType.text = dictRoute[RES_BusTypeName] as? String
            lblBusOperator.text = dictRoute[RES_CompanyName] as? String
            lblDateOfJourney.text = dateFormat.string(from: DataModel.getDateOfJourney())
            lblBoardingPoints.text = dictBoardingPoint[BOARDING_POINT_NAME]
            lblBoardingTime.text = dictBoardingPoint[BOARDING_POINT_TIME]
            let arrSeats:NSArray = arrSelecteSeats as NSArray
            let seatNumbers: String = ((arrSeats.value(forKey: RES_SeatNo) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            lblSeatNumbers.text = "[\(seatNumbers)]"
            lblTotalFareTitle.text = "Total Fare of \(arrSelecteSeats.count) seats"
            lblTotalFareValue.text = "\(RUPEES_SYMBOL) \(fare)"
    }
    
    func calculateBaseFareAndServiceTax(){
        for dict in arrSelecteSeats{
            totalBaseFare += Double(dict[RES_BaseFare]!)!
            totalServiceTax +=  Double(dict[RES_ServiceTax]!)!
        }
    }
    
    func getCancellationPloicy() {
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_OPERATOR_ID: dictRoute[RES_CompanyID] as! String]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetCancellationPolicy, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            self.lblNote.text = dict[RES_note] as? String
            self.arrCancellationPolicy = dict[RES_data] as! [typeAliasStringDictionary]
            self.showCancellationDetail()
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: .WARNING)
        }) {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    func showCancellationDetail(){
        tableViewList.rowHeight = HEIGHT_CANCELLATION_POLICY_CELL
        tableViewList.tableFooterView = UIView.init(frame: CGRect.zero)
        tableViewList.register(UINib.init(nibName: CELL_CANCELLATION_POLICY, bundle: nil), forCellReuseIdentifier: CELL_CANCELLATION_POLICY)
        tableViewList.reloadData()
        _VKPopOver = VKPopover.init(self.viewCancellationPolicy, animation: POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE, animationDuration: 0.3, isBGTransparent: false, borderColor: .clear, borderWidth: 0, borderCorner: 5, isOutSideClickedHidden: true)
        _VKPopOver.delegate = self
        self.navigationController?.view.addSubview(_VKPopOver)
        tableViewList.reloadData()
    }
    
    @IBAction func btnProcessToPayAction() {
        
        var isPaidFees:Bool = false
        if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
            isPaidFees = true;
        }
        else{
            if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if isPaidFees {
            
            let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
                rechargeVC.cart_SubCategory = "1"
                rechargeVC.cart_PrepaidPostpaid = "1"
                rechargeVC.cart_PlanTypeID = dictRoute[RES_ToCityId]! as! String
                rechargeVC.cart_MobileNo = stU_Mobile
                rechargeVC.cart_totalServiceTax = String(totalServiceTax)
                rechargeVC.cart_totalPassengers = String(arrSelecteSeats.count)
                rechargeVC.cart_OperatorId = dictRoute[RES_CompanyID] as! String
                rechargeVC.cart_RegionId = dictRoute[RES_FromCityId] as! String
                rechargeVC.cart_CategoryId = "8"
                rechargeVC.cart_journeyDate = (lblDateOfJourney.text?.trim())!
                rechargeVC.cart_subTotal = String(totalBaseFare)
                rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.BUS_BOOKING
                rechargeVC.cart_arrselectedSeats = arrSelecteSeats
                rechargeVC.cart_Email = stU_Email
                rechargeVC.dictRoute = dictRoute
                rechargeVC.cart_TotalAmount = String(fare)
                rechargeVC.cart_DictBoardingPoint = dictBoardingPoint
                rechargeVC.cart_Extra1 = dictRoute[RES_ReferenceNumber] as! String
                rechargeVC.cart_arrayPassengerDetail = arrPassengerDetail
            
            let _gtmModel = GTMModel()
            _gtmModel.ee_type = GTM_BUS
            _gtmModel.name = GTM_BUS_BOOKING
            _gtmModel.price = "\(totalBaseFare)"
            _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            _gtmModel.brand = self.dictRoute[RES_CompanyName] as! String
            _gtmModel.category = "\(self.dictRoute[RES_FromCityName] as! String) To \(dictRoute[RES_ToCityName] as! String)"
            _gtmModel.variant = self.dictRoute[RES_ArrangementName] as! String
            _gtmModel.option = "Confirm Passenger Details"
            _gtmModel.step = 2
            _gtmModel.quantity = arrSelecteSeats.count
            _gtmModel.dimension5 = "\(self.dictRoute[RES_FromCityName] as! String) : \(dictRoute[RES_ToCityName] as! String)"
            _gtmModel.dimension6 = dictRoute[RES_BookingDate] as! String
            GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
            
            self.navigationController?.pushViewController(rechargeVC, animated: true)
        }
    }
    
    @IBAction func btnCancellationPolicyAction() {
        
        if arrCancellationPolicy.isEmpty{ self.getCancellationPloicy() }
        else{ self.showCancellationDetail() }
        
    }
    @IBAction func btnChangeBoardingPointAction() {
        
        arrBoardingPoints = [typeAliasStringDictionary]()
        let arrPointMain:[String] = (dictRoute[RES_BoardingPoints] as! String).components(separatedBy: "#")
        
        for str in arrPointMain {
            var dict = typeAliasStringDictionary()
            let arrPointSub = str.components(separatedBy: "|")
            if !arrPointSub.isEmpty{
                
                dict = [BOARDING_POINT_ID:arrPointSub[0],
                        BOARDING_POINT_NAME:arrPointSub[1],
                        BOARDING_POINT_TIME:arrPointSub[2]]
                arrBoardingPoints.append(dict)
            }
        }
        
        tableViewBoardingPoint.tableFooterView = UIView.init(frame: CGRect.zero)
        tableViewBoardingPoint.rowHeight = UITableViewAutomaticDimension
        tableViewBoardingPoint.register(UINib.init(nibName: CELL_IDENTIFIER_BOARDING_POINT_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_BOARDING_POINT_CELL)
        tableViewBoardingPoint.estimatedRowHeight = 40
        _VKPopOver = VKPopover.init(self.viewBoardingPoint, animation: POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE, animationDuration: 0.3, isBGTransparent: false, borderColor: .clear, borderWidth: 0, borderCorner: 5, isOutSideClickedHidden: true)
        _VKPopOver.delegate = self
        obj_AppDelegate.navigationController.view.addSubview(_VKPopOver)

    }
  
    @IBAction func btnBoardingPointOkAction() {
        _VKPopOver.closeVKPopoverAction()
    }
    @IBAction func btnCancellationPolicyOkAction() {
        _VKPopOver.closeVKPopoverAction()
    }
       
    //MARK: TABVLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableView == tableViewList ? arrCancellationPolicy.count :  arrBoardingPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tableViewList {
        
            let cell:CancellationPolicyCell = tableView.dequeueReusableCell(withIdentifier: CELL_CANCELLATION_POLICY) as! CancellationPolicyCell
            let dictCancellationDetail = arrCancellationPolicy[indexPath.row]
            let fromTime:Int = Int(dictCancellationDetail[RES_fromTime]!)!/60
            let toTime:Int = dictCancellationDetail[RES_fromTime]! == "0" ? 0 : Int(dictCancellationDetail[RES_toTime]!)!/60
            cell.lblCancellationTime.text = toTime != 0 ? "Between \(fromTime) to \(toTime) hours" : "Before \(fromTime) hours"
            cell.lblRefundPercentage.text = "\(dictCancellationDetail[RES_refundPercentage]!)%"
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell:BoardingPointCell = tableViewBoardingPoint.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_BOARDING_POINT_CELL) as! BoardingPointCell
            let dictPoint = arrBoardingPoints[indexPath.row]
            cell.lblTitle.text = dictPoint[BOARDING_POINT_NAME]
            cell.lblTime.text = dictPoint[BOARDING_POINT_TIME]
            if dictPoint == dictBoardingPoint {
                cell.accessoryType = .checkmark
                cell.lblTime.textColor = COLOUR_DARK_GREEN
                cell.lblTitle.textColor = COLOUR_DARK_GREEN
            }
            else{
                cell.accessoryType = .none
                cell.lblTime.textColor = COLOUR_GRAY
                cell.lblTitle.textColor = COLOUR_GRAY
            }
            cell.selectionStyle = .none
            return cell
        }
    }

    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewBoardingPoint {
            let dictPoint = arrBoardingPoints[indexPath.row]
            dictBoardingPoint = dictPoint
            tableViewBoardingPoint.reloadData()
            lblBoardingPoints.text = dictBoardingPoint[BOARDING_POINT_NAME]
            lblBoardingTime.text = dictBoardingPoint[BOARDING_POINT_TIME]
        }
    }
    
    
    //MARK: VKPOPOVER DELEGATE
    
    func vkPopoverClose() {
        
    }
}
