//
//  SideMenuHeader.swift
//  Cubber
//
//  Created by dnk on 25/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SideMenuHeader: UIView {

    @IBOutlet var ImageMenuIcon: UIImageView!
    @IBOutlet var imageExpandableIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewBGShortTitle: UIView!
    @IBOutlet var lblShortTitle: UILabel!
    @IBOutlet var btnHeader: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    required init(frame: CGRect, dictMenu: typeAliasDictionary) {
        super.init(frame: frame)
        self.loadXIB()
        var stShortOffer = ""
        if  dictMenu[RES_offerShortTitle] != nil {
            stShortOffer = dictMenu[RES_offerShortTitle] as! String
        }

        let isExpandable = dictMenu[IS_EXAPANDABLE] as! Bool
        ImageMenuIcon.sd_setImage(with: (dictMenu[RES_image] as! String).convertToUrl())
         lblTitle.text = dictMenu[RES_menuName] as! String?
        if isExpandable {
            let isExpanded = dictMenu[IS_EXPANDED] as! Bool
            
            if isExpanded {imageExpandableIcon.image = UIImage.init(named: "icon_minus_s")}
            else {imageExpandableIcon.image = UIImage.init(named: "icon_plus_s")}
            imageExpandableIcon.image = imageExpandableIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            imageExpandableIcon.tintColor = COLOUR_ORANGE
        }
        if !stShortOffer.isEmpty{
            lblShortTitle.text = stShortOffer
            lblShortTitle.isHidden = false
            viewBGShortTitle.isHidden = false
        }
        else{
            lblShortTitle.text = ""
            lblShortTitle.isHidden = true
            viewBGShortTitle.isHidden = true
        }
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
    }
}
