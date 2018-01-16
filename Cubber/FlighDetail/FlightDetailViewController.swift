//
//  FlightDetailViewController.swift
//  Cubber
//
//  Created by dnk on 09/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

let TRAVELLER_SEQ_NO                = "TRAVELLER_SEQ_NO"
let TRAVELLER_F_NAME                = "TRAVELLER_F_NAME"
let TRAVELLER_L_NAME                = "TRAVELLER_L_NAME"
let TRAVELLER_M_NAME                = "TRAVELLER_M_NAME"
let TRAVELLER_DOB                   = "TRAVELLER_DOB"
let TRAVELLER_PASSPORT_NO           = "TRAVELLER_PASSPORT_NO"
let TRAVELLER_VISA_TYPE             = "TRAVELLER_VISA_TYPE"
let TRAVELLER_PASSPORT_COUNTRY      = "TRAVELLER_PASSPORT_COUNTRY"
let TRAVELLER_PASSPORT_EXPIRE_DATE  = "TRAVELLER_PASSPORT_EXPIRE_DATE"
let TRAVELLER_NATIONALITY           = "TRAVELLER_NATIONALITY"
let TRAVELLER_FF_NO                 = "TRAVELLER_FF_NO"
let TRAVELLER_FF_AIRLINE            = "TRAVELLER_FF_AIRLINE"
let TRAVELLER_FF_AIRLINE_CODE       = "TRAVELLER_FF_AIRLINE_CODE"
let TRAVELLER_TITLE                 = "TRAVELLER_TITLE"
let TRAVELLER_TITLE_CODE                 = "TRAVELLER_TITLE_CODE"
let TRAVELLER_TYPE                  = "TRAVELLER_TYPE"
let TRAVELLER_NATIONALITY_CODE      = "TRAVELLER_NATIONALITY_CODE"
let TRAVELLER_PASSPORT_COUNTRY_CODE      = "TRAVELLER_PASSPORT_COUNTRY_CODE"
let TRAVELLER_VISA_TYPE_CODE             = "TRAVELLER_VISA_TYPE_CODE"
let TRAVELLER_CATEGORY_ID           = "TRAVELLER_CATEGORY_ID"

import UIKit

class FlightDetailViewController: UIViewController , AppNavigationControllerDelegate , UITableViewDataSource , UITableViewDelegate {

    
    
    //MARK: PROPERTIES
    
    @IBOutlet var viewBGMain: UIView!
    @IBOutlet var viewOneWayBG: UIView!
    @IBOutlet var viewOneWay_JournyInfo: UIView!
    @IBOutlet var viewOneWay_tableViewRouteInfo: UITableView!
    @IBOutlet var viewOneWay_imageViewAirline: UIImageView!
    @IBOutlet var viewOneWay_lblAirlineName: UILabel!
    @IBOutlet var viewOneWay_lblSourceCode: UILabel!
    @IBOutlet var viewOneWay_lblDepartureTime: UILabel!
    @IBOutlet var viewOneWay_lblArrivalTime: UILabel!
    @IBOutlet var viewOneWay_lblDestinationCode: UILabel!
    @IBOutlet var viewOneWay_DepDate: UILabel!
    @IBOutlet var viewOneWay_ArrivalDate: UILabel!
    @IBOutlet var viewOneWay_lblDuration: UILabel!
    
    @IBOutlet var viewOneWay_constraintTableViewStopsHeight: NSLayoutConstraint!
    
    @IBOutlet var viewRoundWayBG: UIView!
    @IBOutlet var viewRoundWay_JournyInfo: UIView!
    @IBOutlet var viewRoundWay_tableViewRouteInfo: UITableView!
    @IBOutlet var viewRoundWay_imageViewAirline: UIImageView!
    @IBOutlet var viewRoundWay_lblAirlineName: UILabel!
    @IBOutlet var viewRoundWay_lblSourceCode: UILabel!
    @IBOutlet var viewRoundWay_lblDepartureTime: UILabel!
    @IBOutlet var viewRoundWay_lblArrivalTime: UILabel!
    @IBOutlet var viewRoundWay_lblDestinationCode: UILabel!
    @IBOutlet var viewRoundWay_DepDate: UILabel!
    @IBOutlet var viewRoundWay_ArrivalDate: UILabel!
    @IBOutlet var viewRoundWay_lblDuration: UILabel!
    @IBOutlet var viewRoundWay_constraintTableViewStopsHeight: NSLayoutConstraint!
    
