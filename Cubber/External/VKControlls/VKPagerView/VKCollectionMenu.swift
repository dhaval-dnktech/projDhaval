//
//  VKCollectionMenu.swift
//  Cubber
//
//  Created by Vyas Kishan on 20/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol VKCollectionMenuDelegate:class {
    func onVKCollectionMenu_TabAction(_ selectedMenu: Int)
    func onVKCollectionMenu_TabAction(_ selectedMenu: Int, arrMenu:[typeAliasDictionary])
}

class VKCollectionMenu: UIView, VKCollectionMenuCellDelegate {

    //MARK: CONSTANT
    let LABEL_WIDTH             = "LABEL_WIDTH"
    let KEY_TRUE                = "true"
    let KEY_FALSE               = "false"
    //MARK: PROPERTIES
    @IBOutlet var collectionViewMenu: UICollectionView!
    @IBOutlet var delegate: VKCollectionMenuDelegate!
    
    //MARK: VARIABLES
    fileprivate var arrMenu =  [typeAliasDictionary]()
    fileprivate var currentIndex: Int = 0
    fileprivate var stKeyName: String = ""
    fileprivate var cellFont: UIFont = FONT_HOME_MENU_CELL
    fileprivate var isImageView:Bool = false
    fileprivate var isFirst:Bool = true
    
    internal var backColor:UIColor = UIColor.groupTableViewBackground
    internal var selectedBottomColor = COLOUR_GREEN
    
    //MARK: VIEW METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        
        self.collectionViewMenu.register(UINib.init(nibName: CELL_IDENTIFIER_COLLECTION_MENU, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_COLLECTION_MENU)
    }
    
    internal func setMenuData(_ array: [typeAliasDictionary], keyName: String) {
        self.arrMenu = array
        self.stKeyName = keyName
        
        for i in 0..<self.arrMenu.count {
            var dict: typeAliasDictionary = self.arrMenu[i]
            let width: CGFloat = (dict[keyName] as! String).textWidth(CGFloat(HEIGHT_COLLECTION_MENU_CELL), textFont: cellFont) + CGFloat(SIZE_EXTRA_TEXT) + CGFloat(PEDDING_HOME_MENU_CELL)
            dict[CELL_WIDTH] = width as AnyObject?
            self.arrMenu[i] = dict
        }
        
        self.collectionViewMenu.reloadData()
        self.collectionViewMenu.layoutIfNeeded()
    }
    
    internal func setMenuData(_ array: [typeAliasDictionary], keyName: String, font: UIFont, widthView: CGFloat) {
        self.arrMenu = array
        self.stKeyName = keyName
        let width: CGFloat = widthView / CGFloat(self.arrMenu.count) //+ 20
        cellFont = font
        
        for i in 0..<self.arrMenu.count {
            var dict: typeAliasDictionary = self.arrMenu[i]
            dict[CELL_WIDTH] = width as AnyObject?
            self.arrMenu[i] = dict
        }
        
        self.collectionViewMenu.reloadData()
        self.collectionViewMenu.layoutIfNeeded()
    }
    
    internal func setMenuData(_ array: [typeAliasDictionary], keyName: String, font: UIFont, widthView: CGFloat , isImageView:Bool) {
        
        self.isImageView = isImageView
        self.arrMenu = array
        self.stKeyName = keyName
        let width: CGFloat = widthView / CGFloat(self.arrMenu.count)
        cellFont = font
        
        for i in 0..<self.arrMenu.count {
            var dict: typeAliasDictionary = self.arrMenu[i]
            dict[CELL_WIDTH] = width as AnyObject?
            let width: CGFloat = (dict[keyName] as! String).textWidth(CGFloat(HEIGHT_COLLECTION_MENU_CELL), textFont: font)+5
            dict[LABEL_WIDTH] = width as AnyObject?
            self.arrMenu[i] = dict
        }
        self.collectionViewMenu.reloadData()
        self.collectionViewMenu.layoutIfNeeded()
    }
    
    internal func setMenuData(_ array: [typeAliasDictionary], keyName: String, font: UIFont, widthView: CGFloat , bgColor:UIColor , selctedColor:UIColor) {
        self.backColor = bgColor
        self.selectedBottomColor = selctedColor
        self.backgroundColor = self.backColor
        self.arrMenu = array
        self.stKeyName = keyName
        let width: CGFloat = widthView / CGFloat(self.arrMenu.count) //+ 20
        cellFont = font
        
        for i in 0..<self.arrMenu.count {
            var dict: typeAliasDictionary = self.arrMenu[i]
            dict[CELL_WIDTH] = width as AnyObject?
            self.arrMenu[i] = dict
        }
        
        self.collectionViewMenu.reloadData()
        self.collectionViewMenu.layoutIfNeeded()
    }
    
