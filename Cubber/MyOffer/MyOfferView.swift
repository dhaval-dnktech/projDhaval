//
//  MyOfferView.swift
//  Cubber
//
//  Created by dnk on 06/06/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class MyOfferView: UIView,UITableViewDelegate, UITableViewDataSource,MyOfferCellDelegate , UIGestureRecognizerDelegate , MyOfferWithImageCellDelegate {

    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var arrCoupon = [typeAliasDictionary]()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var TAG:Int = 100
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var lblNoDataFound: UILabel!
    @IBOutlet var tableViewOffer: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        self.layoutIfNeeded()
        
        //self.loadCoupon()
        
        self.tableViewOffer.rowHeight = UITableViewAutomaticDimension
        self.tableViewOffer.estimatedRowHeight = HEIGHT_OFFER_LIST_CELL
        self.tableViewOffer.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewOffer.register(UINib.init(nibName: CELL_IDENTIFIER_OFFER_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_OFFER_CELL)
        self.tableViewOffer.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableViewOffer.register(UINib.init(nibName: CELL_IDENTIFIER_OFFER_IMAGE_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_OFFER_IMAGE_CELL)
        
    }
    
    //MARK: CUSTOME METHODS
    
    internal func loadData(tag:Int) {
        self.TAG = tag
        self.loadCoupon()
    }
    
    fileprivate func loadCoupon() {
        
        let dictCpn =  self.TAG == 101 ? DataModel.getUpComingCoupons() :DataModel.getCoupons()
        if dictCpn.isEmpty {
            self.TAG == 101 ? DataModel.setUpComingCoupons(typeAliasDictionary()) :DataModel.setCoupons(typeAliasDictionary())
            //DataModel.setCoupons(typeAliasDictionary())
            self.arrCoupon = [typeAliasDictionary]()
            self.tableViewOffer.reloadData()
            self.currentPage = 1; self.callCouponListService();
        }
        else{ self.setCouponData() }
    }
    
    fileprivate func callCouponListService() {
        
        obj_AppDelegate.isCouponServiceCall = true
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_PAGE_NO:"\(self.currentPage)"]

        //FOR UPCOMING OFFERS PASS THIS PARAMETER
         if self.TAG == 101 {params[REQ_IS_COMING_SOON] = "1" }
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_CouponList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
            
            if self.currentPage > 1 {
                self.arrCoupon += arrData

            }
            else {
                self.arrCoupon = arrData
            }
            self.pageSize = Int(dict[RES_par_page] as! String)!
            self.totalPages = Int(dict[RES_total_pages] as! String)!
            self.totalRecords = Int(dict[RES_total_items] as! String)!
            self.tableViewOffer.reloadData()
            self.tableViewOffer.isHidden = false
            self.lblNoDataFound.isHidden = true
            
            if self.currentPage == 1 {
                let dictCoupons: typeAliasDictionary = [RES_data:self.arrCoupon as AnyObject,
                                                        REQ_PAGE_NO:self.currentPage as AnyObject,
                                                        RES_par_page:self.pageSize as AnyObject,
                                                        RES_total_pages:self.totalPages as AnyObject,
                                                        RES_total_items:self.totalRecords as AnyObject]
                
                if self.TAG == 101 { DataModel.setUpComingCoupons(dictCoupons) }
                else { DataModel.setCoupons(dictCoupons) }
                self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_CouponList)
            }
            
            //POST NOTIFICATION
            
        }, onFailure: { (code, dict) in
            self.tableViewOffer.isHidden = true
            self.lblNoDataFound.isHidden = false
            //self.delegate.CouponListView_CouponsNotAvailable(1)
        }) {   }
    }
    
    fileprivate func setCouponData() {
        
        let dictStoreCoupon = self.TAG == 101 ? DataModel.getUpComingCoupons() :DataModel.getCoupons()
        
        self.arrCoupon = dictStoreCoupon[RES_data] as! Array<typeAliasDictionary>
        //self.sortCouponData()
        self.currentPage = 1
        self.pageSize = dictStoreCoupon[RES_par_page] as! Int
        self.totalPages = dictStoreCoupon[RES_total_pages] as! Int
        self.totalRecords = dictStoreCoupon[RES_total_items] as! Int
        self.tableViewOffer.reloadData()
        self.tableViewOffer.isHidden = false
        self.lblNoDataFound.isHidden = true
        //self.delegate.CouponListView_CouponsNotAvailable(self.tag)
    }
    
    func sortCouponData() {
        
        let arr = arrCoupon
        arrCoupon = [typeAliasDictionary]()
        
        for dict in arr{
            if dict[RES_orderTypeID] as! String == String(self.tag){
                arrCoupon.insert(dict, at: 0)
            }
            else{
                arrCoupon.append(dict)
            }
        }
    }
    
     //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoupon.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict: typeAliasDictionary = self.arrCoupon[(indexPath as NSIndexPath).row]
        
        let stBanner: String = dict[RES_bigBanner] as! String
        
        if stBanner.isEmpty || stBanner == "0" {
            
            let cell:MyOfferCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_OFFER_CELL) as! MyOfferCell
            cell.offerdelegate = self
            
            cell.btnGet.accessibilityIdentifier = String(indexPath.row)
            cell.lblTitle.text = dict[RES_couponTitle]! as! String
            
            if self.tag == 101 {
                cell.lblValidity.text = ": \(dict[RES_startDate]!)"
                cell.lblEndDate.text =  ": \(dict[RES_endDate]!)"
                cell.lblValidityTitle.text = "Start From"
                cell.lblEndDateTitle.text = "Valid Till"
            }
            else  {cell.lblValidity.text = ": \(dict[RES_endDate]!)"
                cell.lblValidityTitle.text = "Valid Till"}
            
            if dict[RES_isDisplayCoupon] as! String == "1" {
                cell.constraintsViewCouponHeight.constant = 35
                if dict[RES_couponCode] as! String == ""{cell.lblnotAvailableCode.text = "No Coupon Code is Required"
                    cell.viewBGUpcoming.isHidden = false;cell.viewBGCoupon.isHidden = true
                }
                else{ cell.viewBGUpcoming.isHidden = true;cell.viewBGCoupon.isHidden = false;cell.lblCouponCode.text = dict[RES_couponCode] as! String }
            }
            else{ cell.constraintsViewCouponHeight.constant = 0 ; cell.viewBGUpcoming.isHidden = true;cell.viewBGCoupon.isHidden = true }
            
            if (indexPath as NSIndexPath).row == self.arrCoupon.count - 1 {
                let page: Int = self.currentPage + 1
                if page <= self.totalPages {
                    currentPage = page
                    self.callCouponListService()
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.layoutIfNeeded()
            return cell
        }
        
        else {
            
            let cell:MyOfferWithImageCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_OFFER_IMAGE_CELL) as! MyOfferWithImageCell
            cell.offerdelegate = self
            
            cell.btnGet.accessibilityIdentifier = String(indexPath.row)
            cell.btnImageClick.accessibilityIdentifier = String(indexPath.row)
            cell.lblTitle.text = dict[RES_couponTitle] as! String
            
            if self.tag == 101 {
                cell.lblValidity.text = ": \(dict[RES_startDate]!)"
                cell.lblEndDate.text =  ": \(dict[RES_endDate]!)"
                cell.lblValidityTitle.text = "Start From"
                cell.lblEndDateTitle.text = "Valid Till"
            }
            else  {cell.lblValidity.text = ": \(dict[RES_endDate]!)"
                cell.lblValidityTitle.text = "Valid Till"}
            
            if dict[RES_isDisplayCoupon] as! String == "1" {
                cell.constraintsViewCouponHeight.constant = 35
                if dict[RES_couponCode] as! String == ""{cell.lblnotAvailableCode.text = "No Coupon Code is Required"
                    cell.viewBGUpcoming.isHidden = false;cell.viewBGCoupon.isHidden = true
                }
                else{ cell.viewBGUpcoming.isHidden = true;cell.viewBGCoupon.isHidden = false;cell.lblCouponCode.text = dict[RES_couponCode] as! String }
            }
            else{ cell.constraintsViewCouponHeight.constant = 0 ; cell.viewBGUpcoming.isHidden = true;cell.viewBGCoupon.isHidden = true }
            
            cell.imageViewOffer.sd_setImage(with: stBanner.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                
                if image == nil { cell.imageViewOffer.image = #imageLiteral(resourceName: "logo")
                    /*cell.constraintImageViewHeight.constant =  0*/ }
                else {
                    cell.imageViewOffer.image = image! ;
                  //  cell.constraintImageViewHeight.constant =  (UIScreen.main.bounds.width - 10)/1.80 }
                cell.activityIndicator.stopAnimating()
            }
        }
            
            if (indexPath as NSIndexPath).row == self.arrCoupon.count - 1 {
                let page: Int = self.currentPage + 1
                if page <= self.totalPages {
                    currentPage = page
                    self.callCouponListService()
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func btnmyOfferCell_GetAction(_ button:UIButton){
        
        let ind = Int(button.accessibilityIdentifier!)!
        let dictCoupon:typeAliasDictionary = arrCoupon[ind]
        
        if dictCoupon[RES_isRedirect] as! String  == "1" && dictCoupon[RES_redirectScreen] != nil && dictCoupon[RES_redirectScreen] as! String != "0" {
            
             let _REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE =  REDIRECT_SCREEN_TYPE(rawValue: dictCoupon[RES_redirectScreen] as! String)!
            
            if _REDIRECT_SCREEN_TYPE == REDIRECT_SCREEN_TYPE.SCREEN_AFFILIATE_PARTENERDETAIL {
                let shopDetailVC = AffiliatePartnerDetailViewController(nibName: "AffiliatePartnerDetailViewController", bundle: nil)
                shopDetailVC.partnerID = dictCoupon[RES_partner_id] as! String
                obj_AppDelegate.navigationController?.pushViewController(shopDetailVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_HOWTOEARN {
                let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                howToEarnVC.categoryID = dictCoupon[RES_earnCategoryId] as! String
                obj_AppDelegate.navigationController?.pushViewController(howToEarnVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_AFFILIATE_SHOPPING {
                obj_AppDelegate.showShopView(_selectedTab: Int(dictCoupon[RES_affiliate_type_id] as! String)!)
            }
            else{
                obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue:dictCoupon[RES_redirectScreen]as! String)! , dict:dictCoupon as typeAliasDictionary)
            }
        }
        else {
            if dictCoupon[RES_isShowDetail] as! String  == "1" {
                let notificDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
                notificDetailVC.dictNotification = dictCoupon as typeAliasDictionary
                notificDetailVC.isCoupon = true
                notificDetailVC.couponID = dictCoupon[RES_couponID] as! String
                obj_AppDelegate.navigationController?.pushViewController(notificDetailVC, animated: true)
            }
        }
    }
    
    func btnMyOfferImageCell_GetAction(_ button: UIButton) {
        self.btnmyOfferCell_GetAction(button)
    }
    
 }

