//
//  MyOfferViewController.swift
//  Cubber
//
//  Created by dnk on 06/06/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class MyOfferViewController: UIViewController, VKPagerViewDelegate, AppNavigationControllerDelegate {
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKSideMenu = VKSideMenu()
    @IBOutlet var btnNow: UIButton!
    @IBOutlet var btnComingSoon: UIButton!

    //MARK: CONSTANT
    internal let TAG_PLUS:Int = 100
    
    //MARK: PROPERTRIES
    @IBOutlet var _VKPagerView: VKPagerView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPaginationView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_OFFERANDPROMOCODE)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_OFFERANDPROMOCODE, stclass: F_OFFERANDPROMOCODE)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Offers")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
 
    func appNavigationController_BackAction() {
       let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPrePostpaidAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            btnNow.isSelected = true
            btnComingSoon.isSelected = false
            btnNow.backgroundColor = COLOUR_ORANGE
            btnNow.setTitleColor(UIColor.white, for: .normal)
            btnComingSoon.backgroundColor = UIColor.white
            btnComingSoon.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
            _VKPagerView.jumpToPageNo(0)
        }
        else {
            btnNow.isSelected = false
            btnComingSoon.isSelected = true
            btnComingSoon.backgroundColor = COLOUR_ORANGE
            btnComingSoon.setTitleColor(UIColor.white, for: .normal)
            btnNow.backgroundColor = UIColor.white
            btnNow.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
            _VKPagerView.jumpToPageNo(1)
        }
    }

    
    fileprivate func createPaginationView() {
        
        self.view.layoutIfNeeded()
        let dict: typeAliasStringDictionary = [LIST_ID: String(VAL_LOWER_DECK), LIST_TITLE: "Now Available"]
        let dict1:typeAliasStringDictionary = [LIST_ID:String(VAL_UPPER_DECK), LIST_TITLE: "Coming Soon "]
        let arrOfferList = [dict, dict1]
        self._VKPagerView.setPagerViewData(arrOfferList as [typeAliasDictionary], keyName: LIST_TITLE, font: .systemFont(ofSize: 13), widthView: UIScreen.main.bounds.width)
        self._VKPagerView.delegate = self
        
        for i in 0..<arrOfferList.count {
            
            let xOrigin: CGFloat = CGFloat(i) * self._VKPagerView.scrollViewPagination.frame.width
            let tag: Int = (i + TAG_PLUS)
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: self._VKPagerView.scrollViewPagination.frame.width, height: self._VKPagerView.scrollViewPagination.frame.height)
            let  _myOfferView: MyOfferView = MyOfferView.init(frame: frame)
            _myOfferView.tag = tag
            _myOfferView.translatesAutoresizingMaskIntoConstraints = false;
            self._VKPagerView.scrollViewPagination.addSubview(_myOfferView);
            //---> SET AUTO LAYOUT
            //HEIGHT
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _myOfferView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _myOfferView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _myOfferView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1))
            
            if (i == 0)
            {
                //LEADING
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _myOfferView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else
            {
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let viewPrevious: UIView = self._VKPagerView.scrollViewPagination.viewWithTag(tag - 1)!;
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _myOfferView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            if (i == arrOfferList.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _myOfferView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            self.view.layoutIfNeeded()
            self.setOfferViewData(id: 0)
        }
    }

    func setOfferViewData(id:Int) {
        
        let _MyOfferView: MyOfferView = self._VKPagerView.scrollViewPagination.viewWithTag(id + TAG_PLUS) as! MyOfferView
        _MyOfferView.loadData(tag: id + TAG_PLUS)
    }
    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        self.setOfferViewData(id: selectedMenu)
        if selectedMenu == 0 {
            
            btnNow.isSelected = true
            btnComingSoon.isSelected = false
            btnNow.backgroundColor = COLOUR_ORANGE
            btnNow.setTitleColor(UIColor.white, for: .normal)
            btnComingSoon.backgroundColor = UIColor.white
            btnComingSoon.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
        }
        else {
            btnNow.isSelected = false
            btnComingSoon.isSelected = true
            btnComingSoon.backgroundColor = COLOUR_ORANGE
            btnComingSoon.setTitleColor(UIColor.white, for: .normal)
            btnNow.backgroundColor = UIColor.white
            btnNow.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
        }
    }
}
