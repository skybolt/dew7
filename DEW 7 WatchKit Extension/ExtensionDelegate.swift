//
//  ExtensionDelegate.swift
//  DEW 7 WatchKit Extension
//
//  Created by rob on 11/8/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import WatchKit
import WatchConnectivity


class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
//    func updateComplicationDisplay() {
//        globalVars.textString = "updateComDisp"
//        StatusReporter.isReachableNoReturn()
//        let complicationsController = ComplicationController()
//        complicationsController.reloadOrExtendData()
//    }
//
    func updateComplicationDisplay() {
        let complicationsController = ComplicationController()
        StatusReporter.isReachableNoReturn()
        complicationsController.reloadOrExtendData()
    }
    
    func reloadComplicationData(backgroundTask: WKApplicationRefreshBackgroundTask) {
            if false {
                self.updateComplicationDisplay()
                WKExtension.shared().scheduleBackgroundRefresh(
                withPreferredDate: Date()+100, userInfo: nil) { _ in }
            } else {
//                WKExtension.shared().scheduleBackgroundRefresh(
//                withPreferredDate: Date()+100, userInfo: nil) { _ in }
            }
            backgroundTask.setTaskCompletedWithSnapshot(false)
            updateComplicationDisplay()
        }
    
    
    func handleUserActivity(
        _ userInfo: [AnyHashable : Any]?) {
        updateComplicationDisplay()
//        if let date = userInfo?[CLKLaunchedTimelineEntryDateKey]
//            as? Date {
//            print("launched from complication with date:\(date)")
//        } else {
//            print("launched from complication, but no date :(")
//        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith
        activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: " + "\(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: " + "\(activationState.rawValue)")
    }
    
    func spinUp() {
        if WCSession.isSupported() {
            let session  = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func spinDown() {
        if WCSession.isSupported() {
            let session  = WCSession.default
            session.delegate = self
//            session.deactivate()
        }
    }
    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session  = WCSession.default
            session.delegate = self
            session.activate()
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
    
    func sessionReachabilityDidChange(_ wSession: WCSession) {
        print("sessionReachabilityDidChange() called")
        print("globalVars.connectionStatus = \(globalVars.connectionStatus) \(ExtensionDelegate.oldStatus)")
//        if ExtensionDelegate.oldStatus != globalVars.connectionStatus {
////        if true {
//                StatusReporter.isReachableNoReturn()
//                updateComplicationDisplay()
//        ExtensionDelegate.oldStatus = globalVars.connectionStatus
//        }
//        else {print("no change")}
//        printGlobalVars()
    }

    func applicationDidFinishLaunching() {
//        print("didFinishLaunching")
        setupWatchConnectivity()
        printGlobalVars()
    }

    func applicationDidBecomeActive() {
//        print("applicationDidBecomeActive")
//        let phoneSession = WCSession.default
//        print(self)
//        print(String(phoneSession.isReachable))
        updateComplicationDisplay()
        let backgroundTask = WKApplicationRefreshBackgroundTask()
        reloadComplicationData(backgroundTask: backgroundTask)
    }

    func applicationWillResignActive() {
//        print("applicationWillResignActive")
        updateComplicationDisplay()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        
        for task in backgroundTasks {
            
            switch task {
            
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                //let backgroundTask = WKApplicationRefreshBackgroundTask()
                reloadComplicationData(backgroundTask: backgroundTask)
                print("print WKApplicationRefreshBackgroundTask")
                backgroundTask.setTaskCompletedWithSnapshot(false)
            
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                print("print WKSnapshotRefreshBackgroundTask")
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            
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
}
