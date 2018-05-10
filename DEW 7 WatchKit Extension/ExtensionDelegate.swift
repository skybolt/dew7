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
    
//    func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
//        return "\(file):\(line) : \(function)"
//    }
    
    func updateComplicationDisplay() {
        let complicationsController = ComplicationController()
        complicationsController.reloadOrExtendData()
    }
    
    //this function for BG tasks only
    func reloadComplicationData(backgroundTask: WKApplicationRefreshBackgroundTask) {
        self.updateComplicationDisplay()
//        WKExtension.shared().scheduleBackgroundRefresh(
//        withPreferredDate: Date(), userInfo: nil) { _ in }
        updateComplicationDisplay()
        }
    
    func refreshComplicationData() {
        updateComplicationDisplay()
    }
    
    func handleUserActivity(
        _ userInfo: [AnyHashable : Any]?) {
        updateComplicationDisplay()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith
        activationState: WCSessionActivationState, error: Error?) {
        
        if let error = error {
            print("WC Session activation failed with error: " + "\(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: " + "\(activationState.rawValue)")
    }
    
    func setupWatchConnectivity() {
        print(StatusReporter.debug())
        if WCSession.isSupported() {
            let session  = WCSession.default
            session.delegate = self
            session.activate()
            print("phoneSession.activationState = ", terminator: "")
            print(session.activationState.rawValue)
        }
    }
    
    static var oldStatus = Bool(false)
    
    func printGlobalVars() {
        //        for each in globalVars
        print("\(globalVars.textString)")
        print("\(globalVars.shortString)")
        print("\(globalVars.connectionStatus)")
//        print("\(globalVars.stringColor)")
    }

    func sessionWatchStateDidChange() { //this is designed to run on the phone and alert when the WATCH is gone. Good future feature, but doens't help us detect the phone that's left behind. 
        globalVars.debugString = "watchChange"
        InterfaceController.scheduleLocalNotification()
    }
    
    func sessionReachabilityDidChange(_ wSession: WCSession) {
        
//        globalVars.debugString = "sessionChange"
        print(StatusReporter.debug())
        StatusReporter.isReachableNoReturn()
        updateComplicationDisplay()
        let backgroundTask = WKApplicationRefreshBackgroundTask()
        reloadComplicationData(backgroundTask: backgroundTask)
//        scheduleLocalNotification()
        InterfaceController.scheduleLocalNotification()
    }

    func applicationDidFinishLaunching() {
        setupWatchConnectivity()
//        printGlobalVars()
    }
    
    func applicationDidBecomeActive() {
        print(StatusReporter.debug())

    }

    func applicationWillResignActive() {        
        print(StatusReporter.debug())
//        updateComplicationDisplay()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
//        print(debug())
        for task in backgroundTasks {
            
            switch task {
            
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
//                print("print WKApplicationRefreshBackgroundTask")
//                updateComplicationDisplay()
//                StatusReporter.isReachableNoReturn()
                // Be sure to complete the background task once you’re done.
                //let backgroundTask = WKApplicationRefreshBackgroundTask()
//                reloadComplicationData(backgroundTask: backgroundTask)
//                refreshComplicationData()
                backgroundTask.setTaskCompletedWithSnapshot(false)
            
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
//                print("print WKSnapshotRefreshBackgroundTask")
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date() + 90, userInfo: nil)
                
                //                refreshComplicationData()
                
                
                // Always reset back to the root controller
                // taken from some other app that sort of worked: UHL from book
                //                let wkExtension = WKExtension.shared()
                //                wkExtension.rootInterfaceController?.popToRootController()
                //                wkExtension.rootInterfaceController?.pushController(
                //                    withName: "InterfaceController", context: nil)
                //
//                updateComplicationDisplay()
                
                //                print(Date())
                //                print(Date() + 90)
                //                StatusReporter.isReachableNoReturn()
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                //                StatusReporter.isReachableNoReturn()
                
                //                print(globalVars.counter)
 
            
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                print("WKWatchConnectivityRefreshBackgroundTask invoked")
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                print("WKURLSessionRefreshBackgroundTask invoked")
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext
        applicationContext:[String:Any]) {
        print(StatusReporter.debug())
        // 2
        if let status = applicationContext["status"] as? [String] {
            print("status is \(status)")
            // 3
//            TicketOffice.sharedInstance.purchaseTicketsForMovies(movies)
            // 4
//            DispatchQueue.main.async {
//                WKInterfaceController.reloadRootPageControllers(
//                    withNames: ["PurchasedMovieTickets"],
//                    contexts: nil,
//                    orientation: WKPageOrientation.vertical,
//                    pageIndex: 0)
            //}
        }
    } //end of func session
    
}


