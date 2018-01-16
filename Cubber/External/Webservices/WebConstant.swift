//
//  WebConstant.swift
//  Cubber
//
//  Created by Vyas Kishan on 18/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

//MARK:INSTRUCTIONS FOR CHANGE SERVICE LOCAL TO LIVE(VicaVersa) FOR AFFILIATE AND MAIN
/*
 -> CHANGE ROOT FIRST(COMMENT AND UNCOMMENT)
 -> CHANGE SERVICE VERSION (FOR MAIN ONLY FOR PAYMENT GATEWAY)
 -> CHANGE JWEBSERVICE URL AFTER .in or .me
 -> CHNAGE IV AND KEYS (COMMENT AND UNCOMMENT RESPECTIVELY)
 -> CHANGE GOOGLE INFO PLIST (DIFFERENT FOR LOCAL AND LIVE)
 -> CHANGE TRACKING ID IN APP DELEGATE ( 'UA-105052808-1' FOR LOCAL AND 'UA-78834038-1' FOR LIVE)
 -> CHANGE CONTAINER ID FOR GTM IN APP DELEGATE ('GTM-W2FD7FT'FOR LOCAL AND 'GTM-KS6TMJG' FOR LIVE)
 -> CHANGE REVERSED CLIENT ID OF GOOGLE FIREBASE IN URL TYPES
 -> CHANGE CLIENT ID IN FBAndGoogleLogin.swift file
 
*/

import Foundation

//MARK: AFFILIATE LOCAL
//let JWebService_Affiliate = "https://www.cubber.me/Affiliate/V1/CdsbndNewsdfTestJ589/Mnasdkjuwere"


//let IV_FOR_REQ_AFFILIATE     =     "<-==^*\\#@!)}:[{*"
//let KEY_FOR_REQ_AFFILIATE    =     "D%4)-@2#$+--!?<>"
//let IV_FOR_RES_AFFILIATE     =     "^%$*4!&#}:)(][<?"
//let KEY_FOR_RES_AFFILIATE    =     "!#&^*+G}(>??\\/-%"

//MARK:MAIN LOCAL

let JRoot                           = "https://www.cubber.me/"
let JServiceVersion                 = "T802And/V715androidCnPayJKNuwqwelklk/"
let JWebService                     = JRoot + "T802And/V715andrFilekjsMUIowernsdlfusklif/Tkplsn"

//MARK: KEY AND IV LOCAL

let IV_FOR_REQ                      = "<?\"0#%&)28>^$0^9"
let KEY_FOR_REQ                     = "+T*$_-&)*(|\\*$)%"

let IV_FOR_RES                      = "*+_6$0}%!@#!8+^@"
let KEY_FOR_RES                     = "|$)+&^%@5**9#_/*"

let IV_FOR_TREE                     = "|3_T*0&_*>(7NOR!"
let KEY_FOR_TREE                    = "&|TW&8*+_*0E7/=*"

let IV_FOR_PAYU                     = "|D_(C9|&*(0P7I+!"
let KEY_FOR_PAYU                    = "|+5^8@/ M*U9@ #("
 
//MARK:LIVE VERSION 2.0.6

//  live https://www.cubber.in/appboth/v206ioFDnkIOnelpsOlenkNillojeDf/v206ioVRnlPikYuBuye/V206ioFoKnBmoieUkdlkajpokaujenlDje/Tkplsn

//let JRoot                           = "https://www.cubber.in/"
//let JServiceVersion                 = "appboth/v206aCnlkoo_kjrkoiOJpepf/V206ioCnnMiKpwekdfied/"
//let JWebService                     = JRoot + "appboth/v206ioFDnkIOnelpsOlenkNillojeDf/v206ioVRnlPikYuBuye/V206ioFoKnBmoieUkdlkajpokaujenlDje/Tkplsn"

//MARK: KEY AND IV LIVE

