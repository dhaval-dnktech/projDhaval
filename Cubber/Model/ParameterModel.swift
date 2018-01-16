
//
//  ParameterModel.swift
//  Cubber
//
//  Created by Vyas Kishan on 16/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit


let PARAMETER_KEY                           = "PARAMETER_KEY"
let PARAMETER_VALUE                         = "PARAMETER_VALUE"
let PARAMETER_MASTER                        = "PARAMETER_MASTER"
let PARAMETER_SLAVE                         = "PARAMETER_SLAVE"
let PARAMETER_POSITION                      = "PARAMETER_POSITION"
let PARAMETER_LIMIT_JOINER                  = "-"
let PARAMETER_IMAGE                         = "PARAMETER_IMAGE"
let PARAMETER_NAME                          = "PARAMETER_NAME"

let LIST_TITLE                              = "LIST_TITLE"
let LIST_ID                                 = "LIST_ID"
let LIST_IMAGE                              = "LIST_IMAGE"
let LIST_LIST                               = "LIST_LIST"
let LIST_FLAG                               = "LIST_FLAG"
let LIST_SUB_LIST                           = "LIST_SUB_LIST"
let LIST_SUB_TITLE                          = "LIST_SUB_TITLE"
let LIST_NSTIMER                            = "LIST_NSTIMER"
let CELL_WIDTH                              = "CELL_WIDTH"

let IS_SHOW_IMAGE                           = "IS_SHOW_IMAGE"
let IS_ACCENDING                            = "IS_ACCENDING"

let IMAGE_UN_SELECTED                       = "IMAGE_UN_SELECTED"
let IMAGE_SELECTED                          = "IMAGE_SELECTED"

let CELL_DATA                               = "CELL_DATA"
let IS_ROW_SPAN                             = "IS_ROW_SPAN"
let IS_COL_SPAN                             = "IS_COL_SPAN"
let CELL_DATA_1                             = "CELL_DATA_1"
let CELL_DATA_2                             = "CELL_DATA_2"
let CELL_NO                                 = "CELL_NO"
let IS_SPACE                                = "IS_SPACE"
let COLUMN                                  = "COLUMN"

let BOARDING_POINT_NAME                     = "BOARDING_POINT_NAME"
let BOARDING_POINT_ID                       = "BOARDING_POINT_ID"
let BOARDING_POINT_TIME                     = "BOARDING_POINT_TIME"

let PASSENGER_NAME                          = "PASSENGER_NAME"
let PASSENGER_AGE                           = "PASSENGER_AGE"
let PASSENGER_GENDER                        = "PASSENGER_GENDER"


let VAL_ORDERTYPE_MOBILE                    = "1"
let VAL_ORDERTYPE_ADD_MONEY                 = "2"
let VAL_ORDERTYPE_MEMBERSHIP_FEES           = "3"
let VAL_ORDERTYPE_DTH                       = "4"
let VAL_ORDERTYPE_ELECTRICITY_BILL          = "5"
let VAL_ORDERTYPE_GAS_BILL                  = "6"
let VAL_ORDERTYPE_LANDLINE                  = "7"
let VAL_ORDERTYPE_DATACARD                  = "8"
let VAL_ORDERTYPE_INSURANCE                 = "9"
let VAL_ORDERTYPE_OTHER                     = "11"
let VAL_ORDERTYPE_BUS_BOOKING               = "12"
let VAL_ORDERTYPE_SHOPPING_CASHBACK         = "13"
let VAL_ORDERTYPE_FLIGHT                    = "14"
let VAL_ORDERTYPE_EVENT                     = "15"



let KEY_VALUE_1                             = "VALUE_1"
let KEY_VALUE_2                             = "VALUE_2"

let VAL_SHOP_NOW                            = 0
let VAL_MY_ORDER                            = 1


let VAL_LOWER_DECK                          = 0
let VAL_UPPER_DECK                          = 1

