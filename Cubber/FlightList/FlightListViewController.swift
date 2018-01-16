//
//  FlightListViewController.swift
//  Cubber
//
//  Created by dnk on 03/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

let FLIGHT_FILTER_TYPE  = "FLIGHT_FILTER_TYPE"
let FLIGHT_FILTER_VALUE = "FLIGHT_FILTER_VALUE"

import UIKit
import ImageIO
import ModelIO


class FlightListViewController: UIViewController, AppNavigationControllerDelegate  , UITableViewDelegate , UITableViewDataSource , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , PreferedAirlineCellDelegate , AirlineListCellDelegate {

    //MARK: CONSTANTS
    fileprivate let SORT_PRICE:Int      = 1
    fileprivate let SORT_DEPARTURE:Int  = 2
    fileprivate let SORT_DURATION:Int   = 3
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_DatabaseModel = DatabaseModel()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var arrFlightListMain = [typeAliasDictionary]()
    fileprivate var arrFlightList = [typeAliasDictionary]()
    fileprivate var arrAirlinesList = [typeAliasDictionary]()
    fileprivate var arrAirlinesListMain = [typeAliasDictionary]()
    fileprivate var arrAirportList = [typeAliasDictionary]()
    fileprivate var selectedSortType:Int = 0
    fileprivate var isUp:Bool = false
    fileprivate var arrStopList = [typeAliasDictionary]()
    fileprivate var arrReturnStopListReturn = [typeAliasDictionary]()
    
    internal var isRoundTrip:Bool = false
    internal var isNonStopsOnly:Bool = false
    internal var dictDestination = typeAliasDictionary()
    internal var dictSource = typeAliasDictionary()
    internal var journeyDate = Date()
    internal var returnDate = Date()
    internal var noOfAdults = 1
    internal var noOfChild = 0
    internal var noOfInfants = 0
    internal var dictClass = typeAliasDictionary()
    //FILTER DATA
    
    @IBOutlet var imageFilterStatus: UIImageView!
    
    fileprivate var arrDepartureReturnTimeData = [typeAliasDictionary]()
    fileprivate var arrDepartureReturnStopData = [typeAliasDictionary]()
    fileprivate var arrAirlineTypeData = [typeAliasDictionary]()
    fileprivate var arrSelectedAirlineTypeData = [typeAliasDictionary]()
    fileprivate var arrSelectedPreferedAirlines = [typeAliasDictionary]()
    fileprivate var arrSelectedDepartureTimeData = [typeAliasDictionary]()
    fileprivate var arrSelectedDepartureStopData = [typeAliasDictionary]()
    fileprivate var arrSelectedDepartureReturnTimeData = [typeAliasDictionary]()
    fileprivate var arrSelectedDepartureReturnStopData = [typeAliasDictionary]()
    
    //MARK: PROPERTIES
    
    
    @IBOutlet var viewLoaderBG: UIView!
    @IBOutlet var imageViewFlightLoader: UIImageView!
    @IBOutlet var viewRightNav: UIView!
    @IBOutlet var tableViewFlightList: UITableView!
    @IBOutlet var viewDateFilter: UIView!
    @IBOutlet var collectionViewDateFilter: UICollectionView!
    @IBOutlet var viewSortTypeBG: UIView!
    @IBOutlet var scrollViewPagination: UIScrollView!
    
    @IBOutlet var btnSortTypeCollection: [UIButton]!
    @IBOutlet var btnSortTypeTitleCollection: [UIButton]!
    @IBOutlet var imageSortTypeCollection: [UIImageView]!
    @IBOutlet var lblNoDataFound: UILabel!
    
    @IBOutlet var btnFilter: UIButton!
    
    @IBOutlet var viewSortTypeBottomCollection: [UIView]!
    
    @IBOutlet var constraintImageViewLoaderHeight: NSLayoutConstraint!
    //FILTER
    
    
    @IBOutlet var collectionViewDepartureTime: UICollectionView!
    @IBOutlet var collectionViewDepartureStop: UICollectionView!
    @IBOutlet var collectionViewReturnStop: UICollectionView!
    @IBOutlet var collectionViewReturnTime: UICollectionView!
    @IBOutlet var tableViewAirlineList: UITableView!
    @IBOutlet var tableViewPreferedAirlinesList: UITableView!
    @IBOutlet var constraintTableViewAirlinesListHeight: NSLayoutConstraint!
    @IBOutlet var constraintPreferedAirlinesListHeight: NSLayoutConstraint!
    @IBOutlet var constraintViewFilterTopToViewMain: NSLayoutConstraint!
    @IBOutlet var constraintViewMainTopToSuperView: NSLayoutConstraint!
    
    @IBOutlet var lblReturnTitle: UILabel!
    @IBOutlet var lblDepartureTitle: UILabel!
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet var scrollViewFilterBG: UIScrollView!
    @IBOutlet var viewReturnFiltersBG: UIView!
    
    @IBOutlet var constraintViewAirlineTypeTopToViewOneWayFilter: NSLayoutConstraint!
    @IBOutlet var constraintViewAirlineTypeTopToViewReturnFilter: NSLayoutConstraint!
    
