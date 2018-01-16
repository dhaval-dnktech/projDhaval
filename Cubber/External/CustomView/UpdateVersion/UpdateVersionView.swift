//
//  OTPView.swift
//  Cubber
//
//  Created by Vyas Kishan on 30/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class UpdateVersionView: UIView {
    
    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblCurrentVersion: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _dictAppVersionUpdate = typeAliasStringDictionary()
    
    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ dictAppUpdateInfo: typeAliasStringDictionary) {
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame : frame)
        _dictAppVersionUpdate = dictAppUpdateInfo
        loadXIB()
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
    
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        viewBG.layer.cornerRadius = 5
        
        obj_AppDelegate.navigationController.view.addSubview(self)
        //lblCurrentVersion.text = "Current Version \(DataModel.getAppVersion())"
        lblDescription.text = self._dictAppVersionUpdate[RES_ios_update_msg]
        let isOutsideHidden: Bool = self._dictAppVersionUpdate[RES_isComplusory] == "0" ? true : false
        
        if isOutsideHidden {
            let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseAction))
            self.isUserInteractionEnabled = true
            self.isMultipleTouchEnabled = true
            self.addGestureRecognizer(gestureTap)
        }
        
        let velocity: CGFloat = 10;
        let duration: TimeInterval = 0.8;
        let damping: CGFloat = 0.5;    //usingSpringWithDamping : 0 - 1
        
        //Set sub view at  (- view height)
        var sFrame: CGRect = self.viewBG.frame;
        sFrame.origin.y = -self.viewBG.frame.height;
        self.viewBG.frame = sFrame;
        
        UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: {  self.viewBG.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2); }, completion: nil)
    }

    internal func btnCloseAction() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            var frame = self.viewBG.frame
            frame.origin.y = self.frame.maxY + frame.height
            self.viewBG.frame = frame
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.alpha = 0 }, completion:{ (finished) in self.removeFromSuperview() })
        })
    }
    
    @IBAction func btnDownloadAction() {
        
        //https://bjango.com/articles/ituneslinks/
         UIApplication.shared.openURL("http://itunes.apple.com/app/consume-mobile-isp-packages/id1171382587?mt=8".convertToUrl())
    }
    @IBAction func btnLaterAction() {
        self.btnCloseAction()
    }
    
}
