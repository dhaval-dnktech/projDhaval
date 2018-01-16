//
//  SelectedFilterCell.swift
//  Cubber
//
//  Created by dnk on 18/03/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol SelectedFilterCellDelegate {
    func SelectedFilterCell_btnCloseaction(button:UIButton)
}

class SelectedFilterCell: UICollectionViewCell {

    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    var delegate:SelectedFilterCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnClose.layer.cornerRadius = 10
        self.contentView.setViewBorder(COLOUR_DARK_GREEN, borderWidth: 1, isShadow: false, cornerRadius: 12, backColor: .clear)
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.delegate?.SelectedFilterCell_btnCloseaction(button: sender)
    }

}
