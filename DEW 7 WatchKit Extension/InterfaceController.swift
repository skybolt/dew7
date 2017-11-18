//
//  InterfaceController.swift
//  DEW 7 WatchKit Extension
//
//  Created by rob on 11/8/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var disconnectDEWImage: WKInterfaceImage!
    
    @IBOutlet var connectDEWImage: WKInterfaceImage!
    
    
    func showDisconnectedImage() {
        
    }
    
//    func globalFor() {
//        for variable in globalVars {
//
//        }
//    }
    
    func printGlobalVars() {
        //        for each in globalVars
        print("\(globalVars.textString)")
        print("\(globalVars.shortString)")
        print("\(globalVars.connectionStatus)")
        print("\(globalVars.stringColor)")
    }

    @IBAction func checkStatusAction() {
        globalVars.labelString = "checking"
//        printGlobalVars()
        StatusReporter.isReachableNoReturn()
        statusLabel.setText(globalVars.labelString)
        if StatusReporter.isReachableStatic() == true {
            connectDEWImage.setHidden(false)
            disconnectDEWImage.setHidden(true)
        } else {
            connectDEWImage.setHidden(true)
            disconnectDEWImage.setHidden(false)
        }
    }
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        print("awake withContext")
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        checkStatusAction()
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
