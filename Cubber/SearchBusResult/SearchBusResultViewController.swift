//
//  SearchBusResultViewController.swift
//  Cubber
//
//  Created by dnk on 06/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SearchBusResultViewController: UIViewController , VKPagerViewDelegate , BusListViewDelegate ,  AppNavigationControllerDelegate , BusFilterDelegate{

    //MARK: CONSTANT
    internal let TAG_PLUS:Int = 100
    
    let DURATION        = "DURATION"
    let TOTAL_MINUTES   = "TOTAL_MINUTES"
    let PRICE           = "PRICE"
    let DEPARTURE_TIME  = "DEPARTURE_TIME"
    let ARR_AMOUNT      = "ARR_AMOUNT"

    //MARK: PROPERTRIES
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var lblDateOfJourney: UILabel!
    @IBOutlet var btnPrevious: UIButton!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    internal var dictSource :typeAliasStringDictionary = typeAliasStringDictionary()
    internal var dictDestination:typeAliasStringDictionary = typeAliasStringDictionary()
    internal var dateOfJourney:Date = Date()
    fileprivate var dateFormat = DateFormatter()
    fileprivate var arrRoute = [typeAliasDictionary]()
    fileprivate var arrMainRoute = [typeAliasDictionary]()
    fileprivate var arrFilteredRoute = [typeAliasDictionary]()
    fileprivate var arrMenu = [typeAliasDictionary]()
    fileprivate var arrSelecteFilter = [typeAliasStringDictionary]()
    fileprivate var isAppliedFilter:Bool = false
    
    
    
    var selectedTab: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        dateFormat.dateFormat = "dd-MM-yyyy"
        lblDateOfJourney.text = dateFormat.string(from: dateOfJourney)
        self.createPaginationView()
        if Calendar.current.compare(dateOfJourney, to: Date(), toGranularity: .day) == ComparisonResult.orderedSame{ btnPrevious.isHidden = true ;
            dateOfJourney = Date()}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_BUS_ALLBUSLIST)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_BUS_ALLBUSLIST, stclass: F_BUS_ALLBUSLIST)

    }
    
    //MARK: NAVIGATION METHODS
    
    fileprivate func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("\(dictSource[RES_sourceName]!) to \(dictDestination[RES_destinationName]!)")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setRightButton(image: "icon_orderfilter")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func appNavigationController_RightMenuAction() {
        
        if !arrMainRoute.isEmpty{
            let busFilterVC = BusFilterViewController(nibName: "BusFilterViewController", bundle: nil)
            let _busListView: BusListView = self._VKPagerView.scrollViewPagination.viewWithTag(0 + TAG_PLUS) as! BusListView
            busFilterVC.maxprice = CGFloat(_busListView.maxPrice)
            busFilterVC.minprice = CGFloat(_busListView.minPrice)
            busFilterVC.stDestCityID = dictSource[RES_sourceId]!
            busFilterVC.delegate = self
            busFilterVC.stOriginCityID = dictDestination[RES_destinationId]!
            self.navigationController?.pushViewController(busFilterVC, animated: true)
        }
        
    }
    
    //MARK: BUTTON METHODS
    
    @IBAction func btnPreviousDateAction() {
        
        dateOfJourney = Calendar.current.date(byAdding: .day, value: -1, to: dateOfJourney)!
        if Calendar.current.compare(dateOfJourney, to: Date(), toGranularity: .day) == ComparisonResult.orderedSame{ btnPrevious.isHidden = true ;
            dateOfJourney = Date()}
        lblDateOfJourney.text = dateFormat.string(from: dateOfJourney)
        DataModel.setDateOfJourney(dateOfJourney)
        self.resetBusListView()
    }
    
    @IBAction func btnNextDateAction() {
        dateOfJourney = Calendar.current.date(byAdding: .day, value: 1, to: dateOfJourney)!
        lblDateOfJourney.text = dateFormat.string(from: dateOfJourney)
        btnPrevious.isHidden = false
        DataModel.setDateOfJourney(dateOfJourney)
        self.resetBusListView()
    }

    //MARK: CUSTOM METHODS
    
    fileprivate func resetBusListView(){
        arrRoute = [typeAliasDictionary]()
        _VKPagerView.jumpToPageNo(0)
        for view in _VKPagerView.scrollViewPagination.subviews {
            view.removeFromSuperview()
        }
       self.createPaginationView()
    }
    
    fileprivate func createPaginationView() {
        
        self.view.layoutIfNeeded()
        let dict: typeAliasStringDictionary = [LIST_ID: String(VAL_SORT_POPULAR), LIST_TITLE: "Popular" , IS_SHOW_IMAGE:"false" , IS_ACCENDING:"false"]
        let dict1: typeAliasStringDictionary = [LIST_ID: String(VAL_SORT_TIME), LIST_TITLE: "Time", IS_SHOW_IMAGE:"true", IS_ACCENDING:"true"]
        let dict2: typeAliasStringDictionary = [LIST_ID: String(VAL_SORT_DURATION), LIST_TITLE: "Duration", IS_SHOW_IMAGE:"true", IS_ACCENDING:"true"]
        let dict3: typeAliasStringDictionary = [LIST_ID: String(VAL_SORT_PRICE), LIST_TITLE: "Price", IS_SHOW_IMAGE:"true", IS_ACCENDING:"true"]
        
        let arrMenu = [dict , dict1 , dict2 , dict3]
        self._VKPagerView.setPagerViewData(arrMenu as [typeAliasDictionary], keyName: LIST_TITLE, font: .systemFont(ofSize: 11), widthView: UIScreen.main.bounds.width  , isImageView:true)
        self._VKPagerView.delegate = self
        for i in 0..<arrMenu.count {
            
            let xOrigin: CGFloat = CGFloat(i) * self._VKPagerView.scrollViewPagination.frame.width
            let tag: Int = (i + TAG_PLUS)
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: self._VKPagerView.scrollViewPagination.frame.width, height: self._VKPagerView.scrollViewPagination.frame.height)
            
            let _busListView = BusListView(frame: frame, dateOfJourney: dateFormat.string(from: dateOfJourney), source: dictSource, dest: dictDestination)
            _busListView.tag = tag
            _busListView.delegate = self
            _busListView.translatesAutoresizingMaskIntoConstraints = false;
            self._VKPagerView.scrollViewPagination.addSubview(_busListView);
            
            //---> SET AUTO LAYOUT
            //HEIGHT
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _busListView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _busListView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _busListView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1))
            
            if (i == 0)
            {
                //LEADING
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _busListView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else
            {
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let viewPrevious: UIView = self._VKPagerView.scrollViewPagination.viewWithTag(tag - 1)!;
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _busListView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            if (i == arrMenu.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _busListView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
        }
        
        self.setBusListDetail(0 , isReset: true ,   isAppliedFilter:false)
    }
    
    fileprivate func setBusListDetail(_ index: Int , isReset:Bool , isAppliedFilter:Bool) {
        
        let _busListView: BusListView = self._VKPagerView.scrollViewPagination.viewWithTag(index + TAG_PLUS) as! BusListView
        if isReset{_busListView.arrRoutes = [typeAliasDictionary]()
                    _busListView.dateOfJourney = dateFormat.string(from: dateOfJourney)}
        else if !arrRoute.isEmpty{_busListView.arrRoutes = self.arrRoute}
        if !arrMenu.isEmpty{ _busListView.arrHeaderMenu = arrMenu }
        _busListView.setBusListData(valSortType: index , isAppliedFilter:isAppliedFilter)
    }
    
    func applyFilter() {
    
        let dateFormat1 = DateFormatter()
        let dateFormat2 = DateFormatter()

        dateFormat1.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormat2.dateFormat = "dd-MM-yyyy hh:mm a"
      
        if !arrMainRoute.isEmpty {
            arrFilteredRoute = arrMainRoute
            
            let arrFilter:NSArray = arrSelecteFilter as NSArray
         
            
            let arrBusType = arrSelecteFilter.filter({ (dict) -> Bool in
                return dict[KEY_FILTER_TYPE] == KEY_BUS_TYPE
            })
            let arrBoarding = arrSelecteFilter.filter({ (dict) -> Bool in
                return dict[KEY_FILTER_TYPE] == KEY_BOARDING_POINT
            })
            let arrDropping = arrSelecteFilter.filter({ (dict) -> Bool in
                return dict[KEY_FILTER_TYPE] == KEY_DROPPING_POINT
            })
            let arrBusOperator = arrSelecteFilter.filter({ (dict) -> Bool in
                return dict[KEY_FILTER_TYPE] == KEY_BUS_OPERATOR
            })
            let arrDepTime = arrSelecteFilter.filter({ (dict) -> Bool in
                return dict[KEY_FILTER_TYPE] == KEY_DEPARTURE_TIME
            })
            
            
            let stBUS_TYPE : String = (((arrBusType as NSArray).value(forKey: KEY_ID) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            let stBOARDING_POINTS : String = (((arrBoarding as NSArray).value(forKey: KEY_ID) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            let stDROPPNG_POINTS : String = (((arrDropping as NSArray).value(forKey: KEY_ID) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            let stOPERATORS : String = (((arrBusOperator as NSArray).value(forKey: KEY_ID) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            
    
            let filterByTime = { (dict:typeAliasDictionary) -> Bool in
                
                if !arrDepTime.isEmpty {
                    var isFilterdData:Bool = false
                    let dictTime = arrDepTime[0]
                    let arrTime:[String] = (dictTime[KEY_VALUE]?.components(separatedBy: "-"))!
                    
                        let fromTime:Int = Int(arrTime.first!.trim())!
                        let toTime:Int = Int(arrTime.last!.trim())!
                        let depDate:[Int] = self.getTimein24HourFormat(str: dict[RES_CityTime] as! String)
                        if  depDate.first! >= fromTime && depDate.first! <= toTime  {
                            if depDate.first! == toTime &&  depDate.last! != 00 {
                                return false
                            }
                            else if depDate.first! == fromTime &&  depDate.last! != 00 {
                                return false
                            }
                            isFilterdData = true
                            return true
                        }
                        return false
                    }
                return false
            }
            
           /* for dict in arrMainRoute {
            
                let stBusType:String = dict[RES_BusType] as! String
                let stBoardingPoints:String = dict[RES_BoardingPoints] as! String
                let stDroppingPoints:String = dict[RES_DroppingPoints] as! String
                let stOperatorName:String = dict[RES_CompanyName] as! String
                var isContains = false
                
                if !arrDepTime.isEmpty {
                    
                    if filterByTime(dict)  {
                        isContains = true
                    }
                    else{ isContains = false }
                }
                
                
                if stBUS_TYPE != "" {
                    if stBUS_TYPE.contains(stBusType) { isContains = true }
                   else{isContains = false}
                }
              //  else { isContains = true }
                
                if stBOARDING_POINTS != "" {
                    if stBOARDING_POINTS.contains(stBoardingPoints) { isContains = true }
                    else{isContains = false}
                }
              //  else { isContains = true }
                
                
                if stDROPPNG_POINTS != "" {
                    if stDROPPNG_POINTS.contains(stDroppingPoints) { isContains = true }
                    else {isContains = false}
                }
               // else { isContains = true }
                
                if stOPERATORS != "" {
                    if stOPERATORS.contains(stOperatorName) { isContains = true }
                    isContains = false
                }
              //  else { isContains = true }
                
                if isContains{
                    arrFilteredRoute.append(dict)
                }
            }*/
            
           for dictFilter in arrSelecteFilter {
                
                switch dictFilter[KEY_FILTER_TYPE]! {
                    
                case KEY_DEPARTURE_TIME:
                    let arrTime:[String] = (dictFilter[KEY_VALUE]?.components(separatedBy: "-"))!
                    arrFilteredRoute = arrFilteredRoute.filter({ (dict1) -> Bool in
                        
                        let fromTime:Int = Int(arrTime.first!.trim())!
                        let toTime:Int = Int(arrTime.last!.trim())!
                        let depDate:[Int] = self.getTimein24HourFormat(str: dict1[RES_CityTime] as! String)
                        if  depDate.first! >= fromTime && depDate.first! <= toTime  {
                            if depDate.first! == toTime &&  depDate.last! != 00 {
                                return false
                            }
                            else if depDate.first! == fromTime &&  depDate.last! != 00 {
                             return false
                            }
                            
                            return true
                        }
                        return false
                    })
                    
                    break
                
                case KEY_BUS_TYPE:
                    arrFilteredRoute = arrFilteredRoute.filter({ (dict1) -> Bool in
                        return stBUS_TYPE.contains((dict1[RES_BusType] as? String)!)
                        //return dict1[RES_BusType] as? String == dictFilter[KEY_ID]
                    })
                    break
                    
                case KEY_BOARDING_POINT:
                    arrFilteredRoute = arrFilteredRoute.filter({ (dict1) -> Bool in
                        return stBOARDING_POINTS.contains((dict1[RES_BoardingPoints] as? String)!)
                        //return (dict1[RES_BoardingPoints] as! String).contains(dictFilter[KEY_ID]!)
                    })
                    break
                    
                case KEY_DROPPING_POINT:
                    arrFilteredRoute = arrFilteredRoute.filter({ (dict1) -> Bool in
                            return stDROPPNG_POINTS.contains((dict1[RES_DroppingPoints] as? String)!)
                         //return (dict1[RES_DroppingPoints] as! String).contains(dictFilter[KEY_ID]!)
                    })
                    break
                    
                case KEY_PRICE_RANGE:
                    arrFilteredRoute = arrFilteredRoute.filter({ (dict1) -> Bool in
                        let arrValues = dictFilter[KEY_VALUE]?.components(separatedBy: "-")
                        let min = Int(((arrValues?.first)?.trim())!)
                        let max = Int(((arrValues?.last)?.trim())!)
                        let arrAmount:[String] = dict1[ARR_AMOUNT] as! [String]
                        var isContain:Bool = false
                        for amt in arrAmount {
                            if min! <= Int(amt)! &&  Int(amt)! <= max! {
                                isContain = true
                                break
                            }
                        }
                        return isContain
                    })
                    break
                case KEY_BUS_OPERATOR:
                    arrFilteredRoute = arrFilteredRoute.filter({ (dict1) -> Bool in
                         return stOPERATORS.contains((dict1[RES_CompanyID] as? String)!)
                        //
                        //return dict1[RES_CompanyName] as! String == dictFilter[KEY_NAME]!
                    })
                    break
                default:
                    break
                }
            }
            print(arrFilteredRoute)
            arrRoute = arrFilteredRoute
            _VKPagerView.jumpToPageNo(0)
            let _busListView: BusListView = self._VKPagerView.scrollViewPagination.viewWithTag(0 + TAG_PLUS) as! BusListView
            _busListView.arrRoutes = arrRoute
            _busListView.setBusListData(valSortType: 0, isAppliedFilter: true)
        }
    }
    
    func getTimein24HourFormat(str:String) ->[Int] {
    
        var isPM : Bool = false
        var stTime = str
        if stTime.contains("PM") {isPM = true}
        stTime = stTime.replace("PM", withString: "")
        stTime = stTime.replace("AM", withString: "")
        stTime = stTime.trim()
        let arrtime = stTime.components(separatedBy: ":")
        var hours = Int(arrtime.first!)
        let minutes = Int(arrtime.last!)
        if hours! < 12 && isPM { hours = hours! + 12 }
        let arraHoursandMin:[Int] = [hours! , minutes!]
        return arraHoursandMin 
    }
    
    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        self.setBusListDetail(selectedMenu,isReset: false , isAppliedFilter: isAppliedFilter)
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
        self.arrMenu = arrMenu
        self.setBusListDetail(selectedMenu,isReset: false , isAppliedFilter: isAppliedFilter)
    }
    
    //MARK:  BUSLISTVIEW DELEGATE
    
    func BusListViw_ArrRoute(arr: [typeAliasDictionary]) {
        self.arrRoute = arr
        self.arrMainRoute = self.arrRoute
    }
    
    //MARK: BUSFILTER DELEGATE
    
    func BusFilterDelegate_ApplyFilter(arrFilter: [typeAliasStringDictionary]) {
        if arrFilter.isEmpty{
            isAppliedFilter = false
        }
        else{
            isAppliedFilter = true
        }
        arrSelecteFilter = arrFilter
        self.applyFilter()
    }
}
