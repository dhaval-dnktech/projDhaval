//
//  AffiliatePartnerDetailViewController.swift
//  Cubber
//
//  Created by dnk on 08/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.






import UIKit

class AffiliatePartnerDetailViewController: UIViewController, VKPagerViewDelegate, UITableViewDataSource, UITableViewDelegate , UIScrollViewDelegate , AppNavigationControllerDelegate {
    
    let TAG_PLUS = 100
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var arrList = [typeAliasDictionary]()
    fileprivate var arrOfferList = [typeAliasDictionary]()
    fileprivate var arrCommisionData = [typeAliasDictionary]()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 1
    internal var partnerID:String = ""
    internal var partnerName:String = ""
    fileprivate var cashBackType = ""
    var isCompleted:Bool = false
    fileprivate var dictPartnerDetail = typeAliasDictionary()
    
    //MARK: PROPERTIES
    
    @IBOutlet var lblRewardsTitle: UILabel!
    @IBOutlet var scrollViewTermsBG: UIScrollView!
    @IBOutlet var viewOffer: UIView!
    @IBOutlet var viewTerms: UIView!
    @IBOutlet var viewRewards: UIView!
    @IBOutlet var tableViewOffer: UITableView!
    @IBOutlet var tableViewRewards: UITableView!
    @IBOutlet var viewTerms_BG1: UIView!
    @IBOutlet var viewTerms_BG2: UIView!
    @IBOutlet var btnInstallApp: UIButton!
    @IBOutlet var btnShopEarn: UIButton!
    @IBOutlet var btnCollection: [UIButton]!
    @IBOutlet var viewLabelReward: UIView!
    @IBOutlet var imageViewPartner: UIImageView!
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var constraintViewPagerTopToSuper: NSLayoutConstraint!
    @IBOutlet var lblRewardsCommision: UILabel!
    @IBOutlet var lblEstimatedPayment: UILabel!
    @IBOutlet var lblTrackingSpeed: UILabel!
    @IBOutlet var lblCashbackTerms: UILabel!
    @IBOutlet var lblNoRewardsFound: UILabel!
    @IBOutlet var viewButton: UIView!
 
