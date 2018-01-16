//
//  AffiliateCategoryCell.swift
//  Cubber
//
//  Created by dnk on 08/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class AffiliateCategoryCell: UICollectionViewCell {

    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewLblBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 5
        
    }

}
