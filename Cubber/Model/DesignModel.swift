//
//  DesignModel.swift
//  Cubber
//
//  Created by Vyas Kishan on 16/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

//http://krakendev.io/blog/the-right-way-to-write-a-singleton

import UIKit

let HEIGHT_IPHONE_5                     = 568
let HEIGHT_IPHONE_4                     = 480

let IS_IPAD                             = UIDevice.current.userInterfaceIdiom == .pad
let IS_IPHONE                           = UIDevice.current.userInterfaceIdiom == .phone
let IS_IPHONE_5                         = Int(UIScreen.main.bounds.size.height) == HEIGHT_IPHONE_5
let IS_IPHONE_5_UP                      = Int(UIScreen.main.bounds.size.height) >= HEIGHT_IPHONE_5

let IS_PORTRAIT                         = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
let IS_LANDSCAPE                        = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)

let systemVerion                        = (UIDevice.current.systemVersion as NSString).floatValue
let IS_OS_6_OR_ABOVE                    = systemVerion >= 6.0
let IS_OS_6_BELOW                       = systemVerion < 6.0
let IS_OS_7_OR_ABOVE                    = systemVerion >= 7.0
let IS_OS_7_BELOW                       = systemVerion < 7.0
let IS_OS_8_OR_ABOVE                    = systemVerion >= 8.0
let IS_OS_7_To_8                        = systemVerion >= 7.0 && systemVerion < 8.0
let FRAME_SCREEN                        = UIScreen.main.bounds
let STATUS_BAR_HEIGHT                   = UIApplication.shared.statusBarFrame.height

