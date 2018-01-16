//
//  VKNotificaitonView.swift
//  BusinessCard
//
//  Created by Vyas Kishan on 06/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class VKNotificaitonView: UIView {

    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var constraintViewBGTopWithViewSupper: NSLayoutConstraint!
    @IBOutlet var viewNotificationDetail: UIView!
    @IBOutlet var btnClose: UIButton!
    
    var viewBG: UIView = UIView.init()
    let swipeGesture:UISwipeGestureRecognizer =  UISwipeGestureRecognizer.init()
    
    let height: CGFloat = 110
    var dictNotification = typeAliasDictionary()
    
    //MARK: METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    required init(title: String , dictNotification:typeAliasDictionary) {
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: FRAME_SCREEN.width, height: height)
        super.init(frame: frame)
        self.layoutIfNeeded()
        self.loadXIB()
        self.backgroundColor = .clear
        lblMessage.text = title
        self.dictNotification = dictNotification
        swipeGesture.direction = .up
        swipeGesture.addTarget(self, action: #selector(onDragNotification))
        let tapGesture = UITapGestureRecognizer.init()
            tapGesture.numberOfTapsRequired = 1
            tapGesture.addTarget(self , action: #selector(onTapNotification))
         viewNotificationDetail.addGestureRecognizer(tapGesture)
        //viewNotificationDetail.addGestureRecognizer(swipeGesture)*/
        
        //btnClose.setViewBorder(.white, borderWidth: 1, isShadow: false, cornerRadius: 7.5, backColor: .clear)
        
        self.alpha = 0
        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = 1
            }) { (finished) in
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .beginFromCurrentState, animations: {
                    self.constraintViewBGTopWithViewSupper.constant = 22
                    self.viewBG.layoutIfNeeded()
                    }, completion: { (finished) in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            UIView.animate(withDuration: 0.4, delay: 0.2, options: .beginFromCurrentState, animations: {
                                self.constraintViewBGTopWithViewSupper.constant = -(self.height + 10)
                                self.layoutIfNeeded()
                            }) { (finished) in
                                self.alpha = 0
                                self.removeFromSuperview()
                            }
                        }
                })
        }
    }
    
    fileprivate func loadXIB() {
        viewBG = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        viewBG.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(viewBG)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: viewBG, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: viewBG, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: viewBG, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: viewBG, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        
        self.layoutIfNeeded()
    }
    
   @objc func onDragNotification() {
    
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .beginFromCurrentState, animations: {
            self.constraintViewBGTopWithViewSupper.constant = -(self.height + 10)
            self.layoutIfNeeded()
        }) { (finished) in
            self.alpha = 0
            self.removeFromSuperview()
        }
    }
    func onTapNotification() {
        
        self.onDragNotification()
       let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        obj_AppDelegate.handlePushNotificationsFromHome(dict: self.dictNotification)

    }
    @IBAction func onNotificationTapAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .beginFromCurrentState, animations: {
            self.constraintViewBGTopWithViewSupper.constant = -(self.height + 10)
            self.layoutIfNeeded()
        }) { (finished) in
            self.alpha = 0
            self.removeFromSuperview()
        }
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        obj_AppDelegate.handlePushNotificationsFromHome(dict: self.dictNotification)
    }
    
    @IBAction func btnCloseAction() {
        onDragNotification()
    }
    
}
