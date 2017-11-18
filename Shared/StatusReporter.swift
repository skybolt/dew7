//
//  StatusReporter.swift
//  DEW 7
//
//  Created by rob on 11/9/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import WatchKit
import WatchConnectivity


struct globalVars {
    static var textString = "connecting"
    static var shortString = "..."
    static var labelString = "initializing, system connecting"
    static var stringColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
    static var statusImage = "connected"
    static var connectionStatus = Bool(false)
}

final class StatusReporter: NSObject {
    
    func isReachable() -> Bool {
        return WCSession.default.isReachable
    }
    

    static func isReachableNoReturn() {
        print("isReachableNoReturn()")
        if WCSession.default.isReachable == true {
            globalVars.textString = "connected"
            globalVars.shortString = "CON"
            globalVars.labelString = """
                                    system active
                                    phone connected
                                    """
            globalVars.stringColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
            globalVars.statusImage = "connected"
        }
        else {
            globalVars.textString = "disconnected"
            globalVars.shortString = "DIS"
            globalVars.labelString = """
                                    phone
                                    NOT connected
                                    """
            globalVars.statusImage = "disconnected"
            globalVars.stringColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        globalVars.connectionStatus = WCSession.default.isReachable
//        let complicationsController = ComplicationController()
//        complicationsController.reloadOrExtendData()
    }
    
    static func isReachableStatic() -> Bool {
        return WCSession.default.isReachable
    }
    
    
    var shortText: String {
        if isReachable() == true {
            globalVars.shortString = "CON"
        } else if isReachable() == false {
            globalVars.shortString = "DIS"
        }
        return "string"
    }
    
    var longText: String {
        if isReachable() == true {
            globalVars.textString = "connected"
        } else if isReachable() == false {
            globalVars.textString = "disconnected"
        }
        return "string"
    }
    
    static func labelStatus() -> String {
        var sString = "labelStatus"
        if WCSession.isSupported() {
            let phoneSession = WCSession.default
            if phoneSession.isReachable == true {
                sString = """
                system active
                phone connected
                """
            } else {
                sString = """
            phone
            NOT connected
            """
            }
            
        } else {
            sString = "session not supported"
        }
        return sString
    }
    
    
    static func longStatus() -> String {
        var sString = "init"
        if WCSession.isSupported() {
            let phoneSession = WCSession.default
            if phoneSession.isReachable == true {
                sString = "connected"
                return sString
            } else {
                sString = "disconnected"
                return sString
            }
         } else {
            sString = "not supported"
            return sString
        }
    }
    
    static func shortStatus() -> String {
        var sString = "init"
        if WCSession.isSupported() {
            let phoneSession = WCSession.default
            if phoneSession.isReachable == true {
                sString = "con"
            } else {
                sString = "dis"
            }
        } else {
            sString = "not supported"
        }
        return sString
    }

}
