//
//  VKAlertActionView.swift
//  BusinessCard
//
//  Created by Vyas Kishan on 09/11/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

public enum ALERT_TYPE: Int {
    case DUMMY
    case ADD_TO_CART
    case REMOVE_CART
    case ADD_TO_CART_SINGLE
    case REMOVE_CART_SINGLE
    case PLACE_ORDER
    case LOGOUT
    case GO_TO_CART
    case EXCEL
    case PDF
    case APP_MAINTENANCE
}

public enum ACTION_SHEET_TYPE :Int
{
    case ACTION_SHEET_DUMMY
    case ACTION_SHEET_MORE
    case ACTION_SHEET_EMAIL
}

protocol VKAlertActionViewDelegate
{
    func vkActionSheetAction(_ actionSheetType: ACTION_SHEET_TYPE, buttonIndex: Int, buttonTitle: String)
    func vkYesNoAlertAction(_alertType: ALERT_TYPE , buttonIndex:Int , buttonTitle:String)
}



import UIKit

class VKAlertActionView: NSObject {
    
    //MARK: PROPERTIES
    var delegate: VKAlertActionViewDelegate!
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _ALERT_TYPE: ALERT_TYPE = ALERT_TYPE.DUMMY
    fileprivate var _string: String = ""
    fileprivate var _ACTION_SHEET_TYPE: ACTION_SHEET_TYPE!
    
    
    internal func showYesNoAlertView(_ message: String, alertType: ALERT_TYPE, object: AnyObject) {
        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
         let defaultAction = UIAlertAction.init(title: "No", style: UIAlertActionStyle.default) { (action) in
            self.delegate.vkYesNoAlertAction(_alertType: alertType, buttonIndex: 0, buttonTitle: "No")
         }
        let alertYesAction = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default) { (action) in
            self.delegate.vkYesNoAlertAction(_alertType: alertType, buttonIndex: 1, buttonTitle: "Yes")
        }
        
        alertController.addAction(alertYesAction)
        alertController.addAction(defaultAction)
        obj_AppDelegate.navigationController.present(alertController, animated: true, completion: nil)
    }
    
    internal func showAlertView(_ arrTitle: NSMutableArray, message: String, isIncludeCancelButton : Bool, alertType: ALERT_TYPE)
    {
        _ALERT_TYPE = alertType
        
        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
               for i in 0..<arrTitle.count
        {
            alertController.addAction(UIAlertAction(title: arrTitle.object(at: i) as? String, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.delegate.vkYesNoAlertAction(_alertType: alertType, buttonIndex: i, buttonTitle: arrTitle.object(at: i) as! String)
                
            }))
        }
        obj_AppDelegate.navigationController.present(alertController, animated: true, completion: nil)
    }

    
    internal func showOkAlertView(_ message: String, alertType: ALERT_TYPE, object: String, isCallDelegate: Bool) {
        _ALERT_TYPE = alertType
        _string = object
        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default) { (action) in
            if isCallDelegate {
                 self.delegate.vkYesNoAlertAction(_alertType: alertType, buttonIndex: 0, buttonTitle: "OK" as! String)
            }
        }
        
        alertController.addAction(alertOKAction)
        obj_AppDelegate.navigationController.present(alertController, animated: true, completion: nil)
    }
    
    internal func showActionSheet(_ arrTitle: NSMutableArray, message: String, isIncludeCancelButton : Bool, actionSheetType: ACTION_SHEET_TYPE)
    {
        _ACTION_SHEET_TYPE = actionSheetType
        
        let alertController = UIAlertController.init(title: MSG_TITLE, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if isIncludeCancelButton {
            arrTitle.add("Cancel")
        }
        
        for i in 0..<arrTitle.count
        {
            alertController.addAction(UIAlertAction(title: arrTitle.object(at: i) as? String, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
                self.delegate.vkActionSheetAction(self._ACTION_SHEET_TYPE, buttonIndex: i, buttonTitle: arrTitle.object(at: i) as! String)
                
                
            }))
        }
        obj_AppDelegate.navigationController.present(alertController, animated: true, completion: nil)
    }
}
