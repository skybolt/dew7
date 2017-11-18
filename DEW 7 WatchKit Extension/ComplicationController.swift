//
//  ComplicationController.swift
//  DEW 7 WatchKit Extension
//
//  Created by rob on 11/8/17.
//  Copyright © 2017 the Klebeian Group. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func reloadOrExtendData() {
        print("reloadOrExtendData() called")
        // 1
        let server = CLKComplicationServer.sharedInstance()
        guard let complications = server.activeComplications,
            complications.count > 0 else { return }
            for complication in complications  {
                server.reloadTimeline(for: complication)
            }
        }
 
    // MARK: - Timeline Configuration
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    

    // MARK: - Timeline Population
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        if complication.family == .utilitarianSmall {
            print("utilSmall")
            let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
            smallFlat.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
//            smallFlat.textProvider.tintColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            smallFlat.textProvider = CLKSimpleTextProvider(
            text:   globalVars.shortString)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: smallFlat))
        }
            
        else  if complication.family == .utilitarianLarge {
            print("utilLarge")
            let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
            largeFlat.textProvider = CLKSimpleTextProvider(
                text: globalVars.textString, shortText: globalVars.shortString)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: largeFlat))
        }
            
        else if complication.family == .circularSmall {
            print("circSmall")
            let circSmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            //
            //            let circSmall = CLKComplicationTemplateCircularSmallStackImage()
            //            circSmall.line1ImageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            //            circSmall.line2TextProvider = CLKSimpleTextProvider(text: globalVars.shortString)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circSmall))
        }
            
        else if complication.family == .modularSmall {
            let modSmall = CLKComplicationTemplateModularSmallSimpleImage()
            modSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            modSmall.imageProvider.tintColor = globalVars.stringColor
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modSmall))
        }
            
        else if complication.family == .modularLarge {
            print("largeMod")
            let modLarge = CLKComplicationTemplateModularLargeStandardBody()
            modLarge.headerTextProvider = CLKSimpleTextProvider(text: globalVars.textString)
            modLarge.headerTextProvider.tintColor = globalVars.stringColor
            modLarge.body1TextProvider.tintColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
            modLarge.body1TextProvider = CLKSimpleTextProvider(text: globalVars.labelString)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modLarge))
        }
    }
    
    // MARK: - Placeholder Templates
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        if complication.family == .utilitarianSmall {
            let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
            smallFlat.textProvider = CLKSimpleTextProvider(text: "init")
            smallFlat.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(smallFlat)
        }

        else if complication.family == .utilitarianLarge {
            let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
            largeFlat.textProvider = CLKSimpleTextProvider(text: "installed", shortText:"init")
            handler(largeFlat)
        }
            
        else if complication.family == .circularSmall {
            let circSmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
//            let circSmall = CLKComplicationTemplateCircularSmallStackImage()
//            circSmall.line1ImageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
//            circSmall.line2TextProvider = CLKSimpleTextProvider(text: globalVars.shortString)
            handler(circSmall)
        }
            
        else if complication.family == .modularSmall {
            let modSmall = CLKComplicationTemplateModularSmallSimpleImage()
            modSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(modSmall)
        }
        
        else if complication.family == .modularLarge {
            let modLarge = CLKComplicationTemplateModularLargeStandardBody()
            modLarge.headerTextProvider.tintColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
            modLarge.headerTextProvider = CLKSimpleTextProvider(text: "Distant Early Warning")
            modLarge.body1TextProvider = CLKSimpleTextProvider(text: "system activating, initializing ...")
            handler(modLarge)
        }
    }
}
