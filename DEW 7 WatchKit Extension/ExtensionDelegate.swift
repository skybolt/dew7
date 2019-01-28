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
        sharedObjects.checkSessionStatus()
    }
    
    func compareDates(id: String, date: Date) {
        //this passes in a (for app refresh) or s (for snapshot) and returns that + integer (minutes since last interval)
        let lastInterval = Int(CFDateGetTimeIntervalSinceDate(Date() as CFDate, date as CFDate)/60)
        let someString = "\(id)\(String(lastInterval))"
        globalVars.debugString = someString + globalVars.debugString
        let subString = globalVars.debugString.prefix(45)
        globalVars.debugString = String(subString)
    }
    
    func scheduleApplicationRefresh(callingFunctionName: String = #function) {
        print("\(sharedObjects.simpleDebug()) called by \(callingFunctionName)")
//        print("called by \(callingFunctionName)")
        let nextFire = Date(timeIntervalSinceNow: 1 * 1 * 300)
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextFire, userInfo: nil) { _ in }
        print("\n\(sharedObjects.simpleDebug()) for \(sharedObjects.localTime(date: nextFire))\n")
    }
    
    //pasted BG task from DEW 8
    func scheduleSnapshotRefresh(callingFunctionName: String = #function) {
        print("\(sharedObjects.simpleDebug()) called by \(callingFunctionName)")
        print(sharedObjects.simpleDebug())
        let nextFire = Date(timeIntervalSinceNow: 1 * 1 * 300)
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: nextFire, userInfo: nil) { _ in }
        print("\n\(sharedObjects.simpleDebug()) for \(sharedObjects.localTime(date: nextFire))\n")
    }
    
    func applicationWillResignActive() {
//        reloadComplicationData8(backgroundTask: backgroundTask)
        scheduleApplicationRefresh()  //
//        scheduleSnapshotRefresh()  //this seems to auto schedule if it's in the dock
        updateComplicationDisplay() //might have new data, let's update the complication
    }
    
    func updateComplicationDisplay(callingFunctionName: String = #function) {
        print("\(sharedObjects.simpleDebug()) called by \(callingFunctionName)")
        let complicationsController = ComplicationController()
        complicationsController.reloadOrExtendData()
    }
    
    func reloadComplicationData8(backgroundTask: WKApplicationRefreshBackgroundTask) {
        print("this should never appear in console")
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
    
    func updateInterfaceDisplay(callingFunctionName: String = #function) {
        print("\(sharedObjects.simpleDebug()) called by \(callingFunctionName)")
        //call order 3. Manually called from didBecomeActive
        StatusReporter.updateGlobalVars()
        
        //this section for debugging screen
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
//            updateInterfaceDisplay()
            globalVars.notificationAsked = sharedObjects.localTime(date: Date())
            //                    throwNotification()
        } else {
            globalVars.debugString = " " + globalVars.debugString
            updateComplicationDisplay()
//            updateInterfaceDisplay()
            //no change in status, so don't do anything?
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith
        activationState: WCSessionActivationState, error: Error?) {
        scheduleApplicationRefresh()
        scheduleSnapshotRefresh()
    }
    
    func applicationDidBecomeActive() {
        //got called right after activate session popping interface
        //call order 2
//        print("did Active")
        if globalVars.rawSessionStatus != 0 {
        updateInterfaceDisplay()
        updateComplicationDisplay()
        }
    }
    
    func activateSession(callingFunctionName: String = #function) {
        print("\(sharedObjects.simpleDebug()) called by \(callingFunctionName)")
        //this definitely gets called, most likely from did finish launching
        //not sure why launching gets called if there's no complication.
        if WCSession.isSupported() {
            let session  = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sessionWatchStateDidChange(callingFunctionName: String = #function) { //this is designed to run on the phone and alert when the WATCH is gone. Good future feature, but doens't help us detect the phone that's left behind.
        //this gets called on startup. Wild.
        print(sharedObjects.simpleDebug())
        print("called by \(callingFunctionName)")
        globalVars.debugString = "watchChange"
        print(globalVars.debugString)
    }
    
    func sessionReachabilityDidChange(_ wSession: WCSession) {
        //This should be called when the watch detects a session change. But it never gets called. 
        print(sharedObjects.simpleDebug())
        print("didChange (ExDelegate)")
        StatusReporter.updateGlobalVars()
        globalVars.sessionChangeCounter = globalVars.sessionChangeCounter + 1
        //REMOVE bg task 2019-01-17 see if any trigger
        let backgroundTask = WKApplicationRefreshBackgroundTask()
        reloadComplicationData(backgroundTask: backgroundTask)
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        
        for task in backgroundTasks {
            
            switch task {
            
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                //you are expected to schedule another BG AR task here.
                //see https://developer.apple.com/documentation/watchkit/wkapplicationrefreshbackgroundtask?language=objc
                compareDates(id: "a", date: globalVars.dateLastAppRefreshed)
                globalVars.bgAppCounter = globalVars.bgAppCounter + 1
//                reloadComplicationData8(backgroundTask: backgroundTask)
                sharedObjects.checkSessionStatus()
                globalVars.dateLastAppRefreshed = Date()
                updateComplicationDisplay()
                updateInterfaceDisplay()
                scheduleApplicationRefresh()
                backgroundTask.setTaskCompleted()

                
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                //oddly, this gets called for the complication, not the dock snapshot.
                compareDates(id: "s", date: globalVars.dateLastSnapped)
                globalVars.bgSnapshotCounter = globalVars.bgSnapshotCounter + 1
                globalVars.dateLastSnapped = Date()
                sharedObjects.checkSessionStatus()
                updateComplicationDisplay()
                updateInterfaceDisplay()
                scheduleSnapshotRefresh()
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
