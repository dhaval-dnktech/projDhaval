//
//  AffiliaeLatestOfferCell.swift
//  Cubber
//
//  Created by dnk on 15/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliaeLatestOfferCell: UICollectionViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblCommision: UILabel!
    @IBOutlet var imageViewOfferBanner: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.setViewBorder(UIColor.clear, borderWidth: 1, isShadow: false, cornerRadius: 5
            , backColor: UIColor.clear)
       
    }

}
