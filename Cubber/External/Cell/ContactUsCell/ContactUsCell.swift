//
//  ContactUsCell.swift
//  Cubber
//
//  Created by dnk on 14/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ContactUsCell: UICollectionViewCell {
    
    @IBOutlet var viewBG: UIView!
    @IBOutlet var imageViewCategory: UIImageView!
    @IBOutlet var lblCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.setShadowDrop(self.viewBG)
    }

}
