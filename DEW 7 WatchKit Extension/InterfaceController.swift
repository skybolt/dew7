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
import UserNotifications


class InterfaceController: WKInterfaceController {
    
    
    //not using these three. Comment out after removing all references in interface controller and or storyboard. Might be set in GUI someplace. 
    @IBOutlet var disconnectDEWImage: WKInterfaceImage!
    @IBOutlet var connectDEWImage: WKInterfaceImage!
    @IBOutlet var initialDEWImage: WKInterfaceImage!
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    @IBOutlet var refreshButtonImage: WKInterfaceImage!
    
    static var buttonImageHolder = UIImage(named: "blackDEW") //"UIImage here. Not know how to call."
    //update May 18 2018 this is probably handled under globalVars.statusBitmap
    
    @IBAction func gotoDebugInfo() {
        print(sharedObjects.fullDebug())
        presentController(withName: "debugInfo", context: self)
    }
    
    @IBAction func checkStatusAction() {
        //pulled when round refresh icon on Force Touch screen pressed

        print(sharedObjects.simpleDebug())
        StatusReporter.updateStatus()
        statusLabel.setText(globalVars.labelString)
        refreshButtonImage.setImageNamed(globalVars.statusBitmap)
    }

    @IBAction func refreshButton() {
       //never pulled
        print(sharedObjects.simpleDebug())
        statusLabel.setText("checking . . .")
        checkStatusAction()
    }
    
    
    @IBAction func graphicRefreshButton() {
        print(sharedObjects.simpleDebug())
        //pulled when icon clicked in Interface Controller
        checkStatusAction()
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        print(sharedObjects.fullDebug())
        checkStatusAction()
    }
    
    override func didDeactivate() {
//        print(sharedObjects.fullDebug())
        super.didDeactivate()
    }
    
}
