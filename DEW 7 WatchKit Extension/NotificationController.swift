//
//  NotificationController.swift
//  DEW 7 WatchKit Extension
//
//  Created by rob on 11/8/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {
    
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var image: WKInterfaceImage!
    
    override func didReceive(_ notification: UNNotification, withCompletion completionHandler:
        @escaping (WKUserNotificationInterfaceType) -> Void) {
        globalVars.notificationThrown = sharedObjects.localTime(date: Date())
        let notificationBody = notification.request.content.body
        label.setText(notificationBody)
        if let imageAttachment = notification.request.content.attachments.first {
            let imageURL = imageAttachment.url
            let imageData = try! Data(contentsOf: imageURL)
            let newImage = UIImage(data: imageData)
            image.setImage(newImage)
        } else {
            let catImageName = String(format: "cat%02d", arguments: [Int.randomInt(1, max: 12)])
            image.setImageNamed(catImageName)
        }
        completionHandler(.custom)
    }
}
