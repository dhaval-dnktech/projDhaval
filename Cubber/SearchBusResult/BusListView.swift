//
//  BusListView.swift
//  Cubber
//
//  Created by dnk on 06/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol BusListViewDelegate {
    func BusListViw_ArrRoute(arr:[typeAliasDictionary])
}

class BusListView: UIView , UITableViewDataSource , UITableViewDelegate{

    
    //MARK: CONSTANTS
    
    let DURATION        = "DURATION"
    let TOTAL_MINUTES   = "TOTAL_MINUTES"
    let PRICE           = "PRICE"
    let DEPARTURE_TIME  = "DEPARTURE_TIME"
    let ARR_AMOUNT      = "ARR_AMOUNT"
    
    //MARK: PROPERTIES
    
    @IBOutlet var tableViewDetail: UITableView!
    
    @IBOutlet var lblNoBusFound: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate var dictSource = typeAliasStringDictionary()
    fileprivate var dictDestination = typeAliasStringDictionary()
    internal var dateOfJourney:String = ""
    internal var arrRoutes = [typeAliasDictionary]()
    fileprivate var arrSorted = [typeAliasDictionary]()
    internal var arrHeaderMenu = [typeAliasDictionary]()
    fileprivate var isAcending:Bool = true
    var delegate:BusListViewDelegate? = nil
    internal var minPrice:Int = 100
    internal var maxPrice:Int = 0
    fileprivate var isFirst:Bool = true
    