//let IV_FOR_REQ                      = "<0&?_).028^>^$01"
//let KEY_FOR_REQ                     = "$_+R*)*(81|$\\*)%"

//let IV_FOR_RES                      = "Zw0_+_}!%#!@97^@"
//let KEY_FOR_RES                     = "-&$)^%+@*~9*#_/*"

//let IV_FOR_TREE                     = "*9|3_~_T*0(O7NR!"
//let KEY_FOR_TREE                    = "1|T&&*8*0+_~7/-*"

//let IV_FOR_PAYU                     = "79|&_(P|D82.(0I+"
//let KEY_FOR_PAYU                    = "|+99@/ M@*U^8 #("


//MARK: LIVE AFFILIAATE PROGRAM V6

let JWebService_Affiliate = "https://affiliate.cubber.in/V6/DFdhejrhjgPfjV6jkkqwqqssdp/odpfgtfnertHV6sd"

let IV_FOR_REQ_AFFILIATE =  "<-==^*\\#@!)}:[{*"
let KEY_FOR_REQ_AFFILIATE = "D%4)-@2#$+--!?<>"
let IV_FOR_RES_AFFILIATE =  "^%$*4!&#}:)(][<?"
let KEY_FOR_RES_AFFILIATE = "!#&^*+G}(>??\\/-%"


//DONT CHANGE THIS PAGE URL

let JTermsConditions                = JRoot + JServiceVersion + "term"
let JPrivacyPolicy                  = JRoot + JServiceVersion + "policy"
let JPaymentGateway                 = JRoot + JServiceVersion + "payUpayment"
let JTree                           = JRoot + JServiceVersion + "AppUserTreeStructure"
let JHelpAndFaq                     = JRoot + JServiceVersion + "faq"
let JUpgradeLimit                   = JRoot + JServiceVersion + "cubberKycForm"

let JNameSpace                      = "http://tempuri.org"
let JMethod_Prefix                  = "ns2624"

let HEADER_DEFAULT                  = "hp/R7xYbycq9wzyGeRwFFbG9mDlL/DgtjY01eeyvUCg="

//MARK: METHOD NAMES