let VAL_MOBILE                              = 1
let VAL_DTH                                 = 2
let VAL_ELECTRICITY_BILL                    = 3
let VAL_GAS_BILL                            = 4
let VAL_LANDLINE                            = 5
let VAL_DATACARD                            = 6
let VAL_INSURANCE                           = 7
let VAL_BUS_BOOKING                         = 8
let VAL_FLIGHT_BOOKING                      = 14

let VAL_SEND_MONEY                          = 0
let VAL_REQUEST_MONEY                       = 1
let VAL_ADD_MONEY                           = 14

let VAL_SORT_POPULAR                        = 0
let VAL_SORT_TIME                           = 1
let VAL_SORT_DURATION                       = 2
let VAL_SORT_PRICE                          = 3

let VAL_DEVICE_TYPE                         = "2" //0 - web, 1 - android, 2 - iphone
let VAL_RECHARGE_NONE                       = "0"
let VAL_RECHARGE_PREPAID                    = "1"
let VAL_RECHARGE_POSTPAID                   = "2"
let VAL_RECHARGE_PREPAID_CAPTION            = "Prepaid"
let VAL_RECHARGE_POSTPAID_CAPTION           = "Postpaid"

let VAL_ORDER_STATUS_AWAITING               = "AWAITING"
let VAL_ORDER_STATUS_SUCCESS                = " SUCCESS "
let VAL_ORDER_STATUS_FALIED                 = " FAIL "
let VAL_ORDER_STATUS_PROCESSING             = " PROCESSING "

let VAL_SHOPPING_PARTNERS                   = 0
let VAL_SHOPPING_OFFERS                     = 1
let VAL_SHOPPING_PRODUCT                    = 2

let VAL_OFFER                               = 0
let VAL_TERMS                               = 1
let VAL_REWARDS                             = 2


let VAL_STATUS_FAIL                         = "0"
let VAL_STATUS_SUCCESS                      = "1"
let VAL_STATUS_AUTHENTICATION_FAIL          = "2"

let VAL_SERVICE_STATIC                      = "@"

let RUPEES_SYMBOL                           = "₹"

let KEY_DESCRIPTION                         = "description"

let APNS_APS                                = "aps"
let APNS_SOUND                              = "sound"
let APNS_CONTENT_AVAILABLE                  = "content-available"
let APNS_ALERT                              = "alert"
let APNS_MESSAGE                            = "message"

//cubber://OrderDetail?userID=11536&orderID=42
let SCHEME_CUBBER                           = "CUBBER"
let HOST_ORDER_DETAIL                       = "ORDERDETAIL"
let HOST_REFERRAL                           = "REFERRER"

typealias typeAliasDictionary               = [String: AnyObject]
typealias typeAliasStringDictionary         = [String: String]

let KEY_DEPARTURE_TIME              = "DEPARTURE_TIME"
let KEY_BUS_TYPE                    = "BUS_TYPE"
let KEY_BOARDING_POINT              = "BOARDING_POINT"
let KEY_DROPPING_POINT              = "DROPPING_POINT"
let KEY_BUS_OPERATOR                = "BUS_OPERATOR"
let KEY_PRICE_RANGE                 = "PRICE_RANGE"
let KEY_FILTER_TYPE                 = "FILTER_TYPE"
let KEY_NAME                        = "NAME"
let KEY_ID                          = "ID"
let KEY_VALUE                       = "VALUE"

//GOOGLE ANALYTIC TRACKING SCREEN NAMES

