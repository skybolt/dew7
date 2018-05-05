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


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var disconnectDEWImage: WKInterfaceImage!
    
    @IBOutlet var connectDEWImage: WKInterfaceImage!
    
    @IBOutlet var initialDEWImage: WKInterfaceImage!
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    @IBOutlet var refreshButtonImage: WKInterfaceImage!
    static var buttonImageHolder = UIImage(named: "blackDEW") //"UIImage here. Not know how to call."

    func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\(file):\(line) : \(function)"
    }
    
    
    func showDisconnectedImage() {
        
    }
    
    func printGlobalVars() {
        //        for each in globalVars
        print("\(globalVars.textString)")
        print("\(globalVars.shortString)")
        print("\(globalVars.connectionStatus)")
        print("\(globalVars.stringColor)")
    }
    
    func loadInitialStatus() {
        print(debug())
        statusLabel.setText(globalVars.labelString)
        
        //        if StatusReporter.isReachableStatic() == true {
        if globalVars.textString == "connected" {
//            connectDEWImage.setHidden(false)
            disconnectDEWImage.setHidden(true)
        } else {
            connectDEWImage.setHidden(true)
//            disconnectDEWImage.setHidden(false)
        }
        initialDEWImage.setHidden(true)
        
    }

    @IBAction func checkStatusAction() {
        print(debug())
        animateText()
        StatusReporter.isReachableNoReturn()
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
    
    func animateText() {
//        statusLabel.setText(globalVars.labelString)
        print("checking ...")
        statusLabel.setText("checking ...")
//        sleep(1)
        print("slept 1")
    }
    
    @IBAction func refreshButton() {
        print(debug())
        animateText()
        connectDEWImage.setHidden(true)
        disconnectDEWImage.setHidden(true)
        initialDEWImage.setHidden(false)
        //sleep(1)
        checkStatusAction()
    }
    
    
    @IBAction func graphicRefreshButton() {
        print(debug())
        checkStatusAction()
    }
    
    override func awake(withContext context: Any?) {
        print(debug())
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        print(debug())
        let session = WCSession.default
        print("session.activationState = ", terminator: "")
        print(session.activationState.rawValue)
        globalVars.counter += 1
        checkStatusAction()
//        super.willActivate()
        
    }
    
    override func didDeactivate() {
        print(debug())
                let complicationsController = ComplicationController()
                complicationsController.reloadOrExtendData()
        super.didDeactivate()
    }
}