    @IBOutlet var viewRoundWayBottomToSuper: NSLayoutConstraint!
    
    @IBOutlet var viewOneWayBottomToSuper: NSLayoutConstraint!
    
    @IBOutlet var btnCancellationPolicy: UIButton!
    @IBOutlet var btnReturn_CancellationPolicy: UIButton!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_DatabaseModel = DatabaseModel()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var arrClassList = DataModel.getFlightClassList()

    internal var dictFlight = typeAliasDictionary()
    internal var arrAirlinesList = [typeAliasDictionary]()
    internal var arrAirportList = [typeAliasDictionary]()
    internal var depDate = Date()
    internal var returnDate = Date()
    internal var isRoundTrip:Bool = false
    internal var dictDestination = typeAliasDictionary()
    internal var dictSource = typeAliasDictionary()
    internal var noOfAdults = 1
    internal var noOfChild = 0
    internal var noOfInfants = 0
    internal var index = 0

    internal var dictClass = typeAliasDictionary()
    internal var visaNote:String = ""
    let _gtmModel = GTMModel()

    fileprivate var arrOneWayStopsList = [typeAliasDictionary]()
    fileprivate var arrRoundWayStopsList = [typeAliasDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.viewOneWay_tableViewRouteInfo.register(UINib.init(nibName: CELL_IDENTIFIER_FLIGHT_DETAIL_STOP_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_FLIGHT_DETAIL_STOP_CELL)
        self.viewOneWay_tableViewRouteInfo.rowHeight = 220
        
        self.viewRoundWay_tableViewRouteInfo.register(UINib.init(nibName: CELL_IDENTIFIER_FLIGHT_DETAIL_STOP_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_FLIGHT_DETAIL_STOP_CELL)
        self.viewRoundWay_tableViewRouteInfo.rowHeight = 220
        self.setFlightDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated:Bool){
        
        super.viewDidAppear(animated)
        self.viewOneWay_JournyInfo.setViewBorder(.clear, borderWidth: 0, isShadow: true, cornerRadius: 5, backColor: .white)
        self.viewRoundWay_JournyInfo.setViewBorder(.clear, borderWidth: 0, isShadow: true, cornerRadius: 5, backColor: .white)
        self.btnCancellationPolicy.round(corners: [.bottomLeft,.bottomRight], radius: 5)
        self.btnReturn_CancellationPolicy.round(corners: [.bottomLeft,.bottomRight], radius: 5)
        self.SetScreenName(name: F_FLIGHT_SELECT_SEAT, stclass: F_MODULE_FLIGHT)
        self.sendScreenView(name: F_FLIGHT_SELECT_SEAT)
        
    }
    //MARK: NAVIGATION METHODS
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Flight Review")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    //MARK: CUSTOM METHODS
    
    
    @IBAction func btnContinueAction() {

        let dictWay =  dictFlight[RES_OneWay]!
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID : DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_TrackNo:dictWay[RES_TrackNo] as! String,
                      REQ_NoofAdult:"\(self.noOfAdults)",
                      REQ_NoofChild:"\(self.noOfChild)",
                      REQ_NoofInfant:"\(self.noOfInfants)"
        ]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_verifyTrackCode, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            
             DataModel.setHeaderToken(dict[RES_token] as! String)
            let dictFare = dict[RES_flightVerifyDetails]
            let travelBookDetailVC = TravellerBookDetailsViewController(nibName: "TravellerBookDetailsViewController" , bundle: nil)
            travelBookDetailVC.arrAirlinesList = self.arrAirlinesList
            travelBookDetailVC.dictFlight = self.dictFlight
            travelBookDetailVC.depDate = self.depDate
            travelBookDetailVC.returnDate = self.returnDate
            travelBookDetailVC.isRoundTrip = self.isRoundTrip
            travelBookDetailVC.arrAirportList = self.arrAirportList
            travelBookDetailVC.dictSource = self.dictSource
            travelBookDetailVC.dictDestination = self.dictDestination
            travelBookDetailVC.dictClass = self.dictClass
            travelBookDetailVC.noOfAdults = self.noOfAdults
            travelBookDetailVC.noOfChild = self.noOfChild
            travelBookDetailVC.noOfInfants = self.noOfInfants
            travelBookDetailVC.fareDetail = dictFare as! typeAliasDictionary
            travelBookDetailVC.visaNote = dict[RES_visaNote] as! String
            self.navigationController?.pushViewController(travelBookDetailVC, animated: true)
            GTMModel.pushAddToCartBus(gtmModel: self._gtmModel)
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] != nil ? dict[RES_message] as! String : MSG_ERR_SOMETING_WRONG, messageType: .WARNING)
            self._KDAlertView.didClick(completion: { (clicked) in
                self.obj_AppDelegate.navigateToViewController(FlightBookingViewController(nibName: "FlightBookingViewController", bundle: nil), animated: true)

            })
        }) {
            
        }
    }
    
    func setFlightDetail() {
    
        let dateFormat = DateFormatter()
        let dateFormat1 = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateFormat1.dateFormat = "EEE, MMM dd, yyyy"
        self.view.layoutIfNeeded()
        
        //ONE WAY
        viewOneWayBottomToSuper.priority = PRIORITY_HIGH
        viewRoundWayBottomToSuper.priority = PRIORITY_LOW
        viewRoundWayBG.isHidden = true

        let dictOneWay = self.dictFlight[RES_OneWay] as! typeAliasDictionary
        viewOneWay_lblSourceCode.text = dictOneWay[RES_FromAirportCode] as? String
        viewOneWay_lblDestinationCode.text = dictOneWay[RES_ToAirportCode] as? String
        viewOneWay_lblDepartureTime.text = dictOneWay[RES_DepTime] as? String
        viewOneWay_lblArrivalTime.text = dictOneWay[RES_ArrTime
            ] as? String
        
        let arrStopList:[typeAliasDictionary] = dictFlight[RES_stopList] as! [typeAliasDictionary]
        arrOneWayStopsList = arrStopList.filter({ (dict) -> Bool in
               return dict[RES_TripType] as! String ==  "One Trip"
                   })
        var date:Date = dateFormat.date(from: arrOneWayStopsList.first![RES_DepDate] as! String)!
        
       viewOneWay_DepDate.text = dateFormat1.string(from: date)
       if arrStopList.count > 1 { date = dateFormat.date(from: arrOneWayStopsList.last![RES_ArrDate] as! String)! }
       else { date = dateFormat.date(from: arrOneWayStopsList.first![RES_ArrDate] as! String)! }
        
       viewOneWay_ArrivalDate.text = dateFormat1.string(from: date)
    
        let arrTime = (dictOneWay[RES_TotalFlightTime] as! String).components(separatedBy: ":")
        var time = "\(arrTime.first!)h"
        if arrTime.count > 1 && arrTime.last != "00" {
            time += " \(arrTime.last!)m"
        }
        let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "\(time)")
        viewOneWay_lblDuration.attributedText = str
        
        var arrAirline = Set<String>()
        arrOneWayStopsList.forEach({ (dict) in
            arrAirline.insert(dict[RES_AirlineCode] as! String)
        })
      
        if arrAirline.count == 1 {
            let dictAirline =  self.getAirlineData(strCode: dictOneWay[RES_AirlineCode] as! String)
            if !dictAirline.isEmpty {
                viewOneWay_lblAirlineName.text = dictAirline[RES_AirlineName]! as? String
                viewOneWay_imageViewAirline.sd_setImage(with: (dictOneWay[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                    self.viewOneWay_imageViewAirline.image = image
                })
            }
        }
        else {
            viewOneWay_lblAirlineName.text = "Multi Airlines"
            self.viewOneWay_imageViewAirline.image  = #imageLiteral(resourceName: "flight_default")
        }
       
        viewOneWay_constraintTableViewStopsHeight.constant = viewOneWay_tableViewRouteInfo.rowHeight * CGFloat(arrOneWayStopsList.count)
        if arrOneWayStopsList.count > 1 {
            viewOneWay_constraintTableViewStopsHeight.constant  += CGFloat(arrOneWayStopsList.count - 1) * 30
        }
        viewOneWay_tableViewRouteInfo.reloadData()
        
        //ROUNDWAY
        if isRoundTrip {
            
            let dictRoundWay = self.dictFlight[RES_RoundWay] as! typeAliasDictionary
            viewRoundWay_lblSourceCode.text = dictRoundWay[RES_FromAirportCode] as? String
            viewRoundWay_lblDestinationCode.text = dictRoundWay[RES_ToAirportCode] as? String
            viewRoundWay_lblDepartureTime.text = dictRoundWay[RES_DepTime] as? String
            viewRoundWay_lblArrivalTime.text = dictRoundWay[RES_ArrTime
                ] as? String
            let arrStopList:[typeAliasDictionary] = dictFlight[RES_stopList] as! [typeAliasDictionary]
            arrRoundWayStopsList = arrStopList.filter({ (dict) -> Bool in
                return dict[RES_TripType] as! String ==  "Round Trip"
            })
            
            
            let arrTime = (dictRoundWay[RES_TotalFlightTime] as! String).components(separatedBy: ":")
            var time = "\(arrTime.first!)h"
            if arrTime.count > 1 && arrTime.last != "00" {
                time += " \(arrTime.last!)m"
            }
            let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "\(time)")
            viewRoundWay_lblDuration.attributedText = str

            var date:Date = dateFormat.date(from: arrRoundWayStopsList.first![RES_DepDate] as! String)!
            viewRoundWay_DepDate.text = dateFormat1.string(from: date)
            
            if arrStopList.count > 1 {date = dateFormat.date(from: arrRoundWayStopsList.last![RES_ArrDate] as! String)! }
            else { date = dateFormat.date(from: arrRoundWayStopsList.first![RES_ArrDate] as! String)! }
            
            viewRoundWay_ArrivalDate.text = dateFormat1.string(from: date)
            
            var arrAirline = Set<String>()
            arrRoundWayStopsList.forEach({ (dict) in
                arrAirline.insert(dict[RES_AirlineCode] as! String)
            })
            
            if arrAirline.count == 1 {
                let dictAirline =  self.getAirlineData(strCode: dictRoundWay[RES_AirlineCode] as! String)
                if !dictAirline.isEmpty {
                    viewRoundWay_lblAirlineName.text = dictAirline[RES_AirlineName]! as? String
                    viewRoundWay_imageViewAirline.sd_setImage(with: (dictAirline[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                        self.viewRoundWay_imageViewAirline.image = image
                    })
                }
            }
            else {
                viewRoundWay_lblAirlineName.text = "Multi Airlines"
                self.viewRoundWay_imageViewAirline.image  = #imageLiteral(resourceName: "ic_plane")
            }
            viewOneWayBottomToSuper.priority = PRIORITY_LOW
            viewRoundWayBottomToSuper.priority = PRIORITY_HIGH
            viewRoundWay_constraintTableViewStopsHeight.constant = viewRoundWay_tableViewRouteInfo.rowHeight * CGFloat(arrRoundWayStopsList.count)
            if arrRoundWayStopsList.count > 1 {
                viewRoundWay_constraintTableViewStopsHeight.constant  += CGFloat(arrRoundWayStopsList.count - 1) * 30
            }
            viewRoundWayBG.isHidden = false
            viewRoundWay_tableViewRouteInfo.reloadData()
        }
        
        
        //GTM PRODUCT CLICK // DETAIL
        _gtmModel.ee_type = GTM_FLIGHT
        _gtmModel.name = GTM_FLIGHT_BOOKING
        _gtmModel.price = String.init(describing:dictOneWay[RES_TotalAmount]!)
        _gtmModel.list = "Flight Section"
        _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
        _gtmModel.brand = (viewOneWay_lblAirlineName.text?.trim())!
        _gtmModel.category = "\(dictSource[RES_regionName] as! String) To \(dictDestination[RES_regionName] as! String)"
        _gtmModel.position = index
        _gtmModel.variant = dictOneWay[RES_TrackNo] as! String
        _gtmModel.dimension5 = "\(dictSource[RES_regionName] as! String) : \(dictDestination[RES_regionName] as! String)"
        _gtmModel.dimension6 = dictOneWay[RES_DepDate] as! String
        GTMModel.pushProductDetailFlight(gtmModel: _gtmModel)
        
        self.view.layoutIfNeeded()
    }
    
    func getAirlineData(strCode:String) -> typeAliasDictionary {
    
        for dict in self.arrAirlinesList {
            if dict[RES_AirlineCode] as! String == strCode {
                return dict
            }
        }
         return typeAliasDictionary()
    }
    
    @IBAction func btnCancellationPoliciesAction(_ sender: UIButton) {
    let dictWay = sender.tag == 1 ? self.dictFlight[RES_OneWay]! : self.dictFlight[RES_RoundWay]!
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID : DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_TrackNo:dictWay[RES_TrackNo] as! String]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_GetFareRule, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
             DataModel.setHeaderToken(dict[RES_token] as! String)
            let data = dict[RES_fareRulesAndDetails]!
            let _ = TermsAndCondView.init([RES_remark:data[RES_Farerules] as! String as AnyObject], isSignUP: false, isPrivacyPolicy: false , title:"Fare Rules \(self.dictSource[RES_AirportCode]!)-\(self.dictDestination[RES_AirportCode]!)")
            
        }, onFailure: { (code, dict) in
            
        }) {
        }
     }
    
    
    //MARK: TABLEVIEW DELEGATE
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == viewOneWay_tableViewRouteInfo ? arrOneWayStopsList.count : arrRoundWayStopsList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FlightDetailStopCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_FLIGHT_DETAIL_STOP_CELL) as! FlightDetailStopCell
        
        let dictStop = tableView == viewOneWay_tableViewRouteInfo ? arrOneWayStopsList[indexPath.section] : arrRoundWayStopsList[indexPath.section]
        cell.lblDepTime.text = dictStop[RES_DepTime]! as? String
        cell.lblArrTime.text = dictStop[RES_ArrTime]! as? String
        cell.lblSourceCode.text = dictStop[RES_FromAirportCode]! as? String
        cell.lblDestCode.text = dictStop[RES_ToAirportCode]! as? String
        cell.lblClassName.text = dictStop[RES_FlightClassName] as? String
        for dict in arrAirportList {
            if dict[RES_AirportCode] as! String == dictStop[RES_FromAirportCode] as! String {
                cell.lblSourceAirportName.text = dict[RES_AirportName] as? String
            }
            else if dict[RES_AirportCode] as! String == dictStop[RES_ToAirportCode] as! String {
                cell.lblDestAirportName.text = dict[RES_AirportName] as? String
            }
        }
        
        if dictStop[RES_FromTerminal] as! String != "0" &&  dictStop[RES_FromTerminal] as! String != "" {
            cell.lblTerminal.text = "Terminal : \(dictStop[RES_FromTerminal]!)"
        }
        
        if dictStop[RES_ToTerminal] as! String != "0" &&  dictStop[RES_ToTerminal] as! String != "" {
            cell.lblDestTerminal.text = "Terminal : \(dictStop[RES_FromTerminal]!)"
        }
       
        cell.lblAirlineNumber.text =  "\(dictStop[RES_AirlineCode] as! String)-\(dictStop[RES_FlightNo] as! String)"
        let dictAirline = self.getAirlineData(strCode: dictStop[RES_AirlineCode] as! String)
        if !dictAirline.isEmpty{
            cell.lblAirlineName.text = dictAirline[RES_AirlineName] as! String?
            cell.ImageAirline.sd_setImage(with: (dictAirline[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                cell.ImageAirline.image = image
            })
        }
        
        let arrTime = (dictStop[RES_TotalFlightTime] as! String).components(separatedBy: ":")
        var time = "\(arrTime.first!)h"
        if arrTime.count > 1 && arrTime.last != "00" {
            time += " \(arrTime.last!)m"
        }
        let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "\(time)")
        cell.lblDuration.attributedText = str
        
        let count = tableView == viewOneWay_tableViewRouteInfo ? arrOneWayStopsList.count : arrRoundWayStopsList.count
        if indexPath.section == count - 1 {
            cell.lblDestCode.textColor = .white
            cell.lblDestCode.backgroundColor = COLOUR_DARK_GREEN
        }
        else{
            cell.lblDestCode.textColor = COLOUR_DARK_GREEN
            cell.lblDestCode.backgroundColor = .white
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        label.textColor = COLOUR_TEXT_GRAY
        label.font = UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 12)
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        
        let count = tableView == viewOneWay_tableViewRouteInfo ? arrOneWayStopsList.count : arrRoundWayStopsList.count
        if count > 1 {
            if section == count-1 {return UIView.init()}
            else {
                
                let dictStop = tableView == viewOneWay_tableViewRouteInfo ? arrOneWayStopsList[section + 1] : arrRoundWayStopsList[section + 1]
                if dictStop[RES_HoldFlightTime] != nil {
                    let arrTime = (dictStop[RES_HoldFlightTime] as! String).components(separatedBy: ":")
                    var time = "\(arrTime.first!)h"
                    if arrTime.count > 1 && arrTime.last != "00" {
                        time += " \(arrTime.last!)m"
                    }
                    
                    let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "\(time) Layover.Please check transit visa if required.")
                    
                    str.setColorForText("\(time) Layover", with: COLOUR_ORANGE)
                    label.attributedText = str
                }

                return label
            }
        }
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let count = tableView == viewOneWay_tableViewRouteInfo ? arrOneWayStopsList.count : arrRoundWayStopsList.count
        if count > 1 {
            if section != count-1 { return 30 }
            else {return 0}
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    
}
