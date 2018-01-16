//
//  DatabaseModel.swift
//  HK.CO
//
//  Created by dnk on 26/04/17.
//  Copyright © 2017 dnk. All rights reserved.
//

let DB_CUBBER                               = "CUBBER.sqlite"

//Table For Flight List Filter
let TBL_USER_CONTACT                        = "TBL_USER_CONTACT"
let TBL_FLIGHTLIST                          = "TBL_FLIGHTLIST"
let FLD_ONEWAY_DEPT_TIME                    = "ONEWAY_DEPT_TIME"
let FLD_RETURN_DEPT_TIME                    = "RETURN_DEPT_TIME"
let FLD_ONEWAY_NO_STOPS                     = "ONEWAY_NO_STOPS"
let FLD_RETURN_NO_STOPS                     = "RETURN_NO_STOPS"
let FLD_ONEWAY_FARETEXT_TYPE                = "ONEWAY_FARETEXT_TYPE"
let FLD_RETURN_FARETEXT_TYPE                = "RETURN_FARETEXT_TYPE"
let FLD_ONEWAY_AIRLINE_CODE                 = "ONEWAY_AIRLINE_CODE"
let FLD_RETURN_AIRLINE_CODE                 = "RETURN_AIRLINE_CODE"
let FLD_DICT_FLIGHT_RESPONSE                = "DICT_FLIGHT_RESPONSE"
let FLD_IS_MULTIPLE                         = "IS_MULTIPLE"


let FLD_CONTACT_NAME                        = "CONTACT_NAME"
let FLD_CONTCAT_NUMBER                      = "CONTACT_NUMBER"
let FLD_CONTCAT_EMAIL                       = "CONTACT_EMAIL"
let FLD_TIME_STAMP                          = "TIME_STAMP"
let FLD_IS_INVITED                          = "IS_INVITED"
let FLD_IS_INVITED_ONCE                     = "IS_INVITED_ONCE"

import UIKit

class DatabaseModel: NSObject {
    
    var database: FMDatabase!
    fileprivate var arrAirline = Set<String>()
    fileprivate var arrAirlineReturn = Set<String>()
    var dictRoundWay:typeAliasDictionary = typeAliasDictionary()
    var dictOneWay:typeAliasDictionary = typeAliasDictionary()
    fileprivate let fileManager = FileManager.default
    fileprivate var databasePath: String = ""
    fileprivate var dictUserInfo = typeAliasDictionary()
    var stOneWayDeptTime: String = String()
    var stReturnDeptTime: String = String()
    var stOneWayNumberStops: String = ""
    var stReturnNumberStops: String = ""
    var stOneWayFareTextType: String = String()
    var stReturnFareTextType: String = String()
    var stOneWayAirlineCode: String = String()
    var stReturnAirlineCode: String = String()
    var stDictFlightResponse: String = String()
    var stIsMultiple:String = String()

