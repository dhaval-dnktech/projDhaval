//
//  DropBoardingPointCell.swift
//  Cubber
//
//  Created by dnk on 15/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol DropBoardngCellDelegate {
    func DropBoardoingCell_btnCheckBoxAction(button:UIButton)
   }

class DropBoardingPointCell: UITableViewCell {

    var delegate:DropBoardngCellDelegate? = nil
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCheckBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    @IBAction func btnCheckBoxAction(_ sender: UIButton) {
        self.delegate?.DropBoardoingCell_btnCheckBoxAction(button: sender)
    }
    
}
