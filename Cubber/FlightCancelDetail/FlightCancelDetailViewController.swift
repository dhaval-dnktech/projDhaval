//
//  FlightCancelDetailViewController.swift
//  Cubber
//
//  Created by dnk on 17/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol FlightCancelViewDelegate {
    func FlightCancelView_refreshOrder()
}

class FlightCancelDetailViewController: UIViewController , AppNavigationControllerDelegate, UITableViewDelegate , UITableViewDataSource,KDAlertViewDelegate {

    
    //MARK: PROPERTIES
    
    //ONE WAY
    @IBOutlet var viewOneWayInfo: UIView!
    @IBOutlet var viewOneWay_imageViewAirline: UIImageView!
    @IBOutlet var viewOneWay_lblAirlineName: UILabel!
    @IBOutlet var viewOneWay_lblSourceCode: UILabel!
    @IBOutlet var viewOneWay_lblDepartureTime: UILabel!
    @IBOutlet var viewOneWay_lblArrivalTime: UILabel!
    @IBOutlet var viewOneWay_lblDestinationCode: UILabel!
    @IBOutlet var viewOneWay_DepDate: UILabel!
    @IBOutlet var viewOneWay_ArrivalDate: UILabel!
    @IBOutlet var viewOneWay_lblDuration: UILabel!
   
    
    //RETURN
    @IBOutlet var viewReturnInfo: UIView!
    
    @IBOutlet var viewRoundWay_imageViewAirline: UIImageView!
    @IBOutlet var viewRoundWay_lblAirlineName: UILabel!
    @IBOutlet var viewRoundWay_lblSourceCode: UILabel!
    @IBOutlet var viewRoundWay_lblDepartureTime: UILabel!
    @IBOutlet var viewRoundWay_lblArrivalTime: UILabel!
    @IBOutlet var viewRoundWay_lblDestinationCode: UILabel!
    @IBOutlet var viewRoundWay_DepDate: UILabel!
    @IBOutlet var viewRoundWay_ArrivalDate: UILabel!
    @IBOutlet var viewRoundWay_lblDuration: UILabel!
    
    @IBOutlet var viewPasssengerListHeader: UIView!
    @IBOutlet var tableViewPassengerList: UITableView!
    @IBOutlet var constraintViewPAssengerListHeaderTopToViewOneWayInfo: NSLayoutConstraint!
    
    @IBOutlet var constraintViewPassnegerListHeaderTopToViewRoundWayInfo:NSLayoutConstraint!
    
    //MARK: VARIABLES
     fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_DatabaseModel = DatabaseModel()
    fileprivate var _KDAlertView = KDAlertView()
    var delegate:FlightCancelViewDelegate? = nil
    fileprivate var arrPassengerList = [typeAliasDictionary]()
    fileprivate var arrSelectedPassengerList = [typeAliasDictionary]()
    fileprivate var dictFlight = typeAliasDictionary()
    internal var orderId:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewPassengerList.rowHeight = 50
        self.tableViewPassengerList.register(UINib.init(nibName: CELL_IDENTIFIER_FLIGHT_CANCEL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_FLIGHT_CANCEL)
        self.tableViewPassengerList.tableFooterView = UIView(frame: .zero)
        self.callGetFlightPassengerList()
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
        self.viewOneWayInfo.setShadowDrop(self.viewOneWayInfo)
        self.viewReturnInfo.setShadowDrop(self.viewReturnInfo)
        self.SetScreenName(name: F_FLIGHT_CANCEL_TICKET, stclass: F_MODULE_FLIGHT)
        self.sendScreenView(name: F_FLIGHT_CANCEL_TICKET)
    }
    
    //MARK: NAVIGATION METHODS
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Ticket Cancellation")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOM METHODS
    
