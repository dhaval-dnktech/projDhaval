//
//  AffiliateShopViewController.swift
//  Cubber
//
//  Created by dnk on 08/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliateShopViewController: UIViewController , AppNavigationControllerDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UIScrollViewDelegate , UIGestureRecognizerDelegate , VKPopoverDelegate , UITableViewDelegate , UITableViewDataSource , LGHorizontalDelegate  {

    let CATEGORY_CELL_WIDTH:CGFloat = UIScreen.main.bounds.width/2 - 20
    
    //MARK: PROPERTIES
    
    @IBOutlet var constraintCollectionViewPartnerListHeight: NSLayoutConstraint!
    @IBOutlet var viewLblNotPriomeMember: UIView!
    @IBOutlet var collectionViewCollection: [UICollectionView]!
    
    @IBOutlet var collectionViewProduct: UICollectionView!
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var viewRightNav: UIView!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var tableViewOffers: UITableView!
    
    @IBOutlet var collectionViewLatestOffers: UICollectionView!
    @IBOutlet var collectionViewPartnerList: UICollectionView!
    @IBOutlet var collectionViewPartnerCategoryList: UICollectionView!
    @IBOutlet var btnViewAllOffers: UIButton!
    @IBOutlet var btnViewAllPartners: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var gestureLeft: UISwipeGestureRecognizer!
    @IBOutlet var gestureRight: UISwipeGestureRecognizer!
    @IBOutlet var viewNotPrimeMember: UIView!
    @IBOutlet var constraintHeightTableviewOffers: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKSideMenu = VKSideMenu()
    fileprivate var arrPartnerListMain = [typeAliasDictionary]()
    fileprivate var arrPartnerList = [typeAliasDictionary]()
    fileprivate var arrAffiliateCategoryList = [typeAliasDictionary]()
    fileprivate var arrLatestOfferList = [typeAliasDictionary]()
    fileprivate var arrOffer = [typeAliasDictionary]()
    fileprivate var arrProduct = [typeAliasDictionary]()
    fileprivate var currentItem: Int = 0;
    fileprivate var lastContentOffset = CGPoint.zero
    fileprivate var partnerListCount:Int = 0;
    fileprivate var _VKPopOver:VKPopover = VKPopover()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 1
    fileprivate var collectionViewFlowLayout:LGHorizontalLinearFlowLayout!
    fileprivate var previousPage:Int = 0
    fileprivate var lastOffset:CGPoint = CGPoint.zero
    fileprivate var lastIndex:IndexPath = IndexPath.init(item: 0, section: 0)
    fileprivate var scrollViewDirection:UIAccessibilityScrollDirection =  UIAccessibilityScrollDirection.down
    fileprivate var isRight:Bool = false
    fileprivate var scaleFactor:CGFloat = 1.80
    private var contentOffset: CGFloat {
        return self.collectionViewPartnerList.contentOffset.x + self.collectionViewPartnerList.contentInset.left
    }
    
    @IBOutlet var lblPrimeAlertView_Discription: UILabel!
    //MARK: DEFAULT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        constraintCollectionViewPartnerListHeight.constant =  UIScreen.main.bounds.width/2
        btnViewAllOffers.setViewBorder(.clear, borderWidth: 0, isShadow: false, cornerRadius: btnViewAllOffers.bounds.height/2, backColor: btnViewAllOffers.backgroundColor!)
        btnViewAllPartners.setViewBorder(.clear, borderWidth: 0, isShadow: false, cornerRadius: btnViewAllPartners.bounds.height/2, backColor: btnViewAllOffers.backgroundColor!)
        self.viewBG.alpha = 0
       
        self.RegisterCell()
        if obj_AppDelegate.isShowNotPrimeMemberAlert && DataModel.getUserInfo()[RES_isReferrelActive] as! String == "0"
        {
            viewLblNotPriomeMember.isHidden = false
        }
        
        if self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffilateNewCategory_List){
            self.callAffiliateNew_CategoryList()
        }
        else{
            let dict = DataModel.getAffilateCategoryListResponse()
            self.arrAffiliateCategoryList = dict[RES_affiliateTypeList] as! [typeAliasDictionary]
            self.pageSize = Int(dict[RES_perPage] as! Int)
            self.totalPages = Int(dict[RES_totalPages] as! String)!
            self.totalRecords = Int(dict[RES_totalItems] as! String)!
            //self.callAffiliate_TopPartnerList()
            self.getPartnerListData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_AFFILIATE_HOME)
    }
    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_MODULE_AFFILIATE, stclass: F_AFFILIATE_HOME)
    
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setStatusBarBackgroundColor(color: UIColor.white)
    }
    
    //MARK: APPNAVIGATION
    
    fileprivate func setNavigationBar() {
        
        self.setStatusBarBackgroundColor(color: UIColor.clear)
        obj_AppDelegate.navigationController.setCustomTitle("Shop Now")
        obj_AppDelegate.navigationController.setSideMenuButton()
        obj_AppDelegate.navigationController.setRightView(self, view: viewRightNav, totalButtons: 2)
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    func appNavigationController_SideMenuAction() {
        _VKSideMenu = VKSideMenu()
        self.navigationController?.view.addSubview(self._VKSideMenu)
    }

    //MARK: CUSTOM METHODS
    
    func getPartnerListData() {
        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffiliateTopPartner_list) {
            DataModel.setAffiliatePartnerListResponse(dict: typeAliasDictionary())
            //self.currentPagePartners = 1
            self.callAffiliate_TopPartnerList()
        }
        else {
            
            let dictAffiliatePartner = DataModel.getAffiliatePartnerListResponse()
            if dictAffiliatePartner[String(-1)] != nil {
                let dict:typeAliasDictionary = dictAffiliatePartner[String(-1)] as! typeAliasDictionary
                DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
                //self.currentPagePartners = 1
                self.arrPartnerListMain = dict[RES_partners] as! [typeAliasDictionary]
                for _ in 0..<150 {
                    self.arrPartnerList.append(contentsOf: self.arrPartnerListMain)
                }
                self.partnerListCount = self.arrPartnerList .count + 0
                self.pageControl.numberOfPages = self.arrPartnerListMain.count
                self.lblPrimeAlertView_Discription.text = dict[RES_primeMemberNote]! as? String
                self.collectionViewPartnerList.reloadData()
                self.callAffiliate_LatestOfferList()
            }
            else {
               // self.currentPagePartners = 1
                self.callAffiliate_TopPartnerList()
            }
        }
   
    }
    
    
    @IBAction func btnSearchAction() {
        
        let affiliateSearchOfferVC = AffiliateSearchOfferViewController(nibName: "AffiliateSearchOfferViewController", bundle: nil)
        affiliateSearchOfferVC.arrAffiliateCategoryList = self.arrAffiliateCategoryList
        self.navigationController?.pushViewController(affiliateSearchOfferVC, animated: true)
    }
   
    @IBAction func btnShopOrderAction() {
        let MyOrderVC = MyOrderViewController(nibName: "MyOrderViewController", bundle: nil)
        self.navigationController?.pushViewController(MyOrderVC, animated: true)
    }
    
    @IBAction func btnNotificationAction() {
      /*  let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        self.navigationController?.pushViewController(notificationVC, animated: true) */
    }
    
    @IBAction func btnAllPartnersAction() {
      self.showAllPartners(selCatID: "0")
    }
    @IBAction func btnAllOffersAction() {
        
        let affiliatePartnerVC:AffiliatePartnersViewController = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
        affiliatePartnerVC.selctedTypeId = arrAffiliateCategoryList.first?[RES_partnerTypeId] as! String
        affiliatePartnerVC.isOffer = true
        affiliatePartnerVC.selectedIndex = 1
        affiliatePartnerVC.arrAffiliateCategoryList = self.arrAffiliateCategoryList
        self.navigationController?.pushViewController(affiliatePartnerVC, animated: true)
    }

    @IBAction func btnViewAllAction() {
        let affiliatePartnerVC:AffiliatePartnersViewController = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
        affiliatePartnerVC.selctedTypeId = arrAffiliateCategoryList.first?[RES_partnerTypeId] as! String
        affiliatePartnerVC.isOffer = false
        affiliatePartnerVC.selectedIndex = 2
        affiliatePartnerVC.arrAffiliateCategoryList = self.arrAffiliateCategoryList
        self.navigationController?.pushViewController(affiliatePartnerVC, animated: true)
    }
    
    //MARK: REGISTER COLLECTION VIEW CELL
    
    func RegisterCell() {
        
        collectionViewPartnerList.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PARTNER_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PARTNER_CELL)
        collectionViewPartnerCategoryList.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL)
        collectionViewProduct.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_CELL)
        collectionViewFlowLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: collectionViewPartnerList, itemSize: CGSize.init(width: CATEGORY_CELL_WIDTH, height: CATEGORY_CELL_WIDTH), minimumLineSpacing: 0)
        collectionViewFlowLayout.delegate = self
        tableViewOffers.rowHeight =  HEIGHT_AFFILIATE_OFFER_LIST_CELL
        tableViewOffers.tableFooterView = UIView(frame: CGRect.zero)
        
        tableViewOffers.register(UINib.init(nibName: CELL_IDENTIFIER_LATEST_OFFER_CELL, bundle: nil) , forCellReuseIdentifier: CELL_IDENTIFIER_LATEST_OFFER_CELL)
    }
    
    //MARK: CUSTOME METHODS

    @IBAction func btnNotPrimeAction() {
        
        _VKPopOver = VKPopover.init(self.viewNotPrimeMember , animation: POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE, animationDuration: 0.3, isBGTransparent: false, borderColor: .clear, borderWidth: 0, borderCorner: 5, isOutSideClickedHidden: true)
        _VKPopOver.delegate = self
        self.navigationController?.view.addSubview(_VKPopOver)
    }

    @IBAction func btnNotPrimeMemberOkAction() {
        obj_AppDelegate.isShowNotPrimeMemberAlert = false
        _VKPopOver.closeVKPopoverAction()
        viewLblNotPriomeMember.isHidden = true
         obj_AppDelegate.onVKMenuAction(.HOW_TO_EARN, categoryID: 12)  
    }
    
    func reloadCollectionViews(){
        for view in collectionViewCollection{view.reloadData()}
        //self.partnerListSwipeGestureAction(self.gestureLeft)
        self.viewBG.alpha = 1
        self.collectionViewPartnerList.scrollToItem(at: IndexPath.init(item: self.arrPartnerList.count/2, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        self.collectionViewPartnerList.contentOffset =  self.collectionViewFlowLayout.targetContentOffset(forProposedContentOffset: self.collectionViewPartnerList.contentOffset, withScrollingVelocity: CGPoint.zero)
        previousPage = pageControl.currentPage - 1
    }
    
    func callAffiliate_TopPartnerList() {
    
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken()]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateTopPartner_list, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token] as! String)
            self.arrPartnerListMain = dict[RES_partners] as! [typeAliasDictionary]
            for _ in 0..<150 {
                self.arrPartnerList.append(contentsOf: self.arrPartnerListMain)
            }
            self.partnerListCount = self.arrPartnerList.count + 0
            self.pageControl.numberOfPages = self.arrPartnerListMain.count
            var dictPartners:typeAliasDictionary = DataModel.getAffiliatePartnerListResponse()
            dictPartners[String(-1)] = DataModel.removeNullFromDictionary(dictionary: dict) as AnyObject?
            DataModel.setAffiliatePartnerListResponse(dict: dictPartners)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_AffiliateTopPartner_list)
            self.lblPrimeAlertView_Discription.text = dict[RES_primeMemberNote] as? String
             self.callAffiliate_LatestOfferList()

        
        }, onFailure: { (code, dict) in
        }) {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .INTERNET_WARNING)
            _KDAlertView.didClick(completion: { (isClicked) in
                self.callAffiliate_TopPartnerList()
            })
        }
    }
    
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
            self.getPartnerListData()
       
        }, onFailure: { (code, dict) in
            
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .INTERNET_WARNING)
            _KDAlertView.didClick(completion: { (isClicked) in
                self.callAffiliateNew_CategoryList()
            })
        }
    }
    
    func callAffiliate_LatestOfferList() {
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken()]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateLatestOffer_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            self.arrLatestOfferList = [typeAliasDictionary]()
            self.arrLatestOfferList.append((dict[RES_latestoffers] as! [typeAliasDictionary]).first!)
            self.arrProduct = dict[RES_latestProducts] as! [typeAliasDictionary]
            DataModel.setAffiliateHeaderToken(dict[RES_token] as! String)
            self.reloadCollectionViews()
            self.tableViewOffers.reloadData()
            self.collectionViewProduct.reloadData()
            self.constraintHeightTableviewOffers.constant = self.tableViewOffers.rowHeight *  CGFloat(self.arrLatestOfferList.count)
        }, onFailure: { (code, dict) in
            
        }) {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)
        }
    }
    
    func showAllPartners(selCatID:String) {
        let affiliatePartnerVC:AffiliatePartnersViewController = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
        affiliatePartnerVC.arrAffiliateCategoryList = self.arrAffiliateCategoryList
        affiliatePartnerVC.selctedTypeId = selCatID
        affiliatePartnerVC.selectedIndex = 0
        self.navigationController?.pushViewController(affiliatePartnerVC, animated: true)
    }
    
    //MARK: TABLEVIEW DATA SOURCE 
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrLatestOfferList.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LatestOfferCollectionCell = tableViewOffers.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_LATEST_OFFER_CELL) as! LatestOfferCollectionCell
        cell.collectionViewLatestOffers.tag = indexPath.row
        cell.collectionViewLatestOffers.delegate = self
        cell.collectionViewLatestOffers.dataSource = self
        cell.collectionViewLatestOffers.reloadData()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_AFFILIATE_OFFER_LIST_CELL
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
        
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(2.0)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y:  cell.frame.size.height - separatorHeight, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = tableViewOffers.separatorColor
        if indexPath.row != arrLatestOfferList.count-1 { cell.addSubview(additionalSeparator)}

    }
    
    //MARK: COLLECTIONVIEW DATA SOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == collectionViewPartnerList {count =  self.arrPartnerList.count}
        else if collectionView == collectionViewPartnerCategoryList { count =  arrAffiliateCategoryList.count }
        else if collectionView == collectionViewProduct { count =  arrProduct.count }
        else {
            let dictOffer = arrLatestOfferList[collectionView.tag]
            arrOffer = dictOffer[RES_offersArray] as! [typeAliasDictionary]
            count = arrOffer.count }
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewPartnerList {
            
            let cell:AffiliatePartnerViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PARTNER_CELL, for: indexPath) as! AffiliatePartnerViewCell
            let dict:typeAliasDictionary = arrPartnerList[indexPath.item]
            cell.contentView.isHidden = false ;
            cell.lblRewards.text = (dict[RES_partnerCommission] as? String)?.uppercased()
            cell.activityIndicator.startAnimating()
            cell.imageViewLogo2.sd_setImage(with: (dict[RES_partnerLogo2] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
                cell.activityIndicator.stopAnimating()
                if image != nil {
                    cell.imageViewLogo2.image = image
                }
            })
           cell.contentView.setViewBorder(.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: .clear)
            
            return cell
        }
        
        else if collectionView == collectionViewPartnerCategoryList {
            
            let cell:AffiliateCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL, for: indexPath) as! AffiliateCategoryCell
            
            let dictCategory:typeAliasDictionary = arrAffiliateCategoryList[indexPath.item]
            
            cell.imageViewIcon.sd_setImage(with: (dictCategory[RES_partnerTypeImage] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
                if image != nil {
                 cell.imageViewIcon.image = image
                }
            })
            cell.lblTitle.backgroundColor = .clear
            cell.lblTitle.text = dictCategory[RES_partnerTypeName] as? String
            cell.contentView.layer.cornerRadius = 0
            
            if indexPath.row == self.arrAffiliateCategoryList.count - 1 {
                let page: Int = self.currentPage + 1
                if page <= self.totalPages { currentPage = page
                    self.callAffiliateNew_CategoryList()
                }
            }
            
            return cell
        }
        else if collectionView == collectionViewProduct {
            
            let cell:AffiliateProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_CELL, for: indexPath) as! AffiliateProductCell
            
            let dictProduct:typeAliasDictionary = arrProduct[indexPath.item]
            
            cell.activityIndicator.startAnimating()
            cell.imageViewProduct.sd_setImage(with: (dictProduct[RES_productImage] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
                cell.activityIndicator.stopAnimating()
                if image != nil {
                    cell.imageViewProduct.image = image
                }
            })
            cell.imageViewPartner.sd_setImage(with: (dictProduct[RES_partnerLogo2] as! String).convertToUrl(), completed: { (image, error, cacheType, url) in
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
            cell.lblProductTitle.text = dictProduct[RES_productTitle] as? String

            cell.lblCommission.text = dictProduct[RES_cubberCommission] as? String
            
            return cell
        }

        else  {
            
            let cell:AffiliaeLatestOfferCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_LATEST_OFFER_CELL, for: indexPath) as! AffiliaeLatestOfferCell
            
            let dictOfferCollection = arrLatestOfferList[collectionView.tag]
            arrOffer = dictOfferCollection[RES_offersArray] as! [typeAliasDictionary]
            let dictOffer = arrOffer[indexPath.item]
            cell.imageViewOfferBanner.isHidden = false
            cell.imageViewOfferBanner.sd_setImage(with: (dictOffer[RES_offerBanner] as! String).convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                
                if image == nil {  }
                else { cell.imageViewOfferBanner.image = image! ;
                    self.scaleFactor = (image?.size.width)!/(image?.size.height)!
                }
                cell.activityIndicator.stopAnimating()
            }
            cell.lblCommision.text = dictOffer[RES_offerCommission1] as? String
            return cell
        }
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
            
        case collectionViewPartnerList:
            return CGSize(width: CATEGORY_CELL_WIDTH , height: CATEGORY_CELL_WIDTH)
        case collectionViewPartnerCategoryList:
           return CGSize(width: HEIGH_AFFILIATE_CATEGORY_LIST_CELL , height: HEIGH_AFFILIATE_CATEGORY_LIST_CELL)
        case collectionViewProduct:
            return CGSize(width: (HEIGH_AFFILIATE_PRODUCT_CELL) , height: HEIGH_AFFILIATE_PRODUCT_CELL)
        default:
            break
        }
        
        let width = (scaleFactor * 120)+6
        return   CGSize(width: width , height: HEIGHT_AFFILIATE_LATEST_OFFER_CELL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewPartnerCategoryList {return 0}
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewPartnerCategoryList {
            let dictCat:typeAliasDictionary = arrAffiliateCategoryList[indexPath.item]
            self.showAllPartners(selCatID: dictCat[RES_partnerTypeId] as! String)
        }
        else if collectionView == collectionViewPartnerList{
            
            let partnerDetailVC = AffiliatePartnerDetailViewController(nibName: "AffiliatePartnerDetailViewController", bundle: nil)
            partnerDetailVC.partnerID = arrPartnerList[indexPath.item][RES_partnerId] as! String
            partnerDetailVC.partnerName = arrPartnerList[indexPath.item][RES_partnerName] as! String
            self.navigationController?.pushViewController(partnerDetailVC, animated: true)

        
        }
        else if collectionView == collectionViewProduct{
            
            let productDetailVC = AffiliateProductDetailViewController(nibName: "AffiliateProductDetailViewController", bundle: nil)
            productDetailVC.stProductID = arrProduct[indexPath.item][RES_productId] as! String
            productDetailVC.stProductTitle = arrProduct[indexPath.item][RES_productTitle] as! String
            self.navigationController?.pushViewController(productDetailVC, animated: true)
            
            
        }
        else{
             let dictOfferCollection = arrLatestOfferList[collectionView.tag]
            arrOffer = dictOfferCollection[RES_offersArray] as! [typeAliasDictionary]
            let dictOffer:typeAliasDictionary = arrOffer[indexPath.row]
            let offerDetailVC = affiliateOfferDetailViewController(nibName: "affiliateOfferDetailViewController", bundle: nil)
            offerDetailVC.offerID = dictOffer[RES_offerId] as! String
            self.navigationController?.pushViewController(offerDetailVC, animated: true)
        }
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionViewPartnerList {
            if lastOffset.x > scrollView.contentOffset.x { isRight = true }
            else{isRight = false}
            lastOffset = scrollView.contentOffset
            let point = CGPoint(x: self.collectionViewPartnerList.center.x + scrollView.contentOffset.x,
                                y: self.collectionViewPartnerList.center.y + scrollView.contentOffset.y);
            let indexPath = self.collectionViewPartnerList.indexPathForItem(at: point)
            
            if indexPath != nil {
                if indexPath?.row == arrPartnerList.count - 3 {
                    arrPartnerList.append(contentsOf: arrPartnerListMain)
                    self.collectionViewPartnerList.reloadData()
                }
                else if indexPath?.row == 2 && isRight {
                    
                    arrPartnerList.insert(contentsOf: arrPartnerListMain, at: 0)
                    self.collectionViewPartnerList.reloadData()
                    self.collectionViewPartnerList.scrollToItem(at: IndexPath.init(item: (indexPath?.row)! + arrPartnerListMain.count  , section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                }
                lastIndex = indexPath!
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionViewPartnerList {
            previousPage = pageControl.currentPage
            let pageWidth = CATEGORY_CELL_WIDTH
            let currentPage = Int(self.contentOffset/pageWidth)
            pageControl.currentPage = currentPage < self.arrPartnerListMain.count ? currentPage : currentPage % self.arrPartnerListMain.count
            print("End")
        }
    }
    
    
    func vkPopoverClose() {}
   
    func onLGHorizontalScrolling(_ contentOffset: CGPoint) {
    }
}
