//
//  LatestOfferCollectionCell.swift
//  Cubber
//
//  Created by dnk on 24/07/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class LatestOfferCollectionCell: UITableViewCell {

    
    @IBOutlet var collectionViewLatestOffers: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewLatestOffers.register(UINib.init(nibName: CELL_IDENTIFIER_AFFILIATE_LATEST_OFFER_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_AFFILIATE_LATEST_OFFER_CELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
