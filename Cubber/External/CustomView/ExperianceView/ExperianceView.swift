//
//  ExperianceView.swift
//  Cubber
//
//  Created by dnk on 31/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import MessageUI

class ExperianceView: UIView, MFMailComposeViewControllerDelegate {
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _KDAlertView = KDAlertView()
     //MARK: PROPERTIES

    @IBOutlet var viewBG: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewLogo: UIView!
    
    //MARK: VIEW METHODS
    override init(frame: CGRect) {
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame: frame)
        self.loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadXib(){
         self.alpha = 1
        let view: UIView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.last as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
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
        
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        viewBG.layer.cornerRadius = 5
        viewLogo.layer.cornerRadius = viewLogo.frame.height/2
        
        
        obj_AppDelegate.navigationController.view.addSubview(self)
        
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseViewTapAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(gestureTap)
        
        let velocity: CGFloat = 10;
        let duration: TimeInterval = 0.8;
        let damping: CGFloat = 0.5;    //usingSpringWithDamping : 0 - 1
        
        //Set sub view at  (- view height)
        var sFrame: CGRect = self.viewMain.frame;
        sFrame.origin.y = -self.viewMain.frame.height;
        self.viewMain.frame = sFrame;
        
        UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: {  self.viewMain.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2); }, completion: nil)

    }
    
    @IBAction func btnCloseViewTapAction() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            var frame = self.viewMain.frame
            frame.origin.y = self.frame.maxY + frame.height
            self.viewMain.frame = frame
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.alpha = 0 }, completion:{ (finished) in self.removeFromSuperview() })
        })

    }
    
    @IBAction func btnAwesomeAction() {
        
        self.btnCloseViewTapAction()
        if #available(iOS 11.0 , *) {
           UIApplication.shared.openURL("itms-apps://itunes.apple.com/us/app/cubber/id1171382587?mt=8&action=write-review".convertToUrl())
        }
        else {
        UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1171382587&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&action=write-review")!)
        }
    }
    
    @IBAction func btnCouldbBeBetterAction() {
        
  
            if MFMailComposeViewController.canSendMail() {
                          let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["care@cubber.in"])
                mail.setSubject("Feedback")
                mail.setMessageBody("Cubber \(DataModel.getAppVersion()) On \(DataModel.getDeviceName()) running \(UIDevice.current.systemVersion)",isHTML: false)
                self.obj_AppDelegate.navigationController.present(mail, animated: true)
            }
            else {
                _KDAlertView.showMessage(message: "Mail service is not available", messageType: MESSAGE_TYPE.FAILURE)
                return
            }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        self.btnCloseViewTapAction()

    }


}
