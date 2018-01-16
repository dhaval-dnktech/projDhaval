//
//  AffiliateProductCell.swift
//  Cubber
//
//  Created by dnk on 14/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliateProductCell: UICollectionViewCell {
    @IBOutlet var imageViewProduct: UIImageView!
    @IBOutlet var imageViewPartner: UIImageView!
    @IBOutlet var lblCommission: UILabel!
    @IBOutlet var lblSpecialPrice: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    @IBOutlet var lblProductTitle: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
