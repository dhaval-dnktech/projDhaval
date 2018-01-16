//
//  PhoneBook.swift
//  Cubber
//
//  Created by Vyas Kishan on 29/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
import AddressBook

class PhoneBook: NSObject {

    fileprivate var arrContactList = [typeAliasDictionary]()
    fileprivate var isRemoveExtraContent: Bool = false
    fileprivate let _KDAlertView = KDAlertView()
    
    internal func getPhoneBookContact(_ isRemoveExtraContent: Bool) -> Array<typeAliasDictionary> {
        self.isRemoveExtraContent = isRemoveExtraContent
        self.getAllContactList()
        return self.arrContactList
    }
    
    fileprivate func getAllContactList() {
        let authorizationStatus: ABAuthorizationStatus = ABAddressBookGetAuthorizationStatus()
        switch authorizationStatus {
        case .denied, .restricted:
             _KDAlertView.showMessage(message: "App requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app.", messageType: MESSAGE_TYPE.WARNING)
             return

             
            print("AddressBook : Denied")
            
        case .authorized:
            print("AddressBook : Authorized")
            self.listPeopleInAddressBook()
            
        case .notDetermined:
            print("AddressBook : Not Determined")
            
            let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            ABAddressBookRequestAccessWithCompletion(addressBookRef) { (granted, error) in
                DispatchQueue.main.async {
                    if !granted { print("AddressBook : Just denied");
                        self._KDAlertView.showMessage(message: "App requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app.", messageType: MESSAGE_TYPE.WARNING)
                        return
                    }
                    else { print("AddressBook : Just authorized"); self.listPeopleInAddressBook(); }
                }
            }
        }
    }
    
    fileprivate func listPeopleInAddressBook() {
        var counter: Int = 0
        var errorRef: Unmanaged<CFError>?
        let addressBook = extractABAddressBookRef(abRef: ABAddressBookCreateWithOptions(nil, &errorRef))
        let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
        for person in people {
            if ABRecordCopyCompositeName(person) != nil {
                let contactName: String = ABRecordCopyCompositeName(person).takeRetainedValue() as String
                print("Name \(contactName)")
                if !contactName.contains("Spam") && ABRecordCopyValue(person, kABPersonPhoneProperty) != nil {
                    let phones: ABMultiValue = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
                    for i in 0..<ABMultiValueGetCount(phones) {
                        var phone = ABMultiValueCopyValueAtIndex(phones, i).takeRetainedValue() as! String
                        if self.isRemoveExtraContent{ phone = phone.extractPhoneNo() }
                        if phone.characters.count >= 10 {
                            let dictdictPhone = [LIST_ID:phone, LIST_TITLE:contactName]
                            self.arrContactList.append(dictdictPhone as typeAliasDictionary)
                        }
                    }
                    counter += 1
                }
            }
        }
    }
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBook>!) -> ABAddressBook? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
}