    //MARK: VIEW METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    init(frame: CGRect, dateOfJourney: String, source: typeAliasStringDictionary, dest: typeAliasStringDictionary) {
        super.init(frame: frame)
        self.loadXIB()
        self.dateOfJourney = dateOfJourney
        self.dictSource = source
        self.dictDestination = dest
    }
    
    fileprivate func loadXIB() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        
        self.layoutIfNeeded()
        
        self.tableViewDetail.rowHeight = UITableViewAutomaticDimension
        self.tableViewDetail.estimatedRowHeight = HEIGHT_BUS_LIST_CELL
        self.tableViewDetail.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewDetail.register(UINib.init(nibName: CELL_IDENTIFIER_BUS_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_BUS_LIST_CELL)
    }

    //MARK: CUSTOM METHODS
    
    internal func setBusListData(valSortType:Int , isAppliedFilter:Bool){
        if arrRoutes.isEmpty {
            if isAppliedFilter{
                arrSorted = arrRoutes
                self.tableViewDetail.reloadData()
                lblNoBusFound.isHidden = false
            }
            else{
                self.tableViewDetail.reloadData()
                self.callAvailableRoutesService()
            }
        }
        else{
            lblNoBusFound.isHidden = true
            arrSorted = arrRoutes
            if valSortType != VAL_SORT_POPULAR {
                arrSorted = self.sortArray(valSortType)
            }
            tableViewDetail.reloadData()
        }
    }
    
    func sortArray(_ valSortType:Int) -> [typeAliasDictionary] {
        
        if !arrHeaderMenu.isEmpty{
            let dictHeader = arrHeaderMenu[valSortType]
            isAcending = dictHeader[IS_ACCENDING] as! String == "true" ? true : false
        }
        var arr = arrSorted
        if valSortType == VAL_SORT_TIME {
        arr.sort(by: { (dict, dict1) -> Bool in
            if isAcending{return ((dict[DEPARTURE_TIME] as! Date).compare (dict1[DEPARTURE_TIME] as! Date) == .orderedAscending)}
            else{return ((dict[DEPARTURE_TIME] as! Date).compare (dict1[DEPARTURE_TIME] as! Date) == .orderedDescending)}})
        }
        else if valSortType == VAL_SORT_DURATION {
           arr.sort(by: { (dict, dict1) -> Bool in
            if isAcending{return (dict[TOTAL_MINUTES] as! Int) < (dict1[TOTAL_MINUTES] as! Int)}
            else{return (dict[TOTAL_MINUTES] as! Int) > (dict1[TOTAL_MINUTES] as! Int)}
           })
        }
        else if valSortType == VAL_SORT_PRICE {
            arr.sort(by: { (dict, dict1) -> Bool in
                if isAcending{return Int((dict[ARR_AMOUNT] as! [String]).first!)! < Int((dict1[ARR_AMOUNT] as! [String]).first!)!}
                else{return Int((dict[ARR_AMOUNT] as! [String]).first!)! > Int((dict1[ARR_AMOUNT] as! [String]).first!)!}
            })
        }
        return arr
    }
    
    func callAvailableRoutesService() {
        
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_SOURCE_ID] = dictSource[RES_sourceId]
        params[REQ_DESTINATION_ID] = dictDestination[RES_destinationId]
        params[REQ_DATE] = dateOfJourney
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetAvailableRoutes, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token]! as! String)
            self.arrRoutes = dict[RES_data] as! [typeAliasDictionary]
            self.setArrayData()
            
            //GTM PRODUCT IMPRESSION BUS
            
            var arrImpression = [typeAliasStringDictionary]()
            for i in 0..<self.arrRoutes.count{
                let dictRoute = self.arrRoutes[i]
                
                var gtmDict = typeAliasStringDictionary()
                gtmDict[GTM_name] = GTM_BUS_BOOKING
                gtmDict[GTM_id] = dictRoute[RES_CompanyID] as? String
                gtmDict[GTM_price] = dictRoute[self.ARR_AMOUNT]?.lastObject as? String
                gtmDict[GTM_brand] = dictRoute[RES_CompanyName] as? String
                gtmDict[GTM_category] = "\(dictRoute[RES_FromCityName] as! String) To \(dictRoute[RES_ToCityName] as! String)"
                gtmDict[GTM_variant] = dictRoute[RES_ArrangementName] as? String
                gtmDict[GTM_position] = "\(i as Int)"
                gtmDict[GTM_list] = "Bus Section"
                gtmDict[GTM_dimension5] = "\(dictRoute[RES_FromCityName] as! String) : \(dictRoute[RES_ToCityName] as! String)"
                gtmDict[GTM_dimension6] = dictRoute[RES_BookingDate] as? String
                arrImpression.append(gtmDict)
            }
            let loopCount:Int =  arrImpression.count/10
            if loopCount > 1 {
                var indexPointer:Int = 0
                for i in 0..<loopCount {
                    var arrPush = [typeAliasStringDictionary]()
                    arrPush.append(contentsOf: arrImpression[indexPointer..<(indexPointer+10)])
                    indexPointer += 10
                    if i == (loopCount - 1) {
                        arrPush.append(contentsOf: arrImpression[indexPointer..<arrImpression.count])
                    }
                    GTMModel.pushProductImpressions(impressions: arrPush)
                }
            }
            else {
                 GTMModel.pushProductImpressions(impressions: arrImpression)
                // PUSH DATA HERE TO GTM MODEL
            }
            
        }, onFailure: { (code, dict) in
            self.tableViewDetail.isHidden = true
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
            let _ = self.obj_AppDelegate.navigationController.popViewController(animated: true)
            
        }) {
         let _ = self.obj_AppDelegate.navigationController.popViewController(animated: true)
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        }
        
    }
    
    func setArrayData(){
        
        for i in 0..<arrRoutes.count{
            
            var dictRoute:typeAliasDictionary = arrRoutes[i]
            dictRoute = self.getDuration(dictRoute: dictRoute)
            dictRoute[ARR_AMOUNT] = self.getAmount(dictRoute: dictRoute) as AnyObject!
            arrRoutes[i] = dictRoute
        }
        arrSorted = arrRoutes
        tableViewDetail.reloadData()
        self.delegate?.BusListViw_ArrRoute(arr: self.arrRoutes)
    }
    
    func getDuration( dictRoute:typeAliasDictionary) -> typeAliasDictionary{
        
        var dict = dictRoute
        let stDepTym:String = "\(dictRoute[RES_BookingDate]!) \(dictRoute[RES_CityTime]!)"
        let stArriTym:String = "\(dictRoute[RES_ApproxArrival]!)"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormat.locale = Locale(identifier: "en_US_POSIX")
        let dateDep:Date = dateFormat.date(from: stDepTym)!
        let dateArri:Date = dateFormat.date(from: stArriTym)!
        let DiffMins:Int = Calendar.current.dateComponents([.minute], from: dateDep, to: dateArri).minute!
        let hours = DiffMins/60
        let mins = DiffMins%60
        
        dict[DURATION] = mins == 0 ? "\(String(hours)) hours" as AnyObject? : "\(String(hours)) hours and \(String(mins)) minutes" as AnyObject?
        dict[DEPARTURE_TIME] = dateDep as AnyObject?
        dict[TOTAL_MINUTES] = DiffMins as AnyObject?
        return dict
    }
    
    func getAmount(dictRoute:typeAliasDictionary) -> [String] {
        
        
        var arrAmount = [String]()
        
        if dictRoute[RES_AcSeatRate] as! String != "0"{
            arrAmount.append(dictRoute[RES_AcSeatRate] as! String)
        }
        if dictRoute[RES_AcSleeperRate] as! String != "0"{
            arrAmount.append(dictRoute[RES_AcSleeperRate] as! String)
        }
        if dictRoute[RES_AcSlumberRate] as! String != "0"{
            arrAmount.append(dictRoute[RES_AcSlumberRate] as! String)
        }
        if dictRoute[RES_NonAcSeatRate] as! String != "0"{
            arrAmount.append(dictRoute[RES_NonAcSeatRate] as! String)
        }
        if dictRoute[RES_NonAcSleeperRate] as! String != "0"{
            arrAmount.append(dictRoute[RES_NonAcSleeperRate] as! String)
        }
        if dictRoute[RES_NonAcSlumberRate] as! String != "0"{
            arrAmount.append(dictRoute[RES_NonAcSlumberRate] as! String)
        }

       arrAmount.sort { (str, str1) -> Bool in
         return Int(str)! < Int (str1)!
        }
        
        if isFirst {
            minPrice = Int(arrAmount.first!)!
            isFirst = false
        }
        
        if Int(arrAmount.first!)! < minPrice {minPrice = Int(arrAmount.first!)!}
        if Int(arrAmount.last!)! > maxPrice {maxPrice = Int(arrAmount.last!)!}
        return arrAmount
    }
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return arrSorted.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BusListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_BUS_LIST_CELL, for: indexPath) as!  BusListCell
        
        let dictRoute = arrSorted[indexPath.row]
        cell.lblTime.text = "\(dictRoute[RES_CityTime]!) - \(dictRoute[RES_ArrivalTime]!)"
        cell.lblDetail.text = dictRoute[RES_RouteName] as! String?
        cell.lblPrice.text = "\(RUPEES_SYMBOL)\((dictRoute[ARR_AMOUNT] as! [String]!).joined(separator: "/"))"
        cell.lblAvailability.text = "\(dictRoute[RES_EmptySeats]!) seats available"
        cell.lblName.text = dictRoute[RES_CompanyName] as? String
        cell.lblDuration.text = dictRoute[DURATION] as? String
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictRouteInfo = arrSorted[indexPath.row]
        let params = [RES_userId:DataModel.getUserInfo()[RES_userID]!,
                      RES_operatorName:dictRouteInfo[RES_CompanyName]!,
                      RES_ArrangementName:dictRouteInfo[RES_ArrangementName],
                      RES_RouteName:dictRouteInfo[RES_RouteName]!,
                      FIR_SELECT_CONTENT:"Select Bus"] as [String : Any]
        obj_AppDelegate.navigationController.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])
        let seatSelectVC = SeatSelectionViewController(nibName: "SeatSelectionViewController"
            , bundle: nil)
        seatSelectVC.dictRoute = dictRouteInfo
        DataModel.setArrSelectedSeat(array: [typeAliasStringDictionary]())
        
        //GTM PRODUCT CLICK // DETAIL
        let _gtmModel = GTMModel()
        _gtmModel.ee_type = GTM_BUS
        _gtmModel.name = GTM_BUS_BOOKING
        _gtmModel.price = (dictRouteInfo[self.ARR_AMOUNT]?.lastObject as? String)!
        _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
        _gtmModel.brand = dictRouteInfo[RES_CompanyName] as! String
        _gtmModel.category = "\(dictRouteInfo[RES_FromCityName] as! String) To \(dictRouteInfo[RES_ToCityName] as! String)"
        _gtmModel.position = indexPath.row
        _gtmModel.variant = dictRouteInfo[RES_ArrangementName] as! String
        _gtmModel.dimension5 = "\(dictRouteInfo[RES_FromCityName] as! String) : \(dictRouteInfo[RES_ToCityName] as! String)"
        _gtmModel.dimension6 = dictRouteInfo[RES_BookingDate] as! String
        GTMModel.pushProductClick(gtmModel: _gtmModel)
        GTMModel.pushProductDetailBus(gtmModel: _gtmModel)
        
        obj_AppDelegate.navigationController.pushViewController(seatSelectVC, animated: true)
    }
}
