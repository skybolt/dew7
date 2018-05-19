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
    //set up global variables and set initial values
    static var textString = "connecting"
    static var shortString = "..."
    static var labelString = "D.E.W. initializing"
    static var notificationString = "notification string"
    static var debugString = "debug"
    static var stringColor = UIColor.yellow
    static var statusImage = "connected"
    static var statusBitmap = "blackDew"
    static var newConnectionStatus = Bool(false)
    static var oldConnectionStatus = Bool(true)
    static var newStatusString = "nN"
    static var oldStatusString = "nN"
    static var counter = 0
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

final class StatusReporter: NSObject {
    
    func isReachable() -> Bool {
        return WCSession.default.isReachable
    }
    
    static func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\(file):\(line) : \(function)"
    }
    

    static func updateStatus() {

        if WCSession.default.isReachable == true {
            globalVars.textString = "connected"
            globalVars.shortString = "OK"
            globalVars.labelString = """
                                    D.E.W. active
                                    phone connected
                                    """
            globalVars.notificationString = "iPhone connected"
            globalVars.stringColor = UIColor(red:0.310, green:0.706, blue:0.965, alpha:1.00) //Red:0.310 green:0.706 blue:0.965 alpha:1.00
            globalVars.statusImage = "connected"
            globalVars.statusBitmap = "blueDew"
        }
        else {
            globalVars.textString = "disconnected"
            globalVars.shortString = "!"
            globalVars.labelString = """
                                    Phone not
                                    connected
                                    """
            globalVars.notificationString = "Disconnected!"
            globalVars.statusImage = "disconnected"
            globalVars.statusBitmap = "redDew"
            globalVars.stringColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        globalVars.newConnectionStatus = WCSession.default.isReachable
    }
}







//    static func queryStatus() -> Bool {
//        return WCSession.default.isReachable
//    }

//    var shortText: String {
//        if isReachable() == true {
//            globalVars.shortString = "CON"
//        } else if isReachable() == false {
//            globalVars.shortString = "DIS"
//        }
//        return "string"
//    }
//
//    var longText: String {
//        if isReachable() == true {
//            globalVars.textString = "connected"
//        } else if isReachable() == false {
//            globalVars.textString = "disconnected"
//        }
//        return "string"
//    }

//    static func labelStatus() -> String {
//        var sString = "labelStatus"
//        if WCSession.isSupported() {
//            let phoneSession = WCSession.default
//            if phoneSession.isReachable == true {
//                sString = """
//                system active
//                phone connected
//                """
//            } else {
//                sString = """
//            phone
//            NOT connected
//            """
//            }
//
//        } else {
//            sString = "session not supported"
//        }
//        return sString
//    }
//
//
//    static func longStatus() -> String {
//        var sString = "init"
//        if WCSession.isSupported() {
//            let phoneSession = WCSession.default
//            if phoneSession.isReachable == true {
//                sString = "connected"
//                return sString
//            } else {
//                sString = "disconnected"
//                return sString
//            }
//         } else {
//            sString = "not supported"
//            return sString
//        }
//    }

//    static func shortStatus() -> String {
//        var sString = "init"
//        if WCSession.isSupported() {
//            let phoneSession = WCSession.default
//            if phoneSession.isReachable == true {
//                sString = "con"
//            } else {
//                sString = "dis"
//            }
//        } else {
//            sString = "not supported"
//        }
//        return sString
//    }

