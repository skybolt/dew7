//
//  ExtensionDelegate.swift
//  DEW 7 WatchKit Extension
//
//  Created by rob on 11/8/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UserNotifications

/* the reason we have an extension delegae is there needs to be a cointainer to hold the executable functions. Unlike an interface controiller an extension delegate might be able to do more robust things, that explain why I have a
 static var oldStatus = Bool(false) in an extenkjsion deleghate but not interface controller. Because the interface controller is ligheter. No advanced fguctions required or allowed*/

extension Int {
    static func randomInt(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    func applicationDidFinishLaunching() {
        registerUserNotificationSettings()
        activateSession()
    }
    
    func compareDates(id: String, date: Date) {
        
        let lastInterval = Int(CFDateGetTimeIntervalSinceDate(Date() as CFDate, date as CFDate)/60)
        
        let someString = "\(id)\(String(lastInterval))"
        globalVars.debugString = someString + globalVars.debugString
        let subString = globalVars.debugString.prefix(45)
        globalVars.debugString = String(subString)
//        print(globalVars.debugString)
        
    }
    
    func scheduleApplicationRefresh() {
        //        print(sharedObjects.simpleDebug())
        let nextFire = Date(timeIntervalSinceNow: 1 * 1 * 300)
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextFire, userInfo: nil) { _ in }
        print("\n\(sharedObjects.simpleDebug()) for \(sharedObjects.localTime(date: nextFire))\n")
    }
    
