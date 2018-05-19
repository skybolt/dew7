//
//  InterfaceController.swift
//  DEW 7 WatchKit Extension
//
//  Created by rob on 11/8/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation
import UserNotifications


class InterfaceController: WKInterfaceController {
    
    
    //not using these three. Comment out after removing all references in interface controller and or storyboard. Might be set in GUI someplace. 
    @IBOutlet var disconnectDEWImage: WKInterfaceImage!
    @IBOutlet var connectDEWImage: WKInterfaceImage!
    @IBOutlet var initialDEWImage: WKInterfaceImage!
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    @IBOutlet var refreshButtonImage: WKInterfaceImage!
    
    static var buttonImageHolder = UIImage(named: "blackDEW") //"UIImage here. Not know how to call."
    //update May 18 2018 this is probably handled under globalVars.statusBitmap

//    func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
//        return "\(file):\(line) : \(function)"
//    }
    
    //added comment to test gitHub integration
    
//    func showDisconnectedImage() {
//    }
//
//    func printGlobalVars() {
//        //        for each in globalVars
//        print("\(globalVars.textString)")
//        print("\(globalVars.shortString)")
//        print("\(globalVars.connectionStatus)")
//        print("\(globalVars.stringColor)")
//    }

    //May 18 2018
//    func loadInitialStatus() {
//        print(StatusReporter.debug())
//        statusLabel.setText(globalVars.labelString)
//        if globalVars.connectionStatus {
//            disconnectDEWImage.setHidden(true)
//        } else {
//            connectDEWImage.setHidden(true)
//        }
//        initialDEWImage.setHidden(true)
//
//    }

    @IBAction func checkStatusAction() {
        //pulled when round refresh icon on Force Touch screen pressed
        StatusReporter.updateStatus()
        
        //set Interface Controller objects according to status
        statusLabel.setText(globalVars.labelString)
        refreshButtonImage.setImageNamed(globalVars.statusBitmap)
        
//        if globalVars.textString == "connected" {
////            connectDEWImage.setHidden(false)
//            disconnectDEWImage.setHidden(true)
//        } else {
//            connectDEWImage.setHidden(true)
////            disconnectDEWImage.setHidden(false)
//        }
//        initialDEWImage.setHidden(true)
    }

    //May 18 2018
//    func animateText() {
////        statusLabel.setText(globalVars.labelString)
//        print("checking ...")
////        statusLabel.setText("checking ...")
////        sleep(1)
////        print("slept 1")
//    }
    
    @IBAction func refreshButton() {
        print(sharedObjects.simpleDebug())
//        print(StatusReporter.debug())
//        animateText()
        statusLabel.setText("checking . . .")
//        connectDEWImage.setHidden(false)
//        disconnectDEWImage.setHidden(false)
//        initialDEWImage.setHidden(false)
        //sleep(1)
        checkStatusAction()
    }
    
    
    @IBAction func graphicRefreshButton() {
//        print(sharedObjects.simpleDebug())
        //pulled when icon clicked in Interface Controller
        checkStatusAction()
    }
    
    override func awake(withContext context: Any?) {
//        print(StatusReporter.debug())
        super.awake(withContext: context)
//        registerUserNotificationSettings() //commented May 18 2018
//        scheduleLocalNotification()
    }
    
    override func willActivate() {
//        //May 18 2018
//        print(StatusReporter.debug())
//        let session = WCSession.default
//        print("session.activationState = ", terminator: "")
//        print(session.activationState.rawValue)
//        globalVars.counter += 1
        checkStatusAction()
//        super.willActivate()
        
    }
    
    override func didDeactivate() {
//        print(StatusReporter.debug())
//                let complicationsController = ComplicationController()
//                complicationsController.reloadOrExtendData()
//        scheduleLocalNotification()
        super.didDeactivate()
    }
    
}


//extension InterfaceController {
//
//        //    May 18 2018
////    func registerUserNotificationSettings() {
////        print(StatusReporter.debug())
////        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (granted, error) in
////            if granted {
////                let viewDewAction = UNNotificationAction(identifier: "viewDewAction", title: "Check Status", options: .foreground)
////                let dewCategory = UNNotificationCategory(identifier: "dewNotifications", actions: [viewDewAction], intentIdentifiers: [], options: [])
////                UNUserNotificationCenter.current().setNotificationCategories([dewCategory])
////                UNUserNotificationCenter.current().delegate = self
////                print("⌚️⌚️⌚️Successfully registered notification support")
////            } else {
////                print("⌚️⌚️⌚️ERROR: \(String(describing: error?.localizedDescription))")
////            }
////        }
////    }
//
//
//    static func stringWithUUID() -> String {
//        let uuidObj = CFUUIDCreate(nil)
//        let uuidString = CFUUIDCreateString(nil, uuidObj)!
//        return uuidString as String
//    }
//
//    //May 18 2018
////    static func scheduleLocalNotification() {
////
////        print(StatusReporter.debug())
////        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
////            if settings.alertSetting == .enabled {
////
//////                let dewImageName = String(format: "cat images/local_cat%02d", arguments: [Int.randomInt(1, max: 3)])
//////                let dewImageURL = Bundle.main.url(forResource: dewImageName, withExtension: "jpg")
//////                let notificationAttachment = try! UNNotificationAttachment(identifier: dewImageName, url: dewImageURL!, options: .none)
////
////
////                //configure local notification in four steps from https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SchedulingandHandlingLocalNotifications.html#//apple_ref/doc/uid/TP40008194-CH5-SW1
////
////                //step 1 of four, Create and configure a UNMutableNotificationContent object with the notification details.
////                let notificationContent = UNMutableNotificationContent()
////
//////                notificationContent.title = "title"
//////                notificationContent.subtitle = "subtitle"
//////                notificationContent.body = "content body"
////                notificationContent.title = globalVars.notificationString
////                notificationContent.sound = UNNotificationSound.default();
////                notificationContent.categoryIdentifier = "dewCategory"
//////                notificationContent.attachments = [notificationAttachment]
////
////                var date = DateComponents()
////                date.minute = 12
////                // step 2 of four Create a UNCalendarNotificationTrigger, UNTimeIntervalNotificationTrigger, or UNLocationNotificationTrigger object to describe the conditions under which the notification is delivered.
//////                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//////                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: ((1*60)-0), repeats: true)
////                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: (0.000001), repeats: false)
//////                let notificationTrigger = UNNotificationTrigger(now)
////
////                //step 3 of four: Create a UNNotificationRequest object with the content and trigger information.
////                let identifier = self.stringWithUUID()
////                print("identifier = ", terminator: "")
////                print(identifier)
//////
//////                let notificationRequest = UNNotificationRequest(identifier: "dew", content: notificationContent, trigger: notificationTrigger)
////                let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: notificationTrigger)
////
////                //step 4 of four: Call the addNotificationRequest:withCompletionHandler: method to schedule the notification; see Scheduling Local Notifications for Delivery
////                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
////                    if let error = error {
////                        print("⌚️⌚️⌚️ERROR:\(error.localizedDescription)")
////                    } else {
////                        print(Date().description(with: Locale.current))
////                        print("⌚️⌚️⌚️Local notification was scheduled for ")
////                        print(notificationTrigger)
////                    }
////                }
////
////            } else { //end if settings.alertSetting
////                print("⌚️⌚️⌚️Notification alerts are disabled")
////            }
////
////        }
////    }
//}

// Notification Center Delegate
//extension InterfaceController: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print(StatusReporter.debug())
//        completionHandler([.sound, .alert])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(StatusReporter.debug())
//        completionHandler()
//    }
//}
