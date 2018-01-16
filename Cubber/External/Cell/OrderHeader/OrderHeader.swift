//
//  OrderHeader.swift
//  Cubber
//
//  Created by Vyas Kishan on 09/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class OrderHeader: UIView {
    
    //MARK: PROPERTIES
    @IBOutlet var lblOrderNo: UILabel!
    @IBOutlet var lblOrderAmount: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    required init(frame: CGRect, orderInfo: typeAliasDictionary) {
        super.init(frame: frame)
        self.loadXIB()
        self.lblOrderNo.text = "Order No. : \(orderInfo[RES_orderID] as! String)"
        /*let amount:Double = Double(orderInfo[RES_subTotal] as! String)! + Double(orderInfo[RES_ServiceTax] as! String)! +  Double(orderInfo.isKeyNull(RES_convenienceFee) ? "0" : orderInfo[RES_convenienceFee] as! String)!
        let stAmount = String.init(format: "%.2f", amount)*/
        self.lblOrderAmount.text = "\(RUPEES_SYMBOL) \(orderInfo[RES_displayTotal] as! String)"
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
