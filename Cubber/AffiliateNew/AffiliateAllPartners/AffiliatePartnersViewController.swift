//
//  AffiliatePartnersViewController.swift
//  Cubber
//
//  Created by dnk on 10/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliatePartnersViewController: UIViewController, VKPagerViewDelegate, UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , AppNavigationControllerDelegate, UIGestureRecognizerDelegate,AffiliateProductFilterDelegete {
    
    let TAG_PLUS = 100
    
    //MARK: PROPERTIES
    @IBOutlet var viewShoppingPartners: UIView!
    @IBOutlet var viewShoppingOffers: UIView!
    @IBOutlet var viewShoppingProducts: UIView!
    @IBOutlet var viewSortPrice: UIView!
    @IBOutlet var tableViewPartners: UITableView!
    @IBOutlet var tableViewOffers: UITableView!
    @IBOutlet var tableViewProducts: UITableView!
    
    @IBOutlet var collectionViewPartnerCategoryList: UICollectionView!
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var lblNoOfferFound: UILabel!
    @IBOutlet var lblNoProductsFound: UILabel!
    @IBOutlet var lblFilterApplied: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var arrList = [typeAliasDictionary]()
    fileprivate var arrTopPartnerList = [typeAliasDictionary]()
    fileprivate var arrOfferList = [typeAliasDictionary]()
    fileprivate var arrProductList = [typeAliasDictionary]()
    fileprivate var arrDisableCategoryListProduct = [String]()
    fileprivate var arrDisableCategoryListOffer = [String]()
    fileprivate var dictFilter = typeAliasDictionary()
    internal var arrAffiliateCategoryList = [typeAliasDictionary]()
    fileprivate var arrDisplayCategoryList = [typeAliasDictionary]()

    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 1
    
    fileprivate var pageSizeOffer: Int = 0
    fileprivate var totalPagesOffer: Int = 0
    fileprivate var totalRecordsOffer: Int = 0
    fileprivate var currentPageOffer: Int = 1
    
    fileprivate var pageSizePartners: Int = 0
    fileprivate var totalPagesPartners: Int = 0
    fileprivate var totalRecordsPartrners: Int = 0
    fileprivate var currentPagePartners: Int = 1
    
    fileprivate var pageSizeProduct: Int = 0
    fileprivate var totalPagesProduct: Int = 0
    fileprivate var totalRecordsProduct: Int = 0
    fileprivate var currentPageProduct: Int = 1
    
    internal var selctedTypeId:String = "2"
    internal var isOffer:Bool   = false
    fileprivate var selectedMenu:Int = 0
    internal var selectedIndex = 0
    fileprivate var isReloadService:Bool = false
    fileprivate var isApplyFilter:Bool = false
    var selctedSortType:String = ""
    @IBOutlet var btnDefault: UIButton!
    @IBOutlet var btnLowHigh: UIButton!
    @IBOutlet var btnHighLow: UIButton!
    var stJsonParameter : String = ""
    var count: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSortPrice.isHidden = true
        self.btnPriceSortAction(btnDefault)
        self.tableViewOffers.rowHeight = UITableViewAutomaticDimension
        self.tableViewOffers.estimatedRowHeight = HEIGHT_AFFILIATE_OFFER_LIST_CELL
        self.tableViewOffers.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewOffers.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL)
        self.tableViewOffers.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableViewPartners.rowHeight = UITableViewAutomaticDimension
        self.tableViewPartners.estimatedRowHeight = HEIGHT_AFFILIATE_PARTNERS_LIST_CELL
        self.tableViewPartners.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewPartners.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PARTNERS_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PARTNERS_CELL)
        self.tableViewPartners.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableViewProducts.rowHeight = UITableViewAutomaticDimension
        self.tableViewProducts.estimatedRowHeight = HEIGHT_AFFILIATE_PRODUCT_LIST_CELL
        self.tableViewProducts.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewProducts.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_LIST_CELL)
        self.tableViewProducts.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableViewProducts.separatorColor = UIColor.lightGray

        collectionViewPartnerCategoryList.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL)
        
        if self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffilateNewCategory_List){
            self.callAffiliateNew_CategoryList()
        }
        else{
            let dict = DataModel.getAffilateCategoryListResponse()
            self.arrAffiliateCategoryList = dict[RES_affiliateTypeList] as! [typeAliasDictionary]
            self.arrDisplayCategoryList = self.arrAffiliateCategoryList
            self.pageSize = Int(dict[RES_perPage] as! Int)
            self.totalPages = Int(dict[RES_totalPages] as! String)!
            self.totalRecords = Int(dict[RES_totalItems] as! String)!
            //self.callAffiliate_TopPartnerList()
            self.createPaginationView()
       }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_AFFILIATE_PARTNERLIST)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.SetScreenName(name: F_AFFILIATE_PARTNERLIST, stclass: F_AFFILIATE_PARTNERLIST)
    }
    
    func setNavigationBar() {
       
        obj_AppDelegate.navigationController.setCustomTitle("Partners")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
      let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func getPartnerListData() {
    
        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffiliateTopPartner_list) {
            DataModel.setAffiliatePartnerListResponse(dict: typeAliasDictionary())
            self.currentPagePartners = 1
            self.callAffiliateTopPartnerList()
        }
        else{
            
            let dictAffiliatePartner = DataModel.getAffiliatePartnerListResponse()
            if dictAffiliatePartner[String(selctedTypeId)] != nil {
                let dict:typeAliasDictionary = dictAffiliatePartner[String(selctedTypeId)] as! typeAliasDictionary
                DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
                self.currentPagePartners = 1
                self.arrTopPartnerList = dict[RES_partners] as! [typeAliasDictionary]
                self.pageSizePartners = Int(dict[RES_perPage] as! String)!
                self.totalPagesPartners = Int(dict[RES_totalPages] as! String)!
                self.totalRecordsPartrners = Int(dict[RES_totalItems] as! String)!
                self.tableViewPartners.reloadData()
            }
            else {
                self.currentPagePartners = 1
                 self.callAffiliateTopPartnerList()
            }
        }
    }
    
    func getOfferListData() {
        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffilateOffer_List) {
            DataModel.setAffiliateOfferListResponse(dict: typeAliasDictionary())
            self.currentPageOffer = 1
            self.callAffiliateOfferList()
        }
        else{
            
            let dictAffiliateOffer = DataModel.getAffiliateOfferListResponse()
            if dictAffiliateOffer[String(selctedTypeId)] != nil {
                let dict:typeAliasDictionary = dictAffiliateOffer[String(selctedTypeId)] as! typeAliasDictionary
                DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
                self.currentPageOffer = 1
                self.arrOfferList = dict[RES_offers] as! [typeAliasDictionary]
                self.pageSizeOffer = Int(dict[RES_perPage] as! String)!
                self.totalPagesOffer = Int(dict[RES_totalPages] as! String)!
                self.totalRecordsOffer = Int(dict[RES_totalItems] as! String)!
                self.tableViewOffers.reloadData()
                self.lblNoOfferFound.isHidden = true
            }
            else{
                self.currentPageOffer = 1
                self.callAffiliateOfferList()
            }
        }
    }
    
    func getProductListData() {
        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffiliateProduct_List) {
            DataModel.setAffiliateProductListResponse(dict: typeAliasDictionary())
            self.currentPageProduct = 1
            self.callAffiliateProduct_List()
        }
        else{
            
            self.dictFilter = typeAliasDictionary()
            let dictAffiliatePartner = DataModel.getAffiliateProductListResponse()
            if dictAffiliatePartner[String(selctedTypeId)] != nil {
                let dict:typeAliasDictionary = dictAffiliatePartner[String(selctedTypeId)] as! typeAliasDictionary
                DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
                self.currentPageProduct = 1
                self.dictFilter = dict[RES_filters] as! typeAliasDictionary
                self.arrProductList = dict[RES_products] as! [typeAliasDictionary]
                self.pageSizeProduct = Int(dict[RES_perPage] as! String)!
                self.totalPagesProduct = Int(dict[RES_totalPages] as! String)!
                self.totalRecordsProduct = Int(dict[RES_totalItems] as! String)!
                self.lblFilterApplied.text = "0 Filter Applied"
                self.tableViewProducts.reloadData()
            }
            else {
                self.currentPageProduct = 1
                self.callAffiliateProduct_List()
            }
        }
    }
    
    func callAffiliateProduct_List(){
        
        var params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(), REQ_AFF_CATEGORY_ID:selctedTypeId ,  REQ_PAGE_NO:"\(self.currentPageProduct)", REQ_PARTNER_ID:"", REQ_FILTER_PARAMETER:"",REQ_MAX_PRICE:"",REQ_MIN_PRICE:"",REQ_ORDER_BY:selctedSortType]
        
        if !dictFilter.isEmpty && dictFilter[REQ_FILTER_PARAMETER] != nil {
            isApplyFilter = true
            let dict:typeAliasDictionary = dictFilter[REQ_FILTER_PARAMETER] as! typeAliasDictionary
            print(dict)
            if dict.isEmpty && dictFilter[REQ_MAX_PRICE] as! String == "" && dictFilter[REQ_MIN_PRICE] as! String == "" {
                isApplyFilter = false
            }
            stJsonParameter = dict.convertToJSonString()
            params[REQ_FILTER_PARAMETER] = stJsonParameter
            params[REQ_MAX_PRICE] = dictFilter[REQ_MAX_PRICE] as? String
            params[REQ_MIN_PRICE] = dictFilter[REQ_MIN_PRICE] as? String
            if dictFilter[REQ_MAX_PRICE] as! String == "" || dictFilter[REQ_MIN_PRICE] as! String == ""  {
                count = 0
            }
            else{ count = 1 }
            count += dict.count
           lblFilterApplied.text = "\(count) Filter Applied"
        }
        else{ isApplyFilter = false ;  count = 0; lblFilterApplied.text = "\(count) Filter Applied" }
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateProduct_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrProductList += dict[RES_products] as! [typeAliasDictionary]
            self.arrDisableCategoryListProduct = dict[RES_disableCategories] as! [String]
            if !self.isApplyFilter {
                self.dictFilter = dict[RES_filters] as! typeAliasDictionary
            }
            
            for str in self.arrDisableCategoryListProduct {
                self.arrDisplayCategoryList = self.arrDisplayCategoryList.filter({ (dictCat) -> Bool in
                    return dictCat[RES_partnerTypeId] as! String != str
                })
            }
            self.collectionViewPartnerCategoryList.reloadData()
            self.pageSizeProduct = Int(dict[RES_perPage] as! String)!
            self.totalPagesProduct = Int(dict[RES_totalPages] as! String)!
            self.totalRecordsProduct = Int(dict[RES_totalItems] as! String)!
            self.tableViewProducts.reloadData()
            self.lblNoProductsFound.isHidden = true
            self.tableViewProducts.isHidden = false
            if self.currentPageProduct == 1 && self.selctedSortType == "" && !self.isApplyFilter {
                var dictProduct = DataModel.getAffiliateProductListResponse()
                dictProduct[String(self.selctedTypeId)] = dict as AnyObject?
                DataModel.setAffiliateProductListResponse(dict: dictProduct)
            }
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_AffiliateProduct_List)
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE)
            self.lblNoProductsFound.isHidden = false
            self.tableViewProducts.isHidden = true
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    func callAffiliateNew_CategoryList() {
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(),
                      REQ_PAGE_NO:String(self.currentPage)]
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateNewCategory_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token] as! String)
            self.arrAffiliateCategoryList += dict[RES_affiliateTypeList] as! [typeAliasDictionary]
            self.arrDisplayCategoryList = self.arrAffiliateCategoryList
            self.pageSize = Int(dict[RES_perPage] as! Int)
            self.totalPages = Int(dict[RES_totalPages] as! String)!
            self.totalRecords = Int(dict[RES_totalItems] as! String)!
            DataModel.setAffilateCategoryListResponse(dict: dict)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_AffilateNewCategory_List)
            self.collectionViewPartnerCategoryList.reloadData()
            self.createPaginationView()
            
        }, onFailure: { (code, dict) in
        }) {
             self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        }
    }
    
    func callAffiliateTopPartnerList() {
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(), REQ_AFF_CATEGORY_ID:selctedTypeId ,  REQ_PAGE_NO:"\(self.currentPagePartners)"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateTopPartner_list, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrTopPartnerList += dict[RES_partners] as! [typeAliasDictionary]
            self.pageSizePartners = Int(dict[RES_perPage] as! String)!
            self.totalPagesPartners = Int(dict[RES_totalPages] as! String)!
            self.totalRecordsPartrners = Int(dict[RES_totalItems] as! String)!
            self.tableViewPartners.reloadData()
            if self.currentPagePartners == 1 {
                var dictPartners = DataModel.getAffiliatePartnerListResponse()
                dictPartners[String(self.selctedTypeId)] = dict as AnyObject?
                DataModel.setAffiliatePartnerListResponse(dict: dictPartners)
            }
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_AffiliateTopPartner_list)
        }, onFailure: { (code, dict) in
           self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }

    func callAffiliateOfferList(){
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(), REQ_AFF_CATEGORY_ID:selctedTypeId , REQ_PAGE_NO:"\(self.currentPageOffer)"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateOffer_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrOfferList += dict[RES_offers] as! [typeAliasDictionary]
            self.arrDisableCategoryListOffer = dict[RES_disableCategories] as! [String]
            
            for str in self.arrDisableCategoryListOffer {
                self.arrDisplayCategoryList = self.arrDisplayCategoryList.filter({ (dictCat) -> Bool in
                    return dictCat[RES_partnerTypeId] as! String != str
                })
            }
            self.collectionViewPartnerCategoryList.reloadData()
            self.pageSizeOffer = Int(dict[RES_perPage] as! String)!
            self.totalPagesOffer = Int(dict[RES_totalPages] as! String)!
            self.totalRecordsOffer = Int(dict[RES_totalItems] as! String)!
            self.tableViewOffers.reloadData()
            if self.currentPageOffer == 1 {
                var dictOffer = DataModel.getAffiliateOfferListResponse()
                dictOffer[String(self.selctedTypeId)] = dict as AnyObject?
                DataModel.setAffiliateOfferListResponse(dict: dictOffer)
            }
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_AffilateOffer_List)
            self.lblNoOfferFound.isHidden = true
        }, onFailure: { (code, dict) in
            self.lblNoOfferFound.isHidden = false
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }

    
    fileprivate func createPaginationView() {
        
        self.arrList = [[RES_id :"0" as AnyObject,RES_value:"Partners" as AnyObject] , [RES_id :"1" as AnyObject,RES_value:"Offers" as AnyObject] , [RES_id :"2" as AnyObject,RES_value:"Products" as AnyObject]]
        
        self.view.layoutIfNeeded()
        self._VKPagerView.backColor = COLOUR_AFFILIATE_GREEN
        self._VKPagerView.selectedBottomColor = UIColor.white
        self._VKPagerView.setPagerViewData(self.arrList, keyName: RES_value, font: .systemFont(ofSize: 13), widthView: UIScreen.main.bounds.width)
        self._VKPagerView.delegate = self
        
        for i in 0..<self.arrList.count {
            var dict: typeAliasDictionary = self.arrList[i]
            let categoryID: Int = Int(dict[RES_id] as! String)!
            let xOrigin: CGFloat = CGFloat(i) * _VKPagerView.scrollViewPagination.frame.width
            let tag: Int = (i + TAG_PLUS)
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: _VKPagerView.scrollViewPagination.frame.width, height: _VKPagerView.scrollViewPagination.frame.height)
            
            let setLayout = { (viewBG: UIView) in
                
                let setAutoLayout = { (viewContent: UIView) in
                    viewContent.tag = tag
                    viewContent.translatesAutoresizingMaskIntoConstraints = false;
                    self._VKPagerView.scrollViewPagination.addSubview(viewContent);
                    
                    //---> SET AUTO LAYOUT
                    //HEIGHT
                    self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
                    
                    //WIDTH
                    self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
                    
                    //TOP
                    self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
                    
                    if (i == 0)
                    {
                        //LEADING
                        self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
                    }
                    else
                    {
                        //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                        let viewPrevious: UIView = self._VKPagerView.scrollViewPagination.viewWithTag(tag - 1)!;
                        self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
                    }
                    
                    if (i == self.arrList.count - 1) //This will set scroll view content size
                    {
                        //SCROLLVIEW - TRAILING
                        self.view.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
                    }
                }
                setAutoLayout(viewBG)
            }
            
            if categoryID == VAL_SHOPPING_PARTNERS { viewShoppingPartners.frame = frame; setLayout(viewShoppingPartners) }
            else if categoryID == VAL_SHOPPING_OFFERS { viewShoppingOffers.frame = frame; setLayout(viewShoppingOffers) }
             else if categoryID == VAL_SHOPPING_PRODUCT { viewShoppingProducts.frame = frame; setLayout(viewShoppingProducts) }
        }
        self.view.layoutIfNeeded()
        if isOffer {  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {self._VKPagerView.jumpToPageNo(1) } }
        else {
            if selectedIndex > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {self._VKPagerView.jumpToPageNo(self.selectedIndex) }
                //CALL PRODUCT LIST SERVICE
               // self.currentPageProduct = 1
                self.getProductListData()
            }
            else { self.getPartnerListData() }
        }
        var index:CGFloat = 0
        for i in 0..<arrDisplayCategoryList.count {
            let dict = arrDisplayCategoryList[i]
            if dict[RES_partnerTypeId] as! String == selctedTypeId {
                index = CGFloat(i)
            }
        }
        let offset = CGPoint.init(x: index * 68 , y: 0)
        collectionViewPartnerCategoryList.setContentOffset(offset, animated: true)
    }
    
    @IBAction func btnTapPriceViewCloseAction(_ sender: UITapGestureRecognizer) {
        self.viewSortPrice.isHidden = true
    }
    
    @IBAction func btnPriceSortAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 0 {
            selctedSortType = ""
            btnDefault.isSelected = true
            btnLowHigh.isSelected = false
            btnHighLow.isSelected = false
            
        }
        else if sender.tag == 1{
            selctedSortType = "LTH"
            btnDefault.isSelected = false
            btnLowHigh.isSelected = true
            btnHighLow.isSelected = false

        }
        else {
            selctedSortType = "HTL"
            btnDefault.isSelected = false
            btnLowHigh.isSelected = false
            btnHighLow.isSelected = true

        }
        
    }
    
    @IBAction func btnFilterByAction() {
        let affiliateProductFilterVC = AffiliateProductFilterViewController(nibName: "AffiliateProductFilterViewController", bundle: nil)
        affiliateProductFilterVC.dictFilter = self.dictFilter
        affiliateProductFilterVC.delegate = self
        self.navigationController?.pushViewController(affiliateProductFilterVC, animated: true)
        
    }
    
    @IBAction func btnSortByAction() {
        viewSortPrice.isHidden = false
    }
    
    @IBAction func btnSortByApplyAction() {
        arrProductList = [typeAliasDictionary]()
        currentPageProduct = 1
        self.callAffiliateProduct_List()
        viewSortPrice.isHidden = true
    }
    //MARK: COLLECTIONVIEW DATA SOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return arrDisplayCategoryList.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell:AffiliateCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL, for: indexPath) as! AffiliateCategoryCell
        
        let dictCategory:typeAliasDictionary = arrDisplayCategoryList[indexPath.item]
        cell.imageViewIcon.sd_setImage(with: (dictCategory[RES_partnerTypeImage] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
            if image != nil {
                cell.imageViewIcon.image = image
            }
        })
        
        if selctedTypeId == dictCategory[RES_partnerTypeId] as! String {
            cell.contentView.backgroundColor = .white
            cell.viewLblBG.backgroundColor = RGBCOLOR(29, g: 86, b: 47)
            cell.lblTitle.backgroundColor = .white
             cell.lblTitle.textColor = COLOUR_ORANGE
        }
        else{ cell.contentView.backgroundColor = .clear
            cell.viewLblBG.backgroundColor = .clear
            cell.lblTitle.backgroundColor = .clear
        cell.lblTitle.textColor = COLOUR_AFFILIATE_GREEN }
        cell.lblTitle.text = dictCategory[RES_partnerTypeName] as? String
        cell.contentView.layer.cornerRadius = 0
        
        if indexPath.row == self.arrDisplayCategoryList.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages { currentPage = page
                self.callAffiliateNew_CategoryList()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: HEIGH_AFFILIATE_CATEGORY_LIST_CELL , height: HEIGH_AFFILIATE_CATEGORY_LIST_CELL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let dictCat:typeAliasDictionary = arrDisplayCategoryList[indexPath.item]
        if selectedMenu == 0 { self.arrOfferList = [typeAliasDictionary]() ; self.arrTopPartnerList = [typeAliasDictionary]() ; self.arrProductList = [typeAliasDictionary]()
        }
        else {
            self.arrOfferList = [typeAliasDictionary]() ; self.arrTopPartnerList = [typeAliasDictionary](); self.arrProductList = [typeAliasDictionary]()
        }
            self.dictFilter = typeAliasDictionary()
            selctedTypeId =  dictCat[RES_partnerTypeId] as! String
            self.tableViewPartners.reloadData()
            self.tableViewOffers.reloadData()
            self.tableViewProducts.reloadData()
        selectedMenu == 0 ? self.getPartnerListData() : selectedMenu == 1 ? self.getOfferListData() : self.getProductListData()
            self.collectionViewPartnerCategoryList.reloadData()
    }

    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(tableViewOffers){return arrOfferList.count}
        else if tableView.isEqual(tableViewProducts){return arrProductList.count}
        else{return arrTopPartnerList.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(tableViewOffers) {
            let cell:AffiliateOfferListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL) as! AffiliateOfferListCell
            let dict:typeAliasDictionary = arrOfferList[indexPath.row]
            
            cell.imageViewLogo.sd_setImage(with: (dict[RES_offerBanner] as! String).convertToUrl(), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, catchType, url) in
                if image == nil { cell.imageViewLogo.image = UIImage(named: "logo")}
                else { cell.imageViewLogo.image = image! }
            })
            
            cell.lblCouponCode.text = dict[RES_offerCoupon] as? String
            cell.lblCouponValid.text = "This Offer is valid till \(dict[RES_offerExpireDate] as! String)"
            cell.lblRewards.text = (dict[RES_offerCommission1] as? String)
            cell.lblDiscount.text = dict[RES_offerTitle] as? String
            cell.lblPartnerName.text = "@\(dict[RES_partnerName] as! String) , \(dict[RES_offerDiscount] as! String) "
            if dict[RES_couponFlag] as! Int == 1 { cell.btnCouponCode.isEnabled = true }
            else { cell.btnCouponCode.isEnabled = false }
            
            if indexPath.row == self.arrOfferList.count - 1 {
                let page: Int = self.currentPageOffer + 1
                if page <= self.totalPagesOffer { currentPageOffer = page
                    self.callAffiliateOfferList()
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if tableView.isEqual(tableViewProducts) {
            let cell:AffiliateProductListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_LIST_CELL) as! AffiliateProductListCell
          
            let dictProduct:typeAliasDictionary = arrProductList[indexPath.row]
            cell.lblProductTitle.text = dictProduct[RES_productTitle] as? String
            cell.activityIndicator.startAnimating()
            cell.imageViewProduct.sd_setImage(with: (dictProduct[RES_productImage] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
                cell.activityIndicator.stopAnimating()
                if image != nil {
                    cell.imageViewProduct.image = image
                }
            })
            cell.imageViewPartner.sd_setImage(with: (dictProduct[RES_partnerLogo1] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
                if image != nil {
                    cell.imageViewPartner.image = image
                }
            })
            
            if dictProduct[RES_specialPrice] as! String == "0" {
                cell.lblSellingPrice.text = ""
                cell.lblSpecialPrice.text = (dictProduct[RES_sellingPrice] as! String).setThousandSeperator(decimal: 2)
            }
            else{
                var stSellingPrice:String = (dictProduct[RES_sellingPrice] as! String).setThousandSeperator(decimal: 2)
                let attributedText = NSMutableAttributedString.init(string: stSellingPrice)
                attributedText.addAttributes([NSStrikethroughStyleAttributeName: 1,NSStrikethroughColorAttributeName: UIColor.red], range: NSMakeRange(0, stSellingPrice.characters.count))
                cell.lblSellingPrice.attributedText = attributedText
                cell.lblSpecialPrice.text = (dictProduct[RES_specialPrice] as! String).setThousandSeperator(decimal: 2)
            }
            cell.lblCubberCommision.text = dictProduct[RES_cubberCommission] as? String
            
            if indexPath.row == self.arrProductList.count - 1 {
                let page: Int = self.currentPageProduct + 1
                if page <= self.totalPagesProduct { currentPageProduct = page
                    self.callAffiliateProduct_List()
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
            
        else {
            
            let cell:AffiliatePartnersListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_PARTNERS_CELL) as! AffiliatePartnersListCell
            
            let dict:typeAliasDictionary = arrTopPartnerList[indexPath.row]
            
            if indexPath.row % 2 != 0 {
                cell.viewLeft.isHidden = false
                cell.viewRight.isHidden = true
                cell.lblPartnerDiscountLeft.text = String(describing: dict[RES_partnerCommission]!)
                cell.lblPartnerRewardsLeft.text = "\(dict[RES_partnerName]!)"
                cell.leftActivityIndicator.startAnimating()
                cell.imageViewLogoLeft.sd_setImage(with: (dict[RES_partnerLogo1] as! String).convertToUrl(), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, catchType, url) in
                    cell.leftActivityIndicator.stopAnimating()
                    if image == nil { cell.imageViewLogoLeft.image = UIImage(named: "logo")}
                    else { cell.imageViewLogoLeft.image = image! }
                })
            }
            else {
                cell.viewLeft.isHidden = true
                cell.viewRight.isHidden = false
                cell.lblPartnerDiscountRight.text = String(describing: dict[RES_partnerCommission]!)
                cell.lblPartnerRewardsRight.text = "\(dict[RES_partnerName]!)"
                 cell.rightActivityIndicator.startAnimating()
                cell.imageViewLogoRight.sd_setImage(with: (dict[RES_partnerLogo1] as! String).convertToUrl(), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, catchType, url) in
                    cell.rightActivityIndicator.stopAnimating()
                    if image == nil { cell.imageViewLogoRight.image = UIImage(named: "logo")}
                    else { cell.imageViewLogoRight.image = image! }
                })
            }
            if indexPath.row == self.arrTopPartnerList.count - 1{
                let page: Int = self.currentPagePartners + 1
                if page <= self.totalPagesPartners { currentPagePartners = page
                    self.callAffiliateTopPartnerList()
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(tableViewOffers)  { return UITableViewAutomaticDimension }
        else if tableView.isEqual(tableViewProducts)  { return UITableViewAutomaticDimension }
        else{return HEIGHT_AFFILIATE_PARTNERS_LIST_CELL}
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableViewPartners {
            let dictPartner:typeAliasDictionary = arrTopPartnerList[indexPath.row]
            let partnerDetailVC = AffiliatePartnerDetailViewController(nibName: "AffiliatePartnerDetailViewController", bundle: nil)
            partnerDetailVC.partnerID = dictPartner[RES_partnerId] as! String
            self.navigationController?.pushViewController(partnerDetailVC, animated: true)
        }
        else if tableView == tableViewProducts {
            let productDetailVC = AffiliateProductDetailViewController(nibName: "AffiliateProductDetailViewController", bundle: nil)
            productDetailVC.stProductID = arrProductList[indexPath.row][RES_productId] as! String
            productDetailVC.stProductTitle = arrProductList[indexPath.row][RES_productTitle] as! String
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
        else {
        
            let dictOffer:typeAliasDictionary = arrOfferList[indexPath.row]
            let offerDetailVC = affiliateOfferDetailViewController(nibName: "affiliateOfferDetailViewController", bundle: nil)
            offerDetailVC.offerID = dictOffer[RES_offerId] as! String
            self.navigationController?.pushViewController(offerDetailVC, animated: true)
            
        }
        
    }
    
    // MARK:GESTURE DELEGATE
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        if view?.tag == 100 {
            return true
        }
        return false
        
    }
    
    //MARK: AFFILIATE PRODUCT FILTER DELEGATE
    func AffiliateProductFilterDelegete_ApplyFilter(dictFilter:typeAliasDictionary) {
        self.dictFilter = dictFilter as typeAliasDictionary
        arrProductList = [typeAliasDictionary]()
        currentPageProduct = 1
        self.callAffiliateProduct_List()
    }

    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        self.selectedMenu = selectedMenu
        arrDisplayCategoryList = arrAffiliateCategoryList
        if selectedMenu == 1 {
            for str in self.arrDisableCategoryListOffer {
                self.arrDisplayCategoryList = self.arrDisplayCategoryList.filter({ (dictCat) -> Bool in
                    return dictCat[RES_partnerTypeId] as! String != str
                })
            }
        }
        else if selectedMenu == 2 {
            for str in self.arrDisableCategoryListProduct {
                self.arrDisplayCategoryList = self.arrDisplayCategoryList.filter({ (dictCat) -> Bool in
                    return dictCat[RES_partnerTypeId] as! String != str
                })
            }
        }
        self.selctedTypeId = "0"
        self.collectionViewPartnerCategoryList.reloadData()
        
        if selectedMenu == 1  {
            self.tableViewOffers.reloadData()
            self.getOfferListData()
            self.sendScreenView(name: F_AFFILIATE_OFFERLIST)
            self.SetScreenName(name: F_AFFILIATE_OFFERLIST, stclass: F_MODULE_AFFILIATE)
        }
        else if selectedMenu == 0  {
            self.tableViewPartners.reloadData()
            self.getPartnerListData()
            self.sendScreenView(name: F_AFFILIATE_PARTNERLIST)
            self.SetScreenName(name: F_AFFILIATE_PARTNERLIST, stclass: F_MODULE_AFFILIATE)
        }
        else if selectedMenu == 2  {
            self.tableViewProducts.reloadData()
            self.currentPageProduct = 1
            self.getProductListData()
            self.sendScreenView(name: F_AFFILIATE_PRODUCTLIST)
            self.SetScreenName(name: F_AFFILIATE_PRODUCTLIST, stclass: F_MODULE_AFFILIATE)
        }
        
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
        
    }
}
