//
//  OrderCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 09/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

protocol OrderCellDelegate {
    func btnOrderCell_RepeatAction(_ button: UIButton)
    func btnOrderCell_RetryAction(_ button: UIButton)
}

class OrderCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var viewImageBG: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewItem: UIImageView!
    @IBOutlet var lblItemTitle: UILabel!
    @IBOutlet var btnItemStatus: UIButton!
    @IBOutlet var btnRepeat: UIButton!
    @IBOutlet var btnRetry: UIButton!
    @IBOutlet var btnCollection: [UIButton]!
    
    @IBOutlet var lblOrderDate: UILabel!
    var delegate: OrderCellDelegate! = nil
    @IBOutlet var lblAmount: UILabel!
    
    //MARK: VARIABLES
    
    //MARK: VIEW METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewImageBG.layer.borderWidth = 1.0
        self.viewImageBG.layer.cornerRadius = 30
        self.viewImageBG.layer.borderColor = COLOUR_DARK_GREEN.cgColor
        
        self.btnItemStatus.layer.cornerRadius = 5
        
        self.btnRepeat.layer.cornerRadius = 5.0
        self.btnRepeat.layer.borderWidth = 1.0
        self.btnRepeat.layer.borderColor = COLOUR_ORDER_STATUS_SUCCESS.cgColor
        self.btnRepeat.setTitleColor(COLOUR_ORDER_STATUS_SUCCESS, for: UIControlState())
        
        self.btnRetry.layer.cornerRadius = 5.0
        self.btnRetry.layer.borderWidth = 1.0
        self.btnRetry.layer.borderColor = COLOUR_ORDER_STATUS_FAILURE.cgColor
        self.btnRetry.setTitleColor(COLOUR_ORDER_STATUS_FAILURE, for: UIControlState())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnRepeatAction(_ sender: UIButton) { self.delegate.btnOrderCell_RepeatAction(sender) }
    
    @IBAction func btnRetryAction(_ sender: UIButton) { self.delegate.btnOrderCell_RetryAction(sender) }
}
