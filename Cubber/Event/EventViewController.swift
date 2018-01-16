//
//  EventViewController.swift
//  Cubber
//
//  Created by dnk on 12/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class EventViewController: UIViewController,AppNavigationControllerDelegate, UIScrollViewDelegate, VKPagerViewDelegate , UITableViewDelegate , EventViewDelegate {
    
     let TAG_PLUS = 100
    //MARK:PROPERTIES
    @IBOutlet var scrollViewImages: UIScrollView!
    @IBOutlet var viewImage: UIView!
    fileprivate var imageViewScroll:UIImageView? = nil
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var constraintVKPagerTopToSuper: NSLayoutConstraint!
    
    @IBOutlet var lblNoEventFound: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_Location = Location.init()
    fileprivate var _KDAlertView = KDAlertView()
    var dictOpertaorCategory:typeAliasDictionary!
    var arrSliderData:Array = [typeAliasDictionary]()
    var arrCategoryData:Array = [typeAliasDictionary]()
    fileprivate var timer:Timer = Timer()
    fileprivate var isCompleted:Bool = false
    var isReload:Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
         isReload = true
        self.callGetEventList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isReload {
            self.constraintVKPagerTopToSuper.constant = viewImage.frame.maxY
            isReload = false
        }
        self.SetScreenName(name: F_MODULE_EVENT, stclass: F_MODULE_EVENT)
        self.sendScreenView(name: F_MODULE_EVENT)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNavigationBar() {
        
       obj_AppDelegate.navigationController.setCustomTitle("\(dictOpertaorCategory[RES_operatorCategoryName] as! String)")
       obj_AppDelegate.navigationController.setLeftButton(title: "")
       obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func callGetEventList() {
       
        let dicUser  = DataModel.getUserInfo()
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken() as String
        params[REQ_USER_ID] = dicUser[RES_userID]! as? String
        params[REQ_LATITUDE] = obj_Location.latitude as String
        params[REQ_LONGITUDE] = obj_Location.longitude as String

        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetEventInfo, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.arrSliderData = dict[RES_sliderData] as! [typeAliasDictionary]
            if self.arrSliderData.count == 0 {
                self.constraintVKPagerTopToSuper.constant = 0
            }
            self.setImageScroll()
            self.arrCategoryData = dict[RES_categoryData] as! [typeAliasDictionary]
            self.createPaginationView()
            self.lblNoEventFound.isHidden = true

            }, onFailure: { (code, dict) in
                self.lblNoEventFound.isHidden = false
                self.lblNoEventFound.text = dict[RES_message] as? String
                self.constraintVKPagerTopToSuper.constant = 0
                self.view.layoutIfNeeded()
            
        }) { let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .INTERNET_WARNING)
            }
    }
    
    //MARK: CUSTOME METHODS
    
    fileprivate func createPaginationView() {
    
        self.view.layoutIfNeeded()
        //self._VKPagerView.setPagerViewData(self.arrTransTypeList , keyName: RES_value, font: UIFont.systemFont(ofSize: 11), widthView:  UIScreen.main.bounds.width)
        self._VKPagerView.setPagerViewData(self.arrCategoryData, keyName: RES_categoryName)
        self._VKPagerView.delegate = self
        
        
        for i in 0..<self.arrCategoryData.count {
            var dict: typeAliasDictionary = self.arrCategoryData[i]
            
            let catID = dict[RES_categoryId] as! String
            let xOrigin: CGFloat = CGFloat(i) * self._VKPagerView.scrollViewPagination.frame.width
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: self._VKPagerView.scrollViewPagination.frame.width, height: self._VKPagerView.scrollViewPagination.frame.height)
            let  _eventListView: EventListView = EventListView.init(frame: frame)
            _eventListView.tag = Int(i) + TAG_PLUS
            _eventListView.tableViewEvent.delegate = self
            _eventListView.delegate = self
            _eventListView.translatesAutoresizingMaskIntoConstraints = false;
            self._VKPagerView.scrollViewPagination.addSubview(_eventListView);
            
            //---> SET AUTO LAYOUT
            //HEIGHT
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _eventListView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _eventListView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _eventListView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1))
            
            if (i == 0)
            {
                //LEADING
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _eventListView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else
            {
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let viewPrevious: UIView = self._VKPagerView.scrollViewPagination.viewWithTag(TAG_PLUS + Int(i) - 1)!;
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _eventListView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            if (i == arrCategoryData.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _eventListView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
        }
        self.view.layoutIfNeeded()
        self.setEventViewData(id: 0, categoryid: 0)
    }
    
    func setImageScroll(){
        
            for i in 0..<self.arrSliderData.count {
            let str:String = self.arrSliderData[i][RES_bannerImage] as! String
            let tag:Int = i + 100
            
            let xOrigin:CGFloat = CGFloat(i) * CGFloat(scrollViewImages.frame.size.width)
            imageViewScroll = DesignModel.createImageView(CGRect.init(x: xOrigin, y: 0, width: scrollViewImages.frame.size.width, height: scrollViewImages.frame.size.height), image: UIImage.init(), tag: tag, contentMode: .scaleAspectFit)
            let indicator = UIActivityIndicatorView()
            indicator.hidesWhenStopped = true
            scrollViewImages.addSubview(indicator)
            indicator.startAnimating()
            imageViewScroll?.sd_setImage(with: str.convertToUrl(), completed: { (image, error, type, url) in
                self.imageViewScroll?.image = image
                indicator.stopAnimating()
            })
            self.view.layoutIfNeeded()
            scrollViewImages.addSubview(imageViewScroll!)
            
            //---> SET AUTO LAYOUT
            
            imageViewScroll?.translatesAutoresizingMaskIntoConstraints  = true
            
            //HEIGHT
            scrollViewImages.addConstraint(NSLayoutConstraint.init(item: imageViewScroll!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: scrollViewImages, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            scrollViewImages.addConstraint(NSLayoutConstraint.init(item: imageViewScroll!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollViewImages, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            scrollViewImages.addConstraint(NSLayoutConstraint.init(item: imageViewScroll!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollViewImages, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
            
            //LEADING
            
            if i==0
            {
                scrollViewImages.addConstraint(NSLayoutConstraint.init(item: imageViewScroll!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollViewImages, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else{
                
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let scrollViewPrevious:UIImageView = scrollViewImages.viewWithTag(tag - 1) as! UIImageView
                
                scrollViewImages.addConstraint(NSLayoutConstraint.init(item: imageViewScroll!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollViewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            scrollViewImages.contentSize = CGSize.init(width: CGFloat(scrollViewImages.frame.width) * CGFloat(arrSliderData.count), height: scrollViewImages.frame.size.height)
            scrollViewImages.isPagingEnabled = true
            viewImage.layoutIfNeeded()
            self.view.layoutIfNeeded()
            pageControl.numberOfPages = arrSliderData.count
            pageControl.isHidden = arrSliderData.count == 1 ? true : false
            
        }
    }
    
    @IBAction func sliderTapAction(_ sender: UITapGestureRecognizer) {
        
        let dict = arrSliderData[pageControl.currentPage]
        let eventDetailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
        eventDetailVC.operatorID = dict[RES_operatorID] as! String
        obj_AppDelegate.navigationController.pushViewController(eventDetailVC, animated: true)
    }
    
    
    func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollViewImages.frame.width
        let maxWidth:CGFloat = CGFloat(pageWidth) * CGFloat(arrSliderData.count)
        let contentOffset:CGFloat = self.scrollViewImages.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollViewImages.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollViewImages.frame.height), animated: true)
    }
    
    //MARK: SCROLLVIEW DELEGATE
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollViewImages {
            let pageWidth:CGFloat = scrollViewImages.frame.width
            let currentPage:CGFloat = floor((scrollViewImages.contentOffset.x-pageWidth/2)/pageWidth)+1
            self.pageControl.currentPage = Int(currentPage);
        }
      else {
            if scrollView.contentOffset.y > 0 &&  self.constraintVKPagerTopToSuper.constant == viewImage.frame.maxY {
                self.animateView(isUp: true , scrollView:scrollView)}
            else if scrollView.contentOffset.y <= 0 &&  self.constraintVKPagerTopToSuper.constant == 0 {
                scrollView.bounces = false
                self.animateView(isUp: false ,  scrollView:scrollView)}
        }
       
    }
    
    
    func animateView(isUp:Bool , scrollView:UIScrollView ) {
        if isUp {
            self.constraintVKPagerTopToSuper.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                self.isCompleted = true
                scrollView.bounces = true
            })
        }
        else if isCompleted {
            self.constraintVKPagerTopToSuper.constant = viewImage.frame.maxY
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                self.isCompleted = false
                scrollView.bounces = true
            })
        }
    }

    
    
    func setEventViewData(id:Int, categoryid: Int) {
        let _eventListView:EventListView = self._VKPagerView.viewWithTag(TAG_PLUS + id) as! EventListView
        _eventListView.loadData(id: categoryid)
    }

    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        var dict: typeAliasDictionary = self.arrCategoryData[selectedMenu]
        self.setEventViewData(id: selectedMenu,categoryid:Int(dict[RES_categoryId] as! String)!)
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
        
    }
    //MARK: EVENTVIEW DELEGATE
    func EventViewDelegate_didSelectRow(dict: typeAliasDictionary) {
        let eventDetailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
        eventDetailVC.operatorID = dict[RES_operatorID] as! String
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
}
