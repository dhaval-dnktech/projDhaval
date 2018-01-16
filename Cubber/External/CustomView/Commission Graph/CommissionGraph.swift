//
//  CommissionGraph.swift
//  Cubber
//
//  Created by Vyas Kishan on 12/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class CommissionGraph: UIView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var tableViewLevel: UITableView!
    @IBOutlet var tablViewAmount: UITableView!
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _arrData = [typeAliasStringDictionary]()
    
    //MARK: VIEW METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    init(arrData: Array<typeAliasStringDictionary>) {
        _arrData = arrData.reversed()
        let frame: CGRect = CGRect.init(x: 0, y: STATUS_BAR_HEIGHT, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - STATUS_BAR_HEIGHT)
        super.init(frame : frame)
        self.loadXIB()
        obj_AppDelegate.navigationController.view.addSubview(self)
        let index = IndexPath.init(row: tableViewLevel.numberOfRows(inSection: 0) - 1, section: 0)
        tableViewLevel.scrollToRow(at: index, at: .bottom, animated: true)
    }
    
    fileprivate func loadXIB() {
        self.alpha = 1
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        
        self.tableViewLevel.rowHeight = HEIGHT_COMMISSION_LEVEL_CELL
        self.tableViewLevel.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewLevel.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER_DEFAULT)
        
        self.tablViewAmount.rowHeight = HEIGHT_COMMISSION_LEVEL_CELL
        self.tablViewAmount.tableFooterView = UIView(frame: CGRect.zero)
        self.tablViewAmount.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER_DEFAULT)
        
        //---> Auto Layout
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))

        self.layoutIfNeeded()
        //<---
        
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        self.viewBG.layer.cornerRadius = 5;
        
        let velocity: CGFloat = 10;
        let duration: TimeInterval = 0.8;
        let damping: CGFloat = 0.5;    //usingSpringWithDamping : 0 - 1
        
        //Set sub view at  (- view height)
        var sFrame: CGRect = self.viewBG.frame;
        sFrame.origin.y = -self.viewBG.frame.height;
        self.viewBG.frame = sFrame;
        
        UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.viewBG.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2); }, completion: nil)
    }
    
     //MARK: UIBUTTON METHODS
    @IBAction func gestureTapAction(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            var sFrame: CGRect = self.viewBG.frame;
            sFrame.origin.y = self.frame.height + 50;
            self.viewBG.frame = sFrame;
            self.alpha = 0 }) { (finished) in self.viewBG.removeFromSuperview(); self.removeFromSuperview(); }
    }
    
    //MARK: UISCROLLVIEW DELEGATE
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableViewLevel == scrollView { tablViewAmount.contentOffset = scrollView.contentOffset }
        else if tablViewAmount == scrollView { tableViewLevel.contentOffset = scrollView.contentOffset }
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self._arrData.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DEFAULT)!
        cell.textLabel?.textAlignment = NSTextAlignment.center
        let dict: typeAliasStringDictionary = self._arrData[(indexPath as NSIndexPath).row]
        var title: String = ""
        if tableView == tableViewLevel { title = dict[RES_level]! }
        else { title = "\(RUPEES_SYMBOL) \(dict[RES_amount]!)" }
        cell.textLabel?.text = title
        var textColor: UIColor = UIColor.black
        var textFont: UIFont = UIFont.systemFont(ofSize: 16)
        if (self._arrData.count - 1) == (indexPath as NSIndexPath).row { textColor = COLOUR_DARK_GREEN; textFont = UIFont.boldSystemFont(ofSize: 17); }
        cell.textLabel?.textColor = textColor
        cell.textLabel?.font = textFont
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return HEIGHT_COMMISSION_LEVEL_CELL }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
}
