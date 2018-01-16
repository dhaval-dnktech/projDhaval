//
//  ShopAffiliatedCell.swift
//  Cubber
//
//  Created by dnk on 28/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ShopAffiliatedCell: UICollectionViewCell {

    @IBOutlet var cellViewBG: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         cellViewBG.setViewBorder(COLOUR_GREEN, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: UIColor.clear)
    }

}
