//
//  OperationWeb.swift
//  Cubber
//
//  Created by Vyas Kishan on 18/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
//import CryptoSwift

class OperationWeb: NSObject, XMLParserDelegate , VKAlertActionViewDelegate , KDAlertViewDelegate {
    
    //MARK: VARIABLES

    internal var resultURL: URL!
    internal var _methodName: String!
    var _methodType:METHOD_TYPE = METHOD_TYPE.POST
    var _Parameters:typeAliasStringDictionary = typeAliasStringDictionary()
    var activityParent:UIView = UIView.init(frame: CGRect.zero)
    var isAffiliate:Bool = false
    internal var theRequest: URLRequest!
    internal var theSession = URLSession()
    fileprivate var jsonResponse: String!
    let _KDAlertView = KDAlertView()
    fileprivate var isCancel:Bool = false
    
    var task:URLSessionDataTask?
    //MARK: METHODS

    func callRestApi(methodName:String ,methodType: METHOD_TYPE, isAddToken: Bool, parameters: typeAliasStringDictionary, viewActivityParent: UIView, onSuccess: @escaping (_ dictServiceContent: typeAliasDictionary) -> Void, onFailure: @escaping (_ errorCode: Int , _ dict:typeAliasDictionary) -> Void, onTokenExpire: @escaping () -> Void) {
        
        _methodName = methodName
        _methodType = methodType
        activityParent = viewActivityParent
        _Parameters = parameters
        isAffiliate = false
        
        if currentReachabilityStatus == .notReachable { onTokenExpire() ; return}
        
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        DesignModel.startActivityIndicator(viewActivityParent)
        let stUrl: String = JWebService
        
        var params = parameters
        params[REQ_SERVICE_NAME] = methodName
        var stPostData = ""
        params[REQ_RANDOM] = String(self.generateRandomDigits(6))
        if !DataModel.getUserInfo().isEmpty { params[REQ_USER_ID] = (DataModel.getUserInfo()[RES_userID] as! String) }
        if methodName == JMETHOD_updateProfile || methodName == JMETHOD_registerProblem {
            params.removeValue(forKey: REQ_U_IMAGE)
        }
        for (pKey, pvalue) in params { params[pKey] = self.getcodeforkeys(pvalue)}
        var stJson = (params.convertToJSonString()).trim()
        stJson = self.removeSpecialCharsFromString(text: stJson)
        //print(stJson)
        do {
            let aes = try AES(key:KEY_FOR_REQ , iv:IV_FOR_REQ) // aes128
            let encrypted = try aes.encrypt([UInt8](stJson.utf8))
            stJson = encrypted.toHexString()
            print("Encryptedd :  \(stJson.trim()) \n\n")
            //let decrypted = try aes.decrypt([UInt8](stJson.toHexBytes()))
             //print("Decrypted : \(txtDecrypted)")
        } catch {
            print(error)
        }
        stPostData = "details=\(stJson)"
        
        var stMethodName: String = ""
        switch methodType {
        case .GET:
            stMethodName = "GET"    //Encode url paramters into view controller
            self.theRequest = URLRequest(url: URL(string: stUrl)!)
            self.theRequest.httpMethod = stMethodName
            self.theRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            self.theRequest.addValue("no-cache", forHTTPHeaderField: "cache-control")
            break
            
        case .POST:
            stMethodName = "POST"
            self.theRequest = URLRequest(url: stUrl.convertToUrl())
            self.theRequest.httpMethod = stMethodName
            self.theRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            self.theRequest.addValue("no-cache", forHTTPHeaderField: "cache-control")
            var postData = stPostData.data(using: .utf8)
            if methodName == JMETHOD_updateProfile || methodName == JMETHOD_registerProblem{
                if !(parameters[REQ_U_IMAGE]! as String).isEmpty {
                    var stImage = parameters[REQ_U_IMAGE]!
                    postData?.append("&\(REQ_U_IMAGE)=\(stImage.encode())".data(using: .utf8)!)
                 }
               }
            
            self.theRequest.httpBody = postData
            break
        default:
            break
        }
        self.theRequest.timeoutInterval = 9999999
        self.theSession = URLSession.shared
        
         task = self.theSession.dataTask(with: self.theRequest, completionHandler: { (data, response, error) -> Void in
            print("\(methodName) : \(stUrl) \n")
            DispatchQueue.main.async(execute: {
                do {
                    
                    if self.isCancel { self.isCancel =  false ; return }
                    
                    if data != nil {
                        obj_AppDelegate.isFirstServiceCall = false
                        let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        if dict is Dictionary<AnyHashable,Any> {
                            
                        }
                        else if dict is Array<Any> {
                            
                        }
                        
                        let dictContent: typeAliasDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! typeAliasDictionary
                        DesignModel.stopActivityIndicator()
                        let stResponse = dictContent[RES_Response] as! String
                       var jsonResponse = ""
                        
                        do {
                            let aes = try AES(key: KEY_FOR_RES, iv: IV_FOR_RES)// aes128
                            let decrypted = try aes.decrypt([UInt8](stResponse.toHexBytes()))
                            jsonResponse = (String.init(bytes: decrypted, encoding: .utf8)?.trim())!
                            jsonResponse = jsonResponse.replace("\0", withString: "")
                        } catch {
                            print(error)
                        }
                        if jsonResponse != "" {
                            print("JSON RESPONSE : \(jsonResponse)\n\n")
                            var dictResponse = jsonResponse.convertToDictionary2()
                            dictResponse  = DataModel.removeNullFromDictionary(dictionary: dictResponse)
                           // print("Response:\(dictResponse) \n")
                            let status: String = String(describing: dictResponse[RES_status]!)
                                if status == VAL_STATUS_SUCCESS {
                                    onSuccess(dictResponse)
                                }
                                else if status == VAL_STATUS_FAIL{
                                    onFailure(0,dictResponse)
                                }
                                else if status == VAL_STATUS_AUTHENTICATION_FAIL {
                                   self._KDAlertView.showMessage(message: DataModel.getLogoutNote(), messageType: .WARNING)
                                    self._KDAlertView.didClick(completion: { (clicked) in
                                        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                        obj_AppDelegate.performLogout()
                                    })
                                }
                            }
                    }
                    else {
                        DesignModel.stopActivityIndicator()
                        if obj_AppDelegate.isFirstServiceCall {
                            self._KDAlertView.showMessage(message: DataModel.getCubberMaintananceMessage() != "" ? DataModel.getCubberMaintananceMessage() : "App is Under Maintanance! Please Try Later.", messageType: .WARNING)
                             self._KDAlertView.alertDelegate = self
                        }
                        else {
                            if self.isCancel { self.isCancel =  false ; return }
                            self._KDAlertView.showMessage(message:MSG_ERR_CONNECTION, messageType: .WARNING)
                            print("Nil Data")
                        }
                    }
                } catch {
                    if self.isCancel { self.isCancel =  false ; return }
                    self._KDAlertView.showMessage(message: MSG_ERR_SOMETING_WRONG, messageType: .WARNING)
                    print("Json Parsing Error \(error.localizedDescription)")
                    DesignModel.stopActivityIndicator()
                }
            })
        })
        task!.resume()
    }
    
