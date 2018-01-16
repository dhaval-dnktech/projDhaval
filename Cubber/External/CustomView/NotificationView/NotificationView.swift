//
//  NotificationView.swift
//  Cubber
//
//  Created by dnk on 20/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class NotificationView: UIView, UIGestureRecognizerDelegate {
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    
    //MARK: PROPERTIES
    @IBOutlet var viewMain: UIView!
    @IBOutlet var switchNotificationSetting: UISwitch!
    
    override init(frame: CGRect) {
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame: frame)
        self.loadXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadXIB() {
        self.alpha = 1
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
        
        obj_AppDelegate.navigationController.view.addSubview(self)
        obj_AppDelegate.navigationController.SetScreenName(name: F_NOTIFICATIONSETTING, stclass: F_NOTIFICATIONSETTING)
        let dictUser = DataModel.getUserInfo()
        switchNotificationSetting.isOn = dictUser[RES_pushNotificationStaus] as! String == "1" ? true : false
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseViewTapAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(gestureTap)
        gestureTap.delegate = self
        viewMain.tag = 100
        
        let velocity: CGFloat = 10;
        let duration: TimeInterval = 0.8;
        let damping: CGFloat = 0.5;    //usingSpringWithDamping : 0 - 1
        
        //Set sub view at  (- view height)
        var sFrame: CGRect = self.viewMain.frame;
        sFrame.origin.y = -self.viewMain.frame.height;
        self.viewMain.frame = sFrame;
        
        UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            var sFrame: CGRect = self.viewMain.frame;
            sFrame.origin.y = 0;
            self.viewMain.frame = sFrame;
            
        }, completion: {(completed) in
        })
    }
    
    @IBAction func switchChangeNotificationSettingAction(_ sender: UISwitch) {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_STATUS: sender.isOn ? "1" : "0"]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_NotificationSetting, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token]! as! String)
            var dictUser:typeAliasDictionary = DataModel.getUserInfo()
            dictUser[RES_pushNotificationStaus] = dict[RES_pushNotificationStaus]
            DataModel.setUserInfo(dictUser)
            
        }, onFailure: { (code, dict) in
            
        }) {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING); return
        }
    }

    func btnCloseViewTapAction() {
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            var frame = self.viewMain.frame
            frame.origin.y = self.frame.maxY + frame.height
            self.viewMain.frame = frame
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.alpha = 0 }, completion:{ (finished) in self.removeFromSuperview() })
        })
        
    }
    
    // MARK:GESTURE DELEGATE
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        if view?.tag == 100 {
            return true
        }
        return false
        
    }
}
