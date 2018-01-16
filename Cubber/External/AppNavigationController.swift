//
//  AppNavigationController.swift
//  Cubber
//
//  Created by Vyas Kishan on 16/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
//UA-78834038-1

private let WIDTH_IMAGE_BUTTON: CGFloat                 = 25

@objc protocol AppNavigationControllerDelegate {
    @objc optional func appNavigationController_RightMenuAction()
    @objc optional func appNavigationController_BackAction()
    @objc optional func appNavigationController_MoreMenuAction()
    @objc optional func appNavigationController_SideMenuAction()
    @objc optional func appNavigationController_NotificationAction()
    @objc optional func appNavigationController_RefreshAction()
}

class AppNavigationController: UINavigationController {

    //MARK: PROPERTIES
    var navigationDelegate: AppNavigationControllerDelegate! = nil
    var btnLeft = UIButton()
    var btnRight = UIButton()
    var frameTitleView = CGRect.zero
    var btnWidth = CGFloat()
    var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barTintColor = RGBCOLOR(256, g: 256, b: 256)
        self.navigationBar.isTranslucent = false;
        self.navigationBar.tintColor = COLOUR_TEXT_GRAY;
        let dict:typeAliasDictionary = [NSFontAttributeName:UIFont.init(name: "OpenSans-SemiBold", size: 18)!,NSForegroundColorAttributeName:COLOUR_TEXT_GRAY]
        self.navigationBar.titleTextAttributes = dict
        btnWidth = 20;
        frameTitleView = CGRect(x: 0, y: 0, width: self.navigationBar.frame.width, height: self.navigationBar.frame.height)
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func setCustomTitle(_ title: String) {
        let viewController: UIViewController = self.viewControllers.last!
        //self.lblTitle.removeFromSuperview()
        self.lblTitle = UILabel(frame: frameTitleView)
        if #available(iOS 11.0, *) {
             self.lblTitle.padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        self.lblTitle.textColor = COLOUR_TEXT_GRAY
        self.lblTitle.text = title
        self.lblTitle.font = UIFont(name: FONT_OPEN_SANS_SEMIBOLD, size: 17)
        self.lblTitle.textAlignment = .left
        self.lblTitle.numberOfLines = 0
//        self.lblTitle.layer.borderWidth = 1
        viewController.navigationItem.titleView = self.lblTitle
    }
    
