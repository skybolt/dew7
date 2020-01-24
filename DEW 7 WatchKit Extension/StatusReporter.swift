//
//  StatusReporter.swift
//  DEW 7
//
//  Created by rob on 11/9/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//
// update to test github integration no change

import WatchKit
import WatchConnectivity
import UserNotifications

struct globalVars {
    //set up global variables and set initial values
    static var rawSessionStatus = 0
    static var oldConnectionStatus = Bool(false)
    static var newConnectionStatus = Bool(false)
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
    static var dateLastSnapped = Date()
    static var dateLastAppRefreshed = Date()
}

final class sharedObjects: NSObject {
    
    static func checkSessionStatus(callingFunctionName: String = #function) {
        print("\(sharedObjects.simpleDebug()) called by \(callingFunctionName)")
        //call order 4
        //called on didResignActive.
        //called from (_handle, bgSnap)
        
        globalVars.checkSessionCounter = globalVars.checkSessionCounter + 1
        globalVars.lastSessionCheck = sharedObjects.localTime(date: Date())
        
        if WCSession.isSupported() {
            
            let session = WCSession.default
            //            let activationString = session.activationState.rawValue
            //            print("activationString.rawValue = \(activationString)")
            if (session.activationState.rawValue != 0) { //Don't check session if hasn't been activated
                globalVars.rawSessionStatus = session.activationState.rawValue
                print(globalVars.oldConnectionStatus)
                print(globalVars.newConnectionStatus)
                globalVars.newConnectionStatus = session.isReachable
//                globalVars.oldConnectionStatus = session.isReachable
                StatusReporter.updateGlobalVars()
            }
        }
    }
    
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
//        This should be called when the watch detects a session change. But it never gets called.
        print("didChange (StatusReporter)")
        StatusReporter.updateGlobalVars()
    }
    
    static func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\(file):\(line) : \(function)"
    }
    
    static func updateGlobalVars(callingFunctionName: String = #function) {

        if globalVars.newConnectionStatus == true {
            globalVars.textString = "connected"
            globalVars.shortString = "OK"
            globalVars.labelString =
            """
            D.E.W. Line active
            iPhone connected
            """
            globalVars.bezelString = globalVars.labelString
            globalVars.notificationString = "iPhone detected"
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
            globalVars.bezelString = "iPhone signal lost!"
            globalVars.notificationString = globalVars.bezelString
            globalVars.statusImage = "disconnected"
            globalVars.statusBitmap = "redDew"
            globalVars.statusGraphCir = "red-94"
            globalVars.stringColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        
        if (globalVars.oldConnectionStatus != globalVars.newConnectionStatus) {
            print("oldStat != newStat")
            globalVars.notificationAsked = sharedObjects.localTime(date: Date())
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.alertSetting == .enabled {
                    
                    let notificationContent = UNMutableNotificationContent()
                    
                    notificationContent.body = globalVars.labelString
                    
                    let uuidObj = CFUUIDCreate(nil)
                    let uuidString = CFUUIDCreateString(nil, uuidObj)!
                    
                    notificationContent.body = globalVars.notificationString


                    
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
