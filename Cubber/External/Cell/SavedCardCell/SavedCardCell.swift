//
//  SavedCardCell.swift
//  Cubber
//
//  Created by Dhaval Nagar on 30/12/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol SavedCardCellDelegate {
    func SavedCardCell_btnDeleteCardAction(button:UIButton)
}

class SavedCardCell: UITableViewCell {
    
    @IBOutlet var viewBG: UIView!
    
    @IBOutlet var lblCardHolderName: UILabel!
    @IBOutlet var lblCardNo: UILabel!
    @IBOutlet var lblCardType: UILabel!
    @IBOutlet var btnDeleteCard: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewCardImage: UIImageView!
    var delegate:SavedCardCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func btnDeleteCardAction(_ sender: UIButton) {
        self.delegate?.SavedCardCell_btnDeleteCardAction(button: sender)
    }
    
    
}
