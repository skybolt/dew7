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
        presentController(withName: "debugInfo", context: self)
    }
    
    func checkStatusAction() {
        print(sharedObjects.simpleDebug())
        StatusReporter.updateStatus()
        statusLabel.setText(globalVars.labelString)
        refreshButtonImage.setImageNamed(globalVars.statusBitmap)
    }

    @IBAction func refreshButton() {
        statusLabel.setText("checking . . .")
        checkStatusAction()
    }
    
    
    @IBAction func graphicRefreshButton() {
        checkStatusAction()
    }
    
    override func awake(withContext context: Any?) {
        print(sharedObjects.simpleDebug())
        checkStatusAction()
        super.awake(withContext: context)
    }
    
    override func willActivate() {
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}

//extension WKInterfaceController: UNUserNotificationCenterDelegate {
//    
//}
