//
//  AffiliateProductFilterViewController.swift
//  Cubber
//
//  Created by dnk on 20/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

let SELECTED_FILTER_DATA = "SELECTED_FILTER_DATA"
import UIKit

protocol AffiliateProductFilterDelegete {
     func AffiliateProductFilterDelegete_ApplyFilter(dictFilter:typeAliasDictionary)
}


class AffiliateProductFilterViewController: UIViewController, AppNavigationControllerDelegate, UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, AffiliateBrandPartnerListCellDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , SelectedFilterCellDelegate{
    
    //MARK: PROPERTIES
    @IBOutlet var lblMinPrice: UILabel!
    @IBOutlet var lblMaxPrice: UILabel!
    @IBOutlet var tableViewProductFilter: UITableView!
    @IBOutlet var tableViewBrandPartner: UITableView!
    @IBOutlet var constraintTableViewProductFilterHeight: NSLayoutConstraint!
    @IBOutlet var constraintviewBrandPartnerTopToSuperView: NSLayoutConstraint!
    @IBOutlet var viewBrandPartner: UIView!
    @IBOutlet var viewRightNav: UIView!
    @IBOutlet var viewPriceRange: UIView!
    @IBOutlet var btnSelectTitle: UIButton!
   
   
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var markRangeSlider = MARKRangeSlider()
    internal var dictFilter = typeAliasDictionary()
    fileprivate var arrFilterAttribute = [typeAliasDictionary]()
    fileprivate var arrFilterData = [String]()
    fileprivate var arrFilterDataSelected = [String]()
    var selectedAttrubute:Int = -1
    internal var maxprice:Double = 0.0
    internal var minprice:Double = 0.0
    internal var stMaxPrice:String = ""
    internal var stMinPrice:String = ""
    var delegate:AffiliateProductFilterDelegete? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        constraintviewBrandPartnerTopToSuperView.constant = self.view.frame.height + 20
        self.tableViewProductFilter.rowHeight = HEIGHT_AFFILIATE_PRODUCT_FILTER_LIST_CELL
        self.tableViewProductFilter.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewProductFilter.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_FILTER_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_FILTER_LIST_CELL)
        self.tableViewProductFilter.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableViewBrandPartner.rowHeight = HEIGHT_AFFILIATE_BRAND_PARTNER_LIST_CELL
        self.tableViewBrandPartner.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewBrandPartner.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_BRAND_PARTNER_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_BRAND_PARTNER_LIST_CELL)
        self.tableViewBrandPartner.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
            minprice = Double(dictFilter[RES_minPrice] as! String)!
            maxprice = Double(dictFilter[RES_maxPrice] as! String)!
            lblMinPrice.text = String(minprice).setThousandSeperator(decimal: 0)
            lblMaxPrice.text = String(maxprice).setThousandSeperator(decimal: 0)
            markRangeSlider = MARKRangeSlider.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - (2 * 30), height: 30))
            markRangeSlider.setMinValue(CGFloat(minprice), maxValue: CGFloat(maxprice))
            markRangeSlider.setLeftValue(CGFloat(minprice), rightValue: CGFloat(maxprice))
            markRangeSlider.minimumDistance = 0.2
            markRangeSlider.disableOverlapping = true
            markRangeSlider.addTarget(self, action: #selector(markSliderValueChanges), for: .valueChanged)
            self.viewPriceRange.addSubview(markRangeSlider)
            
            arrFilterAttribute = dictFilter[RES_filterAttribute] as! [typeAliasDictionary]
            for i in 0..<arrFilterAttribute.count {
                var dictFilterData = arrFilterAttribute[i]
                if dictFilterData[SELECTED_FILTER_DATA] == nil {
                    dictFilterData[SELECTED_FILTER_DATA] = [String]() as AnyObject?
                }
                 arrFilterAttribute[i] = dictFilterData
            }
        if dictFilter[REQ_MIN_PRICE] != nil &&  dictFilter[REQ_MIN_PRICE] as! String != "" {
            stMinPrice = dictFilter[REQ_MIN_PRICE]! as! String
            lblMinPrice.text = String(stMinPrice).setThousandSeperator(decimal: 0)
        }
        if  dictFilter[REQ_MAX_PRICE] != nil &&  dictFilter[REQ_MAX_PRICE] as! String != "" {
            stMaxPrice = dictFilter[REQ_MAX_PRICE]! as! String
            lblMaxPrice.text = String(stMaxPrice).setThousandSeperator(decimal: 0)
        }
        if stMaxPrice != "" && stMinPrice != "" {
            markRangeSlider.setLeftValue(CGFloat(Int(stMinPrice)!), rightValue: CGFloat(Int(stMaxPrice)!))
        }
        else if stMaxPrice == "" && stMinPrice != "" {
            markRangeSlider.setLeftValue(CGFloat(Int(stMinPrice)!), rightValue: CGFloat(maxprice))
        }
        else if stMaxPrice != "" && stMinPrice == "" {
            markRangeSlider.setLeftValue(CGFloat(minprice), rightValue: CGFloat(Int(stMaxPrice)!))
        }

           // constraintTableViewProductFilterHeight.constant = CGFloat(arrFilterAttribute.count) * CGFloat(HEIGHT_AFFILIATE_PRODUCT_FILTER_LIST_CELL)
            self.resizeTableView()
            tableViewProductFilter.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
   
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Filter By")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setRightView(self, view: viewRightNav, totalButtons: 2)
        obj_AppDelegate.navigationController.navigationDelegate = self

    }
    
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func resizeTableView() {
        var height:CGFloat = 0
        for dict in arrFilterAttribute {
            if !(dict[SELECTED_FILTER_DATA] as! [String]).isEmpty {
                 height += 80 }
            else { height += 40 }
        }
        constraintTableViewProductFilterHeight.constant = height
        self.tableViewProductFilter.layoutIfNeeded()
    }
    func markSliderValueChanges(markSlider : MARKRangeSlider) {
        stMinPrice = String(describing: markSlider.leftValue)
        stMaxPrice =  String(describing: markSlider.rightValue)
        lblMinPrice.text = String(stMinPrice).setThousandSeperator(decimal: 0)
        lblMaxPrice.text = String(stMaxPrice).setThousandSeperator(decimal: 0)
    }
    
    @IBAction func btnResetAction() {
        self.resetRangleSlider()
        for i in 0..<arrFilterAttribute.count {
            var dictFilterData = arrFilterAttribute[i]
            dictFilterData[SELECTED_FILTER_DATA] = [String]() as AnyObject?
            arrFilterAttribute[i] = dictFilterData
        }
        self.resizeTableView()
        tableViewProductFilter.reloadData()
    }
    
    func resetRangleSlider() {
        stMinPrice = ""
        stMaxPrice = ""
        markRangeSlider.setMinValue(CGFloat(minprice), maxValue: CGFloat(maxprice))
        markRangeSlider.setLeftValue(CGFloat(minprice), rightValue: CGFloat(maxprice))
        lblMinPrice.text = String(minprice).setThousandSeperator(decimal: 0)
        lblMaxPrice.text = String(maxprice).setThousandSeperator(decimal: 0)
    }
    
    @IBAction func btnApplyFilterAction() {
        
        
        if !dictFilter.isEmpty {
            
            dictFilter[REQ_MIN_PRICE] = (stMinPrice == "" ? stMinPrice : String(Int(Float(stMinPrice)!))) as AnyObject?
            dictFilter[REQ_MAX_PRICE] = (stMaxPrice == "" ? stMaxPrice : String(Int(Float(stMaxPrice)!))) as AnyObject?
            
            var dictParameters = typeAliasDictionary()
            for i in 0..<arrFilterAttribute.count {
                let dict = arrFilterAttribute[i]
                if !(dict[SELECTED_FILTER_DATA] as! [String]).isEmpty {
                    let arrSelectedFilterData = dict[SELECTED_FILTER_DATA] as! [String]
                    dictParameters[dict[RES_Key] as! String] = arrSelectedFilterData as AnyObject?
                }
                dictFilter[REQ_FILTER_PARAMETER] = dictParameters as AnyObject
            }
            dictFilter[RES_filterAttribute] = self.arrFilterAttribute as AnyObject?
        }
        let _ = self.navigationController?.popViewController(animated: true)
      self.delegate?.AffiliateProductFilterDelegete_ApplyFilter(dictFilter: dictFilter)
        
    }
    
    @IBAction func btnSelectTitleAction() {
         constraintviewBrandPartnerTopToSuperView.constant = self.view.frame.height + 20
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
   
    @IBAction func btnDoneAction() {
        
         constraintviewBrandPartnerTopToSuperView.constant = self.view.frame.height + 20
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.tableViewProductFilter.reloadData()
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewBrandPartner { return arrFilterData.count }
        else { return arrFilterAttribute.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewBrandPartner {
            let cell:AffiliateBrandPartnerListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_BRAND_PARTNER_LIST_CELL) as! AffiliateBrandPartnerListCell
            cell.delegate = self
            let stTitle = arrFilterData[indexPath.row]
            cell.lblTitle.text = stTitle
            cell.btnCheckBox.accessibilityIdentifier = String(indexPath.row)
            let index = self.isExistSelectedFilterValue(stValue: stTitle)
            if index >= 0 { cell.btnCheckBox.isSelected = true }
            else { cell.btnCheckBox.isSelected = false }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else{
            let cell:ProductFilterListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_FILTER_LIST_CELL) as! ProductFilterListCell
            let dict:typeAliasDictionary = arrFilterAttribute[indexPath.row]
            
                cell.collectionViewFilterAttribute.tag = indexPath.row
                cell.collectionViewFilterAttribute.delegate = self
                cell.collectionViewFilterAttribute.dataSource = self
                cell.collectionViewFilterAttribute.reloadData()
            
            cell.lblFilterAttributeTitle.text = dict[RES_Title] as? String
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewBrandPartner {
            return HEIGHT_AFFILIATE_BRAND_PARTNER_LIST_CELL
        }else {
            
            let dict:typeAliasDictionary = arrFilterAttribute[indexPath.row]
            if !(dict[SELECTED_FILTER_DATA] as! [String]).isEmpty {
                 return HEIGHT_AFFILIATE_PRODUCT_FILTER_LIST_CELL }
            else { return CGFloat(40) }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewBrandPartner {
            let cell:AffiliateBrandPartnerListCell = tableView.cellForRow(at: indexPath) as! AffiliateBrandPartnerListCell
            self.btnAffiliateBrandPartnerListCell_CheckBoxAction(button: cell.btnCheckBox)
            
        }
        else{
            let dict = arrFilterAttribute[indexPath.row]
            selectedAttrubute = indexPath.row
            btnSelectTitle.setTitle("Select \(dict[RES_Title]!)", for: UIControlState.normal)
            arrFilterData = dict[RES_filterData] as! [String]
             tableViewBrandPartner.reloadData()
            constraintviewBrandPartnerTopToSuperView.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func btnAffiliateBrandPartnerListCell_CheckBoxAction(button:UIButton){
        let row: Int = Int(button.accessibilityIdentifier!)!
        let indexPath: IndexPath = IndexPath(row: row, section: 0)
        let s_Info: String = arrFilterData[indexPath.row]
        
        var dict = arrFilterAttribute[selectedAttrubute]
        var arrSelectedFilterData = dict[SELECTED_FILTER_DATA] as! [String]
        
        let index: Int = self.isExistSelectedFilterValue(stValue: s_Info)
        if index >= 0 {
            arrSelectedFilterData.remove(at: index)
        }
        else {
            arrSelectedFilterData.append(s_Info as String)
        }
         dict[SELECTED_FILTER_DATA] = arrSelectedFilterData as AnyObject?
        arrFilterAttribute[selectedAttrubute] = dict
        tableViewBrandPartner.reloadRows(at: [indexPath], with: .none)
        self.resizeTableView()
        tableViewProductFilter.reloadData()
        
    }
    
    func isExistSelectedFilterValue(stValue:String) -> Int {
        let dict = arrFilterAttribute[selectedAttrubute]
        let arrSelectedFilterData = dict[SELECTED_FILTER_DATA] as! [String]
        for i in 0..<arrSelectedFilterData.count {
            let strValue = arrSelectedFilterData[i]
            if strValue == stValue {
                return i
            }
        }
        return -1
    }

    //MARK: COLLECTION VIEW DATA SOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dict = arrFilterAttribute[collectionView.tag]
        let arrValue = dict[SELECTED_FILTER_DATA] as! [String]
        return arrValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SelectedFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_SELECTED_FILTER_CELL, for: indexPath) as! SelectedFilterCell
        cell.delegate = self
        let dict = arrFilterAttribute[collectionView.tag]
        let arrValue = dict[SELECTED_FILTER_DATA] as! [String]
        let stValue :String = arrValue[indexPath.item]
        cell.btnClose.accessibilityIdentifier = String(collectionView.tag)
        cell.btnClose.accessibilityLabel = String(indexPath.item)
        cell.lblTitle.text = stValue
        return cell
    }
    
    //MARK: COLLECTON VIEW DELEGATE FLOW LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dict = arrFilterAttribute[collectionView.tag]
        let arrValue = dict[SELECTED_FILTER_DATA] as! [String]
        let text = arrValue[indexPath.row]
        let width:CGFloat = text.textWidth(11, textFont: UIFont.systemFont(ofSize: 11))
        let size = CGSize.init(width: width+35 , height: 30)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func SelectedFilterCell_btnCloseaction(button:UIButton){
        let index = Int(button.accessibilityIdentifier!)
        let item = Int(button.accessibilityLabel!)
        var dict = arrFilterAttribute[index!]
        var arrValue = dict[SELECTED_FILTER_DATA] as! [String]
        arrValue.remove(at: item!)
        dict[SELECTED_FILTER_DATA] = arrValue as AnyObject?
        arrFilterAttribute[index!] = dict
        self.resizeTableView()
        tableViewProductFilter.reloadData()
        
    }
}