    override init() {
        super.init()
        dictUserInfo = DataModel.getUserInfo()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        databasePath = documentsDirectory.appending("/\(DB_CUBBER)")
        if !FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath);
            print("DB Created")
        }
    }
    
    func createDatabase() {
        database = FMDatabase(path: databasePath);
        print("DB Path : \(databasePath)")
            if database != nil {
                if database.open() {
                    //TBL_FLIGHTLIST
                    let tblFlightList = "create table IF NOT EXISTS \(TBL_FLIGHTLIST) (\(FLD_ONEWAY_DEPT_TIME) text, \(FLD_RETURN_DEPT_TIME) text, \(FLD_ONEWAY_NO_STOPS) integer, \(FLD_RETURN_NO_STOPS) integer, \(FLD_ONEWAY_FARETEXT_TYPE) text, \(FLD_RETURN_FARETEXT_TYPE) text, \(FLD_ONEWAY_AIRLINE_CODE) text, \(FLD_RETURN_AIRLINE_CODE) text, \(FLD_DICT_FLIGHT_RESPONSE) text ,  \(FLD_IS_MULTIPLE) text )"

                    do {
                        try database.executeUpdate(tblFlightList, values: nil)
                        print("\(TBL_FLIGHTLIST) Created")
                        
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    //TBL_USER_CONTACT
                    let tblUserInvite = "create table IF NOT EXISTS \(TBL_USER_CONTACT) (\(FLD_CONTACT_NAME) text, \(FLD_CONTCAT_NUMBER) text, \(FLD_CONTCAT_EMAIL) text, \(FLD_IS_INVITED) text, \(FLD_TIME_STAMP) text,\(FLD_IS_INVITED_ONCE) text)"
                    
                    do {
                        try database.executeUpdate(tblUserInvite, values: nil)
                        print("\(TBL_USER_CONTACT) Created")
                        
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    self.closeDatabaseConnection()
                }
                else { print("Could not open database.") }
            }
        
       // else { print("DB Exists"); }
    }
    
    func openDatabaseConnection() -> Bool {
        if FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath)
            if database != nil { if database.open() { return true } }
        }
        return false
    }
   
    
    func closeDatabaseConnection() { database.close() }
    
    //MARK CONTCAT SYNC
    
    func insertInContactSync(dictContact:typeAliasDictionary) {
        let insert_stmt: String = "insert into \(TBL_USER_CONTACT) (\(FLD_CONTACT_NAME), \(FLD_CONTCAT_NUMBER), \(FLD_CONTCAT_EMAIL), \(FLD_IS_INVITED), \(FLD_TIME_STAMP), \(FLD_IS_INVITED_ONCE)) values ('\(dictContact[FLD_CONTACT_NAME]!)', '\(dictContact[FLD_CONTCAT_NUMBER]!)', '\(dictContact[FLD_CONTCAT_EMAIL]!)', '\(dictContact[FLD_IS_INVITED]!)','\(dictContact[FLD_TIME_STAMP]!)', '\(dictContact[FLD_IS_INVITED_ONCE]!)')"
        
        if database.executeStatements(insert_stmt) { print("\(TBL_USER_CONTACT) - Data Inserted") }
        else {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
        }
    }
    
    func isContactExistInSync(stPhoneNo:String) -> typeAliasDictionary {
        var dictResponse = typeAliasDictionary()
        do {
            let search_stmt_message = "select * from \(TBL_USER_CONTACT) where \(FLD_CONTCAT_NUMBER) = '\(stPhoneNo)'"

            let results = try database.executeQuery(search_stmt_message, values: nil)
            while results.next() {
                dictResponse[FLD_CONTACT_NAME] = results.string(forColumn:FLD_CONTACT_NAME) as AnyObject
                dictResponse[FLD_CONTCAT_NUMBER] = results.string(forColumn:FLD_CONTCAT_NUMBER) as AnyObject
                dictResponse[FLD_CONTCAT_EMAIL] = results.string(forColumn:FLD_CONTCAT_EMAIL) as AnyObject
                dictResponse[FLD_IS_INVITED] = results.string(forColumn:FLD_IS_INVITED) as AnyObject
                dictResponse[FLD_IS_INVITED_ONCE] = results.string(forColumn:FLD_IS_INVITED_ONCE) as AnyObject
                dictResponse[FLD_TIME_STAMP
                    ] = results.string(forColumn:FLD_TIME_STAMP) as AnyObject
            }
        }
        catch { print(error.localizedDescription) }
        return dictResponse
    }
    
    func isContactInvitedInSync(stPhoneNo:String) -> Bool {
        if self.openDatabaseConnection() {
            let search_stmt_message = "select * from \(TBL_USER_CONTACT) where \(FLD_CONTCAT_NUMBER) = '\(stPhoneNo)' AND \(FLD_IS_INVITED) = '1'"
            do {
                let results = try database.executeQuery(search_stmt_message, values: nil)
                while results.next() { return true }
            }
            catch { print(error.localizedDescription) }
            self.closeDatabaseConnection()
        }
        return false
    }
    
    func updateUserSync(dictContact:typeAliasDictionary) {
        
        let updateMstUserSync: String = "update \(TBL_USER_CONTACT) set \(FLD_CONTACT_NAME) = ? , \(FLD_CONTCAT_EMAIL) = ? ,\(FLD_IS_INVITED) = ? ,\(FLD_TIME_STAMP) = ? , \(FLD_IS_INVITED_ONCE) = ? where \(FLD_CONTCAT_NUMBER) = ?"
        do {
            try database.executeUpdate(updateMstUserSync, values: [dictContact[FLD_CONTACT_NAME]! ,dictContact[FLD_CONTCAT_EMAIL]!, dictContact[FLD_IS_INVITED]!, dictContact[FLD_TIME_STAMP]! , dictContact[FLD_IS_INVITED_ONCE]! , dictContact[FLD_CONTCAT_NUMBER]!])
        }
        catch { print(error.localizedDescription) }
    }
    
    func getContactsFromContactSync() ->[typeAliasDictionary] {
        var arrContacts = [typeAliasDictionary]()
        if self.openDatabaseConnection() {
            let search_stmt_message = "select * from \(TBL_USER_CONTACT)"
            
            do {
                let results = try database.executeQuery(search_stmt_message, values: nil)
                while results.next() {
                    let stContactName:String = results.string(forColumn:FLD_CONTACT_NAME)
                    let stContactNumber:String = results.string(forColumn:FLD_CONTCAT_NUMBER)
                    let stContactEmail:String = results.string(forColumn:FLD_CONTCAT_EMAIL)
                    let stIsInvited:String = results.string(forColumn:FLD_IS_INVITED)
                    let stIsInvitedOnce:String = results.string(forColumn:FLD_IS_INVITED_ONCE)
                    let stTimeStamp:String = results.string(forColumn:FLD_TIME_STAMP)
                    let dictContent: typeAliasDictionary = [
                        FLD_CONTACT_NAME:stContactName as AnyObject,
                        FLD_CONTCAT_NUMBER:stContactNumber as AnyObject,
                        FLD_CONTCAT_EMAIL:stContactEmail as AnyObject,
                        FLD_IS_INVITED:stIsInvited as AnyObject,
                        FLD_TIME_STAMP:stTimeStamp as AnyObject,
                        FLD_IS_INVITED_ONCE:stIsInvitedOnce  as AnyObject]
                    arrContacts.append(dictContent)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            self.closeDatabaseConnection()
        }
        return arrContacts
    }
    
    func getSingleContactFromContactSync(stPhoneNo:String) -> typeAliasDictionary {
        
        var dictResponse = typeAliasDictionary()
        
            do {
                let search_stmt_message = "select * from \(TBL_USER_CONTACT)  where \(FLD_CONTCAT_NUMBER) = '\(stPhoneNo)'"
                let results = try database.executeQuery(search_stmt_message, values: nil)
                while results.next() {
                    dictResponse[FLD_CONTACT_NAME] = results.string(forColumn:FLD_CONTACT_NAME)as AnyObject
                    dictResponse[FLD_CONTCAT_NUMBER] = results.string(forColumn:FLD_CONTCAT_NUMBER)as AnyObject
                    dictResponse[FLD_CONTCAT_EMAIL] = results.string(forColumn:FLD_CONTCAT_EMAIL)as AnyObject
                    dictResponse[FLD_IS_INVITED] = results.string(forColumn:FLD_IS_INVITED)as AnyObject
                    dictResponse[FLD_IS_INVITED_ONCE] = results.string(forColumn:FLD_IS_INVITED_ONCE)as AnyObject
                    dictResponse[FLD_TIME_STAMP] = results.string(forColumn:FLD_TIME_STAMP)as AnyObject
                }
            }
            catch {
                print(error.localizedDescription)
            }
       return dictResponse
    }

    
    //INSERT FLIGHTLIST DATA
    func insertFlightListData(_ dict: typeAliasDictionary) {
        if self.openDatabaseConnection() {
            
            if dict[RES_stopList] != nil {
                var arrStopList = [typeAliasDictionary]()
                arrStopList = dict[RES_stopList] as! [typeAliasDictionary]
                arrAirline = Set<String>()
                arrAirlineReturn = Set<String>()
                
                arrStopList.forEach({ (dict) in
                     arrAirline.insert(dict[RES_AirlineCode] as! String)
                })
                arrAirlineReturn = arrAirline
                stOneWayAirlineCode =  arrAirline.joined(separator: ",")
                stReturnAirlineCode =  arrAirlineReturn.joined(separator: ",")
            }
            
            dictOneWay = dict[RES_OneWay] as! typeAliasDictionary
            
            if arrAirlineReturn.count != 0 && arrAirlineReturn.count > 1 && arrAirline.count > 1 {
                stIsMultiple = "1"
            }
            else if arrAirlineReturn.count != 0 && arrAirlineReturn.count < 1 && arrAirline.count < 1 {
                stIsMultiple = "0"
            }
            else{
                stIsMultiple = arrAirline.count > 1 ? "1" : "0"
            }
            
            if dict[RES_RoundWay] != nil {
                 dictRoundWay = dict[RES_RoundWay] as! typeAliasDictionary
                stOneWayDeptTime =  dictOneWay[RES_DepTime] as! String
                stReturnDeptTime =  dictRoundWay[RES_DepTime] as! String
                stOneWayNumberStops = dictOneWay[RES_Stops] as! String
                stReturnNumberStops = dictRoundWay[RES_Stops] as! String
                stOneWayFareTextType = dictOneWay[RES_FareTypeText] as! String
                stReturnFareTextType = dictRoundWay[RES_FareTypeText] as! String
                stOneWayAirlineCode =  arrAirline.joined(separator: ",")
                stReturnAirlineCode =  arrAirlineReturn.joined(separator: ",")
                stDictFlightResponse = dict.convertToJSonString()
            }
            else {
                
                stOneWayDeptTime =  dictOneWay[RES_DepTime] as! String
                stReturnDeptTime =  ""
                stOneWayNumberStops = dictOneWay[RES_Stops] as! String
                stReturnNumberStops = "-1"
                stOneWayFareTextType = dictOneWay[RES_FareTypeText] as! String
                stReturnFareTextType = ""
                stOneWayAirlineCode =  arrAirline.joined(separator: ",")
                stReturnAirlineCode =  arrAirlineReturn.joined(separator: ",")
                stDictFlightResponse = dict.convertToJSonString()
            }
           
            let insert_stmt: String = "insert into \(TBL_FLIGHTLIST) (\(FLD_ONEWAY_DEPT_TIME), \(FLD_RETURN_DEPT_TIME), \(FLD_ONEWAY_NO_STOPS), \(FLD_RETURN_NO_STOPS), \(FLD_ONEWAY_FARETEXT_TYPE), \(FLD_RETURN_FARETEXT_TYPE), \(FLD_ONEWAY_AIRLINE_CODE), \(FLD_RETURN_AIRLINE_CODE), \(FLD_DICT_FLIGHT_RESPONSE),\(FLD_IS_MULTIPLE)) values ('\(stOneWayDeptTime)', '\(stReturnDeptTime)', '\(stOneWayNumberStops)', '\(stReturnNumberStops)', '\(stOneWayFareTextType)', '\(stReturnFareTextType)', '\(stOneWayAirlineCode)', '\(stReturnAirlineCode)', '\(stDictFlightResponse)', '\(stIsMultiple)')"
            
            if database.executeStatements(insert_stmt) { print("\(TBL_FLIGHTLIST) - Data Inserted") }
            else {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            self.closeDatabaseConnection()
        }
    }
    
    
    func getCurrentFlightListData() -> [typeAliasDictionary] {
        
        var arrResult = [typeAliasDictionary]()
        let arrFlightList = [typeAliasStringDictionary]()
        if self.openDatabaseConnection() { //0-Send, 1- Receive
            
            let formater = DateFormatter()
            formater.dateFormat = "HH:mm"
            let time:String = formater.string(from: Date())
            var search_stmt_message = "select * from ( select \(FLD_DICT_FLIGHT_RESPONSE) from \(TBL_FLIGHTLIST) where 1=1 AND strftime('%H:%M', \(FLD_ONEWAY_DEPT_TIME)) > strftime('%H:%M','\(time)') "
            search_stmt_message += ")"
            print("Select stmt: \(search_stmt_message)")
            
            do {
                let results = try database.executeQuery(search_stmt_message, values: nil)
                print(results)
                while results.next() {
                    let dict:typeAliasDictionary = results.string(forColumn: FLD_DICT_FLIGHT_RESPONSE).convertToDictionary2()
                    arrResult.append(dict)
                }
            }
            catch { print(error.localizedDescription) }
            self.closeDatabaseConnection()
        }
        return arrResult
    }
    
    func deleteTableFlightData() {
    
        if self.openDatabaseConnection() {
            let deleteCart: String = "delete from \(TBL_FLIGHTLIST)"
            do { try database.executeUpdate(deleteCart, values: [""]) }
            catch { print(error.localizedDescription) }
            self.closeDatabaseConnection()
        }
    }
    
    //-----------------------------------END-----------------------------------
    
    func getFlightListData(_ arrFilter: [typeAliasDictionary]) -> [typeAliasDictionary] {
        
        var arrResult = [typeAliasDictionary]()
        let arrFlightList = [typeAliasStringDictionary]()
        if self.openDatabaseConnection() { //0-Send, 1- Receive
            
            var search_stmt_message = "select * from ( select \(FLD_DICT_FLIGHT_RESPONSE) from \(TBL_FLIGHTLIST) where 1=1 "
            
            for dict in arrFilter {
                
                let filter_Type:FILTER_FLIGHT_LIST_TYPE = FILTER_FLIGHT_LIST_TYPE(rawValue:  dict[FLIGHT_FILTER_TYPE] as! Int)!
                
                if filter_Type == .DEPARTURE_TIME || filter_Type == .RETURN_DEPARTURE_TIME {
                    
                    let FLD_NAME = filter_Type == .DEPARTURE_TIME ? FLD_ONEWAY_DEPT_TIME : FLD_RETURN_DEPT_TIME
                    
                     let stValue = dict[FLIGHT_FILTER_VALUE] as! String
                    if stValue.contains(",") {
                      let arrValue = stValue.components(separatedBy: ",")
                       for i in 0..<arrValue.count {
                            let val = arrValue[i]
                            let arrTime = val.components(separatedBy: "-")
                            let stTime1 = arrTime[0]
                            let stTime2 = arrTime[1]
                            search_stmt_message += i == 0 ? " AND (" : " OR "
                            search_stmt_message += " strftime('%H:%M', \(FLD_NAME)) BETWEEN strftime('%H:%M','\(stTime1)') AND strftime('%H:%M', '\(stTime2)') "
                        }
                        search_stmt_message += ") "
                    }
                    else{
                        let arrTime = stValue.components(separatedBy: "-")
                        let stTime1 = arrTime[0]
                        let stTime2 = arrTime[1]
                        search_stmt_message += " AND strftime('%H:%M', \(FLD_NAME)) BETWEEN strftime('%H:%M','\(stTime1)') AND strftime('%H:%M', '\(stTime2)') "
                    }
                }
             
                else if filter_Type == .NO_OF_STOPS || filter_Type == .RETURN_NO_OF_STOPS {
                    
                    let FLD_NAME = filter_Type == .NO_OF_STOPS ? FLD_ONEWAY_NO_STOPS : FLD_RETURN_NO_STOPS
                    
                    let stValue = dict[FLIGHT_FILTER_VALUE] as! String
                    if stValue.contains(",") {
                        let arrVal = stValue.components(separatedBy: ",")
                        
                        for i  in 0..<arrVal.count {
                            let val = arrVal[i]
                            search_stmt_message += i == 0 ? " AND (" : " OR "
                            if val == "0" {
                                search_stmt_message += "\(FLD_NAME) = 0"
                            }
                            else  if val == "1" {
                                search_stmt_message += "\(FLD_NAME) = 1"
                            }
                            else if val == "2+" {
                                search_stmt_message += "\(FLD_NAME) > 1"
                            }
                        }
                        search_stmt_message += ") "
                        
                    }
                    else{
                        search_stmt_message += " AND "
                        if stValue == "0" {
                            search_stmt_message += "\(FLD_NAME) = 0"
                        }
                        else  if stValue == "1" {
                            search_stmt_message += "\(FLD_NAME) = 1"
                        }
                        else if stValue == "2+" {
                            search_stmt_message += "\(FLD_NAME) > 1"
                        }
                    }
                }
                else if filter_Type == .FARE_TYPE {
                    let stValue = dict[FLIGHT_FILTER_VALUE] as! String
                    if stValue.contains(","){
                        let arrVal = stValue.components(separatedBy: ",")
                        for i  in 0..<arrVal.count {
                            let val = arrVal[i]
                            if val == "IS_REFUNDABLE" {
                                search_stmt_message += " AND (\(FLD_ONEWAY_FARETEXT_TYPE) = 'Refundable' OR \(FLD_RETURN_FARETEXT_TYPE) = 'Refundable' ) "
                            }
                            else if val == "IS_MULTI" {
                             search_stmt_message += " AND \(FLD_IS_MULTIPLE) = '0' "
                            }
                        }
                    }
                    else{
                        if stValue == "IS_REFUNDABLE" {
                            search_stmt_message += " AND (\(FLD_ONEWAY_FARETEXT_TYPE) = 'Refundable' OR \(FLD_RETURN_FARETEXT_TYPE) = 'Refundable' ) "
                        }
                        else if stValue == "IS_MULTI" {
                            search_stmt_message += " AND \(FLD_IS_MULTIPLE) = '0' "
                        }
                    }
                    
                }
                else if filter_Type == .PREFERED_AIRLINE {
                    let stValue = dict[FLIGHT_FILTER_VALUE] as! String
                    if stValue.contains(","){
                        let arrVal = stValue.components(separatedBy: ",")
                        for i  in 0..<arrVal.count {
                            let val = arrVal[i]
                            search_stmt_message += i == 0 ? " AND (" : " OR "
                            search_stmt_message += "(','||\(FLD_ONEWAY_AIRLINE_CODE)||',' LIKE '%,\(val),%')"
                        }
                        search_stmt_message += ") "
                    }
                    else{
                     search_stmt_message += "AND (','||\(FLD_ONEWAY_AIRLINE_CODE)||',' LIKE '%,\(stValue),%')"
                    }
                }
            }
            search_stmt_message += ")"
            print("Select stmt: \(search_stmt_message)")

            do {
                let results = try database.executeQuery(search_stmt_message, values: nil)
                print(results)
                while results.next() {
                    let dict:typeAliasDictionary = results.string(forColumn: FLD_DICT_FLIGHT_RESPONSE).convertToDictionary2()
                    arrResult.append(dict)
                }
            }
            catch { print(error.localizedDescription) }
            self.closeDatabaseConnection()
        }
        return arrResult
    }
}
