//
//  AffiliateProductDetailViewController.swift
//  Cubber
//
//  Created by dnk on 14/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliateProductDetailViewController: UIViewController, AppNavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate , MaterialShowcaseDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var imageViewProductMain: UIImageView!
    @IBOutlet var imageViewProductPartner: UIImageView!
    @IBOutlet var collectionViewProductImage: UICollectionView!
    @IBOutlet var btnShare: UIButton!
    
    @IBOutlet var tableViewProductOffer: UITableView!
    @IBOutlet var tableViewKeySpecification: UITableView!
    
    @IBOutlet var btnSpecification: UIButton!
    @IBOutlet var btnDescription: UIButton!
    @IBOutlet var tableViewProductAttribute: UITableView!
    @IBOutlet var lblProductTitle: UILabel!
    @IBOutlet var lblSpecialPrice: UILabel!
    @IBOutlet var lblCubberCommission: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    
    @IBOutlet var lblProductAttribute: UILabel!
    @IBOutlet var lblKeySpecification: UILabel!
    @IBOutlet var lblProductOffer: UILabel!
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var viewSpecificationDescription: UIView!
    @IBOutlet var viewOnlySpecification: UIView!
    @IBOutlet var viewProductOffer: UIView!
    @IBOutlet var viewImageCollection: UIView!
    @IBOutlet var viewSpecification: UIView!
    @IBOutlet var viewDescription: UIView!
    @IBOutlet var viewProductKeySpecification: UIView!
    
    @IBOutlet var btnShopNow: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var stMainImage:String = String()
    var widthContentProduct:CGFloat = CGFloat()
    var widthContentOffer:CGFloat = CGFloat()
    var widthContentKeySpecification:CGFloat = CGFloat()

    var isShowProductOffer:Bool = false
    var isShowProductKeyDescription:Bool = false
    var isShowProductAttribute:Bool = false

    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    internal var stProductID:String = String()
    internal var stProductTitle:String = String()
    private var dictProductDetail = typeAliasDictionary()
    private var arrProductImages = [String]()
    private var arrProductOffers = [String]()
    private var arrProductKeySpecification = [String]()
    private var arrProductAttribute = [typeAliasDictionary]()
    private var arrProductSpecification = [typeAliasDictionary]()
    
    private var arrSizeProductOffers = [CGFloat]()
    private var arrSizeProductKeySpecification = [CGFloat]()
    private var arrSizeProductAttribute = [CGFloat]()
    
     var isReload:Bool = true
    
    @IBOutlet var constraintViewProductOfferTopToSuperView: NSLayoutConstraint!
    @IBOutlet var constraintViewProductAttributeTopToSuperview: NSLayoutConstraint!
    @IBOutlet var constraintTableViewProductOfferHeight: NSLayoutConstraint!
    @IBOutlet var constraintTableViewKeySpecificationHeight: NSLayoutConstraint!
    @IBOutlet var constraintTableViewProductAttribureHeight: NSLayoutConstraint!
    @IBOutlet var constraintViewProductAttributeTopToViewProductOffer: NSLayoutConstraint!
    @IBOutlet var constraintviewProductKeySpecificationTopToViewProductOffer: NSLayoutConstraint!
    @IBOutlet var constraintViewProductKeySpecificationTopToSuperView: NSLayoutConstraint!
    @IBOutlet var constraintViewPriceTopToCollectionViewImages: NSLayoutConstraint!
    @IBOutlet var constraintViewPriceTopToMainImageView: NSLayoutConstraint!
    @IBOutlet var constraintViewSpecificationBottomToMainView: NSLayoutConstraint!
    @IBOutlet var constraintViewDescriptionBottomToMainView: NSLayoutConstraint!
    @IBOutlet var constraintViewProductTopToViewProductKeyDescription: NSLayoutConstraint!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         collectionViewProductImage.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_IMAGE_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_IMAGE_CELL)
        self.tableViewProductOffer.rowHeight = UITableViewAutomaticDimension
        self.tableViewProductOffer.estimatedRowHeight = HEIGHT_AFFILIATE_PRODUCT_OFFER_SPECIFICATION_CELL
        self.tableViewProductOffer.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewProductOffer.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_OFFERSPECIFICATION_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_OFFERSPECIFICATION_CELL)
        self.tableViewProductOffer.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableViewKeySpecification.estimatedRowHeight = HEIGHT_AFFILIATE_PRODUCT_OFFER_SPECIFICATION_CELL
        self.tableViewKeySpecification.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewKeySpecification.rowHeight = UITableViewAutomaticDimension
        self.tableViewKeySpecification.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_OFFERSPECIFICATION_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_OFFERSPECIFICATION_CELL)
        self.tableViewKeySpecification.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        self.tableViewProductAttribute.rowHeight = UITableViewAutomaticDimension
        self.tableViewProductAttribute.estimatedRowHeight = HEIGHT_AFFILIATE_PRODUCT_ATTRIBUTE_LIST_CELL
        self.tableViewProductAttribute.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewProductAttribute.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_PRODUCT_ATTRIBUTELIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_ATTRIBUTELIST_CELL)
       
         viewBG.alpha = 0
        self.viewSpecificationDescription.isHidden = true
        self.viewOnlySpecification.isHidden = true

        self.callAffiliateProductDetail()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_AFFILIATE_PRODUCTDETAIL)
          }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_MODULE_AFFILIATE, stclass: F_AFFILIATE_PRODUCTDETAIL)
        
        if isReload {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.viewBG.alpha = 1
            }, completion: nil)
        }
        isReload = false
        let showcase = MaterialShowcase()
        showcase.delegate = self
        if !DataModel.getIsShowProductShareShowcase() {
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
            DataModel.setIsShowProductShareShowcase(true)
        }
    }
    
    //MARK: APPNAVIGATION
    
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSpecificationDescriptionAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            btnSpecification.isSelected = true
            btnDescription.isSelected = false
            btnSpecification.backgroundColor = COLOUR_ORANGE
            btnSpecification.setTitleColor(UIColor.white, for: .normal)
            btnDescription.backgroundColor = UIColor.white
            btnDescription.setTitleColor(UIColor.black, for: .normal)
            viewSpecification.isHidden = false
            viewDescription.isHidden = true
            constraintViewSpecificationBottomToMainView.isActive = true
            constraintViewDescriptionBottomToMainView.isActive = false
        }
        else {
            btnSpecification.isSelected = false
            btnDescription.isSelected = true
            btnDescription.backgroundColor = COLOUR_ORANGE
            btnDescription.setTitleColor(UIColor.white, for: .normal)
            btnSpecification.backgroundColor = UIColor.white
            btnSpecification.setTitleColor(UIColor.black, for: .normal)
            viewSpecification.isHidden = true
            viewDescription.isHidden = false
            constraintViewSpecificationBottomToMainView.isActive = false
            constraintViewDescriptionBottomToMainView.isActive = true
        }
       self.view.layoutIfNeeded()
    }
    
    func callAffiliateProductDetail(){
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken(), REQ_PRODUCT_ID:self.stProductID]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateProductDetail, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.dictProductDetail = dict[RES_productDetail] as! typeAliasDictionary
           self.setProductDetail()
            
        }, onFailure: { (code, dict) in
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    func setProductDetail() {
    obj_AppDelegate.navigationController.setCustomTitle(  dictProductDetail[RES_productTitle] as! String)
       
        if self.dictProductDetail[RES_userCommission] != nil &&  self.dictProductDetail[RES_userCommission] as! String != "" {                    self.btnShopNow.setTitle("Shop Now (You will get upto \(RUPEES_SYMBOL) \(self.dictProductDetail[RES_userCommission]!))", for: .normal)
        }
        else { self.btnShopNow.setTitle("Shop Now", for: .normal) }
        
        if self.dictProductDetail[RES_productOffers] != nil {
            isShowProductOffer = true
            var dictProductOffers:typeAliasDictionary = self.dictProductDetail[RES_productOffers] as! typeAliasDictionary
            lblProductOffer.text = dictProductOffers[RES_Title] as? String
            arrProductOffers = dictProductOffers[RES_productOffersAttribute] as! [String]
        }
        if self.dictProductDetail[RES_productKeySpecification] != nil {
            isShowProductKeyDescription = true
            var dictProductKeySpecification:typeAliasDictionary = self.dictProductDetail[RES_productKeySpecification] as! typeAliasDictionary
            lblKeySpecification.text = dictProductKeySpecification[RES_Title] as? String
            arrProductKeySpecification = dictProductKeySpecification[RES_keySpecificationAttribute] as! [String]

        }
        if self.dictProductDetail[RES_productSpecification] != nil {
            isShowProductAttribute = true
            arrProductSpecification = self.dictProductDetail[RES_productSpecification] as! [typeAliasDictionary]
        /*    var dictSpecificationAttribute : typeAliasDictionary = arrProductSpecification.first as typeAliasDictionary!
            lblProductAttribute.text = dictSpecificationAttribute[RES_Title] as? String
            arrProductAttribute += dictSpecificationAttribute[RES_specificationAttribute] as! [typeAliasDictionary]*/
            
        }
       
        
        lblProductTitle.text = self.dictProductDetail[RES_productTitle] as? String
        if dictProductDetail[RES_specialPrice] as! String == "0" {
            lblSellingPrice.text = ""
            lblSpecialPrice.text = (self.dictProductDetail[RES_sellingPrice] as! String).setThousandSeperator(decimal: 2)
        }
        else{
            lblSpecialPrice.text = (self.dictProductDetail[RES_specialPrice] as! String).setThousandSeperator(decimal: 2)
            var stSellingPrice:String = (self.dictProductDetail[RES_sellingPrice] as! String).setThousandSeperator(decimal: 2)
            let attributedText = NSMutableAttributedString.init(string: stSellingPrice)
            attributedText.addAttributes([NSStrikethroughStyleAttributeName: 1,NSStrikethroughColorAttributeName: UIColor.red], range: NSMakeRange(0, stSellingPrice.count))
            lblSellingPrice.attributedText = attributedText
        }
        
        lblCubberCommission.text = self.dictProductDetail[RES_cubberCommission] as? String
        
        
        self.arrProductImages = self.dictProductDetail[RES_productImages] as! [String]
        
        if arrProductImages.count > 1 {
            constraintViewPriceTopToCollectionViewImages.priority = PRIORITY_HIGH
            constraintViewPriceTopToMainImageView.priority = PRIORITY_LOW
            viewImageCollection.isHidden = false
        }
        else {
            constraintViewPriceTopToCollectionViewImages.priority = PRIORITY_LOW
            constraintViewPriceTopToMainImageView.priority = PRIORITY_HIGH
            viewImageCollection.isHidden = true
        }
        stMainImage = arrProductImages.first!
        collectionViewProductImage.reloadData()
        
        self.activityIndicator.startAnimating()
        imageViewProductMain.sd_setImage(with: (stMainImage.convertToUrl()), completed: { (image, error, cacheType, url) in
            self.activityIndicator.stopAnimating()
            if image != nil {
                self.imageViewProductMain.image = image
            }
        })
        
        imageViewProductPartner.sd_setImage(with: ((self.dictProductDetail[RES_partnerLogo1] as! String).convertToUrl()), completed: { (image, error, cacheType, url) in
            if image != nil {
                self.imageViewProductPartner.image = image
            }
        })

        
        if dictProductDetail[RES_productDescription] as! String != "" {
            viewSpecificationDescription.isHidden = false
            viewOnlySpecification.isHidden = true
            lblDescription.attributedText = (self.dictProductDetail[RES_productDescription]! as? String)?.htmlAttributedString
        }
        else {
            viewOnlySpecification.isHidden = false
            viewSpecificationDescription.isHidden = true
        }
        //self.view.layoutIfNeeded()
        
        //HEIGHT OFFERS SPECS
        widthContentOffer = tableViewProductOffer.frame.width
        let textWidthOffer:CGFloat = widthContentOffer - (40)
        var tableHeightOffer:CGFloat = 0
        var stHeightOffer:String = ""
        for str in arrProductOffers {
            var height:CGFloat = 0
            stHeightOffer = str
            height = stHeightOffer.textHeight(textWidthOffer, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 17)!)
            height = ceil(height)
            height = height > 25 ? height + SIZE_EXTRA_TEXT : 25
            tableHeightOffer += height
        }
        tableViewProductOffer.reloadData()
        constraintTableViewProductOfferHeight.constant = tableHeightOffer + 20
        UIView.animate(withDuration: 0.0, animations: {
            self.tableViewProductOffer.reloadData()
        }) { (completed) in
            self.constraintTableViewProductOfferHeight.constant =  self.tableViewProductOffer.contentSize.height
        }
        
        //HEIGHT KEY SPECS
          widthContentKeySpecification = tableViewKeySpecification.frame.width
        let textWidthKeySpecification:CGFloat = widthContentKeySpecification - (23)
        var tableHeightKeySpecification:CGFloat = 0
        var stHeightKeySpecification:String = ""
        for str in arrProductKeySpecification {
            var height:CGFloat = 0
            stHeightKeySpecification = str
            height = stHeightKeySpecification.textHeight(textWidthKeySpecification, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 12)!)
            height = ceil(height)
            height = height > 25 ? height + SIZE_EXTRA_TEXT : 25
            tableHeightKeySpecification += height
        }
   
        constraintTableViewKeySpecificationHeight.constant = tableHeightKeySpecification
        tableViewKeySpecification.reloadData()
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableViewKeySpecification.reloadData()
            
        }) { (completed) in
            self.constraintTableViewKeySpecificationHeight.constant =  self.tableViewKeySpecification.contentSize.height
        }
        
        //HEIGHT PRODUCT ATTRIB
        widthContentProduct = tableViewProductAttribute.frame.width / 2
        let textWidthProduct:CGFloat = widthContentProduct - (8 * 2)
         var tableHeightProduct:CGFloat = 0
        var stHeightProduct:String = ""
        for dict in arrProductSpecification {
            let array: [typeAliasDictionary] = dict[RES_specificationAttribute] as! [typeAliasDictionary]
            for dict in array {
                var height:CGFloat = 0
                stHeightProduct = dict[RES_Value] as! String
                height = stHeightProduct.textHeight(textWidthProduct, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 17)!)
                height = ceil(height)
                height = height > 25 ? height + SIZE_EXTRA_TEXT : 25
                
                var height1:CGFloat = 0
                stHeightProduct = dict[RES_Key] as! String
                height1 = stHeightProduct.textHeight(textWidthProduct, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 17)!)
                height1 = ceil(height)
                height1 = height1 > 25 ? height1 + SIZE_EXTRA_TEXT : 25
                
                tableHeightProduct += height > height1 ? height : height1
            }
            tableHeightProduct += 25
        }
        
        constraintTableViewProductAttribureHeight.constant = tableHeightProduct
        UIView.animate(withDuration: 0.0, animations: {
            self.tableViewProductAttribute.reloadData()

        }) { (completed) in
            self.constraintTableViewProductAttribureHeight.constant =  self.tableViewProductAttribute.contentSize.height
        }
        
        
        if isShowProductOffer && isShowProductKeyDescription && isShowProductAttribute{
            
            viewProductOffer.isHidden = false
            viewProductKeySpecification.isHidden = false
            constraintviewProductKeySpecificationTopToViewProductOffer.priority = PRIORITY_HIGH
            constraintViewProductKeySpecificationTopToSuperView.priority = PRIORITY_LOW
            constraintViewProductTopToViewProductKeyDescription.priority = PRIORITY_HIGH
            constraintViewProductAttributeTopToViewProductOffer.priority = PRIORITY_LOW
            constraintViewProductAttributeTopToSuperview.priority = PRIORITY_LOW
            constraintViewProductOfferTopToSuperView.priority = PRIORITY_HIGH
            
        }
        else if !isShowProductOffer && isShowProductKeyDescription && isShowProductAttribute{
            viewProductOffer.isHidden = true
            viewProductKeySpecification.isHidden = false
            constraintviewProductKeySpecificationTopToViewProductOffer.priority = PRIORITY_LOW
            constraintViewProductKeySpecificationTopToSuperView.priority = PRIORITY_HIGH
            constraintViewProductTopToViewProductKeyDescription.priority = PRIORITY_HIGH
            constraintViewProductAttributeTopToViewProductOffer.priority = PRIORITY_LOW
            constraintViewProductAttributeTopToSuperview.priority = PRIORITY_LOW
            constraintViewProductOfferTopToSuperView.priority = PRIORITY_HIGH
        }
        else if !isShowProductOffer && !isShowProductKeyDescription && isShowProductAttribute{
            viewProductOffer.isHidden = true
            viewProductKeySpecification.isHidden = true
            constraintviewProductKeySpecificationTopToViewProductOffer.priority = PRIORITY_LOW
            constraintViewProductKeySpecificationTopToSuperView.priority = PRIORITY_LOW
            constraintViewProductTopToViewProductKeyDescription.priority = PRIORITY_LOW
            constraintViewProductAttributeTopToViewProductOffer.priority = PRIORITY_LOW
            constraintViewProductOfferTopToSuperView.priority = PRIORITY_LOW
            constraintViewProductAttributeTopToSuperview.priority = PRIORITY_HIGH
        }
        else if isShowProductOffer && !isShowProductKeyDescription && isShowProductAttribute{
            viewProductOffer.isHidden = false
            viewProductKeySpecification.isHidden = true
            constraintviewProductKeySpecificationTopToViewProductOffer.priority = PRIORITY_LOW
            constraintViewProductKeySpecificationTopToSuperView.priority = PRIORITY_LOW
            constraintViewProductTopToViewProductKeyDescription.priority = PRIORITY_LOW
            constraintViewProductAttributeTopToViewProductOffer.priority = PRIORITY_HIGH
            constraintViewProductAttributeTopToSuperview.priority = PRIORITY_LOW
            constraintViewProductOfferTopToSuperView.priority = PRIORITY_HIGH
        }
        else if isShowProductOffer && !isShowProductKeyDescription && !isShowProductAttribute{
            viewProductOffer.isHidden = false
            viewProductKeySpecification.isHidden = true
            self.tableViewProductAttribute.isHidden = true
        }
            
        else if !isShowProductOffer && !isShowProductKeyDescription && !isShowProductAttribute {
            viewSpecification.isHidden = true
            viewDescription.isHidden = true
            viewOnlySpecification.isHidden = true
            viewSpecificationDescription.isHidden = true
        }
        
        self.tableViewProductOffer.layoutIfNeeded()
        self.tableViewKeySpecification.layoutIfNeeded()
        self.tableViewProductAttribute.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnShareAction() {
        
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken() , REQ_PARTNER_ID:self.dictProductDetail[RES_partnerId] as! String, REQ_PRODUCT_ID:self.dictProductDetail[RES_productId] as! String , REQ_USER_ID:dictUserInfo[RES_affiliateId] as! String , REQ_DEVICE_TYPE:"2"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateShare, methodType: .POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            let dictPartner = dict[RES_partnerDetail] as! typeAliasDictionary
            var strMsg = dict[RES_partnerShare] as! String
           /* if dictPartner[RES_redirectUrlSmall] != nil {
                strMsg += " Shop Now: \(dictPartner[RES_redirectUrlSmall]!)"
            }
            if dictPartner[RES_Title] != nil {
                strMsg += "\n\n Title: \(dictPartner[RES_Title]!)"
            }
            if dictPartner[RES_price] != nil {
                strMsg += "\n\n Sell price: \((dictPartner[RES_price] as! String).setThousandSeperator(decimal: 0))/-"
            }*/
            
            var objectToShare:[Any] = [strMsg]
            if dictPartner[RES_image] != nil && dictPartner[RES_image] as! String  != "" {
                let url = URL(string:dictPartner[RES_image] as! String)
                let data = try? Data(contentsOf: url!)
                let image: UIImage = UIImage(data: data!)!
                objectToShare.append(image)
            }
            
            let activityVC = UIActivityViewController.init(activityItems: objectToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
          /*  print(strMsg)
            let stMessage:String = "whatsapp://send?text=\(strMsg)"
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
    
    @IBAction func btnShopNowAction() {
        
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken() , REQ_PARTNER_ID:self.dictProductDetail[RES_partnerId] as! String, REQ_PRODUCT_ID:self.dictProductDetail[RES_productId] as! String , REQ_USER_ID:dictUserInfo[RES_affiliateId] as! String , REQ_DEVICE_TYPE:"2"]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateClick, methodType: .POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            let dictPartenerDetail:typeAliasStringDictionary = dict[RES_partnerDetail] as! typeAliasStringDictionary
            UIApplication.shared.openURL((dictPartenerDetail[RES_redirectUrl]!).convertToUrl())
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
        }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
    }
    
    func adjustHeight(){
    
        var height:CGFloat = tableViewProductOffer.contentSize.height
        let maxHeight:CGFloat  = (tableViewProductOffer.superview?.frame.height)! - tableViewProductOffer.frame.origin.y
        
        if height > maxHeight {
            height = maxHeight
        }
        
        UIView.animate(withDuration: 0.25) { 
            self.constraintTableViewProductOfferHeight.constant = height
        }
        self.tableViewProductOffer.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    //MARK: COLLECTIONVIEW DATA SOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.arrProductImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:AffiliateProductImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_IMAGE_CELL, for: indexPath) as! AffiliateProductImageCell
        
       /* if stMainImage != "" {
            cell.activityIndicator.startAnimating()
            imageViewProductMain.sd_setImage(with: (stMainImage.convertToUrl()), completed: { (image, error, cacheType, url) in
                cell.activityIndicator.stopAnimating()
                if image != nil {
                    self.imageViewProductMain.image = image
                }
            })
            cell.viewBG.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
        }*/
        
        let stImage:String = arrProductImages[indexPath.item]
        
        if stImage == stMainImage {
         cell.viewBG.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
        }
        else{
        cell.viewBG.setViewBorder(UIColor.clear, borderWidth: 0, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
        }
        
        cell.imageViewProduct.sd_setImage(with: (stImage.convertToUrl()), completed: { (image, error, cacheType, url) in
            if image != nil {
                cell.imageViewProduct.image = image
            }
        })

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HEIGHT_AFFILIATE_PRODUCT_IMAGE_CELL , height: HEIGHT_AFFILIATE_PRODUCT_IMAGE_CELL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            stMainImage = arrProductImages[indexPath.item]
            self.activityIndicator.startAnimating()
            imageViewProductMain.sd_setImage(with: (stMainImage.convertToUrl()), completed: { (image, error, cacheType, url) in
            self.activityIndicator.stopAnimating()
            if image != nil {
                self.imageViewProductMain.image = image
            }
            })
            collectionViewProductImage.reloadData()
    }
    
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewProductAttribute{ return arrProductSpecification.count }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(tableViewProductOffer) {return arrProductOffers.count}
        if tableView.isEqual(tableViewKeySpecification) {return arrProductKeySpecification.count}
        else{
            if arrProductSpecification.count == 0 { return 0 }
            var dict: typeAliasDictionary = arrProductSpecification[section]
            let array = dict[RES_specificationAttribute] as! [typeAliasDictionary]
            return array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(tableViewProductOffer) {
            let cell:ProductOfferSpecificationCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_OFFERSPECIFICATION_CELL) as! ProductOfferSpecificationCell
            let stOffer:String = arrProductOffers[indexPath.row]
            cell.lblOfferSpecificationTitle.text = stOffer
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        else if tableView.isEqual(tableViewKeySpecification) {
            let cell:ProductOfferSpecificationCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_OFFERSPECIFICATION_CELL) as! ProductOfferSpecificationCell
            let stSpecification:String = arrProductKeySpecification[indexPath.row]
            cell.lblOfferSpecificationTitle.text = stSpecification
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else {
            
            let cell:ProductAttributeListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_AFFILIATE_PRODUCT_ATTRIBUTELIST_CELL) as! ProductAttributeListCell
            let dictProduct: typeAliasDictionary = arrProductSpecification[indexPath.section]
            let array: [typeAliasDictionary] = dictProduct[RES_specificationAttribute] as! [typeAliasDictionary]
            let dict:typeAliasDictionary = array[indexPath.row]
            cell.lblAttributeKey.text = dict[RES_Key] as? String
            cell.lblAttributeValue.text = dict[RES_Value] as? String
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.isEqual(tableViewProductOffer) { return UIView.init() }
        if tableView.isEqual(tableViewKeySpecification) { return UIView.init() }
        else{
            let productHeader = ProductHeader(frame: CGRect(x: 0, y: 0, width: tableViewProductAttribute.frame.width, height: 25), productInfo: self.arrProductSpecification[section])
            return productHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.isEqual(tableViewProductOffer) { return 0.001 }
        if tableView.isEqual(tableViewKeySpecification) { return 0.001 }
        else{ return 25 }
       
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero
    }
}
