//
//  HomeCategoryCollectionCell.swift
//  Cubber
//
//  Created by dnk on 29/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class HomeCategoryCollectionCell: UICollectionViewCell {

    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblShortOffer: UILabel!
    @IBOutlet var constraintLblShortOfferHeight: NSLayoutConstraint!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var lblShortTitleBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
