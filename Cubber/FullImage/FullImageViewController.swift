//
//  FullImageViewController.swift
//  Pavitraa
//
//  Created by dnk on 16/03/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
//import ImageScrollView

class FullImageViewController: UIViewController, UIScrollViewDelegate, AppNavigationControllerDelegate {
   
    //MARK: CONSTANTS
    internal let TAG_PLUS: Int = 100
    
    //MARK: PROPERTIES
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var btnRight: UIButton!
    @IBOutlet var scrollviewImageSlider: UIScrollView!
    @IBOutlet var PageControl: UIPageControl!
    @IBOutlet var imageScrollView: ImageScrollView!

    //MARK: VARIABLES
    let obj_AppDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    internal var arrImagesData = [String]()
    fileprivate var currentPage: Int = 0
    internal var pageNo:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if arrImagesData.count == 1
        {
            btnLeft.isHidden = true
            btnRight.isHidden = true
            PageControl.isHidden = true
        }
       // btnLeft.tintColor = COLOR_GOLDERN_YELLOW
        //btnRight.tintColor = COLOR_GOLDERN_YELLOW
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.createPaginationView(false)

    }
    
    //MARK: APPNAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Event Gallery")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() { let _ = self.navigationController?.popViewController(animated: true) }
    
    fileprivate func createPaginationView(_ isLocalImages: Bool) {
        
        scrollviewImageSlider.layoutIfNeeded()
        for i in 0..<arrImagesData.count {
            
            let dictImage: String  =  arrImagesData[i]
            let tag: Int = (i + self.TAG_PLUS)
            
            let xOrigin: CGFloat = CGFloat(i) * scrollviewImageSlider.frame.width
            
            var _VKAddSlider: VKAddSlider!
            if isLocalImages {
                _VKAddSlider = VKAddSlider.init(frame: CGRect(x: xOrigin, y: 0, width: scrollviewImageSlider.frame.width, height: scrollviewImageSlider.frame.height), image: nil, imageName: dictImage,imageUrl: "", imagePlaceholder: UIImage.init(named: "icon_Default")!)
            }
            else {
                _VKAddSlider = VKAddSlider.init(frame: CGRect(x: xOrigin, y: 0, width: scrollviewImageSlider.frame.width, height: scrollviewImageSlider.frame.height), image: nil, imageName: "", imageUrl: dictImage , imagePlaceholder: #imageLiteral(resourceName: "logo"))
            }
            _VKAddSlider.tag = tag
            _VKAddSlider.imageView.contentMode = UIViewContentMode.scaleAspectFit
            _VKAddSlider.translatesAutoresizingMaskIntoConstraints = true
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapZoomAction))
            doubleTap.numberOfTapsRequired = 2
           // scrollViewBG.addGestureRecognizer(doubleTap)
            PageControl.numberOfPages = arrImagesData.count
            
             scrollviewImageSlider.addSubview(_VKAddSlider)

            //---> SET AUTO LAYOUT
            //HEIGHT
            scrollviewImageSlider.addConstraint(NSLayoutConstraint(item: _VKAddSlider, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:scrollviewImageSlider, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            scrollviewImageSlider.addConstraint(NSLayoutConstraint(item: _VKAddSlider, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollviewImageSlider, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            scrollviewImageSlider.addConstraint(NSLayoutConstraint(item: _VKAddSlider, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollviewImageSlider, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
            
            scrollviewImageSlider.layoutIfNeeded()
            if (i == 0)
            {
                //LEADING
                scrollviewImageSlider.addConstraint(NSLayoutConstraint(item: _VKAddSlider, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollviewImageSlider, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else
            {
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let viewPrevious: UIView = scrollviewImageSlider.viewWithTag(tag - 1)!;
                scrollviewImageSlider.addConstraint(NSLayoutConstraint(item: _VKAddSlider, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
       
        if (i == arrImagesData.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _VKAddSlider, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: scrollviewImageSlider, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            
        }

//        scrollviewImageSlider.setContentOffset(CGPoint.zero, animated: true)
//        self.scrollviewImageSlider.layoutIfNeeded()
//        PageControl.currentPage = 0
        self.jumpOnPerticularPageNo(pageNo: CGFloat(pageNo))
//        
        
    }
    func doubleTapZoomAction(sender: UITapGestureRecognizer) {
        
        let scrollViewBG:UIScrollView = scrollviewImageSlider.viewWithTag((sender.view?.tag)!) as! UIScrollView
        if (scrollViewBG.zoomScale == scrollViewBG.minimumZoomScale) {
            
            scrollViewBG.setZoomScale(scrollViewBG.maximumZoomScale, animated: true) }
        else { scrollViewBG.setZoomScale(scrollViewBG.minimumZoomScale, animated: true) }
        
    }
    private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        if scrollView.tag == 1
        { return nil }
        
        if scrollView.tag > 0 {
            let imgView = scrollView.viewWithTag(scrollView.tag - TAG_PLUS) as! UIImageView
            return imgView
        }
        else { return nil }
    }
    
    //MARK: UISCROLLVIEW DELEGATE
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == scrollviewImageSlider {
            let pageWidth: Float = Float(scrollviewImageSlider.frame.width)
            let pageNo: Float = floor(Float(scrollviewImageSlider.contentOffset.x) / pageWidth)
            currentPage = Int(pageNo)
            PageControl.currentPage = currentPage
        }
        else{
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == scrollviewImageSlider {
            let pageWidth: Float = Float(scrollviewImageSlider.frame.width)
            let pageNo: Float = floor(Float(scrollviewImageSlider.contentOffset.x) / pageWidth)
            if (Int(pageNo) < (arrImagesData.count - 1)) { return }
            PageControl.currentPage = Int(pageNo)
        }
        else{
        }
    }
    //MARK: BUTTON ACTION
    @IBAction func btnLeftAction() {
//        let pageWidth: Float = Float(scrollviewImageSlider.frame.width)
        var currentPage:CGFloat = CGFloat(PageControl.currentPage) - 1
        if currentPage < 0 {
            currentPage = 0;
            return
        }
        scrollviewImageSlider.setContentOffset(CGPoint.init(x: scrollviewImageSlider.frame.width * currentPage, y: 0), animated: true)
        PageControl.currentPage = Int(currentPage)
    }
    @IBAction func btnRightAction() {
        
//        let pageWidth: Float = Float(scrollviewImageSlider.frame.width)
        var currentPage:CGFloat = CGFloat(PageControl.currentPage) + 1
        if Int(currentPage) == arrImagesData.count {
            currentPage = CGFloat(arrImagesData.count - 1);
            return
        }
        scrollviewImageSlider.setContentOffset(CGPoint.init(x: scrollviewImageSlider.frame.width * currentPage, y: 0), animated: true)
        PageControl.currentPage = Int(currentPage)
        
       }
    func jumpOnPerticularPageNo(pageNo: CGFloat)
    {
  
    scrollviewImageSlider.setContentOffset(CGPoint.init(x: scrollviewImageSlider.frame.width * pageNo, y: 0), animated: true)
    PageControl.currentPage = Int(currentPage)
    
    }
}
