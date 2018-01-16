//
//  PlanDetailCell.swift
//  Cubber
//
//  Created by Vyas Kishan on 22/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class WalletListCell: UITableViewCell {

    //MARK: PROPERTIES
    @IBOutlet var imageViewLogo: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblWalletCreditDebit: UILabel!
    @IBOutlet var lblWalletTitle: UILabel!
    @IBOutlet var lblOrderId: UILabel!
    @IBOutlet var lblFrom: UILabel!
    @IBOutlet var lblTransactionId: UILabel!
    @IBOutlet var lblNote: UILabel!
    @IBOutlet var constraintLabelFromHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentView.layoutIfNeeded()
    }
}
