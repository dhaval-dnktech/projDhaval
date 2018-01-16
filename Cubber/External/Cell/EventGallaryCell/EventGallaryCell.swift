//
//  EventGallaryCell.swift
//  Cubber
//
//  Created by dnk on 13/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class EventGallaryCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var collectionViewGallery: UICollectionView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewGallery.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_GALLERY_COLLECTION_CELL, bundle: nil) ,forCellWithReuseIdentifier: CELL_IDENTIFIER_EVENT_GALLERY_COLLECTION_CELL)
        
        collectionViewGallery.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_ARTIST_CELL, bundle: nil) ,forCellWithReuseIdentifier: CELL_IDENTIFIER_EVENT_ARTIST_CELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
