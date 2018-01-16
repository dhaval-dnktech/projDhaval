
//
//  SeatArrangementCell.swift
//  Cubber
//
//  Created by dnk on 22/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol SeatArrangementCellDelegate {
    func SeatArrangementCll_btnSeatAction(button:UIButton)
}

class SeatArrangementCell: UICollectionViewCell {

    @IBOutlet var viewSeating: UIView!
    @IBOutlet var viewSleeper: UIView!
    @IBOutlet var iconSleeper: UIImageView!
    @IBOutlet var btnSleeper: UIButton!
    
    @IBOutlet var iconSeat1: UIImageView!
    @IBOutlet var btnSeat1: UIButton!
    @IBOutlet var iconSeat2: UIImageView!
    @IBOutlet var btnSeat2: UIButton!
    @IBOutlet var viewSeat1: UIView!
    @IBOutlet var viewSeat2: UIView!
   
    
    
    var delegate:SeatArrangementCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnSeatAction(_ sender: UIButton) {
        self.delegate?.SeatArrangementCll_btnSeatAction(button: sender)
    }
    

}
