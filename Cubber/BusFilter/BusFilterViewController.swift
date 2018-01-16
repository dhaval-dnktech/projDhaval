//
//  BusFilterViewController.swift
//  Cubber
//
//  Created by dnk on 24/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol BusFilterDelegate {
    func BusFilterDelegate_ApplyFilter(arrFilter:[typeAliasStringDictionary])
}


class BusFilterViewController: UIViewController , AppNavigationControllerDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , SelectedFilterCellDelegate , DropBoardingViewDelegate {

    //MARK: CONSTANTS
    
    //MARK: PROPERTIES
    @IBOutlet var subViewFilterCollection: [UIView]!
    @IBOutlet var collectionViewDepartureTime: UICollectionView!
    @IBOutlet var collectionViewSelectedFilters: UICollectionView!
    @IBOutlet var viewPriceRange: UIView!
    @IBOutlet var lblNoFilterSelected: UILabel!
    
    //MARK: VARIABLES
    @IBOutlet var collectionViewBusType: UICollectionView!
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var markRangeSlider = MARKRangeSlider()
    fileprivate var arrDepTime = [typeAliasStringDictionary]()
    fileprivate var arrBusType = [typeAliasStringDictionary]()
    fileprivate var arrSelectedBusType = [typeAliasDictionary]()
    fileprivate var dictSelectedFilters = typeAliasStringDictionary()
    fileprivate var arrSelectedFilterValues = [typeAliasStringDictionary]()
    fileprivate var stSelectedDepTime = ""
    internal var stDestCityID = ""
    internal var stOriginCityID = ""
    internal var maxprice:CGFloat = 0.0
    internal var minprice:CGFloat = 0.0

    var delegate:BusFilterDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFilterArrays()
       
        collectionViewDepartureTime.register(UINib.init(nibName: CELL_IDENTIFIER_FILTER_DEPARTURE_TIME_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_FILTER_DEPARTURE_TIME_CELL)
        collectionViewBusType.register(UINib.init(nibName: CELL_IDENTIFIER_FILTER_DEPARTURE_TIME_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_FILTER_DEPARTURE_TIME_CELL)
        collectionViewSelectedFilters.register(UINib.init(nibName: CELL_IDENTIFIER_SELECTED_FILTER_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_SELECTED_FILTER_CELL)
        for view in subViewFilterCollection {
            view.setBottomBorder(COLOUR_GRAY, borderWidth: 1)
        }
        self.arrSelectedFilterValues = DataModel.getBusFilter()
        self.setRangeSlider()
        reloadCollectionViewFilter()
        
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK: NAVIGATION METHODS
    
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Filter Results")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setRighButton("Reset All")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_RightMenuAction() {
        arrSelectedFilterValues = [typeAliasStringDictionary]()
        collectionViewBusType.reloadData()
        collectionViewDepartureTime.reloadData()
        self.resetRangleSlider()
        self.reloadCollectionViewFilter()	
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func markSliderValueChanges(markSlider : MARKRangeSlider) {
        
        print("\(markSlider.leftValue)-\(markSlider.rightValue)")
        let dict:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_PRICE_RANGE,
                                              KEY_NAME:"\(RUPEES_SYMBOL)\(Int(markSlider.leftValue))-\(RUPEES_SYMBOL)\(Int(markSlider.rightValue))",
            KEY_VALUE:"\(Int(markSlider.leftValue))-\(Int(markSlider.rightValue))"]
        
        let ind = isExistSelectedFilterValue(dict: dict)
        if ind > -1 {
            arrSelectedFilterValues.remove(at: ind)
            arrSelectedFilterValues.append(dict)
        }
        else{ arrSelectedFilterValues.append(dict) }
        collectionViewSelectedFilters.reloadData()
        self.reloadCollectionViewFilter()
    }
    
    func setRangeSlider() {
        
        markRangeSlider = MARKRangeSlider.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - (2 * 23), height: 30))
        markRangeSlider.setMinValue(minprice, maxValue: maxprice)
        markRangeSlider.setLeftValue(minprice, rightValue: maxprice)
        markRangeSlider.minimumDistance = 0.2
        markRangeSlider.disableOverlapping = true
        markRangeSlider.addTarget(self, action: #selector(markSliderValueChanges), for: .valueChanged)
        
        let dict:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_PRICE_RANGE,
                                              KEY_NAME:"",
                                              KEY_VALUE:""]
        let ind = isExistSelectedFilterValue(dict: dict)
        if ind > -1 {
            let dict = arrSelectedFilterValues[ind]
            let arrValues = dict[KEY_VALUE]?.components(separatedBy: "-")
            markRangeSlider.setLeftValue(CGFloat(Int((arrValues?.first)!)!), rightValue: CGFloat(Int((arrValues?.last)!)!))
        }
        
        self.viewPriceRange.addSubview(markRangeSlider)
        
    }