    @IBOutlet var btnRefresh: UIButton!
    
    
    //MARK: DEFAULT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrDepartureReturnTimeData = ParameterModel.getDepartureReturnTimeList()
        arrDepartureReturnStopData = ParameterModel.getDepartureReturnStopList()
        arrAirlineTypeData = ParameterModel.getAirlineList()
        constraintViewMainTopToSuperView.constant = (self.view.frame.height + 100)
        tableViewAirlineList.register(UINib.init(nibName: CELL_IDENTIFIER_AIRLINE_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AIRLINE_LIST_CELL)
        tableViewAirlineList.rowHeight = HEIGHT_AIRLINE_LIST_CELL
        tableViewAirlineList.tableFooterView = UIView.init(frame: .zero)
        tableViewPreferedAirlinesList.register(UINib.init(nibName: CELL_IDENTIFIER_PREFERED_AIRLINE_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_PREFERED_AIRLINE_LIST_CELL)
        tableViewPreferedAirlinesList.rowHeight = HEIGHT_AIRLINE_LIST_CELL
        tableViewPreferedAirlinesList.tableFooterView = UIView.init(frame: .zero)
        
        self.collectionViewReturnStop.register(UINib.init(nibName: CELL_IDENTIFIER_DEPARTURE_RETURN_STOP_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_DEPARTURE_RETURN_STOP_CELL)
        self.collectionViewDepartureStop.register(UINib.init(nibName: CELL_IDENTIFIER_DEPARTURE_RETURN_STOP_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_DEPARTURE_RETURN_STOP_CELL)
        self.collectionViewReturnTime.register(UINib.init(nibName: CELL_IDENTIFIER_DEPARTURE_RETURN_TIME_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_DEPARTURE_RETURN_TIME_CELL)
        self.collectionViewDepartureTime.register(UINib.init(nibName: CELL_IDENTIFIER_DEPARTURE_RETURN_TIME_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_DEPARTURE_RETURN_TIME_CELL)
    
        if isNonStopsOnly{
            if isRoundTrip {
        arrSelectedDepartureReturnStopData.append(arrDepartureReturnStopData.first!)
            }
         arrSelectedDepartureStopData.append(arrDepartureReturnStopData.first!)
         }
        // self.callOperatorService()
        self.callGetFlightList(sortType:selectedSortType)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
       // self.setStaticImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        constraintTableViewAirlinesListHeight.constant = CGFloat(arrAirlineTypeData.count) * CGFloat(tableViewAirlineList.rowHeight)
        self.SetScreenName(name: F_FLIGHT_ALLBUSLIST, stclass: F_MODULE_FLIGHT)
        self.sendScreenView(name: F_FLIGHT_ALLBUSLIST)

        self.view.layoutIfNeeded()
        
    }
    
    //MARK: NAVIGATION METHODS
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setRightView(self, view: viewRightNav, totalButtons: 2)
        obj_AppDelegate.navigationController.setCustomTitle("\(dictSource[RES_regionName]!) To \(dictDestination[RES_regionName]!)")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        imageViewFlightLoader.stopAnimating()
        obj_OperationWeb.cancelTask()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: BUTTON METHODS
    
    @IBAction func btnRefreshAction() {
        self.btnResetAllAction()
        self.btnApplyFilterAction()
        UIView.animate(withDuration: 0.3, animations: {
            let transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            self.btnRefresh.transform = transform;
        }) { (completed) in
            let transform = CGAffineTransform(rotationAngle: 0);
            self.btnRefresh.transform = transform;
        }
    }
    
    @IBAction func btnSortTypeAction(_ sender: UIButton) {
        
        if sender.tag == selectedSortType {
            sender.isSelected = !sender.isSelected
        }
        
        isUp =  sender.isSelected

        for img in imageSortTypeCollection {
            if img.tag == sender.tag {
                let image:UIImage = (UIImage(named: isUp ? "ic_arrow_up" : "ic_arrow_down")?.withRenderingMode(.alwaysTemplate))!
                img.image = image
                img.isHidden = false
                img.tintColor = COLOUR_DARK_GREEN
            }
            else {
                let image:UIImage = (UIImage(named:"ic_arrow_down")?.withRenderingMode(.alwaysTemplate))!
                img.image =  image
                img.isHidden = true
                img.tintColor = COLOUR_TEXT_GRAY
            }
        }
        
        selectedSortType = sender.tag
        for btn in btnSortTypeTitleCollection {
            if btn.tag == selectedSortType{
                btn.setTitleColor(COLOUR_DARK_GREEN, for: .normal)
            }
            else {
                 btn.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
            }
        }
        self.sortFlightList(sortType: sender.tag)
        let offX = CGFloat((sender.tag - 1)) * scrollViewPagination.frame.width
        scrollViewPagination.setContentOffset(CGPoint.init(x: offX, y: 0), animated: true)
        for view in viewSortTypeBottomCollection {
            view.backgroundColor =  view.tag == sender.tag ? COLOUR_DARK_GREEN : .white
        }
    }
    
    @IBAction func btnFilterAction() {
        
        if isRoundTrip {
            constraintViewAirlineTypeTopToViewOneWayFilter.priority = PRIORITY_LOW
            constraintViewAirlineTypeTopToViewReturnFilter.priority = PRIORITY_HIGH
            viewReturnFiltersBG.isHidden = false
            lblReturnTitle.text = "Return To \(dictSource[RES_regionName]!)"
        }
        else{
            constraintViewAirlineTypeTopToViewOneWayFilter.priority = PRIORITY_HIGH
            constraintViewAirlineTypeTopToViewReturnFilter.priority = PRIORITY_LOW
            viewReturnFiltersBG.isHidden = true
        }
        
        lblDepartureTitle.text = "Deparure From \(dictSource[RES_regionName]!)"
        tableViewPreferedAirlinesList.reloadData()
        scrollViewFilterBG.setContentOffset(.zero, animated: false)
        constraintPreferedAirlinesListHeight.constant = HEIGHT_AIRLINE_LIST_CELL * CGFloat(self.arrAirlinesListMain.count)
        constraintViewMainTopToSuperView.constant = 0
        constraintViewFilterTopToViewMain.constant = 0//(self.view.frame.height/2) - 15
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        scrollViewFilterBG.scrollRectToVisible(.zero, animated: true)
    }
    
    @IBAction func btnFilterCloseAction() {
        constraintViewMainTopToSuperView.constant = ( self.view.frame.height + 100)
        constraintViewFilterTopToViewMain.constant = self.view.frame.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnResetAllAction() {
        
        arrSelectedAirlineTypeData = [typeAliasDictionary]()
        arrSelectedPreferedAirlines = [typeAliasDictionary]()
        arrSelectedDepartureTimeData = [typeAliasDictionary]()
        arrSelectedDepartureStopData = [typeAliasDictionary]()
        arrSelectedDepartureReturnTimeData = [typeAliasDictionary]()
        arrSelectedDepartureReturnStopData = [typeAliasDictionary]()
        
        self.collectionViewReturnStop.reloadData()
        self.collectionViewReturnTime.reloadData()
        self.collectionViewDepartureStop.reloadData()
        self.collectionViewDepartureTime.reloadData()
        self.tableViewPreferedAirlinesList.reloadData()
        self.tableViewAirlineList.reloadData()
    }
 
    @IBAction func btnApplyFilterAction() {
        
        self.btnFilterCloseAction()
        var arrFilter = [typeAliasDictionary]()
        let setFilter = {(type:FILTER_FLIGHT_LIST_TYPE , arrSel:[typeAliasDictionary] , key:String ) in

            let arrSeats:NSArray = arrSel as NSArray
            let stValue: String = ((arrSeats.value(forKey: key) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            let dictFilter = [FLIGHT_FILTER_TYPE:type.rawValue,FLIGHT_FILTER_VALUE:stValue] as [String : Any]
            arrFilter.append(dictFilter as typeAliasDictionary)
        }
        
        if !arrSelectedDepartureReturnStopData.isEmpty {
           setFilter(.RETURN_NO_OF_STOPS, arrSelectedDepartureReturnStopData, PARAMETER_VALUE)
        }
        if !arrSelectedDepartureStopData.isEmpty{
           setFilter(.NO_OF_STOPS, arrSelectedDepartureStopData, PARAMETER_VALUE)
        }
        if !arrSelectedDepartureTimeData.isEmpty{
           setFilter(.DEPARTURE_TIME, arrSelectedDepartureTimeData, PARAMETER_VALUE)
        }
        if !arrSelectedDepartureReturnTimeData.isEmpty{
           setFilter(.RETURN_DEPARTURE_TIME, arrSelectedDepartureReturnTimeData, PARAMETER_VALUE)
        }
        if !arrSelectedAirlineTypeData.isEmpty {
           setFilter(.FARE_TYPE, arrSelectedAirlineTypeData, PARAMETER_VALUE)
        }
        if !arrSelectedPreferedAirlines.isEmpty{
            setFilter(.PREFERED_AIRLINE, arrSelectedPreferedAirlines, RES_AirlineCode)
        }
        
        btnRefresh.isHidden = arrFilter.isEmpty
        
        let arrResult =  obj_DatabaseModel.getFlightListData(arrFilter)
        if !arrResult.isEmpty {
            self.arrFlightListMain = arrResult
            let btn = UIButton.init()
            btn.tag = 2
            self.btnSortTypeAction(btn)
            scrollViewPagination.isHidden = false
            lblNoDataFound.isHidden = true
            self.viewSortTypeBG.isHidden = false
        }
        else {
            scrollViewPagination.isHidden = true
            lblNoDataFound.isHidden = false
            self.viewSortTypeBG.isHidden = true
        }
    }
    
    
    //MARK: CUSTOM METHODS
    
    func createPaginationView() {
        
        for i in 0..<3 {
            
            let tag:Int = i + 101
            
            let xOrigin:CGFloat = CGFloat(i) * CGFloat(scrollViewPagination.frame.size.width)
            self.view.layoutIfNeeded()
            let tableviewPagination = UITableView.init(frame: CGRect.init(x: xOrigin, y: 0, width: scrollViewPagination.frame.size.width, height: scrollViewPagination.frame.size.height))
            tableviewPagination.tag = tag
            tableviewPagination.register(UINib.init(nibName: CELL_IDENTIFIER_FLIGHT_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_FLIGHT_LIST_CELL)
             tableviewPagination.register(UINib.init(nibName: CELL_IDENTIFIER_RETURN_FLIGHT_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_RETURN_FLIGHT_LIST_CELL)
            tableviewPagination.estimatedRowHeight = isRoundTrip ? 220 : 120
            tableviewPagination.rowHeight = UITableViewAutomaticDimension
            tableviewPagination.tableFooterView = UIView.init(frame: .zero)
            tableviewPagination.delegate = self
            tableviewPagination.dataSource = self
            tableviewPagination.backgroundColor = UIColor.groupTableViewBackground
            scrollViewPagination.addSubview(tableviewPagination)
          //  tableviewPagination.backgroundColor = i == 0 ? UIColor.red : .blue
            
            
            //---> SET AUTO LAYOUT
            
            tableviewPagination.translatesAutoresizingMaskIntoConstraints  = false
            
            //HEIGHT
            scrollViewPagination.addConstraint(NSLayoutConstraint.init(item: tableviewPagination, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            scrollViewPagination.addConstraint(NSLayoutConstraint.init(item: tableviewPagination, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            scrollViewPagination.addConstraint(NSLayoutConstraint.init(item: tableviewPagination, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
            
            //LEADING
            
            if i==0
            {
                scrollViewPagination.addConstraint(NSLayoutConstraint.init(item: tableviewPagination, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else{
                
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let scrollViewPrevious:UITableView = scrollViewPagination.viewWithTag(tag - 1) as! UITableView
                
                scrollViewPagination.addConstraint(NSLayoutConstraint.init(item: tableviewPagination, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollViewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
          /*  if (i == 2) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.scrollViewPagination.superview?.addConstraint(NSLayoutConstraint(item: tableviewPagination, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }*/

            scrollViewPagination.contentSize = CGSize.init(width: CGFloat(scrollViewPagination.frame.width) * CGFloat(btnSortTypeCollection.count), height: scrollViewPagination.frame.height)
            scrollViewPagination.isPagingEnabled = true
            self.view.layoutIfNeeded()
        }
        
        let btn = UIButton.init()
        btn.tag = 2
        self.btnSortTypeAction(btn)
    }
    
    func callOperatorService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_CATEGORY_ID:HOME_CATEGORY_TYPE.FLIGHT.rawValue] as [String : Any]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_OperatorList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: obj_AppDelegate.navigationController!.view, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
           self.arrAirlinesList = dict[RES_data] as! [typeAliasDictionary]
        }, onFailure: { (code, dict) in
            
        }, onTokenExpire: {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING); return })
        
    }
    
    func setStaticImage() {
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "plane25", withExtension: "gif")!)
        
        guard let source = CGImageSourceCreateWithData(imageData as! CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return
        }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        imageViewFlightLoader.animationImages = images
        imageViewFlightLoader.animationDuration = 2
        imageViewFlightLoader.startAnimating()
        self.viewLoaderBG.layoutIfNeeded()
    }
    
    func callGetFlightList(sortType:Int) {

        self.setStaticImage()
        viewLoaderBG.isHidden = false
        imageViewFlightLoader.isHidden = false
        btnFilter.isHidden = true
        btnRefresh.isHidden = true
       // return

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let stJourneyDate:String = dateFormatter.string(from: journeyDate)
        let stReturnDate:String  = dateFormatter.string(from: returnDate)
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_NoofAdult:"\(noOfAdults)",
                      REQ_NoofChild:"\(noOfChild)",
                      REQ_NoofInfant:"\(noOfInfants)",
                      REQ_FromAirportCode:dictSource[RES_AirportCode]!,//dictSource[RES_AirportCode]!
                      REQ_ToAirportCode:dictDestination[RES_AirportCode]!,//dictSource[RES_AirportCode]!
                      REQ_DepartureDate:stJourneyDate,
                      REQ_ReturnDate:isRoundTrip ? stReturnDate : "0",
                      REQ_TripType:isRoundTrip ? "2" : "1",
                      REQ_FlightClass:dictClass[RES_categoryCode] as! String,
                      REQ_SpecialFare:isRoundTrip ? "1" : "0",
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID]!
            ] as [String : Any]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetFlightList, methodType: .POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: UIView.init()
        , onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.imageViewFlightLoader.isHidden = true
            let dictData:typeAliasDictionary = dict[RES_flightListData] as! typeAliasDictionary
            self.arrAirlinesListMain = dictData[RES_AirlineListArray] as! [typeAliasDictionary]
            self.arrFlightListMain = dictData[RES_flightArray] as! [typeAliasDictionary]
          
            self.arrAirportList = dictData["AirportList"] as! [typeAliasDictionary]
            self.obj_DatabaseModel.deleteTableFlightData()
            
            //GTM PRODUCT IMPRESSION FLIGHT
            
            var arrImpression = [typeAliasStringDictionary]()
            for i in 0..<self.arrFlightListMain.count{
                let dictFlight = self.arrFlightListMain[i]
                let dictOneWay = dictFlight[RES_OneWay] as! typeAliasDictionary
                var gtmDict = typeAliasStringDictionary()
                gtmDict[GTM_name] = GTM_FLIGHT_BOOKING
                gtmDict[GTM_id] = DataModel.getUserInfo()[RES_userID] as! String?
                gtmDict[GTM_price] = dictOneWay[RES_TotalAmount] as? String
                gtmDict[GTM_brand] = self.getAirlineName(strCode: dictOneWay[RES_AirlineCode] as! String)
                gtmDict[GTM_category] = "\(self.dictSource[RES_regionName] as! String) To \(self.dictDestination[RES_regionName] as! String)"
                gtmDict[GTM_variant] = dictOneWay[RES_TrackNo] as? String
                gtmDict[GTM_list] = "Flight Section"
                gtmDict[GTM_position] = "\(i as Int)"
                gtmDict[GTM_dimension5] = "\(self.dictSource[RES_regionName] as! String) : \(self.dictDestination[RES_regionName] as! String)"
                gtmDict[GTM_dimension6] = stJourneyDate
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

            for dict:typeAliasDictionary in self.arrFlightListMain {
                self.obj_DatabaseModel.insertFlightListData(dict)
                
            }
            if self.journeyDate.isToday() {
                self.arrFlightListMain = self.obj_DatabaseModel.getCurrentFlightListData()
            }
            self.scrollViewPagination.isHidden = false
            self.lblNoDataFound.isHidden = true
            self.createPaginationView()
            self.btnFilter.isHidden = false
            self.viewSortTypeBG.isHidden = false
            self.viewLoaderBG.isHidden = true
            self.imageViewFlightLoader.stopAnimating()
        }, onFailure: { (code, dict) in
            self.viewSortTypeBG.isHidden = true
            self.scrollViewPagination.isHidden = true
            self.lblNoDataFound.isHidden = false
            self.btnFilter.isHidden = true
            self.viewLoaderBG.isHidden = true
            self.imageViewFlightLoader.isHidden = true
            self.imageViewFlightLoader.stopAnimating()
        }) { 
            self.imageViewFlightLoader.isHidden = true
            self.imageViewFlightLoader.stopAnimating()
            self.viewLoaderBG.isHidden = true
        }
    }
    
    func getAirlineName(strCode:String) -> String {
        
        var name:String = "Not Defined"
        for dict in self.arrAirlinesListMain { if dict[RES_AirlineCode] as! String == strCode { name = dict[RES_AirlineName] as! String ; return name } }
        return name
    }
    
    func sortFlightList(sortType:Int) {
        
        DesignModel.startActivityIndicator((self.navigationController?.view!)!)
        self.arrFlightList = [typeAliasDictionary]()
        let tableview:UITableView = scrollViewPagination.viewWithTag(sortType + 100) as! UITableView
        tableview.reloadData()
        self.arrFlightList = self.arrFlightListMain
        
        
        if sortType == SORT_PRICE {
           
                self.arrFlightList = self.arrFlightList.sorted(by: { (dict, dict1) -> Bool in
                    let dictOneWay = dict[RES_OneWay] as! typeAliasDictionary
                    let dictOneWay1 = dict1[RES_OneWay] as! typeAliasDictionary
                    let stAmount = String.init(describing:dictOneWay[RES_TotalAmount]!)
                    let stAmount1 = String.init(describing:dictOneWay1[RES_TotalAmount]!)
                    if isUp {
                        return Int(stAmount)! > Int(stAmount1)!
                    }
                    return Int(stAmount)! < Int(stAmount1)!
                })
        }
            
        else if sortType == SORT_DEPARTURE {
            
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            self.arrFlightList = self.arrFlightList.sorted(by: { (dict, dict1) -> Bool in
                let dictOneWay = dict[RES_OneWay] as! typeAliasDictionary
                let dictOneWay1 = dict1[RES_OneWay] as! typeAliasDictionary
                let stTime = String.init(describing:dictOneWay[RES_DepTime]!)
                let stTime1 = String.init(describing:dictOneWay1[RES_DepTime]!)
                if !isUp{return ((format.date(from: stTime))!.compare (format.date(from: stTime1)!) == .orderedAscending)}
                else{return ((format.date(from: stTime))!.compare (format.date(from: stTime1)!) == .orderedDescending)}
            })
        }
        else if sortType == SORT_DURATION {
            
            let getMinutes = { (time:String) -> Int in
                
                if time.isContainString(":") {
                    let arrTime = time.components(separatedBy: ":")
                    let Totalmins:Int = Int(arrTime[0])! * 60 + Int(arrTime[1])!
                    return Totalmins
                }
                else{
                 return (Int(time)! * 60)
                }
            }
            
            self.arrFlightList = self.arrFlightList.sorted(by: { (dict, dict1) -> Bool in
                let dictOneWay = dict[RES_OneWay] as! typeAliasDictionary
                let dictOneWay1 = dict1[RES_OneWay] as! typeAliasDictionary
                let stTime = String.init(describing:dictOneWay[RES_TotalFlightTime]!)
                let stTime1 = String.init(describing:dictOneWay1[RES_TotalFlightTime]!)
               
                if isUp {
                    return getMinutes(stTime) > getMinutes(stTime1)
                }
                return getMinutes(stTime) < getMinutes(stTime1)
            })
        }
        else{
        
        }
        if isNonStopsOnly{
            isNonStopsOnly = false
            btnApplyFilterAction()
        }
        tableview.reloadData()
        DesignModel.stopActivityIndicator()
    }
    
    func isExistPreferedAirlines(_ dict:typeAliasDictionary) -> Int {
        
        for i in 0..<arrSelectedPreferedAirlines.count {
            let dictAir = arrSelectedPreferedAirlines[i]
            if dict[RES_AirlineCode] as! String == dictAir[RES_AirlineCode] as! String {
                return i
            }
        }
        return -1
    }
    
    func isExistAirlineType(_ dict:typeAliasDictionary) -> Int {
        
        for i in 0..<arrSelectedAirlineTypeData.count {
            let dictAir = arrSelectedAirlineTypeData[i]
            if dict[PARAMETER_KEY] as! String == dictAir[PARAMETER_KEY] as! String {
                return i
            }
        }
        return -1
    }
    
    func isExistInSelectedArray(_ arrSelected:[typeAliasDictionary] , key:String , dict:typeAliasDictionary) -> Int {
    
        for i in 0..<arrSelected.count {
            let dictSel = arrSelected[i]
            if dict[key] as! String == dictSel[key] as! String {
                return i
            }
        }
        return -1
    }
    
    
    //MARK: TABLEVIEW DELEGATE
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewAirlineList {
            return arrAirlineTypeData.count
        }
        else  if tableView == tableViewPreferedAirlinesList {
            return arrAirlinesListMain.count
        }
        return arrFlightList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewAirlineList {
            let cell:AirlineListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AIRLINE_LIST_CELL) as! AirlineListCell
            cell.delegate = self
            let dictAirLine = arrAirlineTypeData[indexPath.row]
            cell.lblAirLineTitle.text = dictAirLine[PARAMETER_NAME] as? String
            cell.btnCheckBox.accessibilityIdentifier = String(indexPath.row)
            let ind = self.isExistAirlineType(dictAirLine)
            cell.btnCheckBox.isSelected = ind > -1 ? true : false
            cell.selectionStyle = .none
            return cell
        }
        else  if tableView == tableViewPreferedAirlinesList {
            
            let cell:PreferedAirlineCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PREFERED_AIRLINE_LIST_CELL) as! PreferedAirlineCell
            cell.delegate = self
            let dictAirLine = arrAirlinesListMain[indexPath.row]
            cell.lblAirlineTitle.text = dictAirLine[RES_AirlineName] as? String
            cell.imageViewAirline.sd_setImage(with: (dictAirLine[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                cell.imageViewAirline.image = image == nil ? #imageLiteral(resourceName: "ic_plane") : image
            })
            let ind = self.isExistPreferedAirlines(dictAirLine)
            cell.btnPreferedCheckBox.isSelected = ind > -1 ? true : false
            cell.btnPreferedCheckBox.accessibilityIdentifier = String(indexPath.row)
            cell.selectionStyle = .none
            return cell
        }
        else {
            if isRoundTrip {
                
                let cell:ReturnFlightListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_RETURN_FLIGHT_LIST_CELL) as! ReturnFlightListCell
                
                let dictFlight = arrFlightList[indexPath.row]
                
                if  dictFlight[RES_OneWay] != nil {
                    
                    let dictOneWay = dictFlight[RES_OneWay] as! typeAliasDictionary
                    if Int(dictOneWay[RES_Stops] as! String) == 0 {
                        cell.lblStops.text = "Nonstop"
                        cell.lblStopsString.text = ""
                    }
                    else{ cell.lblStops.text = "\(dictOneWay[RES_Stops]!) Stops"
                        cell.lblStopsString.text = "\(dictOneWay[RES_stopString]!)"
                    }
                    cell.lblFlightType.text = dictOneWay[RES_FareTypeText] as! String?
                    cell.lblSourceCode.text = dictOneWay[RES_FromAirportCode] as! String?
                    cell.lblDestinationCode.text = dictOneWay[RES_ToAirportCode] as! String?
                    cell.lblDepartureTime.text = dictOneWay[RES_DepTime] as! String?
                    cell.lblArrivalTime.text = dictOneWay[RES_ArrTime] as! String?
                    cell.lblFirstStop.text = cell.lblSourceCode.text
                    cell.lblLastStop.text = cell.lblDestinationCode.text
                    
                    cell.lblDepDate.text = dictOneWay[RES_DepDate] as! String?
                    cell.lblArrivalDate.text = dictOneWay[RES_ArrDate] as! String?
                    
                    let arrTime = (dictOneWay[RES_TotalFlightTime] as! String).components(separatedBy: ":")
                    var time = "\(arrTime.first!)h"
                    if arrTime.count > 1 && arrTime.last != "00" {
                        time += "\(arrTime.last!)m"
                    }
                    let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "Duration  \(time)")
                    str.setColorForText("Duration", with: .lightGray)
                    cell.lblTotalDuration.attributedText = str
                    cell.lblTotalAmount.text = "\(dictOneWay[RES_TotalAmount]!)".setThousandSeperator()
                    cell.lblUserCommission.text = "\(dictOneWay[RES_userCommissionNote]!)"
                    let width = cell.lblFlightType.text?.textWidth(25, textFont: cell.lblFlightType.font)
                    cell.constraintOneWayFlightTypeWidth.constant = width! + 10
                    
                   /* if dictOneWay[RES_image1] as! String == "" {
                        cell.imageAirlineSingle.sd_setImage(with: (dictOneWay[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                            cell.imageAirlineSingle.image = image == nil ? #imageLiteral(resourceName: "ic_plane") : image
                        })
                        cell.imageAirlineSingle.isHidden = false
                        cell.imageAirLineOne.isHidden = true
                        cell.imageAirlineTwo.isHidden = true
                    }
                    else {
                        cell.imageAirLineOne.sd_setImage(with: (dictOneWay[RES_image] as! String).convertToUrl())
                        cell.imageAirlineTwo.sd_setImage(with: (dictOneWay[RES_image1] as! String).convertToUrl())
                        cell.imageAirlineSingle.isHidden = true
                        cell.imageAirLineOne.isHidden = false
                        cell.imageAirlineTwo.isHidden = false
                    }*/
                }
                
                if  dictFlight[RES_RoundWay] != nil {
                    
                    let dictRoundWay = dictFlight[RES_RoundWay] as! typeAliasDictionary
                    if Int(dictRoundWay[RES_Stops] as! String) == 0 {
                        cell.viewReturn_lblStops.text = "Nonstop"
                        cell.lblReturn_StopsString.text = ""
                        
                    }
                    else{cell.viewReturn_lblStops.text = "\(dictRoundWay[RES_Stops]!) Stops"
                        cell.lblReturn_StopsString.text = "\(dictRoundWay[RES_stopString]!)"
                    }
                    cell.ViewReturn_lblFilghtTypeText.text = dictRoundWay[RES_FareTypeText] as! String?
                    cell.ViewReturn_lblFromAirportCode.text = dictRoundWay[RES_FromAirportCode] as! String?
                    cell.ViewReturn_lblToAirportCode.text = dictRoundWay[RES_ToAirportCode] as! String?
                    cell.ViewReturn_lblDepartureTime.text = dictRoundWay[RES_DepTime] as! String?
                    cell.ViewReturn_lblArrivalTime.text = dictRoundWay[RES_ArrTime] as! String?
                    cell.lblReturn_FirstStop.text = cell.ViewReturn_lblFromAirportCode.text
                    cell.lblReturn_LastStop.text = cell.ViewReturn_lblToAirportCode.text
                    
                    cell.lblReturnDepDate.text = dictRoundWay[RES_DepDate] as! String?
                    cell.lblReturnArrivalDate.text = dictRoundWay[RES_ArrDate] as! String?

                    
                    let arrTime = (dictRoundWay[RES_TotalFlightTime] as! String).components(separatedBy: ":")
                    var time = "\(arrTime.first!)h"
                    if arrTime.count > 1 && arrTime.last != "00" {
                        time += "\(arrTime.last!)m"
                    }
                    let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "Duration  \(time)")
                    str.setColorForText("Duration", with: .lightGray)
                    cell.ViewReturn_lblTotalFilghtTime.attributedText = str
                    cell.ViewReturn_lblCommission.text = "\(dictRoundWay[RES_userCommissionNote]!)"
                    let width = cell.ViewReturn_lblFilghtTypeText.text?.textWidth(25, textFont: cell.ViewReturn_lblFilghtTypeText.font)
                    cell.constraintReturnWayFlightTypeWidth.constant = width! + 10
                    cell.contentView.layoutIfNeeded()
                    var height:CGFloat = (cell.ViewReturn_lblCommission.text?.textHeight( self.scrollViewPagination.frame.width - 95 - width!, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 15)!))!
                    height = height > 25 ? height : 25
                    cell.constraintViewReturnFlightCommissionHeight.constant = height
                    
                 /*   if dictRoundWay[RES_image1] as! String == "" {
                        cell.ViewReturn_imageAirlineSingle.sd_setImage(with: (dictRoundWay[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                            cell.ViewReturn_imageAirlineSingle.image = image == nil ? #imageLiteral(resourceName: "ic_plane") : image
                        })
                        cell.ViewReturn_imageAirlineSingle.isHidden = false
                        cell.ViewReturn_imageAirLineOne.isHidden = true
                        cell.ViewReturn_imageAirlineTwo.isHidden = true
                    }
                    else {
                        cell.ViewReturn_imageAirLineOne.sd_setImage(with: (dictRoundWay[RES_image] as! String).convertToUrl())
                        cell.ViewReturn_imageAirlineTwo.sd_setImage(with: (dictRoundWay[RES_image1] as! String).convertToUrl())
                        cell.ViewReturn_imageAirlineSingle.isHidden = true
                        cell.ViewReturn_imageAirLineOne.isHidden = false
                        cell.ViewReturn_imageAirlineTwo.isHidden = false
                    }*/
                }
                
                if dictFlight[RES_stopList] != nil {
                    
                    cell.collectionViewStops.tag = 0
                    cell.collectionViewStops.accessibilityIdentifier = String(indexPath.row)
                 //   cell.collectionViewStops.delegate = self
                 //   cell.collectionViewStops.dataSource = self
                    cell.collectionViewStops.reloadData()
                    
                    cell.viewVerticalLine.addDashedLine(color: .lightGray)
                    
                    cell.ViewReturn_CollectionViewStops.tag = 2
                    cell.ViewReturn_CollectionViewStops.accessibilityIdentifier = String(indexPath.row)
                   // cell.ViewReturn_CollectionViewStops.delegate = self
                   // cell.ViewReturn_CollectionViewStops.dataSource = self
                    cell.ViewReturn_CollectionViewStops.reloadData()
                    
                    self.arrStopList = dictFlight[RES_stopList] as! [typeAliasDictionary]
                    
                    //FILTER DISTINCT AIRLINE FROM STOPLIST
                    
                    var arrAirline = Set<String>()
                    self.arrStopList.forEach({ (dict) in
                        arrAirline.insert(dict[RES_AirlineCode] as! String)
                    })
                    self.arrAirlinesList = [typeAliasDictionary]()
                    for stCode in arrAirline {
                        self.arrAirlinesList.append(contentsOf:self.arrAirlinesListMain.filter({ (dict) -> Bool in
                            return dict[RES_AirlineCode] as! String == stCode
                        })
                        )}
                    
                    cell.collectionViewAirlines.tag = 1
                    cell.collectionViewAirlines.accessibilityIdentifier = String(indexPath.row)
                    cell.collectionViewAirlines.delegate = self
                    cell.collectionViewAirlines.dataSource = self
                    cell.collectionViewAirlines.reloadData()
                    
                    cell.ViewReturn_CollectionViewAirlines.tag = 3
                    cell.ViewReturn_CollectionViewAirlines.accessibilityIdentifier = String(indexPath.row)
                    cell.ViewReturn_CollectionViewAirlines.delegate = self
                    cell.ViewReturn_CollectionViewAirlines.dataSource = self
                    cell.ViewReturn_CollectionViewAirlines.reloadData()
                    
                    //cell.layoutIfNeeded()
                    
                }
                cell.selectionStyle = .none
                return cell
            }
                
            else {
                let cell:FlightListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_FLIGHT_LIST_CELL) as! FlightListCell
                let dictFlight = arrFlightList[indexPath.row]
                
                if  dictFlight[RES_OneWay] != nil {
                    
                    let dictOneWay = dictFlight[RES_OneWay] as! typeAliasDictionary
                    if Int(dictOneWay[RES_Stops] as! String) == 0 {
                        cell.lblStops.text = "Nonstop"
                        cell.lblStopString.text = ""
                    }
                    else{ cell.lblStops.text = "\(dictOneWay[RES_Stops]!) Stops"
                        cell.lblStopString.text = "\(dictOneWay[RES_stopString]!)"
                    }
                    cell.lblFlightType.text = dictOneWay[RES_FareTypeText] as! String?
                    cell.lblSourceCode.text = dictOneWay[RES_FromAirportCode] as! String?
                    cell.lblDestinationCode.text = dictOneWay[RES_ToAirportCode] as! String?
                    cell.lblDepartureTime.text = dictOneWay[RES_DepTime] as! String?
                    cell.lblArrivalTime.text = dictOneWay[RES_ArrTime] as! String?
                    cell.lblFirstStop.text = cell.lblSourceCode.text
                    cell.lblLastStop.text = cell.lblDestinationCode.text
                    
                    cell.lblDepDate.text = dictOneWay[RES_DepDate] as! String?
                    cell.lblArrivalDate.text = dictOneWay[RES_ArrDate] as! String?
                    
                    let arrTime = (dictOneWay[RES_TotalFlightTime] as! String).components(separatedBy: ":")
                    var time = "\(arrTime.first!)h"
                    if arrTime.count > 1 && arrTime.last != "00" {
                        time += "\(arrTime.last!)m"
                    }
                    
                    let str:NSMutableAttributedString = NSMutableAttributedString.init(string: "Duration  \(time)")
                    
                    str.setColorForText("Duration", with: .lightGray)
                    cell.lblTotalDuration.attributedText = str
                    cell.lblTotalAmount.text = "\(dictOneWay[RES_TotalAmount]!)".setThousandSeperator()
                    cell.lblUserCommission.text = "\(dictOneWay[RES_userCommissionNote]!)"
                    let width = cell.lblFlightType.text?.textWidth(25, textFont: cell.lblFlightType.font)
                    cell.constraintFlightTypeWidth.constant = width! + 10
                }
                if dictFlight[RES_stopList] != nil {
                    cell.collectionViewStops.tag = 0
                    cell.collectionViewStops.accessibilityIdentifier = String(indexPath.row)
                   // cell.collectionViewStops.delegate = self
                   // cell.collectionViewStops.dataSource = self
                    self.arrStopList = dictFlight[RES_stopList] as! [typeAliasDictionary]
                    cell.collectionViewStops.reloadData()
                    cell.collectionViewAirlines.tag = 1
                    cell.collectionViewAirlines.accessibilityIdentifier = String(indexPath.row)
                    cell.collectionViewAirlines.delegate = self
                    cell.collectionViewAirlines.dataSource = self
                    cell.collectionViewAirlines.reloadData()
                    //cell.layoutIfNeeded()
                }
                cell.selectionStyle = .none
                return cell
            }
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewAirlineList {
            return HEIGHT_AIRLINE_LIST_CELL
        }
        else  if tableView == tableViewPreferedAirlinesList {
            return HEIGHT_AIRLINE_LIST_CELL
        }
        return UITableViewAutomaticDimension
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableViewAirlineList {
            let cell:AirlineListCell = tableView.cellForRow(at: indexPath) as! AirlineListCell
            self.btnAirlineListCell_CheckBoxAction(cell.btnCheckBox)
        }
        else if tableView == tableViewPreferedAirlinesList {
            let cell:PreferedAirlineCell = tableView.cellForRow(at: indexPath) as! PreferedAirlineCell
            self.btnPreferedAirlineCell_PreferedCheckBoxAction(cell.btnPreferedCheckBox)
        }
        else {
            let dictFlight = arrFlightList[indexPath.row]
            let flightDetailVC = FlightDetailViewController(nibName: "FlightDetailViewController" , bundle: nil)
            flightDetailVC.arrAirlinesList = self.arrAirlinesListMain
            flightDetailVC.dictFlight = dictFlight
            flightDetailVC.depDate = self.journeyDate
            flightDetailVC.returnDate = self.returnDate
            flightDetailVC.isRoundTrip = self.isRoundTrip
            flightDetailVC.arrAirportList = self.arrAirportList
            flightDetailVC.dictSource = self.dictSource
            flightDetailVC.dictDestination = self.dictDestination
            flightDetailVC.dictClass = self.dictClass
            flightDetailVC.noOfAdults = self.noOfAdults
            flightDetailVC.noOfChild = self.noOfChild
            flightDetailVC.noOfInfants = self.noOfInfants
            flightDetailVC.index = indexPath.row
            
            self.navigationController?.pushViewController(flightDetailVC, animated: true)
        }
        
    }
    
    //MARK: UICOLLCTION VIEW DELEGATE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        
        let Count:Int = 0
        if collectionView == collectionViewDepartureTime {
            return arrDepartureReturnTimeData.count
        }
        else if collectionView == collectionViewReturnTime {
            return arrDepartureReturnTimeData.count
        }
        else if collectionView == collectionViewDepartureStop  {
            return arrDepartureReturnStopData.count
        }
        else if collectionView == collectionViewReturnStop{
            return arrDepartureReturnStopData.count
        }
        else  if arrFlightList.count > 0 {           //FLIGHTLIST COLLECTION CELL
            let dictFlight = arrFlightList[Int(collectionView.accessibilityIdentifier!)!]
            
            var arrStops = dictFlight[RES_stopList] as! [typeAliasDictionary]
            arrStops = arrStops.filter({ (dict) -> Bool in
                if collectionView.tag == 0 || collectionView.tag == 1 {
                    return dict[RES_TripType] as! String ==  "One Trip"
                }
                else{
                    return dict[RES_TripType] as! String ==  "Round Trip"
                }
            })
            
            if collectionView.tag == 0 {
                return arrStops.count + 1
                
            }
            else if collectionView.tag == 2 {
                return arrStops.count + 1
            }
            else {
                var arrAirline = Set<String>()
                arrStops.forEach({ (dict) in
                    arrAirline.insert(dict[RES_AirlineCode] as! String)
                })
                return arrAirline.count > 1 ? 2 : arrAirline.count
            }
        }
        else{return 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == collectionViewDepartureTime || collectionView == collectionViewReturnTime {
            
            let cell:DepartureReturnTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_DEPARTURE_RETURN_TIME_CELL, for: indexPath) as! DepartureReturnTimeCell
            let dictTime = arrDepartureReturnTimeData[indexPath.item]
            cell.lblTime.text = dictTime[PARAMETER_NAME] as? String
            cell.imageViewTime.image = UIImage.init(named: dictTime[PARAMETER_IMAGE] as! String)
            cell.imageViewTime.image = cell.imageViewTime.image?.withRenderingMode(.alwaysTemplate)
            let ind = self.isExistInSelectedArray(collectionView == collectionViewDepartureTime ? arrSelectedDepartureTimeData : arrSelectedDepartureReturnTimeData, key: PARAMETER_KEY, dict: dictTime)
            if ind > -1 {
                cell.lblTime.textColor = COLOUR_DARK_GREEN
                cell.imageViewTime.tintColor = COLOUR_DARK_GREEN
                
            }
            else {
                cell.lblTime.textColor = COLOUR_TEXT_GRAY
                cell.imageViewTime.tintColor = COLOUR_TEXT_GRAY
            }
            return cell
        }
        else if collectionView == collectionViewDepartureStop || collectionView == collectionViewReturnStop {
            
            let cell:DepartureReturnStopCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_DEPARTURE_RETURN_STOP_CELL, for: indexPath) as! DepartureReturnStopCell
            let dictStop = arrDepartureReturnStopData[indexPath.item]
            cell.lblStopTitle.text = dictStop[PARAMETER_NAME] as? String
            
            let ind = self.isExistInSelectedArray(collectionView == collectionViewDepartureStop ? arrSelectedDepartureStopData : arrSelectedDepartureReturnStopData, key: PARAMETER_KEY, dict: dictStop)
            if ind > -1 {
                cell.lblStopTitle.textColor = COLOUR_DARK_GREEN
            }
            else{
                cell.lblStopTitle.textColor = COLOUR_TEXT_GRAY
            }
            return cell
            
        }
        else {
        
            let dictFlight = arrFlightList[Int(collectionView.accessibilityIdentifier!)!]
            
            var arrStops = dictFlight[RES_stopList] as! [typeAliasDictionary]
            arrStops = arrStops.filter({ (dict) -> Bool in
                if collectionView.tag == 0 || collectionView.tag == 1 {
                    return dict[RES_TripType] as! String ==  "One Trip"
                }
                else{
                    return dict[RES_TripType] as! String ==  "Round Trip"
                }
            })
            
            if collectionView.tag == 0 {
                
                let cell:CollectionFlightStopCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_FLIGHT_STOP_CELL, for: indexPath) as! CollectionFlightStopCell
                
                /* let dictFlight = arrFlightList[Int(collectionView.accessibilityIdentifier!)!]
                 
                 var arrStops = dictFlight[RES_stopList] as! [typeAliasDictionary]
                 arrStops = arrStops.filter({ (dict) -> Bool in
                 return dict[RES_TripType] as! String == "One Trip"
                 })*/
                cell.viewRight.backgroundColor = UIColor.clear
                cell.viewLeft.backgroundColor = UIColor.clear
                
                if indexPath.item == arrStops.count {
                    let dictStop = arrStops[indexPath.item - 1]
                    cell.lblStop.text = dictStop[RES_ToAirportCode] as! String?
                    cell.imagePlane.isHidden = true
                    cell.viewDot.isHidden = false
                    cell.viewRight.backgroundColor = UIColor.white
                    cell.viewLeft.backgroundColor = UIColor.clear
                    
                    if indexPath.item == 1 {
                        cell.imagePlane.isHidden = false
                        cell.viewDot.isHidden = true
                    }
                }
                else {
                    cell.viewDot.isHidden = false
                    let dictStop = arrStops[indexPath.item]
                    cell.lblStop.text = dictStop[RES_FromAirportCode] as! String?
                    cell.imagePlane.isHidden = true
                    cell.viewRight.backgroundColor = UIColor.clear
                    cell.viewLeft.backgroundColor = UIColor.clear
                    if indexPath.item == 0 {
                        cell.viewRight.backgroundColor = UIColor.lightGray
                        cell.viewLeft.backgroundColor = UIColor.white
                    }
                    if indexPath.item == 1 {
                        cell.imagePlane.isHidden = false
                        cell.viewDot.isHidden = true
                        cell.viewRight.backgroundColor = UIColor.clear
                        cell.viewLeft.backgroundColor = UIColor.lightGray
                    }
                    
                }
                return cell
            }
            else if collectionView.tag == 2 {
                
                let cell:CollectionFlightStopCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_FLIGHT_STOP_CELL, for: indexPath) as! CollectionFlightStopCell
                
                /* let dictFlight = arrFlightList[Int(collectionView.accessibilityIdentifier!)!]
                 
                 var arrStops = dictFlight[RES_stopList] as! [typeAliasDictionary]
                 arrStops = arrStops.filter({ (dict) -> Bool in
                 return dict[RES_TripType] as! String == "Round Trip"
                 })*/
                
                let transform = CGAffineTransform.init(rotationAngle: -CGFloat(M_PI))
                arrStops = arrStops.reversed()
                
                cell.imagePlane.transform = transform
                cell.viewRight.backgroundColor = UIColor.clear
                cell.viewLeft.backgroundColor = UIColor.clear
                
                if indexPath.item == arrStops.count {
                    let dictStop = arrStops[indexPath.item - 1]
                    cell.lblStop.text = dictStop[RES_FromAirportCode] as! String?
                    cell.imagePlane.isHidden = true
                    cell.viewDot.isHidden = false
                    cell.viewRight.backgroundColor = UIColor.white
                    cell.viewLeft.backgroundColor = UIColor.lightGray
                    if indexPath.item == arrStops.count - 1 {
                        cell.imagePlane.isHidden = false
                        cell.viewDot.isHidden = true
                    }
                }
                else {
                    cell.viewDot.isHidden = false
                    let dictStop = arrStops[indexPath.item]
                    cell.lblStop.text = dictStop[RES_ToAirportCode] as! String?
                    cell.imagePlane.isHidden = true
                    
                    if indexPath.item == arrStops.count - 1 {
                        cell.imagePlane.isHidden = false
                        cell.viewDot.isHidden = true
                        cell.viewRight.backgroundColor = UIColor.lightGray
                        cell.viewLeft.backgroundColor = UIColor.clear
                        
                    }
                    if indexPath.item == 0 {
                        cell.viewRight.backgroundColor = UIColor.clear
                        cell.viewLeft.backgroundColor = UIColor.white
                    }
                }
                return cell
            }
                
            else {
                let cell:CollectionViewAirlineCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AIRLINE_CELL, for: indexPath) as! CollectionViewAirlineCell
                
                var arrAirline = Set<String>()
                arrStops.forEach({ (dict) in
                    arrAirline.insert(dict[RES_AirlineCode] as! String)
                })
                var arrAirlines = [typeAliasDictionary]()
                for stCode in arrAirline {
                    arrAirlines.append(contentsOf:self.arrAirlinesListMain.filter({ (dict) -> Bool in
                        return dict[RES_AirlineCode] as! String == stCode
                    })
                    )}
                if indexPath.row < arrAirlines.count {
                    let dictAir = arrAirlines[indexPath.row]
                    cell.imageViewAirline.sd_setImage(with: (dictAir[RES_image] as! String).convertToUrl(), completed: { (image, error, type, url) in
                        cell.imageViewAirline.image = image == nil ? #imageLiteral(resourceName: "ic_plane") : image
                    })
                }
                else{
                    
                }
                cell.imageViewAirline.contentMode = .scaleAspectFit
                cell.contentView.layoutIfNeeded()
                return cell
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == collectionViewDepartureTime {
            return CGSize(width: CGFloat((collectionViewDepartureTime.frame.width - 3) / 4), height: CGFloat(collectionViewDepartureTime.frame.height))
        }
        else if collectionView == collectionViewReturnTime {
            return CGSize.init(width: CGFloat((collectionViewReturnTime.frame.width - 3) / 4), height: CGFloat(collectionViewReturnTime.frame.height))
        }
        else if collectionView == collectionViewDepartureStop {
            return CGSize.init(width: CGFloat((collectionViewDepartureStop.frame.width - 2) / 3), height: CGFloat(collectionViewDepartureStop.frame.height))
        }
        else if collectionView == collectionViewReturnStop {
            return CGSize.init(width: CGFloat((collectionViewReturnStop.frame.width - 2) / 3), height: CGFloat(collectionViewReturnStop.frame.height))
        }
        else if arrFlightList.count > 0 {     //FLIGHTLIST COLLECTION

            let dictFlight = arrFlightList[Int(collectionView.accessibilityIdentifier!)!]
            var arrStops = dictFlight[RES_stopList] as! [typeAliasDictionary]
            arrStops = arrStops.filter({ (dict) -> Bool in
                if collectionView.tag == 0 || collectionView.tag == 1 {
                    return dict[RES_TripType] as! String ==  "One Trip"
                }
                else{
                    return dict[RES_TripType] as! String ==  "Round Trip"
                }
            })
            var arrAirline = Set<String>()
            arrStops.forEach({ (dict) in
                arrAirline.insert(dict[RES_AirlineCode] as! String)
            })
            
            if collectionView.tag == 0 {
                return CGSize.init(width: (collectionView.frame.width/CGFloat(arrStops.count + 1)), height: collectionView.frame.height)
            }
            else if collectionView.tag == 2 {
                return CGSize.init(width: (collectionView.frame.width/CGFloat(arrStops.count + 1)), height: collectionView.frame.height)
            }
            return CGSize.init(width: (collectionView.frame.width/CGFloat(arrAirline.count > 1 ? 2 : arrAirline.count)), height: (collectionView.frame.height))
        }
       return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let didSelectItem = {(_ arrMain:[typeAliasDictionary], _ arrSelected:[typeAliasDictionary]) -> [typeAliasDictionary] in
            var arrSel = arrSelected
            let dictFilter = arrMain[indexPath.row]
            let ind:Int = self.isExistInSelectedArray(arrSel, key: PARAMETER_KEY, dict: dictFilter)
            if ind > -1 {
                arrSel.remove(at: ind)
            }
            else {
                arrSel.append(dictFilter)
            }
            collectionView.reloadData()
            return arrSel
        }
        
        if collectionView == collectionViewDepartureTime {
            arrSelectedDepartureTimeData =  didSelectItem(arrDepartureReturnTimeData, arrSelectedDepartureTimeData)
        }
        
        else if collectionView == collectionViewReturnTime {
            arrSelectedDepartureReturnTimeData =  didSelectItem(arrDepartureReturnTimeData, arrSelectedDepartureReturnTimeData)
        }
        
        else if collectionView == collectionViewDepartureStop {
          arrSelectedDepartureStopData = didSelectItem(arrDepartureReturnStopData, arrSelectedDepartureStopData)
        }
        
        else if collectionView == collectionViewReturnStop {
           arrSelectedDepartureReturnStopData = didSelectItem(arrDepartureReturnStopData, arrSelectedDepartureReturnStopData)
        }
    }
    
    //MARK: PREFERRED AIRLINE CELL DELEGATE
    
    func btnAirlineListCell_CheckBoxAction(_ button: UIButton) {
        let index:Int = Int(button.accessibilityIdentifier!)!
        let dictAirLine = arrAirlineTypeData[index]
        let ind = self.isExistAirlineType(dictAirLine)
        if ind > -1 {
            arrSelectedAirlineTypeData.remove(at: ind)
        }
        else{
            arrSelectedAirlineTypeData.append(dictAirLine)
        }
        tableViewAirlineList.reloadData()
    }
    
    func btnPreferedAirlineCell_PreferedCheckBoxAction(_ button: UIButton) {
        let index:Int = Int(button.accessibilityIdentifier!)!
        let dictAirLine = arrAirlinesListMain[index]
        let ind = self.isExistPreferedAirlines(dictAirLine)
        if ind > -1 {
            arrSelectedPreferedAirlines.remove(at: ind)
        }
        else{
            arrSelectedPreferedAirlines.append(dictAirLine)
        }
        tableViewPreferedAirlinesList.reloadData()
    }
    
    //MARK: SCROOLLVIEW DELEGATE
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewPagination {
            
            let offX = scrollView.contentOffset
            let pageNo = offX.x / scrollView.frame.width
            print(pageNo)
            var btn = UIButton()
            for btn1 in btnSortTypeCollection {
                if btn1.tag == Int(pageNo) + 1 {
                    btn = btn1
                }
            }
            
            if btn.tag == selectedSortType {
                btn.isSelected = !btn.isSelected
            }
            isUp =  btn.isSelected

            for img in imageSortTypeCollection {
                if img.tag == btn.tag {
                    let image:UIImage = (UIImage(named: isUp ? "ic_arrow_up" : "ic_arrow_down")?.withRenderingMode(.alwaysTemplate))!
                    img.image = image
                    img.isHidden = false
                    img.tintColor = COLOUR_DARK_GREEN
                }
                else {
                    let image:UIImage = (UIImage(named:"ic_arrow_down")?.withRenderingMode(.alwaysTemplate))!
                    img.image =  image
                    img.isHidden = true
                    img.tintColor = COLOUR_TEXT_GRAY
                }
            }
            
            selectedSortType = btn.tag
            for view in viewSortTypeBottomCollection {
                view.backgroundColor =  view.tag == btn.tag ? COLOUR_DARK_GREEN : .white
            }
            
            for btn in btnSortTypeTitleCollection {
                if btn.tag == selectedSortType{
                    btn.setTitleColor(COLOUR_DARK_GREEN, for: .normal)
                }
                else {
                    btn.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
                }
            }
            self.sortFlightList(sortType: btn.tag)
        }
    }
}
