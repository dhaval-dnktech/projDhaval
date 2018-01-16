//
//  SummaryView.swift
//  Cubber
//
//  Created by dnk on 27/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SummaryView: UIView {

    //MARK: PROPERTIES
  //  @IBOutlet var lblCubberLevel: UILabel!
    @IBOutlet var lblYourLevel: UILabel!
    @IBOutlet var lblChildLevel: UILabel!
    @IBOutlet var lblTotalMember: UILabel!
    @IBOutlet var lblFeesPaid: UILabel!
    @IBOutlet var lblFeesPending: UILabel!
    @IBOutlet var lblPrimeMember: UILabel!
    @IBOutlet var lblNonPrimeMember: UILabel!
    @IBOutlet var constraintvieFeesPaidWidth: NSLayoutConstraint!
    @IBOutlet var constraintViewPrimeMemberWidth: NSLayoutConstraint!
    
    @IBOutlet var viewDashedLine: UIView!
    @IBOutlet var viewFeesPaidUnPaidBG: UIView!
    @IBOutlet var viewPrimeNonPrimeBG: UIView!
    
    @IBOutlet var imageUserProfile: UIImageView!
    @IBOutlet var lblUserSortName: UILabel!
    
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    required  override init(frame: CGRect ) {
        super.init(frame: frame)
        self.loadXIB()
    }
    
    fileprivate func loadXIB() {
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
       // viewDashedLine.addDashedLine(color:COLOUR_TEXT_GRAY)
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        
        if !(userInfo[RES_userProfileImage] as! String).isEmpty {
            let sturl = userInfo[RES_userProfileImage] as! String
            imageUserProfile.sd_setImage(with: NSURL.init(string: sturl) as URL!, completed: { (image, error, type, url) in
                if image != nil {
                    self.imageUserProfile.isHidden = false
                    self.lblUserSortName.isHidden = true
                }
                else{
                    self.imageUserProfile.isHidden = true
                    self.lblUserSortName.isHidden = false
                }
               // self.activityIndicator.stopAnimating()
            })
        }
        else{
            imageUserProfile.isHidden = true
            lblUserSortName.isHidden = false
        }
        
        let stFirstName: String = userInfo[RES_userFirstName] as! String
        let stLastName: String = userInfo[RES_userLastName] as! String
        var userFullName:String = stFirstName
        
        let startIndex = stFirstName.characters.index(stFirstName.startIndex, offsetBy: 0)
        let range = startIndex..<stFirstName.characters.index(stFirstName.startIndex, offsetBy: 1)
        let stFN = stFirstName.substring( with: range )
        var stLN:String = ""
        if !stLastName.isEmpty { stLN = stLastName.substring( with: range ); userFullName += " " + stLastName; }
        self.lblUserSortName.text = (stFN + stLN).uppercased()

    }
  
    internal func loadData( dictSummary:typeAliasDictionary ) {
        if !dictSummary.isEmpty {
            
           // lblCubberLevel.text = dictSummary[RES_cubberLevel] as? String
            lblYourLevel.text = "Level :\(dictSummary[RES_cubberLevel] as! String)"
            lblChildLevel.text = "Level :\(dictSummary[RES_userLevel] as! String)"
            lblTotalMember.text = "(\(dictSummary[RES_totalMemeber] as! String))"
            lblFeesPaid.text = "(\(self.convertValue(stValue: (dictSummary[RES_paidMember] as? String)!)))"
            lblFeesPending.text =  "(\(self.convertValue(stValue: (dictSummary[RES_unPaidMember] as? String)!)))"
            lblPrimeMember.text = "(\(self.convertValue(stValue: (dictSummary[RES_primeMember] as? String)!)))"
            lblNonPrimeMember.text = "(\(self.convertValue(stValue: (dictSummary[RES_nonPrimeMember] as? String)!)))"
         
            
            let widthPrime:Double = (Double(dictSummary[RES_primeMember] as! String)!/Double(dictSummary[RES_totalMemeber] as! String)!) * Double(viewPrimeNonPrimeBG.frame.width)
            
          //  widthPrime = Double(viewPrimeNonPrimeBG.frame.width) * (5/10)
            
            constraintViewPrimeMemberWidth.constant = CGFloat(widthPrime)
           // viewDashedLine.addDashedLine(color:COLOUR_TEXT_GRAY)
           // self.layoutIfNeeded()
            
            let width:Double = (Double(dictSummary[RES_paidMember] as! String)!/Double(dictSummary[RES_totalMemeber] as! String)!) * Double(viewPrimeNonPrimeBG.frame.width)
          //  width = Double(viewPrimeNonPrimeBG.frame.width) * (5/15)
            constraintvieFeesPaidWidth.constant = CGFloat(width)
            
           // self.layoutIfNeeded()
            
         }
    }
    
    func convertValue(stValue:String) -> String {
        let value:Int = Int(stValue)!
        if value > 999 && value < 1000000 {
            return "\(String(value/1000))K"
        }
        else if value > 999999 {
            return "\(String(value/1000000))M"
        }
        else { return stValue}
    }
    
    func addDashedBottomBorder(to view: UIView) {
        
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = view.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: 0, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [9,6]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: shapeRect.height, width: 0, height: shapeRect.width), cornerRadius: 0).cgPath
        
        view.layer.addSublayer(shapeLayer)
    }
}