//MARK: COLOUR
//**************************COLOR******************************************
public func RGBCOLOR(_ r: CGFloat, g: CGFloat , b: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

public func RGBCOLOR(_ r: CGFloat, g: CGFloat , b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

let COLOUR_NAV                              = RGBCOLOR(238, g: 238, b: 238)
//let COLOUR_ORANGE                           = RGBCOLOR(243, g: 187, b: 50)
let COLOUR_ORANGE                           = "E7B404".hexStringToUIColor()
let COLOUR_DARK_GREEN                       = "20ae48".hexStringToUIColor()
let COLOUR_TRAVELLOR_BG                     = "f5f5f5".hexStringToUIColor()
let COLOUR_GREEN                            = RGBCOLOR(114, g: 187, b: 82)
let COLOUR_AFFILIATE_GREEN                  = RGBCOLOR(114, g: 187, b: 82)
let COLOUR_TEXTFIELD_BORDER                 = RGBCOLOR(183, g: 183, b: 183)
let COLOUR_TEXTFIELD_DISABLE                = RGBCOLOR(238, g: 238, b: 238)
let COLOUR_ORDER_STATUS_SUCCESS             = "20ae48".hexStringToUIColor() // Dark Green 

//let COLOUR_ORDER_STATUS_SUCCESS             = RGBCOLOR(99, g: 166, b: 40) //Green
let COLOUR_ORDER_STATUS_FAILURE             = RGBCOLOR(237, g: 46, b: 60) //Red
let COLOUR_ORDER_STATUS_AWAITING            = RGBCOLOR(250, g: 127, b: 39) //Orange
let COLOUR_ORDER_STATUS_PROCESSING          = RGBCOLOR(241, g: 173, b: 58) //Yellow
let COLOUR_ORDER_STATUS_REFUNDED            = RGBCOLOR(178, g: 182, b: 182)//UIColor.white //Yellow
let COLOUR_GRAY                             = RGBCOLOR(61, g: 61, b: 61)
let COLOUR_ORDER_STATUS_CANCELLED           = RGBCOLOR(178, g: 182, b: 182)
let COLOUR_TEXT_GRAY                        = "3A3E4A".hexStringToUIColor()
let COLOUR_LIGHT_GRAY                       = RGBCOLOR(219, g: 219, b: 219)
//***************************************************************************

//MARK: FONT
//**************************FONT********************************************
//OpenSans-ExtraBoldItalic
//OpenSans-SemiBoldItalic
//OpenSans-ExtraBold
//OpenSans-BoldItalic
//OpenSans-Italic
//OpenSans-SemiBold
//OpenSans-Light
//OpenSans-Regular
//OpenSans-LightItalic
//OpenSans-Bold
let FONT_OPEN_SANS_SEMIBOLD                 = "OpenSans-SemiBold"
let FONT_OPEN_SANS_BOLD                     = "OpenSans-Bold"
let FONT_OPEN_SANS_REGULAR                  = "OpenSans-Regular"
//***************************************************************************

//MARK: IMAGE
//**************************IMAGE********************************************
let IMAGE_UNCHECKED_RADIO                   = "icon_unchecked_radio_box"
let IMAGE_CHECKED_RADIO                     = "icon_checked_radio_box"
let IMAGE_UNCHECKED_BOX                     = "icon_unchecked_box"
let IMAGE_CHECKED_BOX                       = "icon_checked_box"
//***************************************************************************


//MARK: CELL IDENTIFIER
//**************************CELL IDENTIFIER***********************************
let CELL_IDENTIFIER_EVENT_LIST              = "EventListCell"
let CELL_IDENTIFIER_CONTACTUS_CELL          = "ContactUsCell"
let CELL_IDENTIFIER_RECENTLIST_CELL         = "RecentListCell"
let CELL_IDENTIFIER_OPERATORLIST_CELL       = "OperatorListCell"
let CELL_IDENTIFIER_DEFAULT                 = "CellIdentifier"
let CELL_IDENTIFIER_OPERATOR                = "OperatorCell"
let CELL_IDENTIFIER_PLAN_DETAIL             = "PlanDetailCell"
let CELL_IDENTIFIER_REQUESTED_CONTACT       = "RequestedContactCell"
let CELL_IDENTIFIER_PHONE_CONTACT           = "PhoneContactCell"
let CELL_IDENTIFIER_ACCOUNT                 = "AccountCell"
let CELL_IDENTIFIER_ORDER                   = "OrderCell"
let CELL_IDENTIFIER_SELECT_ORDER            = "SelectOrderCell"
let CELL_IDENTIFIER_ORDER_DETAIL            = "OrderDetailCell"
let CELL_IDENTIFIER_WALLET_LIST             = "WalletListCell"
let CELL_IDENTIFIER_NOTIFICATION            = "NotificationCell"
let CELL_IDENTIFIER_COUPON                  = "CouponCell"
let CELL_IDENTIFIER_EDITPROFILE             = "EditProfileCell"
let CELL_IDENTIFIER_REQUESTVIEW_CELL        = "RequestViewCell"
let CELL_IDENTIFIER_INVITEFRIEND_CONTACT_CELL = "InviteFriendContactCell"
let CELL_IDENTIFIER_BUS_LIST_CELL           = "BusListCell"
let CELL_IDENTIFIER_FILTER_DEPARTURE_TIME_CELL           = "FilterDepartureTimeCell"
let CELL_IDENTIFIER_SELECTED_FILTER_CELL    = "SelectedFilterCell"
let CELL_DROP_BOARDING_POINT                = "DropBoardingPointCell"
let CELL_CANCELLATION_POLICY                = "CancellationPolicyCell"
let CELL_IDENTIFIER_SEAT_ARAANGEMENT        = "SeatArrangementCell"
let CELL_IDENTIFIER_BOARDING_POINT_CELL     = "BoardingPointCell"
let CELL_IDENTIFIER_PASSENGER_DETAIL_CELL   = "PassengerDetailCell"
let CELL_IDENTIFIER_SHOP_AFFILIATED_CELL    = "ShopAffiliatedCell"
let CELL_IDENTIFIER_COMMISION_CELL          = "CommisionListCell"
let CELL_IDENTIFIER_ORDER_CELL              = "MyOrderCell"
let CELL_IDENTIFIER_OFFER_CELL              = "MyOfferCell"
let CELL_IDENTIFIER_OFFER_IMAGE_CELL        = "MyOfferWithImageCell"
let CELL_IDENTIFIER_GALLERY_CELL            = "GalleryViewCell"
let CELL_IDENTIFIER_ORDER_SUGGESTION_CELL   = "OrderSuggestionCell"

let CELL_IDENTIFIER_HOME_CATEGORY_CELL                  = "HomeCategoryViewCell"
let CELL_IDENTIFIER_HOME_CATEGORY_COLLECTION_CELL       = "HomeCategoryCollectionCell"
let CELL_IDENIFIER_SIDE_MENU_CELL                       = "SideMenuCell"
let CELL_IDENIFIER_USER_SUMMARY_CELL                    = "UserSummaryCell"
let CELL_IDENIFIER_APPLY_PROMOCODE_CELL                 = "ApplyPromocodeCell"
let CELL_IDENTIFIER_ORDER_DETAIL_SUMMARY_CELL           = "OrderDetailSummaryCell"



let CELL_IDENTIFIER_FLIGHT_LIST_CELL            = "FlightListCell"
let CELL_IDENTIFIER_RETURN_FLIGHT_LIST_CELL     = "ReturnFlightListCell"
let CELL_IDENTIFIER_FLIGHT_STOP_CELL            = "CollectionFlightStopCell"
let CELL_IDENTIFIER_AIRLINE_CELL                = "CollectionViewAirlineCell"
let CELL_IDENTIFIER_TRAVELLOR_LIST              = "TravellorListCell"
let CELL_IDENTIFIER_CLASS_LIST                  = "ClassListCell"
let CELL_AIRPORT_LIST_CELL                      = "AirportListCell"
let CELL_IDENTIFIER_FLIGHT_DETAIL_STOP_CELL     = "FlightDetailStopCell"
let CELL_IDENTIFIER_TRAVELLER_DETAIL            = "TravellerDetailCell"
let CELL_IDENTIFIER_FLIGHT_CANCEL               = "FlightCancelCell"


let CELL_IDENTIFIER_AIRLINE_LIST_CELL           = "AirlineListCell"
let CELL_IDENTIFIER_PREFERED_AIRLINE_LIST_CELL  = "PreferedAirlineCell"
let CELL_IDENTIFIER_DEPARTURE_RETURN_TIME_CELL  = "DepartureReturnTimeCell"
let CELL_IDENTIFIER_DEPARTURE_RETURN_STOP_CELL  = "DepartureReturnStopCell"

let CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL        = "GiveUpCashBackCell"

//AFFILIATE NEW
let CELL_IDENTIFIER_AFFILIATE_BRAND_PARTNER_LIST_CELL = "AffiliateBrandPartnerListCell"
let CELL_IDENTIFIER_AFFILIATE_PRODUCT_FILTER_LIST_CELL    = "ProductFilterListCell"
let CELL_IDENTIFIER_AFFILIATE_PRODUCT_LIST_CELL     = "AffiliateProductListCell"
let CELL_IDENTIFIER_AFFILIATE_PRODUCT_ATTRIBUTELIST_CELL = "ProductAttributeListCell"
let CELL_IDENTIFIER_AFFILIATE_PRODUCT_OFFERSPECIFICATION_CELL = "ProductOfferSpecificationCell"
let CELL_IDENTIFIER_AFFILIATE_PRODUCT_IMAGE_CELL    = "AffiliateProductImageCell"
let CELL_IDENTIFIER_AFFILIATE_PRODUCT_CELL          = "AffiliateProductCell"
let CELL_IDENTIFIER_AFFILIATE_PARTNER_CELL          = "AffiliatePartnerViewCell"
let CELL_IDENTIFIER_AFFILIATE_CATEGORY_CELL         = "AffiliateCategoryCell"
let CELL_IDENTIFIER_AFFILIATE_OFFER_CELL            = "AffiliateOfferListCell"
let CELL_IDENTIFIER_AFFILIATE_REWARDS_CELL          = "AffiliateRewardsListCell"
let CELL_IDENTIFIER_AFFILIATE_PARTNERS_CELL         = "AffiliatePartnersListCell"
let CELL_IDENTIFIER_AFFILIATE_LATEST_OFFER_CELL     = "AffiliaeLatestOfferCell"
let CELL_IDENTIFIER_LATEST_OFFER_CELL               = "LatestOfferCollectionCell"

let CELL_IDENTIFIER_EVENT_GALLERY_CELL      = "EventGallaryCell"
let CELL_IDENTIFIER_EVENT_WEBVIEW_CELL      = "EventWebViewCell"
let CELL_IDENTIFIER_EVENT_LOCATION_CELL     = "EventLocationCell"
let CELL_IDENTIFIER_EVENT_TEXT_CELL         = "EventTextCell"
let CELL_IDENTIFIER_EVENT_ARTIST_CELL       = "EventArtistCell"


let CELL_IDENTIFIER_EVENT_BOOKTIME_CELL     = "EventBookTimeCell"
let CELL_IDENTIFIER_EVENT_BOOKDATE_CELL     = "EventBookDateCell"
let CELL_IDENTIFIER_EVENT_PACKAGE_CELL      = "EventPackageCell"

let CELL_IDENTIFIER_SAVED_CARD_CELL         = "SavedCardCell"

let CELL_IDENTIFIER_EVENT_GALLERY_COLLECTION_CELL = "GalleryCollectionCell"



//***************************************************************************


//MARK: CELL HEIGHT
//*************************CELL HEIGHT***************************************
let HEIGHT_EVENT_LIST_CELL: CGFloat         = 258
let HEIGHT_OPERATORLIST_CELL: CGFloat       = 50
let HEIGHT_RECENTLIST_CELL: CGFloat         = 60
let HEIGHT_OPERATOR_CELL: CGFloat           = 25
let HEIGHT_REGION_CELL: CGFloat             = 60
let HEIGHT_PLAN_DETAIL_CELL: CGFloat        = 130
let HEIGHT_REQUESTED_CONTACT_CELL: CGFloat  = 40
let HEIGHT_PHONE_CONTACT_CELL: CGFloat      = 70
let HEIGHT_ACCOUNT_CELL: CGFloat            = 50
let HEIGHT_DEFAULT_CELL: CGFloat            = 50
let HEIGHT_COMMISSION_LEVEL_CELL: CGFloat   = 40
let HEIGHT_ORDER_CELL: CGFloat              = 100
let HEIGHT_ORDER_HEADER: CGFloat            = 30
let HEIGHT_ORDER_DETAIL_CELL: CGFloat       = 110
let HEIGHT_WALLET_LIST_CELL: CGFloat        = 114
let HEIGHT_NOTIFICATION_CELL: CGFloat       = 500
var HEIGHT_COUPON_CELL: CGFloat             = 110
let HEIGHT_EDITPROFILE_CELL: CGFloat        = 44
let HEIGHT_REQUESTVIEW_CELL : CGFloat       = 90
let HEIGHT_INVITEFRIEND_CONTACT_CELL : CGFloat      = 50
let HEIGHT_BUS_LIST_CELL : CGFloat                  = 98
let HEIGHT_DROP_BOARDING_CELL: CGFloat              = 40
let HEIGHT_CANCELLATION_POLICY_CELL: CGFloat        = 35
let HEIGHT_SEAT_ARAANGEMENT_CELL:CGFloat    = 85
let WIDTH_SEAT_ARAANGEMENT_CELL:CGFloat     = 55
let HEIGHT_PASSENGER_DETAIL_CELL :CGFloat   = 138
let HEIGHT_AFFILIATED_CELL:CGFloat          = 150
let HEIGHT_COMMISION_LIST_CELL:CGFloat      = 50
let HEIGHT_ORDER_LIST_CELL:CGFloat          = 170
let HEIGHT_OFFER_LIST_CELL:CGFloat          = 150
let HEIGHT_GALLERY_CELL:CGFloat             = 271
let HEIGHT_EVENT_PACKAGE_CELL: CGFloat      = 75

let HEIGHT_AFFILIATE_BRAND_PARTNER_LIST_CELL: CGFloat      = 44
let HEIGHT_AFFILIATE_PRODUCT_FILTER_LIST_CELL: CGFloat      = 80
let HEIGHT_AFFILIATE_PRODUCT_LIST_CELL: CGFloat             = 60
let HEIGHT_AFFILIATE_PRODUCT_ATTRIBUTE_LIST_CELL:CGFloat                = 30
let HEIGHT_AFFILIATE_PRODUCT_OFFER_SPECIFICATION_CELL:CGFloat           = 30
let HEIGHT_AFFILIATE_OFFER_LIST_CELL:CGFloat                = 170
let HEIGHT_AFFILIATE_REWARDS_LIST_CELL:CGFloat              = 75
let HEIGHT_AFFILIATE_PARTNERS_LIST_CELL:CGFloat             = 100
let HEIGHT_AFFILIATE_LATEST_OFFER_CELL: CGFloat             = 150
let HEIGH_AFFILIATE_CATEGORY_LIST_CELL: CGFloat             = 68
let HEIGH_AFFILIATE_PRODUCT_CELL: CGFloat             = 135
let HEIGHT_AFFILIATE_PRODUCT_IMAGE_CELL : CGFloat   = 120

let HEIGHT_CLASS_LIST_CELL : CGFloat                        = 44
let HEIGHT_AIRPORT_LIST_CELL : CGFloat                      = 44
let HEIGHT_AIRLINE_LIST_CELL : CGFloat      = 44
let HEIGHT_PREFERED_AIRLINE_LIST_CELL : CGFloat      = 44
let HEIGHT_GIVE_UP_CASHBACK_CELL:CGFloat    = 70
let HEIGHT_SAVED_CARD_CELL:CGFloat    = 90

//***************************************************************************


//When text height/Width is not fixed add following extra height/Width into new height.
let SIZE_EXTRA_TEXT: CGFloat                = 15

//MARK VKPOPOVER CONSTANT
//*******************************************************************************
let VK_POPOVER_ANIMATION                    = "POPOVER_ANIMATION_BOTTOM_TO_TOP"
let VK_IMAGE_ZOOMER_ANIMATION               = "IMAGE_ZOOMER_CROSS_DISSOLVE"
let VK_FILTER_ANIMATION                     = "FILTER_ANIMATION_FADE_IN_OUT"
let VK_POPOVER_DURATION:Double              = 0.35        //0.5
let VK_POPOVER_BG_TRANSPARENT:Bool          = false
let VK_POPOVER_BORDER_COLOR                 = COLOUR_GREEN
let VK_POPOVER_BORDER_WIDTH:CGFloat         = 1
let VK_POPOVER_CORNER_RADIUS:CGFloat        = 5
let VK_POPOVER_OUT_SIDE_CLICK_HIDDEN:Bool   = true
//*******************************************************************************

//MARK: CONSTRINT CONSTANT
//******************CONSTRINT CONSTANT******************************************
let CONSTRAINT_TOP                          = "CONSTRAINT_TOP"
let CONSTRAINT_BOTTOM                       = "CONSTRAINT_BOTTOM"
let CONSTRAINT_LEADING                      = "CONSTRAINT_LEADING"
let CONSTRAINT_TRAILING                     = "CONSTRAINT_TRAILING"
let CONSTRAINT_WIDTH                        = "CONSTRAINT_WIDTH"
let CONSTRAINT_HEIGHT                       = "CONSTRAINT_HEIGHT"
let CONSTRAINT_HORIZONTAL                   = "CONSTRAINT_HORIZONTAL"
let CONSTRAINT_VERTICAL                     = "CONSTRAINT_VERTICAL"

let PRIORITY_LOW: UILayoutPriority              = 555
let PRIORITY_HIGH: UILayoutPriority             = 999
//*******************************************************************************

//MARK: CLASS
class DesignModel: NSObject {
    
    //MARK: VARIABLE
    var _VKActivtyIndicator: VKActivtyIndicator?
    
    static let sharedInstance = DesignModel()
    
    class func startActivityIndicator(_ view: UIView) {
        sharedInstance._VKActivtyIndicator?.removeFromSuperview()
        self.startActivityIndicator(view, title: "Loading...")
    }
    
    class func startActivityIndicator(_ view: UIView, title: String) {
        sharedInstance._VKActivtyIndicator = VKActivtyIndicator(title: title)
        view.addSubview(sharedInstance._VKActivtyIndicator!)
    }
    
    class func stopActivityIndicator() {
        sharedInstance._VKActivtyIndicator?.removeFromSuperview()
    }
    
    class func createImageView(_ frame: CGRect, image: UIImage, contentMode: UIViewContentMode) -> UIImageView
    {
        let imageView: UIImageView = UIImageView.init(frame: frame);
        imageView.image = image;
        imageView.contentMode = contentMode;
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, imageName: String, contentMode: UIViewContentMode) -> UIImageView
    {
        let imageView: UIImageView = self.createImageView(frame, image:UIImage(named: imageName)!, contentMode:contentMode);
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, imageName: String, tag: Int, contentMode: UIViewContentMode) -> UIImageView
    {
        let imageView: UIImageView = self.createImageView(frame, image:UIImage(named: imageName)!, tag:tag , contentMode:contentMode);
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, image: UIImage, tag: Int, contentMode: UIViewContentMode) -> UIImageView
    {
        let imageView: UIImageView = self.createImageView(frame, tag:tag, contentMode:contentMode);
        imageView.image = image;
        return imageView;
    }
    
    class func createImageView(_ frame: CGRect, tag: Int, contentMode: UIViewContentMode) -> UIImageView
    {
        let imageView: UIImageView = UIImageView.init(frame: frame);
        imageView.tag = tag;
        imageView.contentMode = contentMode;
        return imageView;
    }

    
    class func createPaddingLabel(frame: CGRect, labelTag: Int, textColor: UIColor, textAlignment: NSTextAlignment, textFont: UIFont, padding: UIEdgeInsets) -> UILabel {
        
        let label:UILabel = UILabel.init(frame: frame)
        
        label.tag = labelTag
        label.textColor = textColor
        label.font = textFont
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        
        return label
    }
   
    
    //MARK: IMAGE METHODS
    class func resizeImageByWidth(_ image: UIImage, width: CGFloat) -> UIImage {
        let imageWidth: CGFloat = image.size.width;
        let imageHeight: CGFloat = image.size.height;
        let newHeight: CGFloat = (imageHeight / imageWidth) * width;
        return self.imageByScalingToSize(image, targetSize: CGSize(width: width, height: newHeight))
    }
    
    class func resizeImageByHeight(_ image: UIImage, height: CGFloat) -> UIImage {
        let imageWidth: CGFloat = image.size.width;
        let imageHeight: CGFloat = image.size.height;
        let newWidth: CGFloat = (imageWidth / imageHeight) * height;
        return self.imageByScalingToSize(image, targetSize: CGSize(width: newWidth, height: height))
    }
    
    class func imageByScalingToSize(_ sourceImage: UIImage, targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 2.0);
        sourceImage.draw(in: CGRect(x: 0, y: 0,width: targetSize.width,height: targetSize.height))
        let generatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return generatedImage;
    }
    
    class func setAffiliateProductListResponse(dict:typeAliasDictionary) {
        UserDefaults.standard.setValue(dict, forKey:NS_AFFILIATE_PRODUCTLIST_RESPONSE)
        UserDefaults.standard.synchronize()
    }
    
    class func getAffiliateProductListResponse() -> typeAliasDictionary {
        var dict = typeAliasDictionary()
        if UserDefaults.standard.object(forKey: NS_AFFILIATE_PRODUCTLIST_RESPONSE) != nil { dict = UserDefaults.standard.object(forKey: NS_AFFILIATE_PRODUCTLIST_RESPONSE) as! typeAliasDictionary }
        return dict
    }

    
    class func getWidthToHeightRatio(width:CGFloat,height:CGFloat) -> CGFloat {
        return width/height
    }
    
    class func getWidthFromHeight(scale:CGFloat , height:CGFloat) -> CGFloat {
        return scale*height
    }
    
    class func getHeightFromWidth(scale:CGFloat , width:CGFloat) -> CGFloat {
        return width/scale
    }
    
    class func createImageButton(_ frame: CGRect, imageName: String, tag: Int) -> UIButton {
        return self.createImageButton(frame, image: UIImage(named: imageName)!, tag: tag)
    }
    
    class func createImageButton(_ frame: CGRect, image: UIImage, tag: Int) -> UIButton {
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.frame = frame
        button.tag = tag
        button.setImage(image, for: UIControlState())
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor.clear
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        return button
    }
    
    class func createImageButton(_ frame: CGRect, unSelectedImage: UIImage, selectedImage: UIImage, tag: Int) -> UIButton {
        let button: UIButton = self.createImageButton(frame, image: unSelectedImage, tag: tag)
        button.setImage(selectedImage, for: UIControlState.selected)
        return button
    }
    
    class func createImageButton(_ frame: CGRect, unSelectedImageName: String, selectedImageName: String, tag: Int) -> UIButton {
        return self.createImageButton(frame, unSelectedImage: UIImage.init(named: unSelectedImageName)!, selectedImage: UIImage(named: selectedImageName)!, tag: tag)
    }
    
    class func createButton(_ frame: CGRect, title: String, tag: Int, titleColor: UIColor, titleFont: UIFont, textAlignment: UIControlContentHorizontalAlignment, bgColor: UIColor, borderWidth: CGFloat, borderColor: UIColor?, cornerRadius: CGFloat) -> UIButton {
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.frame = frame
        button.tag = tag
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
        button.titleLabel?.font = titleFont
        button.contentHorizontalAlignment = textAlignment
        button.backgroundColor = bgColor
        button.layer.cornerRadius = cornerRadius
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        if borderWidth != 0 { button.layer.borderWidth = borderWidth }
        if borderColor != nil { button.layer.borderColor = borderColor!.cgColor }
        
        return button
    }
    
    
    //MARK: NSLAYOUTCONSTRAINT METHODS
    class func setConstraint_ConWidth_ConHeight_Horizontal_Vertical(_ subView: UIView, superView: UIView, width: CGFloat, height: CGFloat) -> typeAliasDictionary {
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth)
        
        //HEIGHT -  CONSTATNT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight)
        
        //HORZONTAL
        let constraintHorizontal: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        superView.addConstraint(constraintHorizontal)
        
        //VERTICAL
        let constraintVertical: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        superView.addConstraint(constraintVertical)
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight,
                CONSTRAINT_HORIZONTAL:constraintHorizontal,
                CONSTRAINT_VERTICAL:constraintVertical]
    }
    
    class func setConstraint_ConWidth_ConHeight_Leading_Top(_ subView: UIView, superView: UIView,leading:CGFloat,top:CGFloat, width: CGFloat, height: CGFloat) -> typeAliasDictionary {
        
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth)
        
        //HEIGHT -  CONSTATNT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight)
        
        //LEADING
        let constraintLeading: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: leading)
        superView.addConstraint(constraintLeading)
        
        //TOP
        let constraintTop: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: top)
        superView.addConstraint(constraintTop)
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight,
                CONSTRAINT_TOP:constraintTop,
                CONSTRAINT_LEADING:constraintLeading]
    }

    class func setScrollSubViewConstraint(_ subView: UIView, superView :UIView, toView: UIView, leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat, width: CGFloat, height: CGFloat) -> typeAliasDictionary {
        
        subView.translatesAutoresizingMaskIntoConstraints  = false;
        
        //LEADING - TO SUPERVIEW
        let constraintLeading: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: leading)
        superView.addConstraint(constraintLeading)
        
        //TRAILING - TO SUPERVIEW
        let constraintTrailing: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: trailing)
        superView.addConstraint(constraintTrailing);
        
        //TOP - TO SUPERVIEW
        let constraintTop: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: top)
        superView.addConstraint(constraintTop);
        
        //BOTTOM - TO SUPERVIEW
        let constraintBottom: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: bottom)
        superView.addConstraint(constraintBottom);
        
        //WIDTH -  CONSTATNT
        let constraintWidth: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: width)
        superView.addConstraint(constraintWidth);
        
        //HEIGHT - CONSTANT
        let constraintHeight: NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: height)
        superView.addConstraint(constraintHeight);
        
        superView.layoutIfNeeded()
        
        return [CONSTRAINT_LEADING:constraintLeading,
                CONSTRAINT_TRAILING:constraintTrailing,
                CONSTRAINT_TOP:constraintTop,
                CONSTRAINT_BOTTOM:constraintBottom,
                CONSTRAINT_WIDTH:constraintWidth,
                CONSTRAINT_HEIGHT:constraintHeight]
    }
}


/*
 
 //MARK: CONSTANT
 
 //MARK: PROPERTIES
 
 //MARK: VARIABLES
 
 //MARK: VIEW METHODS
 
 //MARK: KEYBOARD
 
 //MARK: CUSTOME METHODS
 
 //MARK: UIBUTTON ACTION
 
 //MARK: UITEXTFIELD DELEGATE

 
 */
