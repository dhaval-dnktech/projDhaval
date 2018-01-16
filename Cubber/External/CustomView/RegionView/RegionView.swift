//
//  RegionView.swift
//  Cubber
//
//  Created by dnk on 14/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol RegionViewDelegate:class {
    func onRegionView_Selection(_ dictRegion: typeAliasDictionary)
}


class RegionView: UIView , UITableViewDataSource , UITableViewDelegate{

    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var  arrRegion = [typeAliasDictionary]()
    fileprivate var stCategoryID:String = ""
    fileprivate var selectedSection: Int = -1
        
    var viewTitle:String = ""
    @IBOutlet var lblTitle: UILabel!
    internal var isBrowsePlan:Bool = false
    var delegate: RegionViewDelegate! = nil
    
    //MARK:PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var tableViewRegion: UITableView!
    @IBOutlet var constraintViewBGTopToSuperview: NSLayoutConstraint!
    @IBOutlet var constraintViewOperatorTopToViewBG: NSLayoutConstraint!
    
    init(frame: CGRect , arrRegion:[typeAliasDictionary] , title:String) {
        
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame: frame)
        self.arrRegion = arrRegion
        self.viewTitle = title
        self.loadXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func loadXIB() {
        
        let view:UIView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)![0] as! UIView
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
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        //viewBG.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        
        lblTitle.text = "Select \(viewTitle)"
        self.tableViewRegion.rowHeight = HEIGHT_REGION_CELL
        self.tableViewRegion.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewRegion.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER_DEFAULT)
        constraintViewBGTopToSuperview.constant = 800
        self.layoutIfNeeded()
        obj_AppDelegate.navigationController.view.addSubview(self)
        self.constraintViewBGTopToSuperview.constant = self.frame.height/2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnCloseAction() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.constraintViewBGTopToSuperview.constant = 800
            self.layoutIfNeeded()
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrRegion.count }
    
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DEFAULT)!
        
        let dict: typeAliasDictionary = self.arrRegion[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = dict[RES_regionName] as? String
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return HEIGHT_REGION_CELL }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictRegion: typeAliasDictionary = self.arrRegion[(indexPath as NSIndexPath).row]
        self.delegate.onRegionView_Selection(dictRegion)
        self.btnCloseAction()
    }
    
    // MARK: SCROLLVIEW DELAGATE
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableViewRegion.contentOffset.y > 0 {
            self.constraintViewBGTopToSuperview.constant = 20
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
        else if tableViewRegion.contentOffset.y < 0{
            self.constraintViewBGTopToSuperview.constant = self.frame.height/2
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