    var effectView = UIVisualEffectView()
    @IBOutlet var lblNoOfferFound: UILabel!
    @IBOutlet var constraintViewTermsBG2TopToSuper: NSLayoutConstraint!
    @IBOutlet var constraintViewTermsBG2TopToBG1: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewOffer.estimatedRowHeight = HEIGHT_AFFILIATE_OFFER_LIST_CELL
        self.tableViewOffer.rowHeight = UITableViewAutomaticDimension
        self.tableViewOffer.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewOffer.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL)
        self.tableViewOffer.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableViewRewards.estimatedRowHeight = HEIGHT_AFFILIATE_REWARDS_LIST_CELL
        self.tableViewRewards.rowHeight = UITableViewAutomaticDimension
        self.tableViewRewards.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewRewards.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_REWARDS_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_REWARDS_CELL)
        self.tableViewRewards.separatorStyle = UITableViewCellSeparatorStyle.none
        
        for btn:UIButton in btnCollection {
            btn.layer.cornerRadius = btn.frame.height/2
        }
        
        viewTerms_BG1.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.white)
        viewTerms_BG2.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.white)

        viewLabelReward.applyGradient(colours: [RGBCOLOR(0, g: 0, b: 0, alpha: 0.63),.clear,.clear,.clear,.clear], locations: [0.0,1.0], frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        
        effectView = UIVisualEffectView(effect: UIBlurEffect.init(style: .light))
        effectView.frame = self.imageViewPartner.frame
        effectView.alpha = 0
        self.imageViewPartner.addSubview(effectView)
        
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_AffilateNewCategory_List)
        {
        }
        self.constraintViewPagerTopToSuper.constant = viewButton.frame.maxY
        self.callAffiliateNewPartner_Detail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_MODULE_AFFILIATE, stclass: F_AFFILIATE_PARTNERDETAIL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_AFFILIATE_PARTNERDETAIL)
    }
    
    //MARK: APP NAVIGATION DELEGATE
    
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle(self.partnerName)
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: BUTTON ACTION
    
   
    @IBAction func btnShopEarnAction() {
        
        self.trackEvent(category: "\(MAIN_CATEGORY):\(F_AFFILIATE_HOME) ", action: "shop & earn", label: "\(DataModel.getUserInfo()[RES_userID] as! String)", value: nil)
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken() , REQ_PARTNER_ID:self.dictPartnerDetail[RES_partnerId] as! String , REQ_USER_ID:dictUserInfo[RES_affiliateId] as! String , REQ_DEVICE_TYPE:"2"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateClick, methodType: .POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            let dictPartenerDetail:typeAliasStringDictionary = dict[RES_partnerDetail] as! typeAliasStringDictionary
            UIApplication.shared.openURL((dictPartenerDetail[RES_redirectUrl]!).convertToUrl())
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    @IBAction func btnInstallAppAction() {
        
    }

    
    func callAffiliateOfferList(){
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(), REQ_PARTNER_ID:partnerID, REQ_PAGE_NO:"\(self.currentPage)"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateOffer_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrOfferList = dict[RES_offers] as! [typeAliasDictionary]
            self.pageSize = Int(dict[RES_perPage] as! String)!
            self.totalPages = Int(dict[RES_totalPages] as! String)!
            self.totalRecords = Int(dict[RES_totalItems] as! String)!
            self.tableViewOffer.reloadData()
            self.lblNoOfferFound.isHidden = true
        }, onFailure: { (code, dict) in
            self.lblNoOfferFound.isHidden = false
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    
    func callAffiliateNewPartner_Detail(){
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(), REQ_PARTNER_ID:partnerID]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateNewPartner_Detail, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
             DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            
            self.dictPartnerDetail = dict[RES_partnerDetail] as! typeAliasDictionary
            self.imageViewPartner.sd_setImage(with: (self.dictPartnerDetail[RES_partnerlogo] as! String).convertToUrl(), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, catchType, url) in
                if image == nil { self.imageViewPartner.image = UIImage(named: "logo")}
                else { self.imageViewPartner.image = image! }
            })
            self.partnerName = self.dictPartnerDetail[RES_partnerName] as! String
           self.setNavigationBar()
            self.lblRewardsCommision.text = self.dictPartnerDetail[RES_partnerCommission]! as? String
            self.lblCashbackTerms.attributedText = (self.dictPartnerDetail[RES_partnerDescription]! as? String)?.htmlAttributedString
            self.lblTrackingSpeed.text = "Tracking Speed :\(self.dictPartnerDetail[RES_orderSyncDays] as! String)"
            self.lblEstimatedPayment.text = "Estimated Payment :\(self.dictPartnerDetail[RES_expectedPaymentDays] as! String) Days"
            
            if self.dictPartnerDetail[RES_expectedPaymentDays] as! String == "0" {
              self.constraintViewTermsBG2TopToSuper.priority = PRIORITY_HIGH
              self.constraintViewTermsBG2TopToBG1.priority = PRIORITY_LOW
              self.viewTerms_BG1.isHidden = true
            }
            else{
                self.constraintViewTermsBG2TopToSuper.priority = PRIORITY_LOW
                self.constraintViewTermsBG2TopToBG1.priority = PRIORITY_HIGH
                self.viewTerms_BG1.isHidden = false
            }
            self.createPaginationView()
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;

        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    func callCommisionDetail() {
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(),
                      REQ_PARTNER_ID: partnerID]
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateCommission_list, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrCommisionData = dict[RES_commissionList] as! [typeAliasDictionary]
            self.tableViewRewards.reloadData()
            self.lblNoRewardsFound.isHidden = true
        }, onFailure: { (code, dict) in
            self.lblNoRewardsFound.isHidden = false
            
        }) {  self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return}
    }
    

    fileprivate func createPaginationView() {
        cashBackType = (dictPartnerDetail[RES_CashbackType] as! String).uppercased()
        lblRewardsTitle.text  = "\(cashBackType) TERMS"
        let dictRewards = [RES_id :"2" as AnyObject,RES_value: cashBackType as AnyObject]
        self.arrList = [[RES_id :"0" as AnyObject,RES_value:"OFFERS" as AnyObject] , [RES_id :"1" as AnyObject,RES_value:"TERMS" as AnyObject] ]
        
        if dictPartnerDetail[RES_isShowCommission] as! String == "1" {
            self.arrList.append(dictRewards)
        }
        self.view.layoutIfNeeded()
        self._VKPagerView.setPagerViewData(self.arrList, keyName: RES_value, font: .systemFont(ofSize: 15), widthView: UIScreen.main.bounds.width)
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
            
            if categoryID == VAL_OFFER { viewOffer.frame = frame; setLayout(viewOffer) }
            else if categoryID == VAL_TERMS { viewTerms.frame = frame; setLayout(viewTerms) }
            else if categoryID == VAL_REWARDS { viewRewards.frame = frame; setLayout(viewRewards) }
        }
        self.callAffiliateOfferList()
        self.view.layoutIfNeeded()
        
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(tableViewOffer) {return arrOfferList.count} else {return arrCommisionData.count} }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(tableViewOffer) {
            
            let dict:typeAliasDictionary = arrOfferList[indexPath.row]
            
            let cell:AffiliateOfferListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_OFFER_CELL) as! AffiliateOfferListCell
            
            cell.imageViewLogo.sd_setImage(with: (dict[RES_offerBanner] as! String).convertToUrl(), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, catchType, url) in
                if image == nil { cell.imageViewLogo.image = UIImage(named: "logo")}
                else { cell.imageViewLogo.image = image! }
            })
            
            cell.lblCouponCode.text = dict[RES_offerCoupon] as? String
            cell.lblCouponValid.text = "This Offer is valid till \(dict[RES_offerExpireDate] as! String)"
            cell.lblRewards.text = (dict[RES_offerCommission1] as? String)?.uppercased()
            cell.lblDiscount.text = dict[RES_offerTitle] as? String
            cell.lblPartnerName.text = "@\(dict[RES_partnerName] as! String) , \(dict[RES_offerDiscount] as! String) "
            if dict[RES_couponFlag] as! Int == 1 { cell.btnCouponCode.isEnabled = true }
            else {cell.btnCouponCode.isEnabled = false}
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else {
            let cell:AffiliateRewardsListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_REWARDS_CELL) as! AffiliateRewardsListCell
            
            let dict:typeAliasDictionary = arrCommisionData[indexPath.row]
            let stCommissionUser = dict[RES_commissionType] as! Int == 1   ? "\(dict[RES_affiliateCommissionUser] as! String)%" : "\(RUPEES_SYMBOL)\(dict[RES_affiliateCommissionUser] as! String)"
             let stCommission = dict[RES_commissionType] as! Int == 1  ? "\(dict[RES_affiliateCommission] as! String)%" : "\(RUPEES_SYMBOL)\(dict[RES_affiliateCommission] as! String)"
            cell.lblRewardsNote.text = "(You will get upto \(stCommissionUser) & Your Channel will get \(stCommissionUser))"
            cell.lblPercentRewards.text = "\(stCommission) \(cashBackType)"
            cell.lblCategory.attributedText = (dict[RES_categoryName] as? String)?.htmlAttributedString
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(tableViewOffer) { return UITableViewAutomaticDimension }
        else {  return UITableViewAutomaticDimension  }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewOffer {
            let dictOffer:typeAliasDictionary = arrOfferList[indexPath.row]
            let offerDetailVC = affiliateOfferDetailViewController(nibName: "affiliateOfferDetailViewController", bundle: nil)
            offerDetailVC.offerID = dictOffer[RES_offerId] as! String
            self.navigationController?.pushViewController(offerDetailVC, animated: true)
        }
    }
    
    //MARK: SCROLLVIEW DELEGATE
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
        if scrollView == tableViewOffer ||  scrollView == tableViewRewards || scrollView == scrollViewTermsBG{
            if scrollView.contentOffset.y > 0 &&  self.constraintViewPagerTopToSuper.constant == viewButton.frame.maxY {
                self.animateView(isUp: true , scrollView:scrollView)}
            else if scrollView.contentOffset.y <= 0 &&  self.constraintViewPagerTopToSuper.constant == 0 {
                scrollView.bounces = false
                self.animateView(isUp: false ,  scrollView:scrollView)}
        }
    }
    
    func animateView(isUp:Bool , scrollView:UIScrollView ) {
        if isUp {
            
            self.constraintViewPagerTopToSuper.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                self.effectView.alpha = 1.0
                self.viewLabelReward.alpha = 0.0
                
            }, completion: { (completed) in
                self.isCompleted = true
                scrollView.bounces = true
            })
        }
        else if isCompleted {
            self.constraintViewPagerTopToSuper.constant = viewButton.frame.maxY
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                self.effectView.alpha = 0.0
                self.viewLabelReward.alpha = 1
            }, completion: { (completed) in
                 self.isCompleted = false
                scrollView.bounces = true
            })
        }
    }
    
    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
//        if selectedMenu == 1 && self.constraintViewButtonTopToViewReward.constant == 106 { self.animateView(isUp: true ,  scrollView:UIScrollView()) }
        if selectedMenu == 2 && arrCommisionData.isEmpty { self.callCommisionDetail() ;  self.SetScreenName(name: F_AFFILIATE_REWARDS, stclass: F_AFFILIATE_REWARDS)
         self.sendScreenView(name: F_AFFILIATE_REWARDS)}
        if selectedMenu == 1 {
            self.SetScreenName(name: F_AFFILIATE_TERMS, stclass: F_AFFILIATE_TERMS)
            self.sendScreenView(name: F_AFFILIATE_TERMS)
        }
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
        
    }
}
