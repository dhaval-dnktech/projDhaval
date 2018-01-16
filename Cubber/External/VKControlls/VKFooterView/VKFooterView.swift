//
//  VKFooterView.swift
//  Cubber
//
//  Created by Vyas Kishan on 16/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class VKFooterView: UIView {
    
    //MARK: PROPERTIES
    
    @IBOutlet var btnTabHome: UIButton!
    @IBOutlet var btnTabCollection: [UIButton]!
    @IBOutlet var imageViewTabCollection: [UIImageView]!
    @IBOutlet var lblTitleCollection: [UILabel]!
    
    
    @IBOutlet var viewBGNotificationBadge: UIView!
    @IBOutlet var imageViewNotification: UIImageView!
    @IBOutlet var btnNotificationBadge: UIButton!
    @IBOutlet var constraintBtnBadgeWidth: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var arrImages = [typeAliasStringDictionary]()
    
    //MARK: METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    fileprivate func loadXIB() {
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
        
       /* let dict = [IMAGE_UN_SELECTED:"icon_home", IMAGE_SELECTED:"icon_home_s", LIST_ID:String(VK_FOOTER_TYPE.HOME.rawValue)]
        let dict1 = [IMAGE_UN_SELECTED:"icon_wallet", IMAGE_SELECTED:"icon_wallet_s", LIST_ID:String(VK_FOOTER_TYPE.WALLET.rawValue)]
        let dict2 = [IMAGE_UN_SELECTED:"icon_profile", IMAGE_SELECTED:"icon_profile_s", LIST_ID:String(VK_FOOTER_TYPE.ACCOUNT.rawValue)]
        let dict3 = [IMAGE_UN_SELECTED:"icon_tree", IMAGE_SELECTED:"icon_tree_s", LIST_ID:String(VK_FOOTER_TYPE.MEMBER_TREE.rawValue)]
        arrImages = [dict, dict1, dict2, dict3] */
        
        let dict = [IMAGE_UN_SELECTED:"icon_home_inactive", IMAGE_SELECTED:"icon_home_active", LIST_ID:String(VK_FOOTER_TYPE.HOME.rawValue)]
        let dict1 = [IMAGE_UN_SELECTED:"icon_wallet_inactive", IMAGE_SELECTED:"icon_wallet_active", LIST_ID:String(VK_FOOTER_TYPE.WALLET.rawValue)]
        let dict2 = [IMAGE_UN_SELECTED:"icon_cart_inactive",IMAGE_SELECTED:"icon_cart_active",LIST_ID:String(VK_FOOTER_TYPE.SHOP.rawValue)]
        let dict3 = [IMAGE_UN_SELECTED:"icon_profile_inactive", IMAGE_SELECTED:"icon_profile_active", LIST_ID:String(VK_FOOTER_TYPE.ACCOUNT.rawValue)]
        let dict4 = [IMAGE_UN_SELECTED:"icon_connects_inactive", IMAGE_SELECTED:"icon_connects_active", LIST_ID:String(VK_FOOTER_TYPE.MEMBER_TREE.rawValue)]
        arrImages = [dict, dict1, dict2, dict3, dict4]
        
        for imgView in imageViewTabCollection {
            let tag: Int = imgView.tag
            let dict = arrImages[tag]
            if self.tag == tag {
                imgView.image = UIImage(named:dict[IMAGE_SELECTED]!)
                            }
            else  {
                imgView.image = UIImage(named: dict[IMAGE_UN_SELECTED]!)
            }
        }
        lblTitleCollection.forEach({ (lbl) in
            lbl.textColor = self.tag == lbl.tag ? "40aa4e".hexStringToUIColor()  : UIColor.darkGray
        })

    }
    
    @IBAction func btnTabAction(_ sender: UIButton) {
        for btn in btnTabCollection { btn.isSelected = false }
        sender.isSelected = true
        obj_AppDelegate.onVKFooterAction(VK_FOOTER_TYPE(rawValue: sender.tag)!)
    }
    
}
