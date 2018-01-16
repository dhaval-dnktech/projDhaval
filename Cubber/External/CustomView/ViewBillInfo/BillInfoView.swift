//
//  BillInfoView.swift
//  Cubber
//
//  Created by dnk on 31/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol BillInfoViewDelegate {
    
    @objc optional func BillInfoView_btnCancelAction(button:UIButton)
    @objc optional func BillInfoView_btnPayNowAction(button:UIButton)
    
}

class BillInfoView: UIView {

    @IBOutlet var imageViewIcon: UIImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewFullSlider: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var btnPayNow: UIButton!
    @IBOutlet var btnOffer: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var viewCancel: UIView!
    @IBOutlet var lblCancel: UILabel!
    @IBOutlet var iconCancel: UIImageView!
    @IBOutlet var constraintImageViewIconHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintLblAmountWidth: NSLayoutConstraint!
    var delegate:BillInfoViewDelegate? = nil
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadXIB()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.delegate?.BillInfoView_btnCancelAction!(button: sender)
    }
    
    @IBAction func btnPayNowAction(_ sender: UIButton) {
        self.delegate?.BillInfoView_btnPayNowAction!(button: sender)
    }
    
}
