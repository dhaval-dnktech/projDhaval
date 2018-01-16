//
//  StartViewController.swift
//  Cubber
//
//  Created by dnk on 26/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import CoreLocation

class StartViewController: UIViewController, UIScrollViewDelegate , UITextFieldDelegate , CLLocationManagerDelegate {
    
    //MARK: PROPERTIES
    
    @IBOutlet var scrollViewBG: UIScrollView!
    
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var viewLineBG: UIView!
    @IBOutlet var viewLine: UIView!
    @IBOutlet var constraintViewLineLeadingToSuper: NSLayoutConstraint!
    
    @IBOutlet var scrollViewImages: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var btnGetStarted: UIButton!
    @IBOutlet var lblStartNote: UILabel!
    fileprivate var imageViewScroll:UIImageView? = nil
    @IBOutlet var viewImage: UIView!
    @IBOutlet var txtCountryCode: FloatLabelTextField!
    
    @IBOutlet var txtMobileNo: FloatLabelTextField!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var arrImages:Array = [typeAliasDictionary]()
    fileprivate var timer:Timer = Timer()
    fileprivate var timerLine:Timer = Timer()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLocationPrompt()
        txtMobileNo.awakeFromNib()
        constraintViewLineLeadingToSuper.constant = -(self.viewLine.frame.width + 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarBackgroundColor(color: .clear)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
        timerLine = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animateLine), userInfo: nil, repeats: true)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_INTRO, stclass: F_INTRO)
        self.setImageScroll()
        btnGetStarted.setViewBorder(UIColor.clear, borderWidth: 0, isShadow: false, cornerRadius: 5, backColor: COLOUR_ORANGE)
        self.registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setStatusBarBackgroundColor(color: UIColor.white)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //MARK: KEYBOARD
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal func keyboardWasShown(_ aNotification: Notification) {
        let info: [AnyHashable: Any] = (aNotification as NSNotification).userInfo!;
        var keyboardRect: CGRect = ((info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
        keyboardRect = self.view.convert(keyboardRect, from: nil);
        
        var contentInset: UIEdgeInsets = scrollViewBG.contentInset
        contentInset.bottom = keyboardRect.size.height
        scrollViewBG.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollViewBG.contentInset = UIEdgeInsets.zero
        }, completion: nil)
    }

    func showLocationPrompt() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == CLAuthorizationStatus.denied || authorizationStatus == CLAuthorizationStatus.restricted {
                let alert = UIAlertController(title: "Need Authorization", message: "This app is unusable if you don't authorize this app to use your location!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    let url = URL(string: UIApplicationOpenSettingsURLString)!
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else { UIApplication.shared.openURL(url) }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setImageScroll(){
        
        let cateResponse = DataModel.getCategoryListResponse()
        arrImages = cateResponse[RES_tutorial] as! [typeAliasDictionary]
        lblStartNote.text = cateResponse[RES_getStartedMessage] as? String
        self.view.layoutIfNeeded()
        self.scrollViewImages.layoutIfNeeded()
        self.viewImage.layoutIfNeeded()
        self.viewBottom.layoutIfNeeded()
        
        for i in 0..<arrImages.count {
            let str:String = arrImages[i][RES_image] as! String
            let tag:Int = i + 100
            
            let xOrigin:CGFloat = CGFloat(i) * CGFloat(scrollViewImages.frame.size.width)
            imageViewScroll = DesignModel.createImageView(CGRect.init(x: xOrigin, y: 0, width: scrollViewImages.frame.size.width, height: viewImage.frame.size.height), image: UIImage.init(), tag: tag, contentMode: .scaleAspectFill)
            
            
            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            // Position Activity Indicator in the center of the main view
            myActivityIndicator.center = (imageViewScroll?.center)!
            
            // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
            myActivityIndicator.hidesWhenStopped = true
            
            // Start Activity Indicator
            myActivityIndicator.startAnimating()
            
            // Call stopAnimating() when need to stop activity indicator
            //myActivityIndicator.stopAnimating()
            
            imageViewScroll?.addSubview(myActivityIndicator)
            myActivityIndicator.startAnimating()
            imageViewScroll?.sd_setImage(with: str.convertToUrl(), completed: { (image, error, type, url) in
                 self.imageViewScroll?.image = image
                myActivityIndicator.stopAnimating()
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
            else {
                
                 //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let scrollViewPrevious:UIImageView = scrollViewImages.viewWithTag(tag - 1) as! UIImageView
                
                scrollViewImages.addConstraint(NSLayoutConstraint.init(item: imageViewScroll!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollViewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            scrollViewImages.contentSize = CGSize.init(width: CGFloat(scrollViewImages.frame.width) * CGFloat(arrImages.count), height: scrollViewImages.frame.width)
            scrollViewImages.isPagingEnabled = true
            viewImage.layoutIfNeeded()
            self.view.layoutIfNeeded()
            pageControl.numberOfPages = arrImages.count
            pageControl.isHidden = arrImages.count == 1 ? true : false
        }
    }
    
    func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollViewImages.frame.width
        let maxWidth:CGFloat = CGFloat(pageWidth) * CGFloat(arrImages.count)
        let contentOffset:CGFloat = self.scrollViewImages.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollViewImages.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollViewImages.frame.height), animated: true)
    }
    
    func animateLine() {
    
      constraintViewLineLeadingToSuper.constant = -(self.viewLine.frame.width + 10)
      self.viewLineBG.layoutIfNeeded()
      constraintViewLineLeadingToSuper.constant = self.viewLineBG.frame.maxX + 10
        UIView.animate(withDuration: 2) {
            self.viewLineBG.layoutIfNeeded()
        }
    }
    
    //MARK: SCROLLVIEW DELEGATE
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewImages {
        let pageWidth:CGFloat = scrollViewImages.frame.width
        let currentPage:CGFloat = floor((scrollViewImages.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
        }
    }
    
    //MARK: BUTTON ACTION

    @IBAction func btnGetStartedAction() {
        
        timer.invalidate()
        let stMobileNo: String = txtMobileNo.text!.trim()
        
        if stMobileNo.isEmpty {
            self._KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: MESSAGE_TYPE.FAILURE); return;
        }
        else {
            if stMobileNo.isNumeric() {
                if !DataModel.validateMobileNo(stMobileNo) {
                  self._KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.FAILURE); return;
                }
            }
        }
        txtMobileNo.resignFirstResponder()
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_MOBILE:stMobileNo]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_IsMobileRegister, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            self.timer.invalidate()
            self.timerLine.invalidate()
            if dict[RES_isRegisterd] as! String == "0" {
                self.obj_AppDelegate.showSignUpPage(mobileNo:stMobileNo)
            }
            else{
                self.obj_AppDelegate.showLoginView(mobileNo: stMobileNo)
            }
        }, onFailure: { (code, dict) in
            print(dict)
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }

    }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtMobileNo.text == "" {
         txtCountryCode.text = ""
        }
        else{ txtCountryCode.text = "+91" }
    }
    //MARK: TEXTFIELD DELEGATE
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
                
        if resultingString.isEmpty { txtCountryCode.text = "" ; return true }
        
        if textField == txtMobileNo  {
            txtCountryCode.text = "+91"
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if resultingString.count == 10 {
                self.txtMobileNo.text = resultingString
                self.txtMobileNo.resignFirstResponder()
                self.btnGetStartedAction()
            }
            else if resultingString.count > 10 {
              return false
            }
            
            return RET
        }
        
        return true
    }
    
    
}
