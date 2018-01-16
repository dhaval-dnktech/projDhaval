//
//  VKFooterView.swift
//  Cubber
//
//  Created by Vyas Kishan on 16/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol CouponListViewDelegate {
    func CouponListView_CouponsNotAvailable(_ tag: Int)
}

class CouponListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , CouponCellDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var collectionViewCoupon: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var delegate: CouponListViewDelegate!
   // @IBOutlet var delegate: AnyObject!
    
    //MARK: VARIABLES
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var arrCoupon = [typeAliasStringDictionary]()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var scaleFactor:CGFloat = 1.8
    fileprivate var size:CGSize = CGSize.zero
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    fileprivate func loadXIB() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
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
        
        self.collectionViewCoupon.register(UINib.init(nibName: CELL_IDENTIFIER_COUPON, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_COUPON)
        //self.loadCoupon()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setCouponData), name: NSNotification.Name(rawValue: NOTIFICATION_COUPON_SERVICE_RESPONSE), object: nil)
    }
    
    //MARK: CUSTOME METHODS
    
    internal func reloadCouponList(dictCoupon:typeAliasDictionary) {
        let arrData: Array<typeAliasStringDictionary> = dictCoupon[RES_data] as! Array<typeAliasStringDictionary>
        self.currentPage = 1
        self.arrCoupon = arrData
        self.pageSize = Int(dictCoupon[RES_par_page] as! String)!
        self.totalPages = Int(dictCoupon[RES_total_pages] as! String)!
        self.totalRecords = Int(dictCoupon[RES_total_items] as! String)!
        self.collectionViewCoupon.reloadData()
    }
    
    fileprivate func loadCoupon() {
        
       if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CouponList) && !obj_AppDelegate.isCouponServiceCall {
            DataModel.setCoupons(typeAliasDictionary())
            self.arrCoupon = [typeAliasStringDictionary]()
            self.currentPage = 1; self.callCouponListService();
        }
        else if !DataModel.getCoupons().isEmpty{
            self.setCouponData()
          NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_COUPON_SERVICE_RESPONSE), object: nil)
        }
        self.collectionViewCoupon.reloadData()
   }
    
    fileprivate func callCouponListService() {
        
       obj_AppDelegate.isCouponServiceCall = true
        self.activityIndicator.startAnimating()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_PAGE_NO:"\(self.currentPage)"]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_CouponList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: .init(), onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasStringDictionary> = dict[RES_data] as! Array<typeAliasStringDictionary>
            self.arrCoupon += arrData
            self.pageSize = Int(dict[RES_par_page] as! String)!
            self.totalPages = Int(dict[RES_total_pages] as! String)!
            self.totalRecords = Int(dict[RES_total_items] as! String)!
            self.collectionViewCoupon.reloadData()
            
            let dictCoupons: typeAliasDictionary = [RES_data:self.arrCoupon as AnyObject,
                                                    REQ_PAGE_NO:self.currentPage as AnyObject,
                                                    RES_par_page:self.pageSize as AnyObject,
                                                    RES_total_pages:self.totalPages as AnyObject,
                                                    RES_total_items:self.totalRecords as AnyObject]
            DataModel.setCoupons(dictCoupons)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_CouponList)
            if self.arrCoupon.count > 0 {
             NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_COUPON_SERVICE_RESPONSE), object: nil)
            }
            else{
                 NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_COUPON_SERVICE_RESPONSE_FALSE), object: nil)
            }
            
         //POST NOTIFICATION
            self.activityIndicator.stopAnimating()
        }, onFailure: { (code, dict) in
            self.activityIndicator.stopAnimating()
             NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_COUPON_SERVICE_RESPONSE_FALSE), object: nil)
        }) {  self.activityIndicator.stopAnimating() }
    }
    
    internal func setCouponData() {
        
        let dictStoreCoupon = DataModel.getCoupons()
        self.arrCoupon = [typeAliasStringDictionary]()
        self.arrCoupon = dictStoreCoupon[RES_data] as! Array<typeAliasStringDictionary>
        self.sortCouponData()
        self.currentPage = dictStoreCoupon[REQ_PAGE_NO] as! Int
        self.pageSize = dictStoreCoupon[RES_par_page] as! Int
        self.totalPages = dictStoreCoupon[RES_total_pages] as! Int
        self.totalRecords = dictStoreCoupon[RES_total_items] as! Int
        self.collectionViewCoupon.reloadData()
    }
    
    func sortCouponData() {
        
        let arr = arrCoupon
        arrCoupon = [typeAliasStringDictionary]()

        for dict in arr{
            if dict[RES_orderTypeID] == String(self.tag){
                arrCoupon.insert(dict, at: 0)
            }
            else{
                arrCoupon.append(dict)
            }
        }
    }
    
    //MARK: UICOLLECTIONVIEW DELEGATE FLOW LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = HEIGHT_COUPON_CELL*1.8
        return CGSize(width: width , height: HEIGHT_COUPON_CELL) }
    
    //VERTICAL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return 0 }
    
    //HORIZONTAL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 10 }
    
    //MARK: UICOLLECTIONVIEW DATASOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCoupon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CouponCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_COUPON, for: indexPath)  as! CouponCell
        let dict: typeAliasStringDictionary = self.arrCoupon[(indexPath as NSIndexPath).row]
            cell.delegate = self
        cell.btnCoupon.accessibilityIdentifier = String(indexPath.row)
        let setCouponLabel = {
            cell.imageViewCoupon.isHidden = true
            cell.lblCoupon.isHidden = false
            cell.lblCoupon.text = "User coupon code : \n\(dict[RES_couponCode]!)"
        }
        
        let stBanner: String = dict[RES_smallBanner]!
        if !stBanner.isEmpty && stBanner != "0" {
            cell.imageViewCoupon.isHidden = false
            cell.lblCoupon.isHidden = true
            
            cell.imageViewCoupon.sd_setImage(with: stBanner.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                
                if image == nil { setCouponLabel() }
                else { cell.imageViewCoupon.image = image!
                    
                    self.scaleFactor = (image?.size.width)!/(image?.size.height)!
                }
                cell.activityIndicator.stopAnimating()
            }
        }
        else { setCouponLabel() }
        
        if (indexPath as NSIndexPath).row == self.arrCoupon.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages {
                currentPage = page
                self.callCouponListService()
            }
        }
        return cell
    }
    
    func CouponCell_btnCouponAction(button: UIButton) {
        
      /*  let ind = Int(button.accessibilityIdentifier!)!
        let dictCoupon:typeAliasStringDictionary = arrCoupon[ind]
        
        if dictCoupon[RES_isRedirect]!  == "1" {
            
            let _REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE =  REDIRECT_SCREEN_TYPE(rawValue: Int(dictCoupon[RES_redirectScreen]!)!)!
            
            if _REDIRECT_SCREEN_TYPE == REDIRECT_SCREEN_TYPE.SCREEN_AFFILIATE_PARTENERDETAIL {
                
                let shopDetailVC = AffiliatePartnerDetailViewController(nibName: "AffiliatePartnerDetailViewController", bundle: nil)
                shopDetailVC.partnerID = dictCoupon[RES_partner_id]!
                obj_AppDelegate.navigationController?.pushViewController(shopDetailVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_HOWTOEARN {
                let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                howToEarnVC.categoryID = dictCoupon[RES_earnCategoryId]!
                obj_AppDelegate.navigationController?.pushViewController(howToEarnVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_ORDER_SUMMARY {
                let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
                orderDetailVC.orderId = dictCoupon[RES_orderID]!
                obj_AppDelegate.navigationController?.pushViewController(orderDetailVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_GALLERY {
                let galleryVC = GallaryURLViewController(nibName: "GallaryURLViewController", bundle: nil)
                galleryVC.galleryURL  = dictCoupon[RES_link]!
                obj_AppDelegate.navigationController?.pushViewController(galleryVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_AFFILIATE_OFFERLIST {
                let afffiliateOfferVC = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
                afffiliateOfferVC.selctedTypeId  = dictCoupon[RES_affiliate_type_id]!
                afffiliateOfferVC.isOffer = true
                obj_AppDelegate.navigationController?.pushViewController(afffiliateOfferVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_AFFILIATE_OFFERDETAIL {
                let affiliateOfferDetailVC = affiliateOfferDetailViewController   (nibName: "affiliateOfferDetailViewController", bundle: nil)
                affiliateOfferDetailVC.offerID  = dictCoupon[RES_offerId]!
                obj_AppDelegate.navigationController?.pushViewController(affiliateOfferDetailVC, animated: true)
            }
            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_AFFILIATE_PARTNERLIST {
                let affiliatePartnersVC = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
                affiliatePartnersVC.selctedTypeId = dictCoupon[RES_affiliate_type_id]!
                affiliatePartnersVC.isOffer = false
                affiliatePartnersVC.navigationController?.pushViewController(affiliatePartnersVC, animated: true)
            }
            else{
                obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue:Int(dictCoupon[RES_redirectScreen]!)!)!,dict:dictCoupon as typeAliasDictionary)
            }

        }
            else {
                
                if dictCoupon[RES_isShowDetail]!  == "1" {
                    let notificDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
                    notificDetailVC.dictNotification = dictCoupon as typeAliasDictionary
                    notificDetailVC.isCoupon = true
                    notificDetailVC.couponID = dictCoupon[RES_couponID]!
                    obj_AppDelegate.navigationController?.pushViewController(notificDetailVC, animated: true)
                }
            }*/
    }
}
