//
//  ClassListCell.swift
//  Cubber
//
//  Created by dnk on 03/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol ClassListCellDelegate {
    func btnClassListCell_RadioAction(_ button:UIButton)
}

class ClassListCell: UITableViewCell {

    @IBOutlet var btnRadioClass: UIButton!
    @IBOutlet var lblClass: UILabel!
    var delegate:ClassListCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
       btnRadioClass.setImage(#imageLiteral(resourceName: "icon_radiouncheck"), for: UIControlState.normal)
        btnRadioClass.setImage(#imageLiteral(resourceName: "icon_radiocheck"), for: UIControlState.selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnRadioClassAction(_ sender: UIButton) {
        self.delegate?.btnClassListCell_RadioAction(sender)
    }
    
}
