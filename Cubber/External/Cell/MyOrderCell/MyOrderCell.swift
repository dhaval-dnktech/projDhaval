//
//  MyOrderCell.swift
//  Cubber
//
//  Created by dnk on 01/05/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

//protocol MyOrderCellDelegate {
//    func btnMyOrderCell_ClaimAction(_ button:UIButton)
//}

class MyOrderCell: UITableViewCell {

    @IBOutlet var lblOrderNO: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblCommision: UILabel!
    @IBOutlet var lblCommisionDate: UILabel!
    @IBOutlet var lblExpctedPaymentDate: UILabel!
    @IBOutlet var viewImagePartner: UIView!
    @IBOutlet var imageViewPartner: UIImageView!
    @IBOutlet var lblPartner: UILabel!
    @IBOutlet var btnStatus: UIButton!
    //@IBOutlet var btnClaim: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    //var delegate: MyOrderCellDelegate! = nil
    @IBOutlet var constraintLblComissionDateHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // btnClaim.setViewBorder(COLOUR_GREEN, borderWidth: 1, isShadow: false, cornerRadius: 3, backColor: UIColor.clear)
        btnStatus.setViewBorder(UIColor.clear, borderWidth: 1, isShadow: false, cornerRadius: 3, backColor: UIColor.clear)
        //imageViewPartner.setViewBorder(UIColor.lightGray, borderWidth: 1, isShadow: false, cornerRadius: 0, backColor: UIColor.clear)
        
         viewImagePartner.setViewBorder(COLOUR_DARK_GREEN, borderWidth: 1, isShadow: false, cornerRadius: viewImagePartner.frame.height/2, backColor: UIColor.clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @IBAction func btnClaimAction(_ sender: UIButton) {
//        self.delegate.btnMyOrderCell_ClaimAction(sender)
//    }
    
}
