//
//  AppDelegate.swift
//  DEW 7
//
//  Created by rob on 11/8/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\(file):\(line) : \(function)"
    }
    
        func sendPhoneHeartbeatNotificationToWatch(_ notification: Notification) {
            if WCSession.isSupported() {
                let status = "connected"
                let session = WCSession.default
                if session.isWatchAppInstalled {
                    do {
                        let dictionary = ["status": status]
                        try session.updateApplicationContext(dictionary)
                    } catch {
                        print("ERROR: \(error)")
                    }
    
                }
                
            }
    }
    
    func sendPhoneHeartbeatToWatch() {
        //this function is to alert the watch that it's still connected
        //the watch will periodically check to see if it's recieved this message
        //in a timely manner, and if not, conclude it's disconnected
        //this broken approach is necessary becuase the watch keeps updating its status
        //when the app closes (as a change state event) it caoncludes it's not connected, when it is
        print(debug())
        if WCSession.isSupported() {
            let status = "connected"
            let session = WCSession.default
            if session.isWatchAppInstalled {
                do {
                    let dictionary = ["status": status]
                    try session.updateApplicationContext(dictionary); print("try yes")
                } catch {
                    print("ERROR: \(error)")
                }
                
            }
            
        }
    }
    
    private func setupNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: NSNotification.Name("status"), object: nil, queue: nil) { (notification:Notification) -> Void in
            self.sendPhoneHeartbeatNotificationToWatch(notification)
        }
    }

    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session  = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // 1
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("phone WC Session did become inactive")
    }
    
    // 2
    func sessionDidDeactivate(_ session: WCSession) {
        print("phone WC Session did deactivate")
        WCSession.default.activate()
    }
    
    // 3
    func session(_ session: WCSession, activationDidCompleteWith
        activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: " + "\(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: " + "\(activationState.rawValue)")
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupWatchConnectivity()
        setupNotificationCenter()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        sendPhoneHeartbeatToWatch()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

