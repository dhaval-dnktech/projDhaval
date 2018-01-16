//
//  CouponCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 02/09/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

protocol CouponCellDelegate {
    func CouponCell_btnCouponAction(button:UIButton)
}

class CouponCell: UICollectionViewCell {

    //MARK: PROPERTIES
    @IBOutlet var imageViewCoupon: UIImageView!
    @IBOutlet var lblCoupon: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var btnCoupon: UIButton!
    var delegate:CouponCellDelegate? = nil
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.lblCoupon.layer.borderWidth = 1.0
        self.lblCoupon.layer.borderColor = RGBCOLOR(220, g: 220, b: 220).cgColor
        self.lblCoupon.layer.cornerRadius = 5
    }
    
    @IBAction func btnCouponAction(_ sender: UIButton) {
        self.delegate?.CouponCell_btnCouponAction(button: sender)
    }
    
}
