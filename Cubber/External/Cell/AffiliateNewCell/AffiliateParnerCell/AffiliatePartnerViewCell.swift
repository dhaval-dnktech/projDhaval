//
//  AffiliatePartnerViewCell.swift
//  Cubber
//
//  Created by dnk on 08/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliatePartnerViewCell: UICollectionViewCell {
    @IBOutlet var lblRewards: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBOutlet var imageViewLogo2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func draw(_ rect: CGRect) {
        lblRewards.setViewBorder(.clear, borderWidth: 0, isShadow: false, cornerRadius: lblRewards.frame.height/2, backColor: lblRewards.backgroundColor!)
    }
}