    //MARK: REST API
    
   func callRest_Affiliate_Api(methodName:String ,methodType: METHOD_TYPE, isAddToken: Bool, parameters: typeAliasStringDictionary, viewActivityParent: UIView, onSuccess: @escaping (_ dictServiceContent: typeAliasDictionary) -> Void, onFailure: @escaping (_ errorCode: Int , _ dict:typeAliasDictionary) -> Void, onTokenExpire: @escaping () -> Void) {
        
        _methodName = methodName
        _methodType = methodType
        activityParent = viewActivityParent
        _Parameters = parameters
        isAffiliate = true
        
        if currentReachabilityStatus == .notReachable {
            onTokenExpire(); return
        }
        
        DesignModel.startActivityIndicator(viewActivityParent)
        let stUrl: String = JWebService_Affiliate
        
        var params = parameters
        params[REQ_SERVICE_NAME] = methodName
        var stPostData = ""
        params[REQ_RANDOM] = String(self.generateRandomDigits(6))
        if methodName == JMETHOD_updateProfile || methodName == JMETHOD_registerProblem {
            params.removeValue(forKey: REQ_U_IMAGE)
        }
        for (pKey, pvalue) in params { params[pKey] = self.getcodeforkeys(pvalue)}
        var stJson = (params.convertToJSonString()).trim()
        stJson = self.removeSpecialCharsFromString(text: stJson)
    
        do {
            let aes = try AES(key:KEY_FOR_REQ_AFFILIATE , iv:IV_FOR_REQ_AFFILIATE) // aes128
            let encrypted = try aes.encrypt([UInt8](stJson.utf8))
            stJson = encrypted.toHexString()
            print("Encryptedd :  \(stJson.trim()) \n\n")
        } catch {
            print(error)
        }
        stPostData = "details=\(stJson)"
        
        
        
        var stMethodName: String = ""
        switch methodType {
        case .GET:
            stMethodName = "GET"    //Encode url paramters into view controller
            self.theRequest = URLRequest(url: URL(string: stUrl)!)
            self.theRequest.httpMethod = stMethodName
            self.theRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            self.theRequest.addValue("no-cache", forHTTPHeaderField: "cache-control")
            break
            
        case .POST:
            stMethodName = "POST"
            self.theRequest = URLRequest(url: stUrl.convertToUrl())
            self.theRequest.timeoutInterval = 180
            self.theRequest.httpMethod = stMethodName
            self.theRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            self.theRequest.addValue("no-cache", forHTTPHeaderField: "cache-control")
            var postData = stPostData.data(using: .utf8)
            if methodName == JMETHOD_updateProfile || methodName == JMETHOD_registerProblem {
                if !(parameters[REQ_U_IMAGE]! as String).isEmpty {
                    var stImage = parameters[REQ_U_IMAGE]!
                    postData?.append("&\(REQ_U_IMAGE)=\(stImage.encode())".data(using: .utf8)!)
                }
            }
            self.theRequest.httpBody = postData
            break
            
        default:
            break
        }
        
        self.theSession = URLSession.shared
        
        let task = self.theSession.dataTask(with: self.theRequest, completionHandler: { (data, response, error) -> Void in
            print("\(methodName) : \(stUrl) \n")
            DispatchQueue.main.async(execute: {
                do {
                    if data != nil {
                        let dictContent: typeAliasDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! typeAliasDictionary
                        DesignModel.stopActivityIndicator()
                        let stResponse = dictContent[RES_Response] as! String
                        var jsonResponse = ""
                        
                        do {
                            let aes = try AES(key: KEY_FOR_RES_AFFILIATE, iv: IV_FOR_RES_AFFILIATE)// aes128
                            let decrypted = try aes.decrypt([UInt8](stResponse.toHexBytes()))
                            jsonResponse = (String.init(bytes: decrypted, encoding: .utf8)?.trim())!
                            jsonResponse = jsonResponse.replace("\0", withString: "")
                        } catch {
                            print(error)
                        }
                        if jsonResponse != "" {
                            print("JSON RESPONSE : \(jsonResponse) \n\n")
                            let dictResponse = jsonResponse.convertToDictionary2()
                            let status: String = dictResponse[RES_status] as! String
                           // let status: String = String(describing: dictResponse[RES_status]!)
                            if status == VAL_STATUS_SUCCESS{
                                onSuccess(dictResponse)
                            }
                            else if status == VAL_STATUS_FAIL{
                                onFailure(0,dictResponse)
                            }
                            else if status == VAL_STATUS_AUTHENTICATION_FAIL {
                                
                                self._KDAlertView.showMessage(message: DataModel.getLogoutNote(), messageType: .WARNING)
                                self._KDAlertView.didClick(completion: { (clicked) in
                                    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                    obj_AppDelegate.performLogout()
                                })
                            }
                        }
                    }
                    else {
                        DesignModel.stopActivityIndicator()
                        self._KDAlertView.showMessage(message:MSG_ERR_CONNECTION, messageType: .WARNING)
                    }
                } catch {
                    
                    self._KDAlertView.showMessage(message: MSG_ERR_SOMETING_WRONG, messageType: .WARNING)
                    print("Json Parsing Error")
                    DesignModel.stopActivityIndicator()
                    
                }
            })
        })
        task.resume()
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_{}\\/\"@#$%^&[]|")
        return String(text.filter {okayChars.contains($0) })
    }
    
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }

    func getcodeforkeys(_ stCode: String) -> String {
        var st_Code: String = stCode
        st_Code = st_Code.replace("&", withString: "&amp;")
        st_Code = st_Code.replace("<", withString: "&lt;")
        st_Code = st_Code.replace(">", withString: "&gt;")
        st_Code = st_Code.replace("'", withString: "&apos;")
        st_Code = st_Code.replace("\"", withString: "&quot;")
        return stCode
    }
    
    func vkYesNoAlertAction(_alertType: ALERT_TYPE, buttonIndex: Int, buttonTitle: String) {
        if _alertType == .LOGOUT {
            if buttonIndex == 0{
                let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                obj_AppDelegate.performLogout()
            }
        }
        else if _alertType == .APP_MAINTENANCE {
            let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            DataModel.setDictServiceUpdate(typeAliasDictionary())
            obj_AppDelegate.setServiceUpdateData(dictServiceUpdate: typeAliasDictionary())
            obj_AppDelegate.restartApp()
        }
    }
    
    func vkActionSheetAction(_ actionSheetType: ACTION_SHEET_TYPE, buttonIndex: Int, buttonTitle: String) {
        
    }
   /* func NoConnectionAlertView_btnRetryAction(view:UIView) {
        
        if currentReachabilityStatus != .notReachable {
            view.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                obj_AppDelegate.restartApp()
            }
        }
        else{
            let _VKAlertActionView = VKAlertActionView.init()
            _VKAlertActionView.showOkAlertView("We can not detect any internet connectivity. Please check your internet connection and try again. ", alertType: .LOGOUT, object: "No Connection", isCallDelegate: false)
            _VKAlertActionView.delegate = self
            return
        }
    }*/
    
    func messageOkAction() {
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        DataModel.setDictServiceUpdate(typeAliasDictionary())
        obj_AppDelegate.setServiceUpdateData(dictServiceUpdate: typeAliasDictionary())
        obj_AppDelegate.restartApp()
    }
    
    func cancelTask() {
        isCancel = true
        task?.cancel()
    }
}
