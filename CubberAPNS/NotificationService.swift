//
//  NotificationService.swift
//  CubberAPNS
//
//  Created by dnk on 04/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        print("Recieved")
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            print("Notification Data : \(bestAttemptContent)")
            // Get the custom data from the notification payload
            // Grab the attachment
            
            let dictNotification: [String: Any] = (bestAttemptContent.userInfo["data"] as! String).convertToDictionary2()
            if let urlString = dictNotification["image"], let fileUrl = URL(string: urlString as! String) {
                // Download the attachment
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                        
                        // Move temporary file to remove .tmp extension
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file:".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        try! FileManager.default.moveItem(at: location, to: tmpUrl)
                        
                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    
                    // Serve the notification content
                    self.contentHandler!(self.bestAttemptContent!)
                    }.resume()
            }
            
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

extension String {
    
    func convertToDictionary2() -> [String:Any] {
        let jsonData: Data = self.data(using: String.Encoding.utf8)!
        do {
            let dict:  [String:Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as! [String:Any]
            return dict
        } catch let error as NSError { print(error) }
        
        return  [String:Any]()
    }
}
