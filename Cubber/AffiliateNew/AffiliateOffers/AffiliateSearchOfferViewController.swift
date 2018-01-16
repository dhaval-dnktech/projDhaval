//
//  AffiliateSearchOfferViewController.swift
//  Cubber
//
//  Created by dnk on 13/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliateSearchOfferViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource , AppNavigationControllerDelegate , VKPagerViewDelegate {

    
    let TAG_PLUS = 100
    
    //MARK: PROPERTIES
    @IBOutlet var collectionViewPartnerCategoryList: UICollectionView!
    @IBOutlet var txtSearchPartner: UITextField!
    @IBOutlet var viewShoppingOffers: UIView!
    @IBOutlet var viewShoppingProducts: UIView!
    @IBOutlet var tableViewOffers: UITableView!
    @IBOutlet var tableViewProducts: UITableView!
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var lblOfferNotFound: UILabel!
    @IBOutlet var lblNoProductsFound: UILabel!

    
    //MARK: VAIRIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 1
    
    fileprivate var pageSizeProduct: Int = 0
    fileprivate var totalPagesProduct: Int = 0
    fileprivate var totalRecordsProduct: Int = 0
    fileprivate var currentPageProduct: Int = 1

    
    fileprivate var pageSizeOffer: Int = 0
    fileprivate var totalPagesOffer: Int = 0
    fileprivate var totalRecordsOffer: Int = 0
    fileprivate var currentPageOffer: Int = 1
    fileprivate var selectedMenu:Int = 0
    fileprivate var arrList = [typeAliasDictionary]()
    
    internal var arrAffiliateCategoryList = [typeAliasDictionary]()
    fileprivate var arrOfferList:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var arrProductList = [typeAliasDictionary]()
    fileprivate var selectedTypeIDOffer:String = "0"
    fileprivate var selectedTypeIDProduct:String = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewPartnerCategoryList.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL)

        self.tableViewOffers.rowHeight = UITableViewAutomaticDimension
        self.tableViewOffers.estimatedRowHeight = HEIGHT_AFFILIATE_OFFER_LIST_CELL
        self.tableViewOffers.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewOffers.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL)
        self.tableViewOffers.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableViewProducts.rowHeight = UITableViewAutomaticDimension
        self.tableViewProducts.estimatedRowHeight = HEIGHT_AFFILIATE_PRODUCT_LIST_CELL
        self.tableViewProducts.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewProducts.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_LIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_LIST_CELL)
        self.tableViewProducts.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableViewProducts.separatorColor = UIColor.lightGray
        
        if self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffilateNewCategory_List){
            self.callAffiliateNew_CategoryList()
        }
        else{
            let dict = DataModel.getAffilateCategoryListResponse()
            self.arrAffiliateCategoryList = dict[RES_affiliateTypeList] as! [typeAliasDictionary]
            self.pageSize = Int(dict[RES_perPage] as! Int)
            self.totalPages = Int(dict[RES_totalPages] as! String)!
            self.totalRecords = Int(dict[RES_totalItems] as! String)!
            collectionViewPartnerCategoryList.reloadData()
            self.callAffiliateSearchOffer()
            self.createPaginationView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_AFFILIATE_SEARCHOFFER)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.SetScreenName(name: F_AFFILIATE_SEARCHOFFER, stclass: F_AFFILIATE_SEARCHOFFER)
    }
    
    //MARK: APP NAVIGATION DELEGATE
    
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Search Offer")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func createPaginationView() {

        self.arrList = [[RES_id :"1" as AnyObject,RES_value:"OFFERS" as AnyObject] , [RES_id :"2" as AnyObject,RES_value:"PRODUCTS" as AnyObject]]
        
        self.view.layoutIfNeeded()
        self._VKPagerView.backColor = COLOUR_AFFILIATE_GREEN
        self._VKPagerView.selectedBottomColor = UIColor.white
        self._VKPagerView.setPagerViewData(self.arrList, keyName: RES_value, font: .systemFont(ofSize: 13), widthView: UIScreen.main.bounds.width)
        // self._VKPagerView.setPagerViewData(self.arrList, keyName: RES_value, font: .systemFont(ofSize: 13), widthView: UIScreen.main.bounds.width, backColor: RGBCOLOR(235, g: 235, b: 241), selectedBottomColor: COLOUR_ORANGE)
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
            
           if categoryID == VAL_SHOPPING_OFFERS { viewShoppingOffers.frame = frame; setLayout(viewShoppingOffers) }
            else if categoryID == VAL_SHOPPING_PRODUCT { viewShoppingProducts.frame = frame; setLayout(viewShoppingProducts) }
        }
        self.view.layoutIfNeeded()
        let offset = CGPoint.init(x: 0 * 68 , y: 0)
        collectionViewPartnerCategoryList.setContentOffset(offset, animated: true)
    }

    
    // MARK: CUSTOM METHODS
    
    func callAffiliateNew_CategoryList() {
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(),
                      REQ_PAGE_NO:String(self.currentPage)]
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateNewCategory_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token] as! String)
            self.arrAffiliateCategoryList += dict[RES_affiliateTypeList] as! [typeAliasDictionary]
            self.pageSize = Int(dict[RES_perPage] as! Int)
            self.totalPages = Int(dict[RES_totalPages] as! String)!
            self.totalRecords = Int(dict[RES_totalItems] as! String)!
            DataModel.setAffilateCategoryListResponse(dict: dict)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_AffilateNewCategory_List)
            self.collectionViewPartnerCategoryList.reloadData()
            self.callAffiliateSearchOffer()
            
        }, onFailure: { (code, dict) in
        }) {
             self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        }
    }
    
    func callAffiliateSearchOffer() {
        
        if self.txtSearchPartner.text?.trim() == "" {
            self.lblNoProductsFound.text = "Please enter search keyword."
            self.lblOfferNotFound.text = "Please enter search keyword."
            self.tableViewProducts.isHidden = true
            self.tableViewOffers.isHidden = true
            self.lblOfferNotFound.isHidden = false
            self.lblNoProductsFound.isHidden = false
            return
        }
        var params = typeAliasStringDictionary()
         params[REQ_HEADER] = DataModel.getAffiliateHeaderToken()
         params[REQ_search_key] = txtSearchPartner.text?.trim()
         params[REQ_AFF_CATEGORY_ID] = self.selectedMenu == 0 ? selectedTypeIDOffer:selectedTypeIDProduct
         params[REQ_PAGE_NO] = String(self.currentPageOffer)
        params[REQ_SEARCH_TYPE] = String(self.selectedMenu + 1)
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateSearchOffer, methodType: .POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            if dict[RES_offers] != nil {
                self.arrOfferList += dict[RES_offers] as! [typeAliasDictionary]
                self.pageSizeOffer = Int(dict[RES_perPage] as! String)!
                self.totalPagesOffer = Int(dict[RES_totalPages] as! String)!
                self.totalRecordsOffer = Int(dict[RES_totalItems] as! String)!
                self.tableViewOffers.reloadData()
                self.lblOfferNotFound.isHidden = true
                self.tableViewOffers.isHidden = false
            }
            else if dict[RES_products] != nil {
            self.arrProductList += dict[RES_products] as! [typeAliasDictionary]
            self.pageSizeOffer = Int(dict[RES_perPage] as! String)!
            self.totalPagesOffer = Int(dict[RES_totalPages] as! String)!
            self.totalRecordsOffer = Int(dict[RES_totalItems] as! String)!
            self.tableViewProducts.reloadData()
                self.lblNoProductsFound.isHidden = true
                self.tableViewProducts.isHidden = false
            }
            
        }, onFailure: { (code, dict) in
            if self.selectedMenu == 0 {
                self.lblOfferNotFound.text = dict[RES_message] as! String?
                self.lblOfferNotFound.isHidden = false
                self.tableViewOffers.isHidden = true
            }
            else if self.selectedMenu == 1 {
                self.lblNoProductsFound.text = dict[RES_message] as! String?
                self.lblNoProductsFound.isHidden = false
                self.tableViewProducts.isHidden = true
            }
            
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(tableViewProducts){return arrProductList.count}
        return arrOfferList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if tableView.isEqual(tableViewProducts) {
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
                  self.callAffiliateSearchOffer()
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }

        else{
            let cell:AffiliateOfferListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL) as! AffiliateOfferListCell
            let dict:typeAliasDictionary = arrOfferList[indexPath.row]
            
            
            cell.imageViewLogo.sd_setImage(with: (dict[RES_offerBanner] as! String).convertToUrl(), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, catchType, url) in
                if image == nil { cell.imageViewLogo.image = UIImage(named: "logo")}
                else { cell.imageViewLogo.image = image!
                    // cell.constraintImageViewHeight.constant =  (UIScreen.main.bounds.width - 30)/1.8
                }
            })
            
            cell.lblCouponCode.text = dict[RES_offerCoupon] as? String
            cell.lblCouponValid.text = "This Offer is valid till \(dict[RES_offerExpireDate] as! String)"
            cell.lblRewards.text = dict[RES_offerCommission] as? String
            cell.lblDiscount.text = dict[RES_offerTitle] as? String
            cell.lblPartnerName.text = "@\(dict[RES_offerPartner] as! String) , \(dict[RES_offerDiscount] as! String) "
            if dict[RES_couponFlag] as! Int == 1 { cell.btnCouponCode.isEnabled = true }
            else {cell.btnCouponCode.isEnabled = false}
            
            if indexPath.row == self.arrOfferList.count - 1 {
                let page: Int = self.currentPageOffer + 1
                if page <= self.totalPages { currentPageOffer = page
                    self.callAffiliateSearchOffer()
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedMenu == 0{
            let dictOffer:typeAliasDictionary = arrOfferList[indexPath.row]
            let offerDetailVC = affiliateOfferDetailViewController(nibName: "affiliateOfferDetailViewController", bundle: nil)
            offerDetailVC.offerID = dictOffer[RES_offerId] as! String
            self.navigationController?.pushViewController(offerDetailVC, animated: true)
        }
        else{
            let productDetailVC = AffiliateProductDetailViewController(nibName: "AffiliateProductDetailViewController", bundle: nil)
            productDetailVC.stProductID = arrProductList[indexPath.row][RES_productId] as! String
            productDetailVC.stProductTitle = arrProductList[indexPath.row][RES_productTitle] as! String
            self.navigationController?.pushViewController(productDetailVC, animated: true)

        }
        
    }
    
    //MARK: COLLECTIONVIEW DATA SOURCE

    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAffiliateCategoryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
           let cell:AffiliateCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL, for: indexPath) as! AffiliateCategoryCell
            
            let dictCategory:typeAliasDictionary = arrAffiliateCategoryList[indexPath.item]
            
            cell.imageViewIcon.sd_setImage(with: (dictCategory[RES_partnerTypeImage] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
                if image != nil {
                    cell.imageViewIcon.image = image
                }
            })
        cell.contentView.layer.cornerRadius = 0
        let selectedTypeID = self.selectedMenu == 0 ? selectedTypeIDOffer : selectedTypeIDProduct
        if selectedTypeID == dictCategory[RES_partnerTypeId] as! String {
            cell.contentView.backgroundColor = .white
            cell.viewLblBG.backgroundColor = RGBCOLOR(29, g: 86, b: 47)
             cell.lblTitle.backgroundColor = .white
            cell.lblTitle.textColor = COLOUR_ORANGE
        }
        else{
            cell.contentView.backgroundColor = .clear
            cell.viewLblBG.backgroundColor = .clear
            cell.lblTitle.backgroundColor = .clear
            cell.lblTitle.textColor = COLOUR_AFFILIATE_GREEN }
        cell.lblTitle.text = dictCategory[RES_partnerTypeName] as? String
        
        if indexPath.row == self.arrAffiliateCategoryList.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages { currentPage = page
                self.callAffiliateNew_CategoryList()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HEIGH_AFFILIATE_CATEGORY_LIST_CELL , height: HEIGH_AFFILIATE_CATEGORY_LIST_CELL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dictCat:typeAliasDictionary = arrAffiliateCategoryList[indexPath.item]
        if selectedMenu == 0 {
            selectedTypeIDOffer = dictCat[RES_partnerTypeId] as! String
        }
        else{
            selectedTypeIDProduct = dictCat[RES_partnerTypeId] as! String
        }
        self.collectionViewPartnerCategoryList.reloadData()
       // self.txtSearchPartner.text = ""
        self.arrOfferList = [typeAliasDictionary]()
        self.arrProductList = [typeAliasDictionary]()
        self.tableViewOffers.reloadData()
        self.tableViewProducts.reloadData()
        self.callAffiliateSearchOffer()
    }

    //MARK: TEXTFIELD DELEGATE
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearchPartner.resignFirstResponder()
        if selectedMenu == 0 {
            self.arrOfferList = [typeAliasDictionary]()
            self.tableViewOffers.reloadData()
        }
        else{
            self.arrProductList = [typeAliasDictionary]()
            self.tableViewProducts.reloadData()
        }
        self.callAffiliateSearchOffer()
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //self.txtSearchPartner.resignFirstResponder()
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        
        self.collectionViewPartnerCategoryList.reloadData()
        self.selectedMenu = selectedMenu
        if selectedMenu == 0  {
        }
        else if selectedMenu == 1 {
        }
        if selectedMenu == 0 /*&& self.arrOfferList.isEmpty */{
            self.arrOfferList.removeAll()
            self.tableViewOffers.reloadData()
            self.callAffiliateSearchOffer()
        }
        else if selectedMenu == 1 /*&& self.arrProductList.isEmpty*/ {
            self.arrProductList.removeAll()
            self.tableViewProducts.reloadData()
            self.callAffiliateSearchOffer()
        }
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
        
    }
}
