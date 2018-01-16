//
//  EventListCell.swift
//  Cubber
//
//  Created by dnk on 12/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol EventListCellDelegate {
    func EventListCell_btnSelecteventAction(button:UIButton)
}

class EventListCell: UITableViewCell {

    @IBOutlet var imageViewEvent: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var lblEventName: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblEventPlace: UILabel!
    @IBOutlet var lblEventDate: UILabel!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var btnSelectEvent: UIButton!
    
    
    var delegate:EventListCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.setShadowDrop(self.viewBG)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        self.viewBG.setShadowDrop(self.viewBG)
    }
    
    
    @IBAction func btnSelectAction(_ sender: UIButton) {
        self.delegate?.EventListCell_btnSelecteventAction(button: sender)
    }
    
}