    internal func setBackButton() {
        let viewController: UIViewController = self.viewControllers.last!
        let btnBack: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: WIDTH_IMAGE_BUTTON, height: WIDTH_IMAGE_BUTTON), imageName: "ic_nav", tag: 0)
            btnBack.setTitle("", for: .normal)
        let leftNav: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        viewController.navigationItem.backBarButtonItem = leftNav
    }
    
    internal func setBackButton(_ title: String) {
        let viewController: UIViewController = self.viewControllers.last!
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    internal func setOrderCancelButton() {
        let viewController: UIViewController = self.viewControllers.last!
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnBackAction))
    }
    
    internal func setLeftButton(title:String) {
        
        let viewController: UIViewController = self.viewControllers.last!
        let btnBack: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 25, height: WIDTH_IMAGE_BUTTON), imageName: "ic_nav", tag: 0)
        btnBack.setTitle(title, for: .normal)
        btnBack.setTitleColor(.black, for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        let leftNav: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        viewController.navigationItem.leftBarButtonItem = leftNav
    }
    
    internal func setDefaultBackButton() {
        let viewController: UIViewController = self.viewControllers.last!
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    internal func setRighButton(_ title: String) {
        let viewController: UIViewController = self.viewControllers.last!
        btnRight = DesignModel.createButton(CGRect(x: 0, y: 0, width: 80, height: 40), title: title, tag: 0, titleColor: COLOUR_TEXT_GRAY, titleFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 15)!, textAlignment: .right, bgColor: .clear, borderWidth: 0, borderColor: nil, cornerRadius: 0)
        btnRight.addTarget(self, action: #selector(btnRightMenuAction), for: UIControlEvents.touchUpInside)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btnRight)
    }
    
    internal func setNotificationButton() {
        
        let viewController: UIViewController = self.viewControllers.last!
        let rightNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let btnMore: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage(named: "icon_notification")!, tag: 0)
        btnMore.addTarget(self, action: #selector(btnNotificationAction), for: UIControlEvents.touchUpInside)
        rightNavView.addSubview(btnMore)
        let btnNotifi = DesignModel.createButton(CGRect.init(x:4, y: -5, width: 25, height: 25), title: "", tag: 102, titleColor: .white, titleFont: .systemFont(ofSize: 11), textAlignment: .center, bgColor: COLOUR_GREEN, borderWidth: 0, borderColor: .clear, cornerRadius: 12.5)
        btnNotifi.addTarget(self, action: #selector(btnNotificationAction), for: UIControlEvents.touchUpInside)
        rightNavView.addSubview(btnNotifi)
        let rightNav = UIBarButtonItem.init(customView: rightNavView)
        viewController.navigationItem.rightBarButtonItem = rightNav
    }
    
    internal func setNotificationButton(image:String) {
        
        let viewController: UIViewController = self.viewControllers.last!
        let rightNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let btnMore: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage(named: image)!, tag: 0)
        btnMore.addTarget(self, action: #selector(btnNotificationAction), for: UIControlEvents.touchUpInside)
        rightNavView.addSubview(btnMore)
        let btnNotifi = DesignModel.createButton(CGRect.init(x:4, y: -5, width: 25, height: 25), title: "", tag: 102, titleColor: COLOUR_GREEN, titleFont: .systemFont(ofSize: 11), textAlignment: .center, bgColor: .white, borderWidth: 0, borderColor: .clear, cornerRadius: 12.5)
        btnNotifi.addTarget(self, action: #selector(btnNotificationAction), for: UIControlEvents.touchUpInside)
        rightNavView.addSubview(btnNotifi)
        let rightNav = UIBarButtonItem.init(customView: rightNavView)
        viewController.navigationItem.rightBarButtonItem = rightNav
    }
    
    internal func setMoreButton() {
        let viewController: UIViewController = self.viewControllers.last!
        let btnMore: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage(named: "icon_more")!, tag: 0)
        btnMore.addTarget(self, action: #selector(btnMoreMenuAction), for: UIControlEvents.touchUpInside)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btnMore)
    }
    
    internal func setRefreshButton() {
        let viewController: UIViewController = self.viewControllers.last!
        let btnMore: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage(named: "ic_refresh")!, tag: 0)
        btnMore.addTarget(self, action: #selector(btnRefreshAction), for: UIControlEvents.touchUpInside)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btnMore)
    }
    
    internal func setRightButton(image:String) {
        let viewController: UIViewController = self.viewControllers.last!
        let btnMore: UIButton = DesignModel.createImageButton(CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage(named: image)!, tag: 0)
        btnMore.addTarget(self, action: #selector(btnRightMenuAction), for: UIControlEvents.touchUpInside)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btnMore)
    }
    
    internal func setLeftButton(image:String) {
        let viewController: UIViewController = self.viewControllers.last!
        let btnBack: UIButton = DesignModel.createImageButton(CGRect.init(x: 0, y: 0, width: WIDTH_IMAGE_BUTTON, height: WIDTH_IMAGE_BUTTON), imageName: image, tag: 0)
        btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        let leftNav: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        viewController.navigationItem.leftBarButtonItem = leftNav

    }
    
    internal func setSideMenuButton() {
        let viewController: UIViewController = self.viewControllers.last!
        let btnBack: UIButton = DesignModel.createImageButton(CGRect.init(x: 0, y: 0, width: WIDTH_IMAGE_BUTTON, height: WIDTH_IMAGE_BUTTON), imageName: "icon_menu_b", tag: 0)
        btnBack.addTarget(self, action: #selector(btnSideMenuAction), for: .touchUpInside)
        let leftNav: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        viewController.navigationItem.leftBarButtonItem = leftNav
    }
    
    internal func setLeftView(_ viewController: UIViewController, view: UIView, totalButtons: Int) {
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(80), height: CGFloat(navigationBar.frame.height))
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
        
    }
    
    internal func setRightView(_ viewController: UIViewController, view: UIView, totalButtons: Int) {

        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30 * totalButtons), height: CGFloat(navigationBar.frame.height))
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        
    }

    internal func btnSideMenuAction() {
        self.navigationDelegate.appNavigationController_SideMenuAction!()
    }
    
    internal func btnRightMenuAction() {
        self.navigationDelegate.appNavigationController_RightMenuAction!()
    }
    
    internal func btnBackAction() {
        self.navigationDelegate.appNavigationController_BackAction!()
    }
    
    internal func btnMoreMenuAction() {
        self.navigationDelegate.appNavigationController_MoreMenuAction!()
    }
    
    internal func btnRefreshAction() {
        self.navigationDelegate.appNavigationController_RefreshAction!()
    }
    
    internal func btnNotificationAction() {
        self.navigationDelegate.appNavigationController_NotificationAction!()
    }
}

class titleLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
}

