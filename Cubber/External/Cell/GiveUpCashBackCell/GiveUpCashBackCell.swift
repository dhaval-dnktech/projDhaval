//
//  GiveUpCashBackCell.swift
//  Cubber
//
//  Created by dnk on 22/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol GiveUpCashBackCellDelegate {
    func GiveUpCashBackCell_btnSelectAction(button:UIButton)
}

class GiveUpCashBackCell: UITableViewCell {
    
    @IBOutlet var lblProfileInitial: UILabel!
    @IBOutlet var imageViewProfile: UIImageView!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var imageViewStatus: UIImageView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    @IBOutlet var btnInfo: UIButton!
    
    var delegate:GiveUpCashBackCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    @IBAction func btnSelectAction(_ sender: UIButton) {
        self.delegate?.GiveUpCashBackCell_btnSelectAction(button: sender)
    }
    
}