let JMETHOD_IsMobileRegister        = "JMYSTWFFOCYJVKUG"//done
let JMETHOD_homeScreenData          = "RKCNLPQHOUSTSADJ" //done
let JMETHOD_CategoryList            = "FSCSRYLOVLUVDHCE" //done
let JMETHOD_OperatorList            = "TWCKJGLVILUECATH" //done
let JMETHOD_SearchMobile            = "UWUCSEKWCZRSUKQU" //done
let JMETHOD_PlanList                = "ZIMIHBKOGCZLUGOT" //done
let JMETHOD_OpratorPlanList         = "HOASTYQHDXXKWMLM" //done
let JMETHOD_InvitedFriendList       = "QBUTZYJSKIDJMDCB" //done
let JMETHOD_SynchronizeBook         = "TSQJKSXAIUJGTIKH" //done
let JMETHOD_UserRegistration        = "NHOTMUGVRYUKJNID" //done
let JMETHOD_GenerateOtp             = "IZYZCKNNJINYBFGX" //done
let JMETHOD_VerifyOtp               = "GSSONXVYPRQSRIZX" //done
let JMETHOD_UserLogin               = "MKNCSPASNAPBPEXR" //done
let JMETHOD_GetUserWallet           = "USXRMXIAEHWUKHCC" //done
let JMETHOD_GetUsedWallet           = "OCFCFZCAEELUNVXG" //done
let JMETHOD_AppliedCoupon           = "AZCKIUBKMQFFPSND" //done
let JMETHOD_AddOrder                = "IAMZAEUSRDETQZYZ" //done
let JMETHOD_ListUserOrders          = "YKETVQXKTHIHEDPD" //done
let JMETHOD_SingleOrderDetails      = "XNBPHPEDXRJFGDDE" //done
let JMETHOD_UpdateOrderStatus       = "OOLRRIMJGADSRCCN" //done
let JMETHOD_CommissionLevelGraph    = "MJZHTSUXPXZZZOXB" //done
let JMETHOD_UserWalletList          = "RXFOPKJGEUUUSLUM" //done
let JMETHOD_UserNotification        = "SLROZKCPHDYJDSOO" //done
let JMETHOD_GetuserNotificationDetail = "YHSRSLTWUYUBFUJSD" //Remain Same
let JMETHOD_ReadNotification        = "ZPOINORVLISYUTVJ" //done
let JMETHOD_billAmoutCheck          = "OIJJSYYDBFLUVXIY" //done
let JMETHOD_RequestMoney            = "BYOIUQQQDIGROTLG" //done
let JMETHOD_SendMoney               = "GXNMUWMZNVKEHTMC" //done
let JMETHOD_CouponList              = "FTONIWFNRPEFATVH" //done
let JMETHOD_generateInvoice         = "HPFPHRQRYUOYPBYO" //done
let JMETHOD_updateProfile           = "EZUWSHFDEXBJONIA" //done
let JMETHOD_AuthenticatePassword    = "OFVJNIPCBWHWQJSG" //done
let JMETHOD_UpdatePassword          = "RJDNQYKOTYMJPOQO" //done
let JMETHOD_IsReferrelUser          = "ACIDCZLRPJAOXUEO" //done
let JMETHOD_UserLogout              = "KNEBWPTAFDCIQUXR" //done
let JMETHOD_getAllOrderType         = "MAXAEECIPZCYPYBG" //done
let JMETHOD_getUserOrderByOrderType = "DPBKQVOYSRGZBATC" //done
let JMETHOD_registerProblem         = "KIBHSJHIAHAEXNAP" //done
let JMETHOD_GetLatestOrders         = "VXYJEOIUJZGIHNDO" //done
let JMETHOD_GetMenuList             = "KXZOLPZXMJYKFEKD" //done
let JMETHOD_NotificationSetting     = "OFPAPPHIJWQEMRQH" //done
let JMETHOD_InviteFriend            = "QOROWQQLYYTUVZNL" //done
let JMETHOD_GetOrderStatus          = "KDQTPCONEYUUZGPF" //done
let JMETHOD_ToRequestedMoneyList    = "LBOQNGWGUNDBZHJG" //done
let JMETHOD_FromRequestedMoneyList  = "ARTOYZBMCOHGBSZA" //done
let JMETHOD_howToEarnPage           = "AUKVLBRZHLVAJVAD" //done
let JMETHOD_GetDestinationsBasedOnSource    = "XBIQBXNYIMKYBULZ" //done
let JMETHOD_GetSources              = "UELOPIFIFMHGOVGZ" //done
let JMETHOD_GetAvailableRoutes      = "TVOIHZHVCQDTBPIX" //done
let JMETHOD_GetBoardingDropLocationsByCity  = "LZIPFXJZQMYYQNLW" //done
let JMETHOD_GetCancellationPolicy   = "FYEXQFDEOSFJMNIU" //done
let JMETTHOD_GetSeatArrangementDetails = "SSXFRYPVHEQWPCOH" //done
let JMETHOD_GetCancelDetails        = "DZSJDDMSYZNSPWHI" //done
let JMETHOD_ConfirmCancellation     = "SNOKQRDCBVRGEFXA" //done
let JEMTHOD_VerifyEmail             = "PMVIPCJAXNKSWKXY" //done
let JMETHOD_getGallertyList         = "XDOIXTYDSQDINYRP" //done
let JMETHOD_REMOVE_HOME_SLIDER      = "DUJEHNDUDYPPVMDG" //done