let APPNAME                                 = "Cubber"
let MAIN_CATEGORY                           = APPNAME + "(iOS)"
let SCREEN_SPLASH                           = "Splash"
let SCREEN_HOME                             = "Home"
let SCREEN_WALLET                           = "Wallet"
let SCREEN_USEROFFERNOTIFICATION            = "OfferNotification"
let SCREEN_INVITEFRIENDS                    = "InviteFriends"
let FAST_FORWARD                            = "Fast Forward"
let SCREEN_OFFERANDPROMOCODE                = "Offer & Promocode"
let SCREEN_COMPLETEPAYMENT                  = "Complete Payment"
let SCREEN_ORDERSUMMARY                     = "Order Summary"
let APPFEEDBACK                             = "App Feedback"
let SCREEN_CHANGEPASSWORD                   = "ChangePassword"
let SCREEN_HELP                             = "Help & FAQ"
let SCREEN_SHARE_APP                        = "Share App"
let SCREEN_ORDERPROBLEM                     = "Order Problem"
let SCREEN_PICKANORDER                      = "Pick an Order"
let SCREEN_PROFILE                          = "Profile"
let SCREEN_TRANSACTION                      = "Transaction"
let TREEPOSITION                            = "Connects"
let YOURORDERS                              = "OrderList"
let YOURREQUESTS                            = "Requests"
let PROFILE                                 = "Profile"
let CONTACTUS                               = "Contact US"
let EDITPROFILE                             = "Edit Profile"
let FORGOTPASSWORD                          = "Forgot Password"
let HOWTOEARN                               = "How To Earn"
let UPDATE_VERSION                          = "Update Version"
let COMMISSIONLEVEL_GRAPH                   = "Commission Level Graph"
let HOME_HEADER_WALLET_CLICK                = "Home Header Wallet Click"
let HOME_HEADER_USERDATA_CLICK              = "Home Header UserData Click"
let PAY_MEMBERSHIPFEES                      = "Pay Membership fees"
let LOGOUT                                  = "Logout"
let OPTION_MENU                             = "Option Menu"
let PROCESSTORECHARGE                       = "Process To Recharge"
let SENDMONEY                               = "Send Money"
let APPLYCOUPON                             = "Apply Coupon"
let ADDORDER                                = "Add Order"
let SCREEN_DONATE_MONEY                     = "Donate Money"

//Home
let SCREEN_HOME_MOBILE                      = "MOBILE"
let SCREEN_HOME_DTH                         = "DTH"
let SCREEN_HOME_ELEBILL                     = "ELEBILL"
let SCREEN_HOME_GASBILL                     = "GASBILL"
let SCREEN_HOME_LANDLINE_BROADBAND          = "LANDLINE / BROADBAND"
let SCREEN_HOME_DATACARD                    = "DATACARD"
let SCREEN_HOME_INSURANCE                   = "INSURANCE"
//Wallet
let SCREEN_WALLET_SENDMONEY                 = "SENDMONEY"
let SCREEN_WALLET_REQUESTMONEY              = "REQUESTMONEY"
let SCREEN_WALLET_ADDMONEY                  = "ADDMONEY"
//ACCOUNT
let SCREEN_ACCOUNT                          = "ACCOUNT"
//Notification
let SCREEN_NOTIFICATION                     = "NOTIFICATION"
//Login
let SCREEN_LOGIN                            = "LOGIN"
//SignUp
let SCREEN_SIGNUP                           = "SIGNUP"
//InviteFriend
let SCREEN_INVITEFRIEND                     = "INVITEFRIEND"


let GTM_MOBILE_RECHARGE                     = "Mobile Recharge"
let GTM_DTH_RECHARGE                        = "Dth Recharge"
let GTM_ELE_BILL_PAY                        = "Electricity Bill Pay"
let GTM_GAS_BILL_PAY                        = "Gas Bill Pay"
let GTM_LANDLINE_BILL_PAY                   = "Landline/Broadband Bill Pay"
let GTM_DATACARD_RECHARGE                   = "Datacard Recharge"
let GTM_INSUARANCE_BILL_PAY                 = "Insurance Bill Pay"
let GTM_BUS                                 = "Bus"
let GTM_BUS_BOOKING                         = "Bus Booking"
let GTM_ADDMONEY                            = "Add Money"
let GTM_MEMBERSHIP                          = ""
let GTM_EE_TYPE_RECHARGE                    = "Recharge"
let GTM_EE_TYPE_BILL                        = "Bill Pay"
let GTM_EE_TYPE_WALLET                      = "Wallet"
let GTM_USER_PRIME                          = "Prime User"
let GTM_USER_NON_PRIME                      = "Non Prime User"
let GTM_EVENT                               = "Event"
let GTM_EVENT_BOOKING                       = "Event Booking"
let GTM_DONATE_MONEY                        = "Donate Money"
let GTM_FLIGHT                              = "Flight"
let GTM_FLIGHT_BOOKING                      = "Flight Booking"
let GTM_EE_TYPE_DONATE_MONEY                = "Donate Money"



