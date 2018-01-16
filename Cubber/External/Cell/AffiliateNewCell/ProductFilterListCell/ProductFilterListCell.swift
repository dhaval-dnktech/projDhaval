//
//  ProductFilterListCell.swift
//  Cubber
//
//  Created by dnk on 20/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ProductFilterListCell: UITableViewCell {

    @IBOutlet var lblFilterAttributeTitle: UILabel!
    @IBOutlet var collectionViewFilterAttribute: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionViewFilterAttribute.register(UINib.init(nibName: CELL_IDENTIFIER_SELECTED_FILTER_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_SELECTED_FILTER_CELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
