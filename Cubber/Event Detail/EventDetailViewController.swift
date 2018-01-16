//
//  EventDetailViewController.swift
//  Cubber
//
//  Created by dnk on 13/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController , AppNavigationControllerDelegate , VKPagerViewDelegate , UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource  , EventTextCellDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, MKMapViewDelegate , EventLocationCellDelegate {
    
    let TAG_PLUS = 100
    let TYPE_gallery    = "gallery"
    let TYPE_text       = "text"
    let TYPE_webview    = "webview"
    let TYPE_seatLayout  = "seat layout"
    let TYPE_venue      = "venue"
    let TYPE_artist     = "artist"
    var HEIGHT_TEXT_CELL1:CGFloat  = 150
    var HEIGHT_TEXT_CELL2:CGFloat  = 150
    var HEIGHT_EXTRA:CGFloat = 0
    let CELL_HEIGHT = "CELL_HEIGHT"
    
    //MARK:PROPERTIES
    @IBOutlet var viewBG: UIView!
    
    @IBOutlet var scrollViewEventDetail: UIScrollView!
    @IBOutlet var viewImage: UIView!
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var viewEventInfoBG: UIView!
    @IBOutlet var tableViewDetails: UITableView!
    @IBOutlet var imageViewEventBanner: UIImageView!
    @IBOutlet var lblEventTitle: UILabel!
    @IBOutlet var lblEventPrice: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblEventVenue: UILabel!
    
    @IBOutlet var lblViewBottom_Price: UILabel!
    @IBOutlet var constraintScrollViewBGTopToSuper: NSLayoutConstraint!
    @IBOutlet var constraintTableviewDetailHeight: NSLayoutConstraint!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var dictEventDetail = typeAliasDictionary()
    fileprivate var arrDetailData = [typeAliasDictionary]()
    fileprivate var arrPackageData = [typeAliasDictionary]()
    fileprivate var arrContentData = [AnyObject]()
    fileprivate var isCompleted:Bool = false
    internal var operatorID:String = ""
    var isReload:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isReload = true
        viewBG.alpha = 0
        self.tableViewDetails.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_GALLERY_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_EVENT_GALLERY_CELL)
        self.tableViewDetails.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_WEBVIEW_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_EVENT_WEBVIEW_CELL)
        self.tableViewDetails.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_LOCATION_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_EVENT_LOCATION_CELL)
        self.tableViewDetails.register(UINib.init(nibName: CELL_IDENTIFIER_EVENT_TEXT_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_EVENT_TEXT_CELL)
        self.tableViewDetails.tableFooterView = UIView.init(frame: .zero)
        self.tableViewDetails.estimatedRowHeight = 200
        self.tableViewDetails.rowHeight = UITableViewAutomaticDimension
        self.callGetSingleEventDetail()
        constraintScrollViewBGTopToSuper.constant = 208.5
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_MODULE_EVENT, stclass: F_MODULE_EVENT)
        self.sendScreenView(name: F_MODULE_EVENT)
    }
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Event Detail")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func callGetSingleEventDetail() {
        
        let dicUser  = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: dicUser[RES_userID] as! String,
                      REQ_OPERATOR_ID:operatorID]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetSingleEventDetail, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.dictEventDetail = dict[RES_eventContent] as! typeAliasDictionary
            self.arrPackageData = dict[RES_packageData] as! [typeAliasDictionary]
            self.setEventDetail()
            self.pushEventDetail()
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);
            self._KDAlertView.didClick(completion: { (completed) in
                let _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func setEventDetail() {
        
        self.arrDetailData = self.dictEventDetail[RES_data] as! [typeAliasDictionary]
        
        for i in 0..<self.arrDetailData.count  {
            var dict = self.arrDetailData[i]
            let type = dict[RES_type] as! String
            if type == TYPE_venue {
                var height : CGFloat = 0.0
                height += (self.dictEventDetail[RES_venue] as! String).textHeight(self.tableViewDetails.frame.width - 16, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 15)!)
                height += (self.dictEventDetail[RES_address] as! String).textHeight(self.tableViewDetails.frame.width - 16, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 15)!) + 10
                height += 160
                dict[CELL_HEIGHT] =  height > 150 ? height as AnyObject? : HEIGHT_TEXT_CELL1 as AnyObject?
            }
            else { dict[CELL_HEIGHT] = HEIGHT_TEXT_CELL1 as AnyObject? }
            self.arrDetailData[i] = dict
        }
        
        lblEventTitle.text = self.dictEventDetail[RES_operatorName]! as? String
        lblEventVenue.text = self.dictEventDetail[RES_venue] as! String?
        lblStartDate.text = self.dictEventDetail["fromDate"] as! String?
        lblEventPrice.text = "\(RUPEES_SYMBOL) \(self.dictEventDetail[RES_price] as! String)"
        lblViewBottom_Price.text = "\(RUPEES_SYMBOL) \(self.dictEventDetail[RES_price] as! String)"
        imageViewEventBanner.sd_setImage(with: (self.dictEventDetail[RES_image] as! String).convertToUrl()) { (image, error, type, url) in
            if image == nil {}
            else { self.imageViewEventBanner.image = image }
        }

        self.tableViewDetails.reloadData()
        self.resizeTableView()
        self.createPaginationView()
        if isReload {
            UIView.animate(withDuration: 0.0, animations: {
                self.viewBG.alpha = 1.0
                self.isReload = false
            })
        }
    }
    
    func pushEventDetail() {
        
        let _gtmModel = GTMModel()
        _gtmModel.ee_type = GTM_EVENT
        _gtmModel.name = GTM_EVENT_BOOKING
        _gtmModel.price = self.dictEventDetail[RES_price] as! String
        _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
        _gtmModel.brand = self.dictEventDetail[RES_operatorName] as! String
        _gtmModel.category = self.dictEventDetail[RES_venue] as! String
        _gtmModel.variant = self.operatorID
        _gtmModel.step = 1
        _gtmModel.dimension4 = "0"
        _gtmModel.list = "Event Section"
        GTMModel.pushProductDetail(gtmModel: _gtmModel)
                
    }
    
    func resizeTableView() {
        var height:CGFloat = 0
        for dict in arrDetailData {
            height += dict[CELL_HEIGHT] as! CGFloat
        }
        constraintTableviewDetailHeight.constant = height
    }
    
    fileprivate func createPaginationView() {
        
        self.view.layoutIfNeeded()
        
        self._VKPagerView.setPagerViewData(self.arrDetailData, keyName: RES_tabTitle)
        self._VKPagerView.delegate = self
        
        for i in 0..<self.arrDetailData.count {
            var dict: typeAliasDictionary = self.arrDetailData[i]
            
            let xOrigin: CGFloat = CGFloat(i) * self._VKPagerView.scrollViewPagination.frame.width
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: self._VKPagerView.scrollViewPagination.frame.width, height: self._VKPagerView.scrollViewPagination.frame.height)
            let  _eventListView: UIView = UIView.init(frame: frame)
            _eventListView.tag = Int(i) + TAG_PLUS
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
            
            if (i == arrDetailData.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _eventListView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
        }
        self.view.layoutIfNeeded()
        
    }
    
    @IBAction func btnBookTicketAction() {
        let eventbookVC = EventBookingViewController(nibName: "EventBookingViewController", bundle: nil)
        eventbookVC.dictEventDetail = self.dictEventDetail
        eventbookVC.arrPackageData = self.arrPackageData
        eventbookVC.operatorID = self.operatorID
        self.navigationController?.pushViewController(eventbookVC, animated: true)
    }
    
    
    //MARK: TABLEVIEW DELEGATE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDetailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = arrDetailData[indexPath.row]
        let type = dict[RES_type] as! String
        
        if type == TYPE_text {
            
            let cellText:EventTextCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_TEXT_CELL) as! EventTextCell
            cellText.btnShowMoreLess.isHidden = true
            cellText.btnShowMoreLess.isEnabled = false
            cellText.lblTitle.text = dict[RES_title] as! String?
            cellText.lblText.attributedText = (dict[RES_contentData] as! String).htmlAttributedString
            cellText.delegate = self
            cellText.btnShowMoreLess.accessibilityIdentifier = String(indexPath.row)
            let height:CGFloat = (cellText.lblText.text?.textHeight(cellText.lblText.frame.width, textFont: cellText.lblText.font))!
            print(height)
            if height > 80 {
                cellText.btnShowMoreLess.isHidden = false
                cellText.btnShowMoreLess.isEnabled = true
                
            }
            else {
                if dict[CELL_HEIGHT] as! CGFloat > 150 {
                    cellText.btnShowMoreLess.isSelected = true
                }
                else{
                    cellText.btnShowMoreLess.isSelected = false
                }
                cellText.btnShowMoreLess.isHidden = true
                cellText.btnShowMoreLess.isEnabled = false
            }
            cellText.selectionStyle = .none
            cellText.contentView.layoutIfNeeded()
            return cellText
        }
            
        else if type == TYPE_webview {
            let cellWeb:EventWebViewCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_WEBVIEW_CELL) as! EventWebViewCell
            cellWeb.lblTitle.text = dict[RES_title] as! String?
            cellWeb.webViewEvent.loadHTMLString(dict[RES_contentData] as! String, baseURL: nil)
            cellWeb.selectionStyle = .none
            return cellWeb
        }
            
        else if type == TYPE_venue {
            
            let cellVenue:EventLocationCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_LOCATION_CELL) as! EventLocationCell
            cellVenue.btnCellVenue.accessibilityIdentifier = String(indexPath.row)
            cellVenue.delegate = self
            cellVenue.mapView.delegate = self
            cellVenue.lblTitle.text = dict[RES_title] as! String?
            let contentData = dict[RES_contentData] as! typeAliasDictionary
            let annotation = MKPointAnnotation()
            
            annotation.title = title
            let cordinate = CLLocationCoordinate2DMake(Double(contentData[RES_latitude] as! String)!,Double(contentData[RES_longitude] as! String)!)
            annotation.coordinate = cordinate
            cellVenue.mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(cordinate, span)
            cellVenue.mapView.setRegion(region, animated: true)
            cellVenue.lblVanue.text =  dictEventDetail[RES_venue] as! String?
            cellVenue.lblAddress.text =  dictEventDetail[RES_address] as! String?
            cellVenue.selectionStyle = .none
            
            return cellVenue
        }
        else if type == TYPE_gallery || type == TYPE_seatLayout {
            let cellGallery:EventGallaryCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_GALLERY_CELL) as! EventGallaryCell
            cellGallery.lblTitle.text = dict[RES_title] as! String?
            cellGallery.collectionViewGallery.dataSource = self
            cellGallery.collectionViewGallery.delegate = self
            arrContentData = dict[RES_contentData] as! [String] as [AnyObject]
            cellGallery.collectionViewGallery.accessibilityIdentifier = type
            cellGallery.collectionViewGallery.tag = indexPath.row
            cellGallery.collectionViewGallery.reloadData()
            cellGallery.selectionStyle = .none
            return cellGallery
        }
            
        else if  type == TYPE_artist {
            let cellGallery:EventGallaryCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_GALLERY_CELL) as! EventGallaryCell
            cellGallery.lblTitle.text = dict[RES_title] as! String?
            cellGallery.collectionViewGallery.dataSource = self
            cellGallery.collectionViewGallery.delegate = self
            cellGallery.collectionViewGallery.tag = indexPath.row
            arrContentData = dict[RES_contentData] as! [typeAliasDictionary] as [AnyObject]
            cellGallery.collectionViewGallery.accessibilityIdentifier = TYPE_artist
            cellGallery.collectionViewGallery.reloadData()
            cellGallery.selectionStyle = .none
            return cellGallery
        }
            
        else {
            let cellGallery:EventGallaryCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EVENT_GALLERY_CELL) as! EventGallaryCell
            cellGallery.lblTitle.text = dict[RES_title] as! String?
            return cellGallery
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dict = self.arrDetailData[indexPath.row]
        let type = dict[RES_type] as! String
        if type == TYPE_venue {
            return dict[CELL_HEIGHT] as! CGFloat
            return UITableViewAutomaticDimension
        }
        else { return dict[CELL_HEIGHT] as! CGFloat  }
    }
    
    //MARK: COLLECTION VIEW DATASOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dict = arrDetailData[collectionView.tag]
        
        if collectionView.accessibilityIdentifier == TYPE_artist {
            let  arrtData = dict[RES_contentData] as! [typeAliasDictionary] as [AnyObject]
            return arrtData.count
        }
        else if  collectionView.accessibilityIdentifier == TYPE_gallery {
            let  arrtData = dict[RES_contentData] as! [String] as [AnyObject]
            return arrtData.count
        }
        return arrContentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dict = arrDetailData[collectionView.tag]
        if collectionView.accessibilityIdentifier == TYPE_artist {
            let  arrtData = dict[RES_contentData] as! [typeAliasDictionary] as [AnyObject]
            let cell:EventArtistCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_EVENT_ARTIST_CELL, for: indexPath) as! EventArtistCell
            let dictArtist = arrtData[indexPath.item] as! typeAliasDictionary
            cell.imageViewArtist.sd_setImage(with: ( dictArtist[RES_image] as! String).convertToUrl()) { (image, error, cacheType, url) in
                cell.imageViewArtist.image = image
            }
            cell.lblName.text = dictArtist[RES_name] as? String
            return cell
        }
            
        else {
            let cell:GalleryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_EVENT_GALLERY_COLLECTION_CELL, for: indexPath) as! GalleryCollectionCell
            let  arrtData = dict[RES_contentData] as! [String] as [AnyObject]
            cell.activityIndicator.startAnimating()
            cell.imageViewGallery.sd_setImage(with: (arrtData[indexPath.item] as! String).convertToUrl()) { (image, error, cacheType, url) in
                cell.imageViewGallery.image = image
                cell.activityIndicator.stopAnimating()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.accessibilityIdentifier == TYPE_artist { return CGSize.init(width: 80, height: 100) }
        else { return CGSize.init(width: 200, height: 150) }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.accessibilityIdentifier == TYPE_gallery || collectionView.accessibilityIdentifier == TYPE_seatLayout {
            let dict = arrDetailData[collectionView.tag]
            arrContentData = dict[RES_contentData] as! [String] as [AnyObject]
            let fullImageView = FullImageViewController(nibName: "FullImageViewController", bundle: nil)
            fullImageView.arrImagesData = [arrContentData[indexPath.item] as! String]
            self.navigationController?.pushViewController(fullImageView, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewEventDetail {
            if scrollView.contentOffset.y > 0 &&  self.constraintScrollViewBGTopToSuper.constant == 208.5 {
                self.animateView(isUp: true , scrollView:scrollView)}
            else if scrollView.contentOffset.y <= 0 &&  self.constraintScrollViewBGTopToSuper.constant == 0 {
                scrollView.bounces = false
                self.animateView(isUp: false ,  scrollView:scrollView)}
        }
    }
    
    func animateView(isUp:Bool , scrollView:UIScrollView ) {
        if isUp {
            
            self.constraintScrollViewBGTopToSuper.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                self.isCompleted = true
                scrollView.bounces = true
            })
        }
        else if isCompleted {
            self.constraintScrollViewBGTopToSuper.constant = 208.5
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                self.isCompleted = false
                scrollView.bounces = true
            })
        }
    }
    
    //MARK: VKPAGERVIEW DELEGATE
    
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        let cell = tableViewDetails.cellForRow(at: IndexPath.init(row: selectedMenu, section: 0))
        let point:CGPoint = (cell?.contentView.convert((cell?.contentView.frame.origin)!, to: scrollViewEventDetail))!
        scrollViewEventDetail.setContentOffset(point, animated: true)
    }
    
    func onVKPagerViewScrolling(_ selectedMenu: Int, arrMenu: [typeAliasDictionary]) {
        
    }
    func EventTextCell_btnShowMoreAction(button: UIButton) {
        
        button.isSelected = !button.isSelected
        let ind:Int  = Int(button.accessibilityIdentifier!)!
        var dict = arrDetailData[ind]
        
        if button.isSelected {
            let cell:EventTextCell = tableViewDetails.cellForRow(at: IndexPath.init(row: ind, section: 0)) as! EventTextCell
            let height:CGFloat = (cell.lblText.text?.textHeight(cell.lblText.frame.width, textFont: cell.lblText.font))!
            dict[CELL_HEIGHT] = HEIGHT_TEXT_CELL1 + (height - 0) + HEIGHT_EXTRA as AnyObject?
            //dict[CELL_HEIGHT] = (height + 70) as AnyObject?
            arrDetailData[ind] = dict
            
        }
        else {
            dict[CELL_HEIGHT] = HEIGHT_TEXT_CELL1 as AnyObject?
            arrDetailData[ind] = dict
        }
        self.tableViewDetails.reloadData()
        self.resizeTableView()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = #imageLiteral(resourceName: "ic_pointer")
            return annotationView
        }
    }
    func EventCell_btnLocationAction(button: UIButton) {
        
        let ind = Int(button.accessibilityIdentifier!)!
        let cellVenue:EventLocationCell = tableViewDetails.cellForRow(at: IndexPath.init(row: ind, section: 0)) as! EventLocationCell
        let mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
        mapVC.lat = (cellVenue.mapView.annotations.first?.coordinate.latitude)!
        mapVC.long = (cellVenue.mapView.annotations.first?.coordinate.longitude)!
        mapVC.stVenue = dictEventDetail[RES_venue] as! String
        mapVC.stAddress = dictEventDetail[RES_address] as! String
        obj_AppDelegate.navigationController.pushViewController(mapVC, animated: true)
    }
}
