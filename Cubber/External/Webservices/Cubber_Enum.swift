//
//  Cubber_Enum.swift
//  Cubber
//
//  Created by Vyas Kishan on 18/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import Foundation

public enum METHOD_TYPE: Int {
    case GET
    case POST
    case PUT
    case DELETE
    case POST2
}

public enum API_STATUS: Int {
    case SUCCESS = 200
    case NEED_TOKEN = 500
    case EXPIRED_TOKEN = 501
    case NOT_EXIST_TOKEN = 502
    case DUMMY
}

public enum SOCIAL_LOGIN: Int {
    case DUMMY
    case GOOGLE
    case FACEBOOK
    case TWITTER
}

public enum SITE_TYPE: Int {
    case DUMMY
    case TERMS_CONDITIONS
    case PRIVACY_POLICY
}

public enum VK_FOOTER_TYPE: Int {
    case HOME
    case WALLET
    case SHOP
    case ACCOUNT
    case MEMBER_TREE
    case NOTIFICATION
}

public enum ACCOUNT_MENU: Int {
    case ORDER
    case TREE
    case REQUEST
    case MEMBERSHIP_FEES
    case HELP_FAQ
    case CONTACT_US
    case HOW_EARN
    case GIVE_UP_CASHBACK
    case SAVED_CARDS
}

public enum RECHARGE_TYPE: Int {
    case DUMMY
    case MOBILE_RECHARGE
    case ADD_MONEY
    case MEMBERSHIP_FEES
    case DTH_RECHARGE
    case ELECTRICITY_BILL
    case GAS_BILL
    case LANDLINE_BROABAND
    case DATA_CARD
    case INSURANCE
    case REFUND
    case OTHER
    case BUS_BOOKING
    case SHOPPING_CASHBACK
    case FLIGHT_BOOKING
    case EVENT
    case DONATE_MONEY
    
}

public enum VK_MENU_TYPE:Int {
    case DUMMY
    case RECHARGE
    case BILL
    case TICKET
    case SHOP
    case INVITE_FRIENDS
    case SHARE_APP
    case RATE_US
    case LOGOUT
    case HOW_TO_EARN
    case OFFERS
    case GALLERY
}

public enum HOME_CATEGORY_TYPE:String {
    case DUMMY              = "0"
    case MOBILE             = "1"
    case DTH                = "2"
    case ELECTRICITY        = "3"
    case GAS                = "4"
    case LANDLINE           = "5"
    case DATACARD           = "6"
    case INSURANCE          = "7"
    case BUSBOOKING         = "8"
    case ADDMONEY           = "14"
    case SENDMONEY          = "15"
    case RECEIVEMONEY       = "16"
    case TRANSACTION        = "17"
    case FLIGHT             = "18"
    case HOTEL              = "19"
    case EVENT              = "20"
    case BROADBAND          = "22"
    case DONATE_MONEY       = "33"
}


public enum REDIRECT_SCREEN_TYPE:String {
    
    case DUMMY                                                 
    case SCREEN_MOBILE                                          = "1"
    case SCREEN_DTH                                             = "2"
    case SCREEN_ELEBILL                                         = "3"
    case SCREEN_GASBILL                                         = "4"
    case SCREEN_LANDLINE                                        = "5"
    case SCREEN_DATACARD                                        = "6"
    case SCREEN_INSURANCE                                       = "7"
    case SCREEN_SENDMONEY                                       = "8"
    case SCREEN_REQUESTMONEY                                    = "9"
    case SCREEN_ADDMONEY                                        = "10"
    case SCREEN_NOTIFICATION                                    = "11"
    case SCREEN_TREE                                            = "12"
    case SCREEN_HOWTOEARN                                       = "13"
    case SCREEN_REQUEST                                         = "14"
    case SCREEN_WALLETLIST                                      = "15"
    case SCREEN_BUS_HOME                                        = "16"
    case SCREEN_AFFILIATE_SHOPPING                              = "17"
    case SCREEN_AFFILIATE_PARTENERDETAIL                        = "18"
    case SCREEN_AFFILIATE_ORDERLIST                             = "19"
    case SCREEN_AFFILIATE_CLAIMORDER                            = "20"
    case SCREEN_OFFER_LIST                                      = "21"
    case SCREEN_MEMBERSHEEP_FEES                                = "22"
    case SCREEN_GALLERY                                         = "23"
    case SCREEN_INVITE_FRIEND                                   = "24"
    case SCREEN_ORDER_SUMMARY                                   = "25"
    case SCREEN_AFFILIATE_OFFERLIST                             = "26"
    case SCREEN_AFFILIATE_OFFERDETAIL                           = "27"
    case SCREEN_AFFILIATE_PARTNERLIST                           = "28"
    case SCREEN_NOTIFICATION_REDIRECT                           = "29"
    case SCREEN_HOME                                            = "30"
    case SCREEN_EVENT                                           = "31"
    case SCREEN_FLIGHT                                          = "33"
    case SCREEN_AFFILIATE_PRODUCT_LIST                          = "34"
    case SCREEN_AFFILIATE_PRODUCT_DETAIL                        = "35"
    case SCREEN_GIVE_UP_CASHBACK                                = "36"
    case SCREEN_DONATE_MONEY                                    = "37"
}

public enum ORDER_STATUS: Int {
    case DUMMY
    case AWAITING
    case PROCESSING
    case SUCCESS
    case FAILED
    case PARTIAL
    case REFUNDED
    case CANCELLED
    case REFUND_TO_BANK
    case QUEUED  = 10
}

public enum REQUESTS_STATUS: Int {
    case DUMMY
    case PENDING
    case SUCCESS
    case FAILED
}

public enum UPDATE_PASSWORD: Int {
    case FORGOT
    case CHANGE
}

public enum FILTER_LIST_TYPE: Int {
    
    case DUMMY
    case BOARDING
    case DROPPING
    case OPERATOR_LIST

}

public enum FILTER_FLIGHT_LIST_TYPE: Int {
    
    case DUMMY
    case DEPARTURE_TIME
    case RETURN_DEPARTURE_TIME
    case NO_OF_STOPS
    case RETURN_NO_OF_STOPS
    case FARE_TYPE
    case MULTIPLE_AIRLINES
    case PREFERED_AIRLINE
}


public enum Model : String {
    case simulator = "simulator/sandbox",
    iPod1          = "iPod 1",
    iPod2          = "iPod 2",
    iPod3          = "iPod 3",
    iPod4          = "iPod 4",
    iPod5          = "iPod 5",
    iPad2          = "iPad 2",
    iPad3          = "iPad 3",
    iPad4          = "iPad 4",
    iPhone4        = "iPhone 4",
    iPhone4S       = "iPhone 4S",
    iPhone5        = "iPhone 5",
    iPhone5S       = "iPhone 5S",
    iPhone5C       = "iPhone 5C",
    iPadMini1      = "iPad Mini 1",
    iPadMini2      = "iPad Mini 2",
    iPadMini3      = "iPad Mini 3",
    iPadAir1       = "iPad Air 1",
    iPadAir2       = "iPad Air 2",
    iPhone6        = "iPhone 6",
    iPhone6plus    = "iPhone 6 Plus",
    iPhone6S       = "iPhone 6S",
    iPhone6Splus   = "iPhone 6S Plus",
    unrecognized   = "?unrecognized?"
}