    func resetRangleSlider() {
        markRangeSlider.setMinValue(minprice, maxValue: maxprice)
        markRangeSlider.setLeftValue(minprice, rightValue: maxprice)
    }
    //MARK: BUTTON METHODS
   
    @IBAction func btnApplyFlterAction() {
        
        DataModel.setBusFilter(arrSelectedFilterValues)
        let _ = self.navigationController?.popViewController(animated: true)
        self.delegate?.BusFilterDelegate_ApplyFilter(arrFilter: arrSelectedFilterValues)
    }
    
    
    @IBAction func btnBoardingDropAction(_ sender: UIButton) {
        
        let DropBoardVC = DropBoardingPointViewController(nibName: "DropBoardingPointViewController", bundle: nil)
        DropBoardVC._FILTER_LIST_TYPE = FILTER_LIST_TYPE(rawValue: sender.tag)!
        DropBoardVC.arrSelected = arrSelectedFilterValues
        DropBoardVC.delegate = self
        DropBoardVC.stCityID = sender.tag == 1 ? stDestCityID : stOriginCityID
        self.navigationController?.pushViewController(DropBoardVC, animated: true)
    }
       
    
    //MARK: CUSTOM METHODS

    func setFilterArrays() {
        
        let dict:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_DEPARTURE_TIME,KEY_NAME:"06:00 AM\n12:00 PM",KEY_ID:"0",KEY_VALUE:"6-12"]
        let dict1:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_DEPARTURE_TIME,KEY_NAME:"12:00 PM\n06:00 PM",KEY_ID:"1",KEY_VALUE:"12-18"]
        let dict2:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_DEPARTURE_TIME,KEY_NAME:"06:00 PM\n12:00 AM",KEY_ID:"2",KEY_VALUE:"18-24"]
        let dict3:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_DEPARTURE_TIME,KEY_NAME:"12:00 AM\n06:00 AM",KEY_ID:"3" , KEY_VALUE:"0-6"]
        
        let dict4:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_BUS_TYPE,KEY_NAME:"A/C",KEY_ID:"0"]
        let dict5:typeAliasStringDictionary = [KEY_FILTER_TYPE:KEY_BUS_TYPE,KEY_NAME:"NON A/C",KEY_ID:"1"]
        arrDepTime = [dict,dict1,dict2,dict3]
        arrBusType = [dict4,dict5]
    }
    
    func reloadCollectionViewFilter() {
        if arrSelectedFilterValues.isEmpty{
            collectionViewSelectedFilters.isHidden = true
            lblNoFilterSelected.isHidden = false
        }
        else{
            collectionViewSelectedFilters.isHidden = false
            lblNoFilterSelected.isHidden = true
        }
        collectionViewSelectedFilters.reloadData()
    }
    
    func resetSelectedfilterArray(filterType:String) {
    
        arrSelectedFilterValues = arrSelectedFilterValues.filter({ (dict) -> Bool in
            dict[KEY_FILTER_TYPE] != filterType
        })
        
    }
    func isExistSelectedFilterValue(dict:typeAliasStringDictionary) -> Int {
        
        
        for i in 0..<arrSelectedFilterValues.count {
            let dictFilter = arrSelectedFilterValues[i]
            if dict[KEY_FILTER_TYPE] == KEY_DEPARTURE_TIME &&  dictFilter[KEY_FILTER_TYPE] == dict[KEY_FILTER_TYPE] {
                return i
            }
            if dict[KEY_FILTER_TYPE] == KEY_PRICE_RANGE &&  dictFilter[KEY_FILTER_TYPE] == dict[KEY_FILTER_TYPE] {
                return i
            }
            else if dictFilter[KEY_FILTER_TYPE] == dict[KEY_FILTER_TYPE] && dictFilter[KEY_ID] == dict[KEY_ID] {
                return i
            }
        }
        return -1
    }
    
    //MARK: COLLECTIONVIEW DATASOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewDepartureTime: return arrDepTime.count
        case collectionViewBusType: return arrBusType.count
        case collectionViewSelectedFilters : return arrSelectedFilterValues.count
        default:return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewDepartureTime {
            let cell:FilterDepartureTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_FILTER_DEPARTURE_TIME_CELL, for: indexPath) as! FilterDepartureTimeCell
            let dict = arrDepTime[indexPath.item]
            cell.lblTitle.text = dict[KEY_NAME]
            var colorBorder = COLOUR_GRAY
            let ind = isExistSelectedFilterValue(dict: dict)
            if ind > -1 && arrSelectedFilterValues[ind][KEY_ID] == dict[KEY_ID] { colorBorder = COLOUR_DARK_GREEN }
            cell.lblTitle.setViewBorder(colorBorder, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: .clear)
            cell.lblTitle.textColor = colorBorder
            return cell
        }
        else if collectionView == collectionViewBusType {
            let cell:FilterDepartureTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_FILTER_DEPARTURE_TIME_CELL, for: indexPath) as! FilterDepartureTimeCell
            let dict = arrBusType[indexPath.item]
            var colorBorder = COLOUR_GRAY
            let ind = isExistSelectedFilterValue(dict: dict)
            if ind > -1{ colorBorder = COLOUR_DARK_GREEN }
            cell.lblTitle.text = dict[KEY_NAME]
            cell.lblTitle.textColor = colorBorder
            cell.lblTitle.setViewBorder(colorBorder, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: .clear)
            return cell
        }
        else{
            let cell:SelectedFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_SELECTED_FILTER_CELL, for: indexPath) as! SelectedFilterCell
            let dict = arrSelectedFilterValues[indexPath.item]
            var text = dict[KEY_NAME]!
            text = text.replace("\n", withString: "-")
            cell.lblTitle.text = text
            cell.btnClose.accessibilityIdentifier = String(indexPath.item)
            cell.delegate = self
            return cell
        }
    }
    
    //MARK: COLLECTIONVIEW FLOWLAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewBusType {
            let size = CGSize.init(width: ((collectionView.frame.width) - ((2 - 1) * 5) )/2, height: 35)
            return size
        }
        else if collectionView == collectionViewDepartureTime {
            
            let size = CGSize.init(width: ((collectionView.frame.width) - ((4 - 1) * 5) )/4, height: collectionView.frame.height)
            return size
        }
        else{
        let dict = arrSelectedFilterValues[indexPath.item]
            var text = dict[KEY_NAME]!
            text = text.replace("\n", withString: "-")
            let width:CGFloat = text.textWidth(11, textFont: UIFont.systemFont(ofSize: 11))
            let size = CGSize.init(width: width+30 , height: 25)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {return 5}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewDepartureTime{
            let dict = arrDepTime[indexPath.row]
            let ind = isExistSelectedFilterValue(dict: dict)
            if ind > -1 {
                if arrSelectedFilterValues[ind] == dict{
                    arrSelectedFilterValues.remove(at: ind)
                }
                else{arrSelectedFilterValues[ind] = dict}
            }
            else{arrSelectedFilterValues.append(dict)}
    }
        else if collectionView == collectionViewBusType {
            
            let dict = arrBusType[indexPath.row]
            let ind = isExistSelectedFilterValue(dict: dict)
            if ind > -1 { arrSelectedFilterValues.remove(at: ind)}
            else{ arrSelectedFilterValues.append(dict)}
        }
        collectionView.reloadData()
        self.reloadCollectionViewFilter()
        
    }
    
    //MARK: SELECTED FILTER CELL DELEGATE
    
    func SelectedFilterCell_btnCloseaction(button: UIButton) {
        let ind = Int(button.accessibilityIdentifier!)!
        let dict = arrSelectedFilterValues[ind]
        if dict[KEY_FILTER_TYPE] == KEY_PRICE_RANGE{
            markRangeSlider.setLeftValue(minprice, rightValue: maxprice)
        }
        arrSelectedFilterValues.remove(at: ind)
        collectionViewBusType.reloadData()
        collectionViewDepartureTime.reloadData()
        self.reloadCollectionViewFilter()
    }
    
    //MARK: DROPBOARDVIEW DELEGATE
    func DropBoardingView_SelectedArray(array: [typeAliasStringDictionary] ,filterType:String) {
        self.resetSelectedfilterArray(filterType: filterType)
        for dict in array {
            if isExistSelectedFilterValue(dict: dict) == -1 {
                arrSelectedFilterValues.append(dict)
            }
        }
       self.reloadCollectionViewFilter()
    }
    
}