let GTM_ee_type                             = "ee_type"
let GTM_ecommerce                           = "ecommerce"
let GTM_currencyCode                        = "currencyCode"
let GTM_detail                              = "detail"
let GTM_actionField                         = "actionField"
let GTM_list                                = "list"
let GTM_products                            = "products"
let GTM_name                                = "name"
let GTM_id                                  = "id"
let GTM_price                               = "price"
let GTM_brand                               = "brand"
let GTM_variant                             = "variant"
let GTM_category                            = "category"
let GTM_quantity                            = "quantity"
let GTM_dimension3                          = "dimension3"
let GTM_dimension4                          = "dimension4"
let GTM_dimension5                          = "dimension5"
let GTM_dimension6                          = "dimension6"
let GTM_dimension7                          = "dimension7"
let GTM_dimension10                         = "dimension10"
let GTM_dimension11                         = "dimension11"
let GTM_dimension12                         = "dimension12"
let GTM_checkout                            = "checkout"
let GTM_step                                = "step"
let GTM_option                              = "option"
let GTM_usedwallet                          = "usedwallet"
let GTM_cashback_discount                   = "cashback/discount"
let GTM_coupon                              = "coupon"
let GTM_position                            = "position"



//FIREBASE SCRREN NAME

let FIR_SELECT_CONTENT                      = "FIR_SELECT_CONTENT"
 let F_MODULE_BUS                           = "Bus";
 let F_MODULE_AFFILIATE                     = "Affiliate";
 let F_MODULE_MOBILE                        = "Mobile";
 let F_MODULE_DTH                           = "DTH";
 let F_MODULE_ELE                           = "Electricity bill";
 let F_MODULE_GAS                           = "GAS bill";
 let F_MODULE_LANDLINE                      = "LandLine / Broadband";
 let F_MODULE_DATACARD                      = "Datacard";
 let F_MODULE_INSURANCE                     = "Insurance";
 let F_MODULE_ADDMONEY                      = "Add Money";
 let F_MODULE_REQUESTMONEY                  = "Request Money";
 let F_MODULE_SENDMONEY                     = "Send Money";
 let F_MODULE_ACCOUNT                       = "Account";
 let F_MODULE_WALLET                        = "Wallet";
 let F_MODULE_HOME                          = "Home";
 let F_MODULE_EVENT                         = "Event";
 let F_MODULE_FLIGHT                         = "Flight"

let F_FLIGHT_BOOKING                        = "Flight Home";
let F_FLIGHT_ALLBUSLIST                     = "Flight Listing";
let F_FLIGHT_PASSENGERDETAIL                = "Flight Passenger Detail";
let F_FLIGHT_SELECT_JOURNEYLOCATION         = "Flight Select Journey Location";
let F_FLIGHT_SELECT_SEAT                    = "Flight Review";
let F_FLIGHT_ADD_PASSENGER                  = "Add Passenger";
let F_FLIGHT_CANCEL_TICKET                  = "Cancel Flight Ticket"