let JMETHOD_AffiliatePartner_Click  = "VBVEUMUFKRNOPPDK"; //done
let JMETHOD_AffiliatePartner_list   = "BJCQUDULQAERXOCD"; //done
let JMETHOD_AffiliateOrder_Claim    = "QHNOZECDYFOAZMKJ"; //done
let JMETHOD_AffiliateOrder_List     = "SSSFQPXFWNTYFQRL"; //done
let JMETHOD_AffilateCategoryList    = "SJFEYUCJHSNXVTAD"; //done
let JMETHOD_AffiliateCommission_list = "LLPNFHOCFRKVDWRS"; //done
let JMETHOD_AffiliateStatus_List    = "MJGNWBDYXJPFCJHJ"; //done
let JMETHOD_AffiliatePartner_detail = "SSHRKILDIFKQCHQD" //done

let JMETHOD_GetHomeSlider           = "FMFJRAKIKCQEMPMT" //done
let JMETHOD_GetUserSummary          = "HQASVVEHFRCRLDSL" //done
let JMETHOD_CancelOrderRefund       = "HGNLVBZASWUPTKYR" //done
let JMETHOD_userFeedback            = "PXHPOLSVJVWYLBDN" //done
let JMETHOD_GetEventList            = "UDXOOUSVQNFNPFED" //done
let JMETHOD_GetSingleEventDetail    = "HDRIBOVQDQYSHUBL" //done
let JMETHOD_GetEventInfo            = "CBVECLBOEITIMGCS" //done
let JMETHOD_CheckTickets            = "NWSTBCWOYULNKJJV" //done

//AFFILIATE NEW
let JMETHOD_AffiliateTopPartner_list      = "BJCQUDULQAERXOCD" //done
let JMETHOD_AffilateNewCategory_List      = "SJFEYUCJHSNXVTAD" //done
let JMETHOD_AffilateOffer_List            = "LVGQMSQHMCNRCGWH" //done
let JMETHOD_AffilateLatestOffer_List      = "AITURMUQWLZIPHZR" //done
let JMETHOD_AffilateNewPartner_Detail     = "SSHRKILDIFKQCHQD" //done
let JMETHOD_AffilateNewOffer_Detail       = "ETDUQRJRPSWCRSBO" //done
let JMETHOD_AffilateSearchOffer           = "RJXHMNWEQJMOZNHT" //done
let JMETHOD_AffilateClick                 = "AXVRJRTKHIHWZSWJ"//done
let JMETHOD_AffiliateProductDetail        = "KEIDCLJRZLUFPCNO" //done
let JMETHOD_AffiliateProduct_List         = "TMYWMSGMWLNNAORR" //done
let JMETHOD_AffiliateShare                = "SCMLXDDUVDAQPBBJ" //done

//MARK:GIVEUP

let JMETHOD_SaveGiveup                    = "KDCFREFASNZRZEAP" //done
let JMETHOD_GetGiveUpList                 = "JGAGNTWPTAWSSVRF"//done

//MARK: SAVED CARD SERVICE
let JMETHOD_GetCard                       = "FRIISTLVLHOMVVTR"
let JMETHOD_DeleteCard                    = "VNQLRYBJVVCZOJCU"

//FLIGHT SERVICES

let JMETHOD_getAutoSuggestData            = "DJOLZCOPEZQZCZQV"//done
let JMETHOD_GetFlightList                 = "DXDKJZKAMMUSXYRM"//done
let JMETHOD_verifyTrackCode               = "UABVCZHIUQHJFSXO"//done
let JMETHOD_GetFareRule                   = "UKFPMNNEPMRWARDS"//done
let JMETHOD_flightTicketCancellation      = "IWRYYTAXHGLLVPKL"//done
let JMETHOD_GetFlightClassList            = "AVGRHJTIBDSMNNJP"//done
let JMETHOD_GetFlightPassengerList        = "GJJPJZJLUOQAMIPY"//done
let JMETHOD_GetCountryList                = "HIZPMUOCMZOGMOSU"//done
let JMETHOD_GetVisaTypeList               = "DHFYCUDQORRBZJMO"//done