    //pasted BG task from DEW 8
    func scheduleSnapshotRefresh() {
        print(sharedObjects.simpleDebug())
        let nextFire = Date(timeIntervalSinceNow: 1 * 1 * 300)
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: nextFire, userInfo: nil) { _ in }
        print("\n\(sharedObjects.simpleDebug()) for \(sharedObjects.localTime(date: nextFire))\n")
    }
    
    func applicationWillResignActive() {
        print(sharedObjects.simpleDebug())
//        reloadComplicationData8(backgroundTask: backgroundTask)
        //2018-01-17 do not schedule app or snap refreshes see what happens, will it ever fire? What
        //if watch state changes?
        scheduleApplicationRefresh()
//        scheduleSnapshotRefresh()
        updateComplicationDisplay()
    }
    
    func updateComplicationDisplay() {
//        print(sharedObjects.simpleDebug())
        let complicationsController = ComplicationController()
        complicationsController.reloadOrExtendData()
    }
    
    func reloadComplicationData8(backgroundTask: WKApplicationRefreshBackgroundTask) {
        let nextFire = Date(timeIntervalSinceNow: 360)
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextFire, userInfo: nil) { _ in }
        self.updateComplicationDisplay()
    }
    
    //this function for BG tasks only
    func reloadComplicationData(backgroundTask: WKApplicationRefreshBackgroundTask) {
        updateComplicationDisplay()
    }
    
    func handleUserActivity(
        _ userInfo: [AnyHashable : Any]?) {
        //this gets called when clicking on a complication
        updateComplicationDisplay()
    }
    
    func stringWithUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)!
        return uuidString as String
    }
    
    
    func throwNotification() {
        
//        globalVars.notificationThrown = sharedObjects.localTime(date: Date())
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            if settings.alertSetting == .enabled {
//                let notificationContent = UNMutableNotificationContent()
//
//
//                notificationContent.sound = UNNotificationSound.default;
//                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: (0.000001), repeats: false)
//                let identifier = self.stringWithUUID()
//
//                notificationContent.body = globalVars.labelString
//                notificationContent.body =
//
//                """
//                Ask: \(globalVars.notificationAsked)
//                Thr: \(globalVars.notificationThrown)
//                UUID:\(identifier)
//                """
//                print(identifier)
//                print("thrown")
//
//                let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: notificationTrigger)
//                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
//                }
//            }
//        }
    }
    
    func updateDisplayData() {
        
    }

    func checkSessionStatus() {
        
        print(sharedObjects.simpleDebug())
        
        if WCSession.isSupported() {
//            StatusReporter.updateStatus() //this might not be necessary as updateStatus gets called elsewhere as well
            let session = WCSession.default
            if (session.activationState.rawValue != 0) { //if you don't have this, sometimes it;ll try and check status before the ssession is active. Not sure if that's an expensive fail or a cheap fail, better to code around it rather than let it fail
                
                globalVars.checkSessionCounter = globalVars.checkSessionCounter + 1
                globalVars.lastSessionCheck = sharedObjects.localTime(date: Date())
                globalVars.newConnectionStatus = session.isReachable
                
                if (globalVars.newConnectionStatus == true) {
                    globalVars.newStatusString = "nT"
                } else {
                    globalVars.newStatusString = "nF"
                }
                
                if (globalVars.oldConnectionStatus == true) {
                    globalVars.oldStatusString = "oT"
                } else {
                    globalVars.oldStatusString = "oF"
                }

                if (globalVars.oldConnectionStatus != globalVars.newConnectionStatus || globalVars.newConnectionStatus == false) {
                    globalVars.debugString = "!" + globalVars.debugString
                    updateComplicationDisplay()
                    globalVars.notificationAsked = sharedObjects.localTime(date: Date())
//                    throwNotification()
                } else {
                    globalVars.debugString = " " + globalVars.debugString
                    //no change in status, so don't do anything?
                }
                globalVars.oldConnectionStatus = session.isReachable
            } //end of if session not active
            else {
//                print("session not active, try next time")
            }
        } //no else, end of if WCSession is supported
                updateComplicationDisplay()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith
        activationState: WCSessionActivationState, error: Error?) {
    }
    
    func applicationDidBecomeActive() {
        print("did Active")
//        checkSessionStatus() //this is not causing the snapshot loop
        updateComplicationDisplay()
    }
    
    func activateSession() {
        if WCSession.isSupported() {
            let session  = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sessionWatchStateDidChange() { //this is designed to run on the phone and alert when the WATCH is gone. Good future feature, but doens't help us detect the phone that's left behind.
        globalVars.debugString = "watchChange"
    }
    
    func sessionReachabilityDidChange(_ wSession: WCSession) {
        //This should be called when the watch detects a session change. But it never gets called. 
        print(sharedObjects.simpleDebug())
        print("didChange (ExDelegate)")
        StatusReporter.updateStatus()
        globalVars.sessionChangeCounter = globalVars.sessionChangeCounter + 1
        //REMOVE bg task 2019-01-17 see if any trigger
        let backgroundTask = WKApplicationRefreshBackgroundTask()
        reloadComplicationData(backgroundTask: backgroundTask)
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        print("func handle(bg/sn)")
        for task in backgroundTasks {
            
            switch task {
            
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                print(task)
                //you are expected to schedule another BG AR task here.
                //see https://developer.apple.com/documentation/watchkit/wkapplicationrefreshbackgroundtask?language=objc
                compareDates(id: "a", date: globalVars.dateLastAppRefreshed)
                globalVars.bgAppCounter = globalVars.bgAppCounter + 1
                reloadComplicationData8(backgroundTask: backgroundTask)
                checkSessionStatus()
                globalVars.dateLastAppRefreshed = Date()
                scheduleApplicationRefresh()
//                backgroundTask.setTaskCompletedWithSnapshot(false)
                backgroundTask.setTaskCompleted()

                
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                print(task)
                print("wtf?")
                compareDates(id: "s", date: globalVars.dateLastSnapped)
                globalVars.bgSnapshotCounter = globalVars.bgSnapshotCounter + 1
                globalVars.dateLastSnapped = Date()
                checkSessionStatus() //commenting this out stops the endless loop, but is useless to comment it out as it's our core activity, also, it's unlikely this is the root cause, only the smoking gun. Something in checkSessionStatus() must be causing the snapshot to get called again and again. Note: reason type is 2, as if it's scheduled, but the schedule is 5 min in future (or some other value that's not now).
                // another ntoe - this only loops in the simulator, not on the watch
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil) //code based on DEW 8, new normal code as inserted by xCode

            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                print("connectivityTask")
                connectivityTask.setTaskCompletedWithSnapshot(false)
            
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                print("urlSessionTask")
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            
            default:
                print("case default")
//                task.setTaskCompletedWithSnapshot(false)
                task.setTaskCompleted()
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext
        applicationContext:[String:Any]) {
        if let status = applicationContext["status"] as? [String] {
            print("applicationContext[\"status\"] is \(status)")
        }
    } //end of func session
}

extension ExtensionDelegate: UNUserNotificationCenterDelegate {
    
    func registerUserNotificationSettings() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            } else {//not granted
            }
        } //request closed
    }
}