//Bus
 let F_BUS_BOOKING                          = "Bus Home";
 let F_BUS_CONFIRMBOOKING                   = "Bus Confirm Booking";
 let F_BUS_ALLBUSLIST                       = "Bus Listing";
 let F_BUS_PASSENGERDETAIL                  = "Bus Passenger Detail";
 let F_BUS_REFINE                           = "Bus Refine";
 let F_BUS_SELECT_JOURNEYLOCATION           = "Bus Select Journey Location";
 let F_BUS_SELECT_POINTLOCATION             = "Bus Select Point Location";
 let F_BUS_SELECT_SEAT                      = "Bus Select Seat";
 let F_BUS_LOWERDESK                        = "Bus Lower Desk";
 let F_BUS_UPPERDESK                        = "Bus Upper Desk";
//Other
 let F_BROWSEPLAN                           = "Browse Plan";
 let F_CHANGEPASSWORD                       = "Change Password";
 let F_CONTACT_US                           = "Contact Us";
 let F_EDITPROFILE                          = "Edit Profile";
 let F_FORGOTPASSWORD                       = "Forgot Password";
 let F_HELPANDFAQ                           = "Help & FAQ";
 let F_HOWTOEARN                            = "How To Earn";
 let F_INVITEFRIEND                         = "Invite Friend";
 let F_INVOICE                              = "Invoice";
 let F_LOGIN                                = "Login";
 let F_HOME                                 = "Home Tab";
//Home Category3

 let F_HOME_MOBILE                          = "Mobile";
 let F_HOME_DTH                             = "Dth";
 let F_HOME_ELE                             = "Electricity bill";
 let F_HOME_GAS                             = "Gas bill";
 let F_HOME_LANDLINE                        = "Broadband & Landline";
 let F_HOME_DATACARD                        = "Datacard";
 let F_HOME_INSURANCE                       = "Insurance";
//Wallet Category

 let F_WALLET_ADDMONEY                      = "AddMoney";
 let F_WALLET_SENDMONEY                     = "SendMoney";
 let F_WALLET_REQUESTMONEY                  = "RequestMoney";

let F_MEMBERSHIP_FEES                       = "Membership Fees"
 let F_WALLET                               = "Wallet Tab";
 let F_SHOPPING                             = "Shopping Tab";
 let F_ACCOUNT                              = "Account Tab";
 let F_TREE                                 = "Connects Tab";
 let F_NOTIFICATIONLIST                     = "Notification List";
 let F_NOTIFICATIONDETAIL                   = "Notification Detail";
 let F_NOTIFICATIONSETTING                  = "Notification Setting";
 let F_OFFERANDPROMOCODE                    = "Offer & Promo code";
 let F_ORDERSUMMARY                         = "Order Summary";
 let F_ORDERPROBLEM                         = "Order Problem";
 let F_ORDERPROCESS                         = "Order Process";
 let F_PICKORDER                            = "Pick Order";
 let F_PROFILE                              = "Profile";
 let F_REQUESTLIST                          = "Requests List";
 let F_REQUEST_CONATCT                      = "Requests List";
 let F_REQUEST_YOUR                         = "Your Requests List";
 let F_SELECTLOCATION                       = "Select Location";
 let F_OPERATORLIST                         = "Operator List";
 let F_SELECTPARENT                         = "Select Parent";
 let F_SIGNUP2                              = "Complete SignUp";
 let F_SIGNUP                               = "SignUp";
 let F_SPLASH                               = "Splash";
let F_INTRO                                 = "Intro"
 let F_TRANSACTION                          = "Wallet Transaction";
 let F_TREE_POSITION                        = "Connects";
 let F_UPGRADE_WALLET                       = "Upgrade Wallet";
 let F_ORDERLIST                            = "OrderList";
 let F_ALLORDER                             = "All Order";
 let F_CONTACTBOOK                          = "Contact book";
 let F_PENDINGREQUESTS                      = "Pending Requests";
//Affiliate

