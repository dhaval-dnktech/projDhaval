//
//  AffiliatePartnersListCell.swift
//  Cubber
//
//  Created by dnk on 10/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliatePartnersListCell: UITableViewCell {

    @IBOutlet var viewLeft: UIView!
    @IBOutlet var viewRight: UIView!
    @IBOutlet var imageViewLogoLeft: UIImageView!
    @IBOutlet var lblPartnerRewardsLeft: UILabel!
    @IBOutlet var lblPartnerDiscountLeft: UILabel!
    @IBOutlet var imageViewLogoRight: UIImageView!
    @IBOutlet var lblPartnerRewardsRight: UILabel!
    @IBOutlet var lblPartnerDiscountRight: UILabel!
    @IBOutlet var leftActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var rightActivityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewLeft.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
        viewRight.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 5, backColor: UIColor.clear)
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
