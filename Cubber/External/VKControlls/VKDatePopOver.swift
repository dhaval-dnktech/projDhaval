//
//  VKDatePopOver.swift
//  Cubber
//
//  Created by dnk on 16/11/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

public enum VKDateFormat : String {
    case DDMMYYYY
    case DDMMMYYYY
    case MMDDYYYY
    case YYYYMMDD
    case HHMMAA
}

public enum VKPickerFormat :String
{
    case Picker_Date
    case Picker_DateAndTime
    case Picker_Time
}

public enum DATE_TYPE :String
{
    case DATE_DEFAULT
    case DATE_FROM
    case DATE_TO
    case DATE_INVOICE_DATE
    case DATE_BIRTHDATE
    case DATE_OF_JOURNEY
}

protocol VKDatePopoverDelegate
{
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String, dateType: DATE_TYPE, dateFormat: DateFormatter)
    func vkDatePopoverClearDate(_ dateType: DATE_TYPE)
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate:String)
}

class VKDatePopOver: UIView, UIGestureRecognizerDelegate {
    
    //MARK: PROPERTIES
    var delegate: VKDatePopoverDelegate!
    
    //MARK: CONSTANT
    internal let VK_DATE_POPOVER_DURATION: Double = 0.3
    internal let SUPER_VIEW_TAG: Int = 100001
    internal let SUB_VIEW_TAG: Int = 1100001
    internal let BAR_HEIGHT: Int = 44
    fileprivate let COLOUR_TOOLBAR_TINT: UIColor = RGBCOLOR(238, g: 238, b: 238)
    
    //MARK: VARIABLES
    var selDate, minDate, maxDate: String!
    var datePicker: UIDatePicker!
    var _vkDateFormat: VKDateFormat!
    var obj_vkPickerFormat: VKPickerFormat!
    var _isOutSideClickedHidden: Bool!
    var _DATE_TYPE: DATE_TYPE!
    var stDateFormate: String!
    var contentView: UIView!
    var isShowCancelButton:Bool = true
    
    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    func initSetFrame(_ selectedDate: String, mininumDate: String, maximumDate: String, dateFormat: VKDateFormat, dateType: DATE_TYPE, isOutSideClickedHidden: Bool , isShowCancel: Bool) {
        
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.frame = UIScreen.main.bounds
        obj_AppDelegate.navigationController.view.addSubview(self)
        
        selDate = selectedDate
        minDate = mininumDate
        maxDate = maximumDate
        isShowCancelButton = isShowCancel
        self._vkDateFormat = dateFormat
        self._isOutSideClickedHidden = isOutSideClickedHidden
        self._DATE_TYPE = dateType
        self.createDatePickerView()
        
    }
    
    func createDatePickerView() {
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        if _isOutSideClickedHidden == true {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.vkDatePopover_CancelAction))
            tapGesture.delegate = self
            self.tag = SUPER_VIEW_TAG
            self.addGestureRecognizer(tapGesture)
            self.isMultipleTouchEnabled = true
            self.isUserInteractionEnabled = true
        }
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 240))
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        //UIDatePicker - datePicker
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 44, width: 0, height: 0))
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        
        if _vkDateFormat ==  VKDateFormat.YYYYMMDD{
            stDateFormate = "yyyy-MM-dd"
        }else if _vkDateFormat == VKDateFormat.DDMMYYYY{
            stDateFormate = "dd-MM-yyyy"
        }else if _vkDateFormat == VKDateFormat.DDMMMYYYY{
            stDateFormate = "dd/MMM/yyyy"
        }else if _vkDateFormat == VKDateFormat.MMDDYYYY{
            stDateFormate = "MM/dd/yyyy"
        }
        
        if selDate != "" {
            datePicker.setDate(self.getDate(selDate, format: stDateFormate), animated: true)
        }
        if minDate != "" {
            datePicker.minimumDate = self.getDate(minDate, format: stDateFormate)
        }
        if maxDate != ""{
            datePicker.maximumDate = self.getDate(maxDate, format: stDateFormate)
        }
        contentView.addSubview(datePicker)
        
        //Toolbar
        let barWidth: CGFloat = UIScreen.main.bounds.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Int(barWidth), height: BAR_HEIGHT))
        toolbar.isTranslucent = false
        toolbar.barTintColor = COLOUR_TOOLBAR_TINT
        toolbar.tintColor = UIColor.black
        toolbar.alpha = 0.9
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(vkDatePopover_CancelAction))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(vkDatePopover_ClearAction))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(vkDatePopover_DoneAction))
        
        var barItems = [flexSpace, doneButton]
        if isShowCancelButton {
            barItems = [flexSpace, cancelButton, clearButton, doneButton]
        }

        toolbar.setItems(barItems, animated: true)
        contentView.addSubview(toolbar)
        var cFrame = contentView.frame
        cFrame.origin.y = UIScreen.main.bounds.height
        contentView.frame = cFrame
        
        //Animation
        UIView.animate(withDuration: VK_DATE_POPOVER_DURATION, animations: {() -> Void in
            var frame = self.contentView.frame
            frame.origin.y = UIScreen.main.bounds.height - self.contentView.frame.height
            self.contentView.frame = frame
            }, completion: { _ in })
    }
    
    
    private func getDate(_ strDate: String, format: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.date(from: strDate)!
    }
    
    func vkDatePopover_CancelAction() {
        UIView.animate(withDuration: TimeInterval(VK_DATE_POPOVER_DURATION), animations: {() -> Void in
            var frame = self.contentView.frame
            frame.origin.y = UIScreen.main.bounds.height
            self.contentView.frame = frame
            }, completion: {(_ finished: Bool) -> Void in
                UIView.transition(with: self.superview!, duration: TimeInterval(self.VK_DATE_POPOVER_DURATION), options: .transitionCrossDissolve, animations: {() -> Void in
                    self.removeFromSuperview()
                    }, completion: { _ in })
        })
    }
    
    func vkDatePopover_DoneAction() {
        let df = DateFormatter()
        self.vkDatePopover_CancelAction()
        df.dateFormat = stDateFormate
        let selectedDate: String = df.string(from: datePicker.date)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(VK_DATE_POPOVER_DURATION * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
            
            self.delegate.vkDatePopoverSelectedDate(self.datePicker.date, strDate: selectedDate, dateType: self._DATE_TYPE, dateFormat: df)
        })
    }
    
    func vkDatePopover_ClearAction() {
        self.vkDatePopover_CancelAction()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(VK_DATE_POPOVER_DURATION * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
            self.delegate.vkDatePopoverClearDate(self._DATE_TYPE)
        })
    }
    
    class func getDate(_ vkDateFormat: VKDateFormat, date: Date) -> String {
        var format = ""
        
        if vkDateFormat == VKDateFormat.YYYYMMDD {
            format = "yyyy-MM-dd"
        }else if vkDateFormat == VKDateFormat.DDMMYYYY {
            format = "dd-MM-yyyy"
        }else if vkDateFormat == VKDateFormat.DDMMMYYYY {
            format = "dd-MMM-yyyy"
        }else if vkDateFormat == VKDateFormat.MMDDYYYY {
            format = "MM-dd-yyyy"
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: date)
    }
    
    //MARK: UIGestureRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        if view?.tag != SUPER_VIEW_TAG {
            return false
        }
        return true
    }
}
