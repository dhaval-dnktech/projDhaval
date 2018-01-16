//
//  VKPagerView.swift
//  Cubber
//
//  Created by Vyas Kishan on 23/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol VKPagerViewDelegate:class {
            func onVKPagerViewScrolling(_ selectedMenu: Int)
 @objc optional func onVKPagerViewScrolling(_ selectedMenu: Int , arrMenu:[typeAliasDictionary])
}

class VKPagerView: UIView {
    
    //MARK: PROPERTIES
    @IBOutlet var _vkCollectionMenu: VKCollectionMenu!
    @IBOutlet var scrollViewPagination: UIScrollView!
    @IBOutlet var delegate: VKPagerViewDelegate!
    
    internal var backColor:UIColor = UIColor.white
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

    }
    
    internal func setPagerViewData(_ array: [typeAliasDictionary], keyName: String) {
        self._vkCollectionMenu.setMenuData(array, keyName: keyName)
    }
    
    internal func setPagerViewData(_ array: [typeAliasDictionary], keyName: String, font: UIFont, widthView: CGFloat) {
        self._vkCollectionMenu.setMenuData(self.getUpperCasedArray(array: array, keyName: keyName), keyName: keyName, font: font, widthView: widthView)
        
    }
    
    internal func setPagerViewData(_ array: [typeAliasDictionary], keyName: String, font: UIFont, widthView: CGFloat , isImageView:Bool) {
        self._vkCollectionMenu.setMenuData(self.getUpperCasedArray(array: array, keyName: keyName), keyName: keyName, font: font, widthView: widthView,isImageView:isImageView)
    }
    
    internal func setPagerViewData(_ array: [typeAliasDictionary], keyName: String, font: UIFont, widthView: CGFloat, backColor:UIColor , selectedBottomColor: UIColor) {
        self._vkCollectionMenu.setMenuData(self.getUpperCasedArray(array: array, keyName: keyName), keyName: keyName, font: font, widthView: widthView, bgColor: backColor, selctedColor: selectedBottomColor)
        
    }
    
    //MARK: CUSTOME METHODS
    
    func getUpperCasedArray(array:[typeAliasDictionary] , keyName:String) -> [typeAliasDictionary] {
    
        var arr = [typeAliasDictionary]()
        for i in 0..<array.count {
            var dict:typeAliasDictionary = array[i]
            dict[keyName] = ((dict[keyName] as! String).uppercased()) as AnyObject?
            arr.append(dict)
        }
        return arr
        
    }
    
    internal func jumpToPageNo(_ page: Int) { self._vkCollectionMenu.setSpecificPage(page) }
    
    //MARK: UISCROLLVIEW DELEGATE
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollViewPagination.frame.width;
        let page: Int = Int(floor((scrollViewPagination.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        _vkCollectionMenu.setSelectedMenu(page)
        self.delegate.onVKPagerViewScrolling(page)
    }
    
    //MARK: VKCOLLECTIONMENU DELEGATE
    func onVKCollectionMenu_TabAction(_ selectedMenu: Int) {
        var contentOffset: CGPoint = scrollViewPagination.contentOffset
        contentOffset.x = scrollViewPagination.frame.width * CGFloat(selectedMenu)
        scrollViewPagination.setContentOffset(contentOffset, animated: true)
        self.delegate.onVKPagerViewScrolling(selectedMenu)
    }
    
    func onVKCollectionMenu_TabAction(_ selectedMenu: Int, arrMenu:[typeAliasDictionary]){
        
        var contentOffset: CGPoint = scrollViewPagination.contentOffset
        contentOffset.x = scrollViewPagination.frame.width * CGFloat(selectedMenu)
        scrollViewPagination.setContentOffset(contentOffset, animated: true)
        self.delegate.onVKPagerViewScrolling!(selectedMenu, arrMenu: arrMenu)
    }
}
