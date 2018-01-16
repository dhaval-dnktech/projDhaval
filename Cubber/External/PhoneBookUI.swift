//
//  PhoneBookUI.swift
//  Cubber
//
//  Created by Vyas Kishan on 15/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
import AddressBookUI

protocol PhoneBookUIDelegate {
    func phoneBookUI_SelectedNumber(_ number: String)
}

class PhoneBookUI: NSObject, ABPeoplePickerNavigationControllerDelegate {

    //MARK: PROPERTIES
    var delegate: PhoneBookUIDelegate! = nil
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: CUSTOME METHODS
    internal func showPhoneBook(_ viewController: UIViewController) {
        let addressBookController: ABPeoplePickerNavigationController = ABPeoplePickerNavigationController()
        addressBookController.peoplePickerDelegate = self
        addressBookController.displayedProperties = [NSNumber(value: kABPersonPhoneProperty as Int32)]
        obj_AppDelegate.navigationController.present(addressBookController, animated: true, completion: nil)
    }
    
    //MARK: AB PEOPLE PICKER NAVIGATION CONTROLLER DELEGATE
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        let phones: ABMultiValue = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        var selectedPhone = ABMultiValueCopyValueAtIndex(phones, ABMultiValueGetIndexForIdentifier(phones, identifier)).takeRetainedValue() as! String
        selectedPhone = selectedPhone.extractPhoneNo()
        self.delegate.phoneBookUI_SelectedNumber(selectedPhone)
    }
    
    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
        peoplePicker.dismiss(animated: true, completion: nil)
    }
}
