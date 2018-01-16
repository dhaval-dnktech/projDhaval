//
//  EventTextCell.swift
//  Cubber
//
//  Created by dnk on 13/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol EventTextCellDelegate {
    func EventTextCell_btnShowMoreAction(button:UIButton)
}

class EventTextCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblText: UILabel!
    @IBOutlet var btnShowMoreLess: UIButton!
    @IBOutlet var constraintShowMoreLessButtonHeight: NSLayoutConstraint!
    var delegate:EventTextCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnShowMoreLessAction(_ sender: UIButton) {
        self.delegate?.EventTextCell_btnShowMoreAction(button: sender)
    }
    
}
