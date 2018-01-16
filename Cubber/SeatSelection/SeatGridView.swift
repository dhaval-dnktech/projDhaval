//
//  SeatGridView.swift
//  Cubber
//
//  Created by dnk on 20/03/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SeatGridView: UIView , UITableViewDelegate , UITableViewDataSource , VKPopoverDelegate , seatArrangementViewDelegate {

    let HEIGHT_SEAT: CGFloat = 50
    let WIDTH_SEAT: CGFloat = 50
    let TAG_PLUS: Int         = 1000
    
    //MARK: PROPERTIES
    @IBOutlet var scrollviewMain: UIScrollView!
    @IBOutlet var collectionViewSeatArrangement: UICollectionView!
    @IBOutlet var constraintCollectionViewSeatWidth: NSLayoutConstraint!
    @IBOutlet var constraintCollectionViewSeatHeight: NSLayoutConstraint!
    @IBOutlet var lblSelectedSeats: UILabel!
    @IBOutlet var lblTotalFare: UILabel!
    @IBOutlet var viewSelectedSeats: UIView!
    @IBOutlet var constraintSelectedSeatViewBottomToSuper: NSLayoutConstraint!
    @IBOutlet var constraintCollectionViewSeatBootomSuper: NSLayoutConstraint!
    @IBOutlet var imageViewStearing: UIImageView!
    @IBOutlet var viewBoardingPoint: UIView!
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var constraintViewSubMainWidth: NSLayoutConstraint!
    
    @IBOutlet var constraintViewSeatCollectiinWidth: NSLayoutConstraint!
    @IBOutlet var constraintViewSeatCollectiinHeight: NSLayoutConstraint!
    
    @IBOutlet var viewSeatCollection: UIView!
    @IBOutlet var constraintScrollViewLeading: NSLayoutConstraint!
    @IBOutlet var constraintScrollViewTrailing: NSLayoutConstraint!
    @IBOutlet var constraintScollViewWidth: NSLayoutConstraint!
    @IBOutlet var constraintScrollViewHorizontal: NSLayoutConstraint!
    
    //MARK: VARIABLES
    
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _VKPopOver = VKPopover()
    fileprivate let _KDAlertView = KDAlertView()
    internal var arrSeatArrangement = [typeAliasDictionary]()
    internal var arrSeat = [[typeAliasDictionary]]()
    var arrSelectedSeat = [typeAliasStringDictionary]()
    internal var isUpperLower:Bool = false
    internal var columns:CGFloat = 0
    internal var seatLimit:Int = 5
    internal var dictRoute:typeAliasDictionary = typeAliasDictionary()
    internal var arrColumn = [String]()
    var fare:Double = 0.00
    var baseFare:Double = 0.00
    
    var arrBoardingPoints = [typeAliasStringDictionary]()
    var dictSelectedBoardingPoint = typeAliasStringDictionary()
    
    var cellHeight = HEIGHT_SEAT_ARAANGEMENT_CELL
    var cellWidth = WIDTH_SEAT_ARAANGEMENT_CELL
    
    internal var arrColumns = [String]()
    internal var arrRows = [String]()
    
    private var indexRowSize: Int = 0
    private var indexColumnSize: Int = 0
    
    //MARK: VIEW METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXIB()
    }
    
    fileprivate func loadXIB() {
        
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0]as! UIView
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
        
        //self.collectionViewSeatArrangement.register(UINib.init(nibName: CELL_IDENTIFIER_SEAT_ARAANGEMENT, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_SEAT_ARAANGEMENT)
      
        self.layoutIfNeeded()
    }

    
    internal func setSeatData(isUpper:Bool) {
        
        self.alpha = 0
        isUpperLower = isUpper
        cellWidth = WIDTH_SEAT_ARAANGEMENT_CELL
        imageViewStearing.isHidden = isUpper
        arrSelectedSeat = DataModel.getArrSelectedSeat()
        self.constraintSelectedSeatViewBottomToSuper.constant = -115
        setSelectedSeatView()
        obj_AppDelegate.navigationController.SetScreenName(name: isUpperLower ? F_BUS_UPPERDESK : F_BUS_LOWERDESK, stclass: isUpperLower ? F_BUS_UPPERDESK : F_BUS_LOWERDESK)
        
        var arrRowsModified = [Int]()
        for st in arrRows {
            arrRowsModified.append(Int(st)!);
        }
        let maxRowNumber = arrRowsModified.max()!
        var arrModified = [String](repeating: "-1", count: maxRowNumber)
        for st in arrRows { arrModified[(Int(st)! - 1)] = st }
        arrRows = arrModified
        
        for i in 0..<arrSeatArrangement.count {
            
            let dict:typeAliasDictionary = arrSeatArrangement[i]
            let stSeatNo: String = dict[RES_SeatNo] as! String

            let columnIndex = arrColumns.index(of: dict[RES_Column] as! String)!
            let rowIndex = arrRows.index(of: dict[RES_Row] as! String)!
            
            let xOrigin: CGFloat = CGFloat(columnIndex) * WIDTH_SEAT
            let yOrigin: CGFloat = CGFloat(rowIndex) * WIDTH_SEAT
            let width: CGFloat = dict[RES_ColumnSpan] as! String == "2" ? WIDTH_SEAT * 2 : WIDTH_SEAT
            let height: CGFloat = dict[RES_RowSpan] as! String == "2" ? HEIGHT_SEAT * 2 : HEIGHT_SEAT
            
            let _SeatArrangementView = SeatArrangementView.init(frame: CGRect(x: xOrigin, y: yOrigin, width: width, height: height))
            _SeatArrangementView.delegate = self
            _SeatArrangementView.btnSeatSelection.tag = i
            _SeatArrangementView.tag = i + TAG_PLUS
            viewSeatCollection.addSubview(_SeatArrangementView);
      
            
            if dict[RES_BlockType] as! String == "3" {
                
                _SeatArrangementView.imageViewSeat.isHidden = true
                _SeatArrangementView.imageViewSleeper_Horizontal.isHidden = true
                _SeatArrangementView.imageViewSleeper_Vertical.isHidden = true
                _SeatArrangementView.btnSeatSelection.isEnabled = false
            }
            else {
                //self.setSeatImageIcon(tag:  i + TAG_PLUS, dictSeat: dict)
                
                
      //SLEEPER V
                if dict[RES_RowSpan] as! String == "2" {
                    
                    _SeatArrangementView.imageViewSeat.isHidden = true
                    _SeatArrangementView.imageViewSleeper_Horizontal.isHidden = true
                    _SeatArrangementView.imageViewSleeper_Vertical.isHidden = false
                    
                    
                    if dict[RES_Available] as! String == "Y"{
                        
                        if dict[RES_IsLadiesSeat] as! String == "Y"{
                            _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_reservedforladies")
                        }
                        else{
                            _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_available")
                        }
                        if isSelectedSeatExists(dictSeat: dict as! typeAliasStringDictionary) > -1{
                            _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_selected")
                        }
                        _SeatArrangementView.btnSeatSelection.isEnabled = true
                    }
                    else{
                        
                        if dict[RES_IsLadiesSeat] as! String == "Y"{
                            _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_bookedbyladies")
                        }
                        else{
                            _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_booked")
                        }
                        _SeatArrangementView.btnSeatSelection.isEnabled = false
                    }

                    
                }
    //SLEEPER H
                else if dict[RES_ColumnSpan] as! String == "2" {
                    
                    _SeatArrangementView.imageViewSeat.isHidden = true
                    _SeatArrangementView.imageViewSleeper_Horizontal.isHidden = false
                    _SeatArrangementView.imageViewSleeper_Vertical.isHidden = true
                    
                    if dict[RES_Available] as! String == "Y"{
                        
                        if dict[RES_IsLadiesSeat] as! String == "Y"{
                            _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_reservedforladies_h")
                        }
                        else{
                             _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_available_h")
                        }
                        if isSelectedSeatExists(dictSeat: dict as! typeAliasStringDictionary) > -1{
                            _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_selected_h")
                        }
                        _SeatArrangementView.btnSeatSelection.isEnabled = true
                    }
                    else{
                        
                        if dict[RES_IsLadiesSeat] as! String == "Y"{
                              _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_bookedbyladies_h")
                        }
                        else{
                              _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_booked_h")
                        }
                        _SeatArrangementView.btnSeatSelection.isEnabled = false
                    }
                }
//SEAT
                else{
                    
                    _SeatArrangementView.imageViewSeat.isHidden = false
                    _SeatArrangementView.imageViewSleeper_Horizontal.isHidden = true
                    _SeatArrangementView.imageViewSleeper_Vertical.isHidden = true
                    
                    if dict[RES_Available] as! String == "Y"{
                        
                        if isSelectedSeatExists(dictSeat: dict as! typeAliasStringDictionary) > -1{
                           _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_selected")
                        }
                        else{
                            
                            if dict[RES_IsLadiesSeat] as! String == "Y"{
                                _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_reservedforladies")
                            }
                            else{
                                 _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_available")
                            }
                        }
                      _SeatArrangementView.btnSeatSelection.isEnabled = true
                    }
                    else{
                        
                        if dict[RES_IsLadiesSeat] as! String == "Y"{
                              _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_bookedbyladies")
                        }
                        else{
                            _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_booked")
                        }
                        _SeatArrangementView.btnSeatSelection.isEnabled = false
                    }
                }
                _SeatArrangementView.btnSeatSelection.setTitle(stSeatNo, for: .normal)
            }
           
            _SeatArrangementView.btnSeatSelection.accessibilityIdentifier = "\(dict[RES_Row] as! String),\( dict[RES_Column] as! String)"
        }
        
        //let dictLast = arrSeatArrangement.last!
        indexRowSize = self.arrRows.count - 1
        indexColumnSize = self.arrColumns.count - 1
        let maxWidth: CGFloat = self.setViewWidth()
        let maxHeight: CGFloat = self.setViewHeight()
        
        constraintViewSeatCollectiinWidth.constant = maxWidth
        constraintViewSeatCollectiinHeight.constant = maxHeight
        
        var space: CGFloat = 0
        if (maxWidth < self.frame.width) {
            constraintScollViewWidth.constant = maxWidth + 16
            
            let yCenterSelf = self.frame.width / 2
            space = (maxWidth + 16) / 2
            space = yCenterSelf - space
        }
        else {
            constraintScollViewWidth.constant = self.frame.width
        }
        
        constraintScrollViewLeading.constant = space
        
        self.layoutIfNeeded()
        self.alpha = 1
        self.viewSeatCollection.layer.borderWidth = 1
    }
    
    func setViewWidth() -> CGFloat {
        var maxWidth: CGFloat = 0
        let stLastColumn: String = arrColumns[indexColumnSize]
        
        for view in self.viewSeatCollection.subviews {
            if view.isKind(of: SeatArrangementView.classForCoder()) {
                let viewSeat = view as! SeatArrangementView
                let stIdentifier: String = viewSeat.btnSeatSelection.accessibilityIdentifier!
                let arrContent: [String] = stIdentifier.components(separatedBy: ",")
                let column = arrContent[1]
                if column == stLastColumn { maxWidth = view.frame.maxX }
            }
        }
        
        if maxWidth == 0 {
            indexColumnSize -= 1
            maxWidth = self.setViewWidth()
        }
        
        return maxWidth
    }
    
    func setViewHeight() -> CGFloat {
        var maxHeight: CGFloat = 0
        let stLastRow: String = arrRows[indexRowSize]
        
        for view in self.viewSeatCollection.subviews {
            if view.isKind(of: SeatArrangementView.classForCoder()) {
                let viewSeat = view as! SeatArrangementView
                let stIdentifier: String = viewSeat.btnSeatSelection.accessibilityIdentifier!
                let arrContent: [String] = stIdentifier.components(separatedBy: ",")
                let row = arrContent[0]
                if row == stLastRow { maxHeight = view.frame.maxY }
            }
        }
        
        if maxHeight == 0 {
            indexRowSize -= 1
            maxHeight = self.setViewHeight()
        }
        
        return maxHeight
    }
    
    func setSeatImageIcon(tag:Int , dictSeat:typeAliasDictionary ) {
        
        let _SeatArrangementView:SeatArrangementView = viewSeatCollection.viewWithTag(tag) as! SeatArrangementView
        
        if dictSeat[RES_RowSpan] as! String == "2" {
            
            _SeatArrangementView.imageViewSeat.isHidden = true
            _SeatArrangementView.imageViewSleeper_Horizontal.isHidden = true
            _SeatArrangementView.imageViewSleeper_Vertical.isHidden = false
            
            
            if dictSeat[RES_Available] as! String == "Y"{
                
                if dictSeat[RES_IsLadiesSeat] as! String == "Y"{
                    _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_reservedforladies")
                }
                else{
                    _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_available")
                }
                if isSelectedSeatExists(dictSeat: dictSeat as! typeAliasStringDictionary) > -1{
                    _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_selected")
                }
                
            }
            else{
                
                if dictSeat[RES_IsLadiesSeat] as! String == "Y"{
                    _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_bookedbyladies")
                }
                else{
                    _SeatArrangementView.imageViewSleeper_Vertical.image = #imageLiteral(resourceName: "icon_sleeper_booked")
                }
            }
            
            
        }
            //SLEEPER H
        else if dictSeat[RES_ColumnSpan] as! String == "2" {
            
            _SeatArrangementView.imageViewSeat.isHidden = true
            _SeatArrangementView.imageViewSleeper_Horizontal.isHidden = false
            _SeatArrangementView.imageViewSleeper_Vertical.isHidden = true
            
            if dictSeat[RES_Available] as! String == "Y"{
                
                if dictSeat[RES_IsLadiesSeat] as! String == "Y"{
                    _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_reservedforladies_h")
                }
                else{
                    _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_available_h")
                }
                if isSelectedSeatExists(dictSeat: dictSeat as! typeAliasStringDictionary) > -1{
                    _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_selected_h")
                }
                
            }
            else{
                
                if dictSeat[RES_IsLadiesSeat] as! String == "Y"{
                    _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_bookedbyladies_h")
                }
                else{
                    _SeatArrangementView.imageViewSleeper_Horizontal.image = #imageLiteral(resourceName: "icon_sleeper_booked_h")
                }
            }
        }
            //SEAT
        else{
            
            _SeatArrangementView.imageViewSeat.isHidden = false
            _SeatArrangementView.imageViewSleeper_Horizontal.isHidden = true
            _SeatArrangementView.imageViewSleeper_Vertical.isHidden = true
            
            if dictSeat[RES_Available] as! String == "Y"{
                
                if isSelectedSeatExists(dictSeat: dictSeat as! typeAliasStringDictionary) > -1{
                    _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_selected")
                }
                else{
                    
                    if dictSeat[RES_IsLadiesSeat] as! String == "Y"{
                        _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_reservedforladies")
                    }
                    else{
                        _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_available")
                    }
                }
                
            }
            else{
                
                if dictSeat[RES_IsLadiesSeat] as! String == "Y"{
                    _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_bookedbyladies")
                }
                else{
                    _SeatArrangementView.imageViewSeat.image = #imageLiteral(resourceName: "ic_seat_booked")
                }
            }
        }
        
    }
    
    func removeSpaceDict() {
 
        var arrDelete = [Int]()
        
        for  i in (0..<arrSeatArrangement.count).reversed() {
                    let dictCell = arrSeatArrangement[i]
            if dictCell[IS_SPACE] as! String == "1" {
            
                let dictSeat1 = dictCell[CELL_DATA_1] as! typeAliasStringDictionary
                let dictSeat2 = dictCell[CELL_DATA_2] as! typeAliasStringDictionary
                if !dictSeat1.isEmpty && dictSeat1[RES_BlockType] == "3" {
                    if !dictSeat2.isEmpty && dictSeat2[RES_BlockType] == "3" || dictSeat2.isEmpty {
                        arrDelete.append(i)
                    }
                }
                else if dictSeat1.isEmpty && dictSeat2.isEmpty{
                    arrDelete.append(i)
                }
            }
            else{
                break
            }
        }
        
        for i in arrDelete {
            arrSeatArrangement.remove(at: i)
        }
        
        
    }
    
    func isSelectedSeatExists(dictSeat:typeAliasStringDictionary) -> Int {
    
        for i in 0..<arrSelectedSeat.count {
            let dict = arrSelectedSeat[i]
            if dict[RES_SeatNo] == dictSeat[RES_SeatNo] { return i }
        }
        return -1
    }
    
       
    internal func setSelectedSeatView() {
    
        arrSelectedSeat = DataModel.getArrSelectedSeat()
        if arrSelectedSeat.isEmpty{
            UIView.animate(withDuration: 0.3, animations: { 
                 self.constraintSelectedSeatViewBottomToSuper.constant = -115
                            })
            viewSelectedSeats.isHidden = true
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintSelectedSeatViewBottomToSuper.constant = 0
            })
            var arrSeatNo = [String]()
             fare  = 0.00
            for dict in arrSelectedSeat{
                arrSeatNo.append(dict[RES_SeatNo]!)
                fare += Double(dict[RES_BaseFare]!)! + Double(dict[RES_ServiceTax]!)!
                baseFare +=  Double(dict[RES_BaseFare]!)!
            }
            lblSelectedSeats.text = arrSeatNo.joined(separator: ",")
            lblTotalFare.text = "\(RUPEES_SYMBOL) \(fare)"
            viewSelectedSeats.isHidden = false
        }
        
    }
    
    @IBAction func btnProceedAction() {
        
        self.constraintSelectedSeatViewBottomToSuper.constant = -115
       viewSelectedSeats.isHidden = true
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
        let arr:NSArray = arrSelectedSeat as NSArray
        let params = [RES_userId : DataModel.getUserInfo()[RES_userID]!,
                      RES_SeatNames:((arr.value(forKey: RES_SeatNo) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ","),
                      FIR_SELECT_CONTENT:"Select Seats"] as [String : Any]
        obj_AppDelegate.navigationController.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])
        dictSelectedBoardingPoint = arrBoardingPoints[0]
        tableViewList.tableFooterView = UIView.init(frame: CGRect.zero)
        tableViewList.rowHeight = UITableViewAutomaticDimension
         tableViewList.register(UINib.init(nibName: CELL_IDENTIFIER_BOARDING_POINT_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_BOARDING_POINT_CELL)
        tableViewList.estimatedRowHeight = 40
        _VKPopOver = VKPopover.init(self.viewBoardingPoint, animation: POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE, animationDuration: 0.3, isBGTransparent: false, borderColor: .clear, borderWidth: 0, borderCorner: 5, isOutSideClickedHidden: true)
        _VKPopOver.delegate = self
       obj_AppDelegate.navigationController.view.addSubview(_VKPopOver)
        
    }
    @IBAction func btnViewBoardingPointOkAction() {
        _VKPopOver.closeVKPopoverAction()
        let passengerDetailVC = PassengerDetailViewController(nibName: "PassengerDetailViewController", bundle: nil)
            passengerDetailVC.arrSelecteSeats = arrSelectedSeat
            passengerDetailVC.dictRoute = dictRoute
            passengerDetailVC.dictBoardingPoint = dictSelectedBoardingPoint
            passengerDetailVC.totalFare = fare
            passengerDetailVC.baseFare  = baseFare
        
        //GTM ADD TO CART BUS
        let _gtmModel = GTMModel()
        _gtmModel.ee_type = GTM_BUS
        _gtmModel.name = GTM_BUS_BOOKING
        _gtmModel.price = "\(baseFare)"
        _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
        _gtmModel.brand = self.dictRoute[RES_CompanyName] as! String
        _gtmModel.category = "\(self.dictRoute[RES_FromCityName] as! String) To \(dictRoute[RES_ToCityName] as! String)"
        _gtmModel.variant = self.dictRoute[RES_ArrangementName] as! String
        _gtmModel.quantity = arrSelectedSeat.count
        _gtmModel.dimension5 = "\(self.dictRoute[RES_FromCityName] as! String) : \(dictRoute[RES_ToCityName] as! String)"
        _gtmModel.dimension6 = dictRoute[RES_BookingDate] as! String
        GTMModel.pushAddToCartBus(gtmModel: _gtmModel)
        obj_AppDelegate.navigationController.pushViewController(passengerDetailVC, animated: true)
    }
    
    
    
    //MARK: TABVLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrBoardingPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BoardingPointCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_BOARDING_POINT_CELL) as! BoardingPointCell
        let dictPoint = arrBoardingPoints[indexPath.row]
        cell.lblTitle.text = dictPoint[BOARDING_POINT_NAME]
        cell.lblTime.text = dictPoint[BOARDING_POINT_TIME]
        if dictPoint == dictSelectedBoardingPoint {
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
    
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictPoint = arrBoardingPoints[indexPath.row]
         dictSelectedBoardingPoint = dictPoint
        let params = [RES_userId : DataModel.getUserInfo()[RES_userID]!,
                      "Boarding Name":dictSelectedBoardingPoint[BOARDING_POINT_NAME]!,
                      FIR_SELECT_CONTENT:"Select boarding point"] as [String : Any]
        obj_AppDelegate.navigationController.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])

        tableViewList.reloadData()
    }
    
    //MARK: VKPOPOVER DELEGATE
    
    func vkPopoverClose() {
        
    }
    
    //MARK: SEATARRANGEMENTVIEW DELEGATE 
    
    func seatArrangementViewDelegate_btnSeatAction(button: UIButton) {
        
        let index = Int(button.tag)
        var dictSeat = arrSeatArrangement[index]
           let ind = isSelectedSeatExists(dictSeat: dictSeat as! typeAliasStringDictionary)
        if ind > -1 { arrSelectedSeat.remove(at: ind) }
        else {
            if arrSelectedSeat.count == seatLimit {
                let message = "There cannot be more than \(seatLimit) passengers in single booking."
                _KDAlertView.showMessage(message: message, messageType: .WARNING)
                return
            }
            arrSelectedSeat.append(dictSeat as! typeAliasStringDictionary)
        }
         DataModel.setArrSelectedSeat(array: arrSelectedSeat)
         self.setSeatImageIcon(tag:  index + TAG_PLUS, dictSeat: dictSeat)
        self.setSelectedSeatView()
    }
}