    func setFlightDetail() {
        
        let dictOneWay = dictFlight[RES_OneWay] as! typeAliasDictionary
        self.viewOneWay_lblSourceCode.text = dictOneWay[RES_FromAirportCode] as! String?
        self.viewOneWay_lblDestinationCode.text = dictOneWay[RES_ToAirportCode] as! String?
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let date:Date = dateFormat.date(from: dictOneWay[RES_DepDate] as! String)!
        dateFormat.dateFormat = "EEE, MMM dd, yyyy"
        viewOneWay_DepDate.text = dateFormat.string(from: date)
        
        viewOneWay_lblArrivalTime.text = dictOneWay[RES_ArrTime] as! String?
        viewOneWay_lblDepartureTime.text = dictOneWay[RES_DepTime] as! String?
        
        dateFormat.dateFormat = "dd/MM/yyyy"
        let date1:Date = dateFormat.date(from: dictOneWay[RES_ArrDate] as! String)!
        dateFormat.dateFormat = "EEE, MMM dd, yyyy"
        viewOneWay_ArrivalDate.text = dateFormat.string(from: date1)
        
        let arrTime = (dictOneWay[RES_TotalFlightTime] as! String).components(separatedBy: ":")
        var time = "\(arrTime.first!)h"
        if arrTime.count > 1 && arrTime.last != "00" {
            time += " \(arrTime.last!)m"
        }
        let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "\(time)")
        viewOneWay_lblDuration.attributedText = str
        viewOneWay_imageViewAirline.sd_setImage(with: (dictOneWay[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
            self.viewOneWay_imageViewAirline.image = image
        })
        viewOneWay_lblAirlineName.text = dictOneWay[RES_AirlineName] as! String
        
        if dictFlight[RES_RoundWay] != nil {
            
            let dictRoundWay = dictFlight[RES_RoundWay] as! typeAliasDictionary
            self.viewRoundWay_lblSourceCode.text = dictRoundWay[RES_FromAirportCode] as! String?
            self.viewRoundWay_lblDestinationCode.text = dictRoundWay[RES_ToAirportCode] as! String?
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let date:Date = dateFormat.date(from: dictRoundWay[RES_DepDate] as! String)!
            dateFormat.dateFormat = "EEE, MMM dd, yyyy"
            
            dateFormat.dateFormat = "dd/MM/yyyy"
            let date1:Date = dateFormat.date(from: dictRoundWay[RES_ArrDate] as! String)!
            dateFormat.dateFormat = "EEE, MMM dd, yyyy"
            viewRoundWay_ArrivalDate.text = dateFormat.string(from: date1)
            viewRoundWay_DepDate.text = dateFormat.string(from: date)

            viewRoundWay_lblArrivalTime.text = dictRoundWay[RES_ArrTime] as! String?
            viewRoundWay_lblDepartureTime.text = dictRoundWay[RES_DepTime] as! String?
            
            let arrTime = (dictRoundWay[RES_TotalFlightTime] as! String).components(separatedBy: ":")
            var time = "\(arrTime.first!)h"
            if arrTime.count > 1 && arrTime.last != "00" {
                time += " \(arrTime.last!)m"
            }
            let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "\(time)")
            viewRoundWay_lblDuration.attributedText = str
            
            constraintViewPAssengerListHeaderTopToViewOneWayInfo.priority = PRIORITY_LOW
            constraintViewPassnegerListHeaderTopToViewRoundWayInfo.priority = PRIORITY_HIGH
            viewReturnInfo.isHidden = false
            viewRoundWay_imageViewAirline.sd_setImage(with: (dictRoundWay[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                self.viewOneWay_imageViewAirline.image = image
            })
            viewRoundWay_lblAirlineName.text = dictRoundWay[RES_AirlineName] as! String
        }
        else {
            constraintViewPAssengerListHeaderTopToViewOneWayInfo.priority = PRIORITY_HIGH
            constraintViewPassnegerListHeaderTopToViewRoundWayInfo.priority = PRIORITY_LOW
            viewReturnInfo.isHidden = true
        }
        self.view.setShadowDrop(viewOneWayInfo)
        self.view.setShadowDrop(viewReturnInfo)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnCancelTicketAction() {
    
        if arrSelectedPassengerList.isEmpty {
            _KDAlertView.showMessage(message: "Please select passenger.", messageType: .WARNING)
            return
        }
        else if !arrSelectedPassengerList.isEmpty {
           // _KDAlertView.showMessage(message: MSG_QUE_CANCEL_TICKET, messageType: MESSAGE_TYPE.QUESTION)
            _KDAlertView.showMessage(message: MSG_QUE_CANCEL_TICKET, messageType: .QUESTION, title: "Cancel Ticket?")
             _KDAlertView.alertDelegate = self
            return
        }
    }
    
    func callGetFlightPassengerList() {
    
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_ORDER_ID:orderId]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetFlightPassengerList, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            let dictTripDetal = dict[RES_tripDetails] as! typeAliasDictionary
            self.arrPassengerList = dictTripDetal[RES_passengerList] as! [typeAliasDictionary]
            self.dictFlight = (dictTripDetal[RES_flightArray] as! [typeAliasDictionary]).first!
            self.setFlightDetail()
            self.tableViewPassengerList.reloadData()
        }, onFailure: { (code, dict) in
            
        }) { 
            
        }
    }
    
    
    func isPassengerSelected(dictPass:typeAliasDictionary) -> Int {
        for i in 0..<arrSelectedPassengerList.count{
            let dict = arrSelectedPassengerList[i]
            if dict[RES_PaxSeqNo] as! String ==  dictPass[RES_PaxSeqNo] as! String {return i}
        }
        return -1
    }
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPassengerList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FlightCancelCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_FLIGHT_CANCEL) as! FlightCancelCell
        
        let dictPassenger = arrPassengerList[indexPath.row]
        cell.lblPassengerName.text = "\(dictPassenger[RES_Title]!) \(dictPassenger[RES_FirstName]!) \(dictPassenger[RES_LastName]!)"
        cell.lblPassengerType.text = dictPassenger[RES_PassengerType] as! String == "1" ? "Adult" : dictPassenger[RES_PassengerType] as! String == "2" ? "Child" : "Infant"
        let ind = isPassengerSelected(dictPass: dictPassenger)
        cell.btnCheckBox.isSelected = ind > -1 ? true : false
        cell.selectionStyle = .none
        return cell
    }
     //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictPassenger = arrPassengerList[indexPath.row]
        let ind = isPassengerSelected(dictPass: dictPassenger)
        if ind > -1 {
            arrSelectedPassengerList.remove(at: ind)
        }
        else{arrSelectedPassengerList.append(dictPassenger)}
        self.tableViewPassengerList.reloadData()
    }
    
    //MARK: KD ALERT DELEGATE
    func messageYesAction() {
        
        var seqNo = ""
        for dict in arrSelectedPassengerList{
            seqNo += seqNo == "" ? dict[RES_PaxSeqNo] as! String : ",\(dict[RES_PaxSeqNo])"
        }
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_ORDER_ID:self.orderId,
                      REQ_PASSENGER_SEQ_NO:seqNo]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_flightTicketCancellation, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
             self._KDAlertView.showMessage(message: dict[RES_message] != nil ? dict[RES_message] as! String : MSG_ERR_SOMETING_WRONG, messageType: .WARNING)
            self._KDAlertView.didClick(completion: { (completed) in
                self.appNavigationController_BackAction()
                self.delegate?.FlightCancelView_refreshOrder()
            })
        }, onFailure: { (code, dict) in
             self._KDAlertView.showMessage(message: dict[RES_message] != nil ? dict[RES_message] as! String : MSG_ERR_SOMETING_WRONG, messageType: .WARNING)
        }) {
        }

    }
    
    func messageNoAction() {
        print("Back Action")
    }
    func messageOkAction() {
        print("OK Action")
    }

}
