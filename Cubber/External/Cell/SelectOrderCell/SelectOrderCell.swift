//
//  SelectOrderCell.swift
//  Cubber
//
//  Created by dnk on 09/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol SelectOrderCellDelegate {
    func btnSelectOrderCell_SelectAction(_ button: UIButton)
}

class SelectOrderCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var viewImageBG: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewItem: UIImageView!
    @IBOutlet var lblItemTitle: UILabel!
    @IBOutlet var btnItemStatus: UIButton!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var lblAmount: UILabel!
    var delegate: SelectOrderCellDelegate! = nil
    @IBOutlet var lblOrderDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewImageBG.layer.borderWidth = 1.0
        self.viewImageBG.layer.cornerRadius = 30
        self.viewImageBG.layer.borderColor = COLOUR_DARK_GREEN.cgColor
        self.btnSelect.layer.cornerRadius = 5.0
        self.btnSelect.layer.borderWidth = 1.0
        self.btnItemStatus.layer.cornerRadius = 5
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnSelectOrderAction(_ sender: UIButton) {
        self.delegate.btnSelectOrderCell_SelectAction(sender)
    }
    
}
