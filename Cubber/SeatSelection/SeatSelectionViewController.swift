//
//  SeatSelectionViewController.swift
//  Cubber
//
//  Created by dnk on 20/03/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SeatSelectionViewController: UIViewController, VKPagerViewDelegate , UITableViewDelegate , UITableViewDataSource , VKPopoverDelegate, AppNavigationControllerDelegate {
    
    //MARK: CONSTANT
    internal let TAG_PLUS:Int = 100

    //MARK: PROPERTRIES
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var lblPolicy: UILabel!
    @IBOutlet var tableViewpolicy: UITableView!
    @IBOutlet var viewCancellationPolicy: UIView!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKPopOver = VKPopover()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate var arrMenu:Array = [typeAliasDictionary]()
    internal var dictRoute:typeAliasDictionary = typeAliasDictionary()
    fileprivate var arrCancellationDetails = [typeAliasStringDictionary]()
    fileprivate var arrSeatDetails = [typeAliasStringDictionary]()
    fileprivate var arrUpperBirth = [typeAliasStringDictionary]()
    fileprivate var arrLowerBirth = [typeAliasStringDictionary]()
    fileprivate var arrSpace = [typeAliasStringDictionary]()
    fileprivate var arrFinalLower = [typeAliasDictionary]()
    fileprivate var arrFinalUpper = [typeAliasDictionary]()
    fileprivate var maxRow:Int = 0
    fileprivate var maxColumnUpper:Int = 0
    fileprivate var maxColumnLower:Int = 0
    fileprivate var maxSeat:Int = 0
    fileprivate var isUpperReload:Bool = false
    fileprivate var isLowerReload:Bool = false
    fileprivate var isReload:Bool = false
    @IBOutlet var lblNote: UILabel!
    
    var arrLowerColumns = [String]()
    var arrLowerRows = [String]()
    var arrUpperColumns = [String]()
    var arrUpperRows = [String]()
    
    
    //range: NSMakeRange(40, 58)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMain.alpha = 0
        let attributedString = NSMutableAttributedString.init(string:"By booking this ticket you agree to the Cancellation Policy of the bus operator.")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: COLOUR_DARK_GREEN, range: NSRange.init(location: 40, length: 19))
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: 1.0, range: NSRange.init(location: 40, length: 19))
        lblPolicy.attributedText = attributedString
        tableViewpolicy.rowHeight = HEIGHT_CANCELLATION_POLICY_CELL
        tableViewpolicy.tableFooterView = UIView.init(frame: CGRect.zero)
        tableViewpolicy.register(UINib.init(nibName: CELL_CANCELLATION_POLICY, bundle: nil), forCellReuseIdentifier: CELL_CANCELLATION_POLICY)
        self.callGetSeatArrangementDetailsServise()
        isReload = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        if !_VKPagerView.scrollViewPagination.subviews.isEmpty{
            for i in 0..<_VKPagerView.scrollViewPagination.subviews.count{
                let view:SeatGridView = _VKPagerView.scrollViewPagination.subviews[i] as! SeatGridView
                view.setSelectedSeatView()
            }
        }
       self.sendScreenView(name: F_BUS_SELECT_SEAT)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.SetScreenName(name: F_BUS_SELECT_SEAT, stclass: F_BUS_SELECT_SEAT)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // DataModel.setArrSelectedSeat(array: [typeAliasStringDictionary]())
    }
    
    fileprivate func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Select Seats")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    fileprivate func createPaginationView() {
        
        self.view.layoutIfNeeded()
        let dict: typeAliasStringDictionary = [LIST_ID: String(VAL_LOWER_DECK), LIST_TITLE: "Lower Deck"]
        let dict1:typeAliasStringDictionary = [LIST_ID:String(VAL_UPPER_DECK), LIST_TITLE: "Upper Deck"]
        var arrMenu = [dict, dict1]
        if arrUpperBirth.isEmpty { arrMenu = [dict] }
        
        self._VKPagerView.setPagerViewData(arrMenu as [typeAliasDictionary], keyName: LIST_TITLE, font: .systemFont(ofSize: 13), widthView: UIScreen.main.bounds.width)
        self._VKPagerView.delegate = self
        for i in 0..<arrMenu.count {
            
            let xOrigin: CGFloat = CGFloat(i) * self._VKPagerView.scrollViewPagination.frame.width
            let tag: Int = (i + TAG_PLUS)
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: self._VKPagerView.scrollViewPagination.frame.width, height: self._VKPagerView.scrollViewPagination.frame.height)
            let _seatGridView = SeatGridView.init(frame: frame)
            _seatGridView.tag = tag
            _seatGridView.translatesAutoresizingMaskIntoConstraints = false;
            self._VKPagerView.scrollViewPagination.addSubview(_seatGridView);
            //---> SET AUTO LAYOUT
            //HEIGHT
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _seatGridView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _seatGridView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _seatGridView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1))
            
            if (i == 0)
            {
                //LEADING
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _seatGridView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else
            {
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let viewPrevious: UIView = self._VKPagerView.scrollViewPagination.viewWithTag(tag - 1)!;
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _seatGridView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            if (i == arrMenu.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _seatGridView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
        }
        
        self.setSeatData(0)
        
    }
    
    fileprivate func setSeatData(_ index: Int ) {
        
        let _seatGridView: SeatGridView = self._VKPagerView.scrollViewPagination.viewWithTag(index + TAG_PLUS) as! SeatGridView
        if index == 0  && !isLowerReload  {
                isLowerReload = true
            _seatGridView.arrSeatArrangement = arrFinalLower
            _seatGridView.seatLimit = maxSeat
            _seatGridView.dictRoute = dictRoute
            _seatGridView.arrRows = arrLowerRows
            _seatGridView.arrColumns = arrLowerColumns
            _seatGridView.columns = CGFloat(maxColumnLower)
            _seatGridView.setSeatData(isUpper: false)
        }
        else if index == 1 && !isUpperReload {
            isUpperReload = true
            _seatGridView.arrSeatArrangement = arrFinalUpper
            _seatGridView.seatLimit = maxSeat
            _seatGridView.dictRoute = dictRoute
            _seatGridView.arrRows = arrUpperRows
            _seatGridView.arrColumns = arrUpperColumns
            _seatGridView.columns = CGFloat(maxColumnUpper)
            _seatGridView.setSeatData(isUpper: true)
        }
        _seatGridView.setSelectedSeatView()
    }
    
    func getCancellationPloicy() {
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_OPERATOR_ID: dictRoute[RES_CompanyID] as! String]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetCancellationPolicy, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            self.lblNote.text = dict[RES_note] as? String
            self.arrCancellationDetails = dict[RES_data] as! [typeAliasStringDictionary]
            self.showCancellationDetail()
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: .WARNING)
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return}
    }
    
    func callGetSeatArrangementDetailsServise() {
    
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_REFERENCE_NO: dictRoute[RES_ReferenceNumber] as! String]
        obj_OperationWeb.callRestApi(methodName: JMETTHOD_GetSeatArrangementDetails, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            
            self.arrSeatDetails = dict[RES_data] as! [typeAliasStringDictionary]
            self.maxSeat = Int(dict[RES_maxSeat] as! String)!
            self.setSeatArrangementData()
            UIView.animate(withDuration: 0.3, animations: {
                self.viewMain.alpha = 1
            })
        }, onFailure: { (code, dict) in
            let msg = dict[RES_message]
            self._KDAlertView.showMessage(message: msg as! String, messageType: .WARNING)
            
        }) {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }

    func showCancellationDetail(){
    
        tableViewpolicy.reloadData()
        _VKPopOver = VKPopover.init(self.viewCancellationPolicy, animation: POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE, animationDuration: 0.3, isBGTransparent: false, borderColor: .clear, borderWidth: 0, borderCorner: 5, isOutSideClickedHidden: true)
        _VKPopOver.delegate = self
        self.navigationController?.view.addSubview(_VKPopOver)
        tableViewpolicy.reloadData()
    }
    
    func setSeatArrangementData() {
       
        var arrDelete = [Int]()
        var arrSeat = [String]()
        for i in 0..<arrSeatDetails.count {
            let dict = arrSeatDetails[i]
            if !arrSeat.contains(dict[RES_SeatNo]!) { arrSeat.append(dict[RES_SeatNo]!)}
            else{ arrDelete.append(i)}
        }
        
        arrSeatDetails = arrSeatDetails.enumerated()
            .filter{ !arrDelete.contains($0.offset) }
            .map { $0.element }

        for dictSeat in arrSeatDetails{
            if dictSeat[RES_UpLowBerth]!  == "UB" { arrUpperBirth.append(dictSeat) }
            else  if dictSeat[RES_UpLowBerth]! == "LB" { arrLowerBirth.append(dictSeat) }
        }
        
        let setSeatView = { (arrBirth: [typeAliasStringDictionary], isUpper: Bool, isAddSpaceColumn: Bool) in
            
            //Columns
            var arrColumns = [String]()
            var arrRows = [String]()
            var maxColumns: Int = 0
            var arrOutput = [typeAliasDictionary]()
            
            let stColumns: String = (((arrBirth as NSArray).value(forKey: RES_Column) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            arrColumns = stColumns.components(separatedBy: ",")
            arrColumns = Array(Set(arrColumns))
            arrColumns = arrColumns.sorted(by: { (st, st1) -> Bool in return Int(st)! < Int(st1)! }) //Sort Columns
            maxColumns = arrColumns.count;
            
            //Rows
            let stRows: String = (((arrBirth as NSArray).value(forKey: RES_Row) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ",")
            arrRows = stRows.components(separatedBy: ",")
            arrRows = Array(Set(arrRows))
            arrRows = arrRows.sorted(by: { (st, st1) -> Bool in return Int(st)! < Int(st1)! }) //Sort Rows
            
            //Sort by rows & columns
            var arrBirthLoop: [typeAliasStringDictionary] = arrBirth;
            var arrFinal = [[typeAliasStringDictionary]]()
            for stRow in arrRows {
                var arrBirthDelete = [Int]()
                var arrRow = [typeAliasStringDictionary]()
                for stColumn in arrColumns {
                    for i in 0..<arrBirthLoop.count {
                        let dict: typeAliasStringDictionary = arrBirthLoop[i]
                        let row: String = dict[RES_Row]!
                        let column: String = dict[RES_Column]!;
                        if row == stRow && column == stColumn {
                            arrRow.append(dict)
                            arrBirthDelete.append(i)
                        }
                    }
                }
                arrFinal.append(arrRow);
                arrBirthLoop = arrBirthLoop
                    .enumerated()
                    .filter { !arrBirthDelete.contains($0.offset) }
                    .map { $0.element }
            }
            
            //Array in one line
            for array: [typeAliasStringDictionary] in arrFinal { arrOutput = arrOutput + (array as [typeAliasDictionary]) }
            
            //Remove last blank rows
            var stLastRow: String = ""
            var arrLowerRowLastSpaceDelete = [Int]()
            for i in (0...(arrOutput.count - 1)).reversed() {
                let dict: typeAliasDictionary = arrOutput[i]
                if (dict[RES_BlockType] as! String == "3") {
                    stLastRow = dict[RES_Row] as! String
                    arrLowerRowLastSpaceDelete.append(i)
                }
                else { break; }
            }
            if let index = arrRows.index(of:stLastRow) { arrRows.remove(at: index) }
            arrOutput = arrOutput
                .enumerated()
                .filter { !arrLowerRowLastSpaceDelete.contains($0.offset) }
                .map { $0.element }
            
            if (isUpper) {
                self.arrUpperColumns = arrColumns
                self.arrUpperRows = arrRows
                self.maxColumnUpper = maxColumns
                self.arrFinalUpper = arrOutput
            }
            else {
                self.arrLowerColumns = arrColumns
                self.arrLowerRows = arrRows
                self.maxColumnLower = maxColumns
                self.arrFinalLower = arrOutput
            }
        }
        
        setSeatView(arrLowerBirth, false, false)
        
        if arrUpperBirth.count != 0 {
            setSeatView(arrUpperBirth, true, false)
            
            //--->
            //Find lower columns space
            let totalLowerRows: Int = arrLowerRows.count
            var arrSpaceColumn = [typeAliasStringDictionary]()
            for j in 0..<arrLowerColumns.count {
                let stColumn: String = arrLowerColumns[j]
                var totalSpaceRow: Int = 0
                for stRow in arrLowerRows {
                    for i in 0..<arrFinalLower.count {
                        let dict: typeAliasDictionary = arrFinalLower[i]
                        let row: String = dict[RES_Row] as! String
                        let column: String = dict[RES_Column] as! String
                        if row == stRow && column == stColumn {
                            if (dict[RES_BlockType] as! String == "3") {
                                totalSpaceRow += 1
                            }
                        }
                    }
                    
                    if (totalSpaceRow == (totalLowerRows - 3)) {
                        let dictSpace:typeAliasStringDictionary = [LIST_ID:String(j), RES_Column: stColumn]
                        arrSpaceColumn.append(dictSpace)
                    }
                }
            }
            
            //Find upper columns space and if not exist then add blank space of that column
            for j in 0..<arrUpperColumns.count {
                let stColumn: String = arrUpperColumns[j]
                var totalSpaceRow: Int = 0
                for stRow in arrUpperRows {
                    for i in 0..<arrFinalUpper.count {
                        let dict: typeAliasDictionary = arrFinalUpper[i]
                        let row: String = dict[RES_Row] as! String
                        let column: String = dict[RES_Column] as! String
                        if row == stRow && column == stColumn {
                            if (dict[RES_BlockType] as! String == "3") {
                                totalSpaceRow += 1
                            }
                        }
                    }
                    
                    if (totalSpaceRow == (totalLowerRows - 3)) {
                        let arrFound = arrSpaceColumn.getArrayFromArrayOfDictionary2(key: LIST_ID, valueString: String(j), valueInt: "")
                        if arrFound.count == 0 {
                            let dictSpace:typeAliasStringDictionary = [LIST_ID:String(j), RES_Column: stColumn]
                            arrSpaceColumn.append(dictSpace)
                        }
                    }
                }
            }
            
            //Add blank space column dict into array and rearrange seat again.
            var arrSpaceColumnDelete = [Int]()
            if arrSpaceColumn.count != 0 {
                for k in 0..<arrSpaceColumn.count {
                    let dict: typeAliasStringDictionary = arrSpaceColumn[k]
                    let stColumnSpace: String = dict[RES_Column]!
                    if (!arrUpperColumns.contains(stColumnSpace)) {
                        for i in 0..<arrUpperColumns.count {
                            let stColumn: String = arrUpperColumns[i]
                            if (Int(stColumn)! > Int(stColumnSpace)!) {
                                arrUpperColumns.insert(stColumnSpace, at: i)
                                break
                            }
                        }
                    }
                    else {
                        arrSpaceColumnDelete.append(k)
                    }
                }
                
                arrSpaceColumn = arrSpaceColumn
                    .enumerated()
                    .filter { !arrSpaceColumnDelete.contains($0.offset) }
                    .map { $0.element }
                
                for dict in arrSpaceColumn {
                    for stRow in arrUpperRows {
                        let dicBlankSeat =
                            [RES_BlockType: "3",
                             RES_Column: dict[RES_Column]!,
                             RES_Row: stRow,
                             RES_SeatNo: "",
                             RES_ColumnSpan: "0",
                             RES_RowSpan: "0"];
                        arrUpperBirth.append(dicBlankSeat)
                    }
                }
                
                setSeatView(arrUpperBirth, true, true)
            }
            //<---
        }
        
        self.createPaginationView()
    }
    
    func isSpaceDictExist(arr:[typeAliasStringDictionary]) -> Bool {
        var count = 0
        for dict in arr {
            if dict[RES_BlockType] == "3" { count += 1}
        }
        return count >= 5 ? true : false
    }
    
    func RemoveSpaceFromArrSpace() -> [typeAliasStringDictionary] {
    
        
        var arrColumn = [String]()
        for i in 0..<arrSpace.count {
            
            let dictSpace = arrSpace[i]
            if dictSpace[RES_Row] == "1" {
                arrColumn.append(dictSpace[RES_Column]!)
            }
        }
        arrSpace = arrSpace.filter({ (dict) -> Bool in
            if arrColumn.contains(dict[RES_Column]!) { return true }
            return false
        })
        return arrSpace
    }
    
    func getMaxRow() -> Int {
    
        for dict in (arrSeatDetails).reversed() {
            if dict[RES_BlockType] != "3"{ return Int(dict[RES_Row]!)!}
        }
        return 0
    }
    
    func addSpaceDict(arr:[typeAliasDictionary]) -> [typeAliasDictionary] {
    
        var arrFinal = arr
        var count = 1
        for i in 0..<arr.count + (arr.count / 3) {
            
          let  dictSeat = [CELL_DATA_1: typeAliasStringDictionary() as AnyObject,
                        IS_ROW_SPAN:"0" as AnyObject,
                        IS_SPACE:"1" as AnyObject,
                        CELL_DATA_2:typeAliasStringDictionary(),
                        IS_COL_SPAN:"0" as AnyObject] as [String : Any]
            if i == count {
                arrFinal.insert(dictSeat as typeAliasDictionary, at: count)
                count += 4
            }
        }
        return arrFinal
    }
    
    func getMaxColumn(isUpper:Bool) -> Int {
    
        let arr = isUpper ? arrUpperBirth : arrLowerBirth
        var arrColumn = [Int]()
        for dict in arr {       //dict[RES_BlockType] != "3" &&
            if dict[RES_Row] == "1" && !arrColumn.contains(Int(dict[RES_Column]!)!)  {
                arrColumn.append(Int(dict[RES_Column]!)!)
                //if arrColumn.count == 5 {return arrColumn.count}
            }
        }
        return arrColumn.count == 3 ? arrColumn.count + 1 : arrColumn.count
    }
    
    func getArrColumn(arr:[typeAliasStringDictionary] , isReverse:Bool)->[String] {
        
        var arrColumn = [String]()
        for dict in arr {
            if dict[RES_Row] == "1" {
                arrColumn.append(dict[RES_Column]!)
            }
        }
        return arrColumn.sorted(by: { (str, str1) -> Bool in
            return Int(str)! < Int(str1)!
        })
    }
    
    func getFinalSeatArray(arrSorted:[typeAliasStringDictionary] , isUpper:Bool) -> [typeAliasDictionary]
    {
        var arrSorted = arrSorted
        var arrDeleteRow = [String]()
        var arrFinal = [typeAliasDictionary]()
        
        //FIND SECOND DICT WITH SAME COLUMN AND NEST ROW
        
        let getSecondDict = {(row:Int , column:Int) -> typeAliasStringDictionary in
    
            for i in 0..<arrSorted.count {
    
                let dict = arrSorted[i]
                if dict[RES_Row]! == "\(row)" && dict[RES_Column]! == "\(column)" {
                    arrDeleteRow.append(dict[RES_SeatNo]!)
                    return dict
                }
            }
    
            return typeAliasStringDictionary()
        }
        
        //SET SPACE IN LAST ROW
        
        
      //  if isUpper {
            
            var lastRowCount = 0
            var SecondLastRowCount = 0
            for dict in arrSorted {
                if dict[RES_Row] == String(maxRow) {
                    lastRowCount += 1
                }
                if dict[RES_Row] == String(maxRow - 2) {
                    SecondLastRowCount += 1
                }
            }
            
            if lastRowCount != SecondLastRowCount {
             
                let setSpaceDict = {() -> Int in
                    
                    var arrColumn = self.getArrColumn(arr: arrSorted , isReverse:true)
                    var spaceIndex = 0
                    var columnCount = 0
                    var missingColumn = ""
                    for i in 0..<arrSorted.count {
                        let dict = arrSorted[i]
                        if dict[RES_Row] == String(self.maxRow) {
                            if dict[RES_Column]! != arrColumn[columnCount] {
                                spaceIndex = i
                                missingColumn = arrColumn[columnCount]
                                break
                            }
                            columnCount = columnCount == arrColumn.count - 1 ? 0 : columnCount + 1
                        }
                    }
                    
                    if spaceIndex > 0 {
                        let dictSeat = [RES_BlockType: "3",
                                        RES_SeatNo : "dummy",
                                        RES_Column : missingColumn,
                                        RES_Row : String(self.maxRow)]
                        arrSorted.insert(dictSeat, at: spaceIndex)
                    }
                    return spaceIndex
                }
                
                var ind =  setSpaceDict()
                var count = 3
                while ind > 0 && count > 0  {
                    ind =  setSpaceDict()
                    count -= 1
                }
          //  }
        }
        
        //SET FINAL DICT ARRAY
    
        for i in 0..<arrSorted.count{
    
            var dictSeat = typeAliasDictionary()
            let dictLower = arrSorted[i]
            if arrDeleteRow.contains(dictLower[RES_SeatNo]!){
                continue
            }
            
            print("Column:\(dictLower[RES_Column]!)   Row:\(dictLower[RES_Row]!)")
            if dictLower[RES_BlockType] == "3" {
    
                dictSeat = [CELL_DATA_1: dictLower as AnyObject,
                            IS_ROW_SPAN:"0" as AnyObject,
                            IS_SPACE:"1" as AnyObject,
                            CELL_DATA_2:getSecondDict(Int(dictLower[RES_Row]!)! + 1 , Int(dictLower[RES_Column]!)!) as AnyObject,
                            IS_COL_SPAN:"0" as AnyObject,
                            COLUMN:dictLower[RES_Column] as AnyObject]
            }
            else if dictLower[RES_RowSpan] == "2" {
    
                dictSeat = [CELL_DATA: dictLower as AnyObject,
                            IS_ROW_SPAN:"1" as AnyObject,
                            IS_SPACE:"0" as AnyObject,
                            IS_COL_SPAN:"0" as AnyObject,
                            COLUMN:dictLower[RES_Column] as AnyObject]
    
            }
            else if dictLower[RES_ColumnSpan] == "2" {
    
                dictSeat = [CELL_DATA: dictLower as AnyObject,
                            IS_ROW_SPAN:"0" as AnyObject,
                            IS_SPACE:"0" as AnyObject,
                            IS_COL_SPAN:"1" as AnyObject,
                            COLUMN:dictLower[RES_Column] as AnyObject ]
            }
            else{
                dictSeat = [CELL_DATA_1: dictLower as AnyObject,
                            IS_ROW_SPAN:"0" as AnyObject,
                            IS_SPACE:"0" as AnyObject,
                            CELL_DATA_2:getSecondDict(Int(dictLower[RES_Row]!)! + 1 , Int(dictLower[RES_Column]!)!) as AnyObject,
                            IS_COL_SPAN:"0" as AnyObject,
                            COLUMN:dictLower[RES_Column] as AnyObject]
            }
           // print(dictSeat)
            arrFinal.append(dictSeat)
        }
        
        //Remove Space Before HoriZonatal Dict
        
        for i in 0..<arrFinal.count {
            let dict = arrFinal[i]
            if dict[IS_COL_SPAN] as! String == "1" {
                let dictPre = arrFinal[i-1]
                if dictPre[IS_SPACE] as! String == "1" {
                    arrFinal.remove(at: i - 1)
                    break
                }
            }
        }
        return arrFinal
    }
    
    @IBAction func btnCancellationPolicyOKAction() {
        _VKPopOver.closeVKPopoverAction()
    }
    
    @IBAction func lblCancellationPolicy_Action(_ sender: UITapGestureRecognizer)
    {
        if arrCancellationDetails.isEmpty{ self.getCancellationPloicy() }
        else{ self.showCancellationDetail() }
    }
    
    //MARK: TABVLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrCancellationDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CancellationPolicyCell = tableView.dequeueReusableCell(withIdentifier: CELL_CANCELLATION_POLICY) as! CancellationPolicyCell
        let dictCancellationDetail = arrCancellationDetails[indexPath.row]
        let fromTime:Int = Int(dictCancellationDetail[RES_fromTime]!)!/60
        let toTime:Int = dictCancellationDetail[RES_fromTime]! == "0" ? 0 : Int(dictCancellationDetail[RES_toTime]!)!/60
        cell.lblCancellationTime.text = toTime != 0 ? "Between \(fromTime) to \(toTime) hours" : "Before \(fromTime) hours"
        cell.lblRefundPercentage.text = "\(dictCancellationDetail[RES_refundPercentage]!)%"
        cell.selectionStyle = .none
        return cell

    }
    
 
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_CANCELLATION_POLICY_CELL
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        if selectedMenu == 0 { isLowerReload = true}
        self.setSeatData(selectedMenu)
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
    }
    
    //MARK: VKPOPOVER DELEGATE
    
    func vkPopoverClose() {
        
    }

}
