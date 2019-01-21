//
//  StatusReporter.swift
//  DEW 7
//
//  Created by rob on 11/9/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UserNotifications

struct globalVars {
    //set up global variables and set initial values
    static var stringColor = UIColor.yellow
    static var textString = "connecting"
    static var shortString = "..."
    static var labelString = "Initializing D.E.W. Line"
    static var bezelString = "D.E.W. initializing"
    static var notificationString = "notification string"
    static var statusImage = "connected"
    static var statusBitmap = "blackDew"
    static var statusGraphCir = "black-94"
    static var debugString = " "
    static var lastSessionCheck = "never"
    static var bgAppCounter = 0
    static var bgSnapshotCounter = 0
    static var checkSessionCounter = 0
    static var updateDisplayCounter = 0 
    static var sessionChangeCounter = 0
    static var counter = 0
    static var notificationAsked = "n/a"
    static var notificationThrown = "n/a"
    static var newStatusString = "nN"
    static var oldStatusString = "nN"
    static var newConnectionStatus = Bool(false)
    static var oldConnectionStatus = Bool(false)
    static var dateLastSnapped = Date()
    static var dateLastAppRefreshed = Date()
}

final class sharedObjects: NSObject {
    
    static func localDateTime(date: Date) -> String {
        let timeStamp = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .medium)
        return timeStamp
    }
    
    static func localTime(date: Date) -> String {
        let timeStamp = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        return timeStamp
        
    }
    
    static func fullDebug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\n\(localDateTime(date: Date())) \(file) line:\(line) func:\(function)\n"
    }
    
    static func simpleDebug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\(localTime(date: Date())) function \(function) (line \(line))"
    }
    
}

final class StatusReporter: NSObject, UNUserNotificationCenterDelegate, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    func isReachable() -> Bool {
        return WCSession.default.isReachable
    }
    
    func sessionReachabilityDidChange(_ wSession: WCSession) {
        //This should be called when the watch detects a session change. But it never gets called.
        print("didChange (StatusReporter)")
        globalVars.notificationThrown = sharedObjects.localTime(date: Date())
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                let notificationContent = UNMutableNotificationContent()
                
                notificationContent.body = globalVars.labelString
                
                let uuidObj = CFUUIDCreate(nil)
                let uuidString = CFUUIDCreateString(nil, uuidObj)!
                print("uuidString: \(uuidString)")
                let identifier = String(uuidString)
                
                notificationContent.body =
                
                """
                \(globalVars.labelString)
                Ask: \(globalVars.notificationAsked)
                Thr: \(globalVars.notificationThrown)
                uuid: uuID=\(uuidString)
                """
                notificationContent.sound = UNNotificationSound.default;
                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: (0.000001), repeats: false)

                let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: notificationTrigger)
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                }
            }
        }
    }
    
    static func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\(file):\(line) : \(function)"
    }
    
    static func updateStatus() {
        print(sharedObjects.simpleDebug())

        globalVars.newConnectionStatus = WCSession.default.isReachable
        if WCSession.default.isReachable == true {
            globalVars.textString = "connected"
            globalVars.shortString = "OK"
            globalVars.labelString =
            """
            D.E.W. Line
            active
            """
            globalVars.bezelString = globalVars.labelString
            globalVars.notificationString = "iPhone connected"
            globalVars.stringColor = UIColor(red:0.310, green:0.706, blue:0.965, alpha:1.00) //Red:0.310 green:0.706 blue:0.965 alpha:1.00
            globalVars.statusImage = "connected"
            globalVars.statusBitmap = "blueDew"
            globalVars.statusGraphCir = "blue-94"
        }
        else {
            globalVars.textString = "disconnected"
            globalVars.shortString = "D"
            globalVars.labelString =
            """
            Cannot detect
            phone signal
            """
            globalVars.bezelString = "Phone signal lost!"
            globalVars.notificationString = "Disconnected!"
            globalVars.statusImage = "disconnected"
            globalVars.statusBitmap = "redDew"
            globalVars.statusGraphCir = "red-94"
            globalVars.stringColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        
        if (globalVars.oldConnectionStatus != globalVars.newConnectionStatus) {
//        if (true) {
            print("oldStat != newStat")
            globalVars.notificationAsked = sharedObjects.localTime(date: Date())
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.alertSetting == .enabled {
                    
                    let notificationContent = UNMutableNotificationContent()
                    
                    notificationContent.body = globalVars.labelString
                    
                    let uuidObj = CFUUIDCreate(nil)
                    let uuidString = CFUUIDCreateString(nil, uuidObj)!
                    
                    notificationContent.body =

                    """
                    \(globalVars.labelString)
                    Ask: \(globalVars.notificationAsked)
                    Thr: \(globalVars.notificationThrown)
                    Last updated: \(sharedObjects.localTime(date: Date()))
                    """
                    
                    notificationContent.sound = UNNotificationSound.default;
                    let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: (0.000001), repeats: false)
                    
                    
                    let identifier = String(uuidString)
                    print("uuidString: \(uuidString)")

                    let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: notificationTrigger)
                    UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    }
                }
            }
        }
        globalVars.oldConnectionStatus = globalVars.newConnectionStatus
    }
}

//extension StatusReporter: UNUserNotificationCenterDelegate {
//
//    func stringWithUUID() -> String {
//        let uuidObj = CFUUIDCreate(nil)
//        let uuidString = CFUUIDCreateString(nil, uuidObj)!
//        return uuidString as String
//    }
//
//    func throwNotification() {
//
//        globalVars.notificationThrown = sharedObjects.localTime(date: Date())
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            if settings.alertSetting == .enabled {
//                let notificationContent = UNMutableNotificationContent()
//
//                notificationContent.body = globalVars.labelString
//
//                notificationContent.body = """
//                Ask: \(globalVars.notificationAsked)
//                Thr: \(globalVars.notificationThrown)
//                """
//                notificationContent.sound = UNNotificationSound.default();
//                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: (0.000001), repeats: false)
//                let identifier = self.stringWithUUID()
//                let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: notificationTrigger)
//                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
//                }
//            }
//        }
//    }
//}