let F_AFFILIATE_HOME                       = "Affiliate Home";
let F_AFFILIATE_PARTNERLIST                = "Affiliate PartnerList";
let F_AFFILIATE_PRODUCTLIST                = "Affiliate ProductList";
let F_AFFILIATE_ORDERLIST                  = "Affiliate OrderList";
let F_AFFILIATE_OFFER_DETAIL               = "Affiliate Offer Detail";
let F_AFFILIATE_CLAIMORDER                 = "Affiliate Claim Order";
let F_AFFILIATE_PARTNERDETAIL              = "Affiliate Partner Detail";
let F_AFFILIATE_PRODUCTDETAIL               = "Affiliate Product Detail";
let F_AFFILIATE_OFFERLIST                  = "Affiliate OfferList";
let F_AFFILIATE_SHOPANDEARN                = "Shop & Earn";
let F_AFFILIATE_INSTALLAPP                 = "Install ";
let F_AFFILIATE_SEARCHOFFER                = "Search offer";
let F_AFFILIATE_REWARDS                    = "Rewards";
let F_AFFILIATE_TERMS                      = "Terms";

 let F_HOME_TAB                             = "Home_Tab";
 let F_Account_Tab                          = "Account_Tab";
 let F_MemberTree_Tab                       = "Connects_Tab";
 let F_Shopping_Tab                         = "Shopping_Tab";
 let F_Wallet_Tab                           = "Wallet_Tab";


class ParameterModel: NSObject {
    
    class func getAdultList() -> [String]{
        return ["1","2","3","4","5","6","7","8","9"]
    }
    
    class func getChildrenList() -> [String]{
        return ["0","1","2","3","4","5","6","7","8"]
    }
    
    class func getInfantsList() -> [String]{
        return ["0","1","2","3","4"]
    }
    
    class func getAirlineList() -> [typeAliasDictionary]{
        
        let dict = [PARAMETER_KEY:"0",PARAMETER_VALUE:"IS_REFUNDABLE",PARAMETER_NAME:"Refundable flights only"]
        let dict1 = [PARAMETER_KEY:"1",PARAMETER_VALUE:"IS_MULTI",PARAMETER_NAME:"Hide multi-airline itineraries"]
        return [dict as Dictionary<String, AnyObject>,dict1 as Dictionary<String, AnyObject>]
    }
    
    class func getDepartureReturnTimeList() -> [typeAliasDictionary]{
        
        let dict = [PARAMETER_IMAGE:"icon_sunrise",PARAMETER_KEY:"0",PARAMETER_VALUE:"00:00-10:59", PARAMETER_NAME:"Before 11 AM"]
        let dict1 = [PARAMETER_IMAGE:"icon_afternoon",PARAMETER_KEY:"1",PARAMETER_VALUE:"11:00-17:00", PARAMETER_NAME:"11 AM - 5 PM"]
        let dict2 = [PARAMETER_IMAGE:"icon_sunrise",PARAMETER_KEY:"2",PARAMETER_VALUE:"17:00-21:00", PARAMETER_NAME:"5 PM - 9 PM"]
        let dict3 = [PARAMETER_IMAGE:"icon_evening",PARAMETER_KEY:"3",PARAMETER_VALUE:"21:01-23:59", PARAMETER_NAME:"After 9 PM"]
        return [dict as Dictionary<String, AnyObject>,dict1 as Dictionary<String, AnyObject>,dict2 as Dictionary<String, AnyObject>,dict3 as Dictionary<String, AnyObject>]
        
    }
    
    class func getDepartureReturnStopList() -> [typeAliasDictionary]{
        
        let dict = [PARAMETER_KEY:"0",PARAMETER_VALUE:"0",PARAMETER_NAME:"Non Stop"]
        let dict1 = [PARAMETER_KEY:"1",PARAMETER_VALUE:"1",PARAMETER_NAME:"1 Stop"]
        let dict2 = [PARAMETER_KEY:"2",PARAMETER_VALUE:"2+",PARAMETER_NAME:"2+ Stop"]
        return [dict as Dictionary<String, AnyObject>,dict1 as Dictionary<String, AnyObject>,dict2 as Dictionary<String, AnyObject>]
        
    }

}