    internal func setSelectedMenu(_ index: Int) {
        self.currentIndex = index
        self.collectionViewMenu.reloadData()
        self.collectionViewMenu.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    internal func setSpecificPage(_ index: Int) {
        self.setSelectedMenu(index)
        if isImageView {self.delegate.onVKCollectionMenu_TabAction(index, arrMenu: arrMenu)}
        else{self.delegate.onVKCollectionMenu_TabAction(index)}
    }
    
    //MARK: UICOLLECTIONVIEW DELEGATE FLOWLAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let dict: typeAliasDictionary = self.arrMenu[(indexPath as NSIndexPath).row]
        return CGSize(width: dict[CELL_WIDTH] as! CGFloat, height: CGFloat(HEIGHT_COLLECTION_MENU_CELL))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    //MARK: UICOLLECTIONVIEW DATASOURCE
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return self.arrMenu.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: VKCollectionMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_COLLECTION_MENU, for: indexPath) as! VKCollectionMenuCell
        cell.delegate = self
        
        var titleColor: UIColor = COLOUR_TEXT_GRAY
            //self.selectedBottomColor == COLOUR_GREEN ?  RGBCOLOR(100, g: 100, b: 100) : RGBCOLOR(228, g: 228, b: 228)
        
        var bottomColor: UIColor = self.backColor
        var font = cellFont
        
        var dict: typeAliasDictionary = self.arrMenu[(indexPath as NSIndexPath).row]
        cell.btnTitle.accessibilityIdentifier = String((indexPath as NSIndexPath).row)
        
        if (indexPath as NSIndexPath).row == currentIndex {
            
            titleColor = COLOUR_DARK_GREEN
            bottomColor = COLOUR_ORANGE
            font = UIFont.boldSystemFont(ofSize: font.pointSize)
        }
        if !isImageView {cell.btnTitle.setTitle(dict[self.stKeyName] as? String, for: UIControlState())
            cell.btnTitle.backgroundColor = self.backColor
        }
        else{cell.btnTitle.setTitle("", for: UIControlState())
            cell.btnTitle.backgroundColor = UIColor.clear
            cell.constraintLblTitleWidth.constant = dict[LABEL_WIDTH] as! CGFloat
            if dict[IS_SHOW_IMAGE] as! String  == KEY_FALSE{
                cell.constraintLblTitleTrailing.priority = 999
                cell.constraintBtnSortIconTrailing.priority = 900
            }
            else {cell.constraintLblTitleTrailing.priority = 900;cell.constraintBtnSortIconTrailing.priority = 950}
            cell.btnSortIcon.isHidden =  (indexPath as NSIndexPath).row == currentIndex && dict[IS_SHOW_IMAGE] as!  String == KEY_TRUE ? false : true
            cell.btnSortIcon.isSelected = dict[IS_ACCENDING] as!  String == KEY_TRUE ? false : true
        }
        cell.btnTitle.setTitleColor(titleColor, for: UIControlState())
        cell.btnTitle.titleLabel?.font = font
        cell.viewTitleWithIcon.isHidden = !isImageView
        cell.lblTitle.text = dict[self.stKeyName] as? String
        cell.lblTitle.textColor = titleColor
        cell.lblTitle.font = font
        cell.viewUnderLine.backgroundColor = bottomColor
        
        return cell;
    }
    
    func btnVKCollectionMenuCell_TitleAction(_ button: UIButton) {
        let index: Int = Int(button.accessibilityIdentifier!)!
        
        if isImageView {
            let cell:VKCollectionMenuCell = collectionViewMenu.cellForItem(at: IndexPath.init(item: index, section: 0)) as! VKCollectionMenuCell
            var dict = arrMenu[index]
            if self.currentIndex == index {
                cell.btnSortIcon.isSelected =  !cell.btnSortIcon.isSelected
                cell.btnSortIcon.isHidden = dict[IS_SHOW_IMAGE] as!  String == "true" ? false : true
                dict[IS_ACCENDING] = String(!cell.btnSortIcon.isSelected) as AnyObject?
                arrMenu[index] = dict
                self.delegate.onVKCollectionMenu_TabAction(index, arrMenu: arrMenu)
            }
            else{self.setSpecificPage(index)
            cell.btnSortIcon.isHidden = true}
        }
        else{
            self.setSpecificPage(index)
        }
    }
}
