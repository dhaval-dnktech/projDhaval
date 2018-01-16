//
//  PartnerDetailViewController.swift
//  Cubber
//
//  Created by dnk on 10/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import AudioToolbox

class affiliateOfferDetailViewController: UIViewController , AppNavigationControllerDelegate , MaterialShowcaseDelegate {

    //MARK: PROPERTIES
    
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblExpiryDate: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblCommisiion: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblCouponCode: UILabel!
    @IBOutlet var iamgeViewLogo: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var btnCouponCode: UIButton!
    @IBOutlet var webViewDescription: UIWebView!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var rightNav: UIView!

    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    internal var offerID : String = "1"
    fileprivate var dictOffer:typeAliasDictionary = typeAliasDictionary()
    fileprivate var isReload:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBG.alpha = 0
        isReload = true
        self.callAffiliate_NewOfferDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.sendScreenView(name: F_AFFILIATE_OFFER_DETAIL)
        obj_AppDelegate.navigationController.setRightView(self, view: rightNav, totalButtons: 2)
    }
      
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_AFFILIATE_OFFER_DETAIL, stclass: F_AFFILIATE_OFFER_DETAIL)
         btnCouponCode.addDashedBorder(color: COLOUR_ORANGE)
        
        let showcase = MaterialShowcase()
        showcase.delegate = self
        if !DataModel.getIsShowOfferShareShowcase() {
            showcase.tag = 1
            showcase.setTargetView(view:btnShare) // always required to set targetView
            showcase.primaryText = "Share & Earn"
            showcase.secondaryText = "Share this product and get amazing cashback/rewards on your referrals purchase."
            showcase.show(completion: { })
        
        // Background
            showcase.backgroundPromptColor = COLOUR_TEXT_GRAY //RGBCOLOR(40, g: 56, b: 149)
            showcase.backgroundPromptColorAlpha = 0.95
        
        //Target
            showcase.targetTintColor = UIColor.gray
            showcase.targetHolderRadius = 25
            showcase.targetHolderColor = UIColor.white
        
        //Text
            showcase.primaryTextColor = UIColor.white
            showcase.secondaryTextColor = UIColor.white
            showcase.primaryTextSize = 16
            showcase.secondaryTextSize = 13
        
        //Animation
            showcase.aniComeInDuration = 0.5 // unit: second
            showcase.aniGoOutDuration = 0.5 // unit: second
            showcase.aniRippleScale = 1.5
            showcase.aniRippleColor = UIColor.white
            showcase.aniRippleAlpha = 0.2
            DataModel.setIsShowOfferShareShowcase(true)
        }
    }
    
    
    //MARK: APP NAVIGATION DELEGATE
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func appNavigationController_NotificationAction() {
        
      /*  let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        self.navigationController?.pushViewController(notificationVC, animated: true)*/
    }

    //MARK: CUSTOM METHODS
    
   
    @IBAction func btnShareAction() {
        
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken() , REQ_PARTNER_ID:self.dictOffer[RES_partnerId] as! String, REQ_offer_id:self.dictOffer[RES_offerId] as! String , REQ_USER_ID:dictUserInfo[RES_affiliateId] as! String , REQ_DEVICE_TYPE:"2"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateShare, methodType: .POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            let dictPartner = dict[RES_partnerDetail] as! typeAliasDictionary
            
            let strMsg = dict[RES_partnerShare] as! String
            var objectToShare:[Any] = [strMsg]
            if dictPartner[RES_image] != nil && dictPartner[RES_image] as! String  != "" {
                let url = URL(string:dictPartner[RES_image] as! String)
                let data = try? Data(contentsOf: url!)
                let image: UIImage = UIImage(data: data!)!
                objectToShare.append(image)
            }
            
            let activityVC = UIActivityViewController.init(activityItems: objectToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
           /* let stMessage:String = "whatsapp://send?text=\(strMsg)"
            let  urlString = stMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            let isWPInstalled:Bool = UIApplication.shared.canOpenURL(URL.init(string: "whatsapp://")!)
            
            let whatsappURL : URL = URL.init(string:urlString!)!
            if isWPInstalled {
                UIApplication.shared.openURL(whatsappURL)
            }*/
            
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    
    @IBAction func btnCouponCodeAction() {
        
        if dictOffer[RES_couponFlag] as! Int == 1 {
            let paste = UIPasteboard.general
            paste.string = btnCouponCode.titleLabel?.text
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            _KDAlertView.showMessage(message: " Copied to clipboard ", messageType: MESSAGE_TYPE.SUCCESS); return;
            
        }
    }
    
    
    @IBAction func btnShopEarnAction() {
        
        self.trackEvent(category: "\(MAIN_CATEGORY):\(F_AFFILIATE_HOME) ", action: "shop & earn", label: "\(DataModel.getUserInfo()[RES_userID] as! String)", value: nil)
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken() , REQ_PARTNER_ID:self.dictOffer[RES_partnerId] as! String , REQ_USER_ID:dictUserInfo[RES_affiliateId] as! String , REQ_DEVICE_TYPE:"2" ,  REQ_offer_id:"\(dictOffer[RES_offerId] as! String)"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateClick, methodType: .POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            let dictPartenerDetail:typeAliasStringDictionary = dict[RES_partnerDetail] as! typeAliasStringDictionary
            UIApplication.shared.openURL((dictPartenerDetail[RES_redirectUrl]!).convertToUrl())
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
            
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    func setOfferDetail() {
        
        obj_AppDelegate.navigationController.setCustomTitle((dictOffer[RES_offerPartner] as! String))
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
        
        lblTitle.text = dictOffer[RES_offerTitle] as? String
        lblExpiryDate.text = " This Offer Valid Till - \(dictOffer[RES_offerExpireDate] as! String)"
        lblDiscount.text = dictOffer[RES_offerDiscount]! as? String
        lblCommisiion.text = (dictOffer[RES_offerCommission1]! as? String)
        lblDescription.attributedText = (dictOffer[RES_offerDescription] as? String)?.htmlAttributedString
        webViewDescription.loadHTMLString(dictOffer[RES_offerDescription] as! String, baseURL: nil)
        btnCouponCode.setTitle((dictOffer[RES_offerCoupon] as? String)?.uppercased(), for: .normal)
        activityIndicator.startAnimating()
        iamgeViewLogo.sd_setImage(with: (dictOffer[RES_offerBanner]as! String).convertToUrl()) { (image, error, cacheType, url) in
            self.iamgeViewLogo.image = image
            self.activityIndicator.stopAnimating()
        }
        if isReload {
            UIView.animate(withDuration: 0.3, animations: { 
                self.viewBG.alpha = 1
        })
                      }
        isReload = false
      
    }
    
    func callAffiliate_NewOfferDetail() {
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(),
                      REQ_offer_id:self.offerID]
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateNewOffer_Detail, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token] as! String)
            self.dictOffer = dict[RES_offerDetail] as! typeAliasDictionary
            self.setOfferDetail()
        }, onFailure: { (code, dict) in
            
        }) {   self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return     }
    }
}
