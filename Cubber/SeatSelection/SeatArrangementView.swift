//
//  SeatArrangementView.swift
//  Cubber
//
//  Created by dnk on 04/05/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol seatArrangementViewDelegate {
    func seatArrangementViewDelegate_btnSeatAction(button:UIButton)
}
class SeatArrangementView: UIView {
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: PROPERTIES
    var delegate:seatArrangementViewDelegate? = nil
    
    @IBOutlet var btnSeatSelection: UIButton!
    @IBOutlet var imageViewSeat: UIImageView!
    @IBOutlet var imageViewSleeper_Vertical: UIImageView!
    @IBOutlet var imageViewSleeper_Horizontal: UIImageView!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXib()
    }
    
    func loadXib(){
        
        self.alpha = 1
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        
        self.layoutIfNeeded()
        self.obj_AppDelegate.navigationController.view.addSubview(self)
    }
    
    @IBAction func btnSeatAction(_ sender: UIButton) {
        self.delegate?.seatArrangementViewDelegate_btnSeatAction(button: sender)
    }
  
}
