//
//  DebugInfoController.swift
//  DEW 7 WatchKit Extension
//
//  Created by rob on 5/20/18.
//  Copyright © 2018 the Klebeian Group. All rights reserved.
//

import WatchKit
import Foundation


class DebugInfoController: WKInterfaceController {
    
    @IBOutlet var debugLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        print(sharedObjects.fullDebug())
        debugLabel.setText(
            """
            session changes: \(globalVars.sessionChangeCounter)
            bgApp Refreshes: \(globalVars.bgAppCounter)
            bgSnp Refreshes: \(globalVars.bgSnapshotCounter)
            oldStatus: \(globalVars.oldConnectionStatus)
            newStatus: \(globalVars.newConnectionStatus)
            notificationAsked: \(globalVars.notificationAsked)
            notificationThrow: \(globalVars.notificationThrown)
            """)
    }

    override func willActivate() {
//          hexLabel.setText("#" + color.hexString)

        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        print(sharedObjects.fullDebug())
        super.didDeactivate()
    }

}
