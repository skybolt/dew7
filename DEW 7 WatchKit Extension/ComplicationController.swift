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
        // 1
        let server = CLKComplicationServer.sharedInstance()
        guard let complications = server.activeComplications,
            complications.count > 0 else { return }
            for complication in complications  {
                server.reloadTimeline(for: complication)
            }
        }
 
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }

    // MARK: - Timeline Population
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
                    if #available(watchOSApplicationExtension 5.0, *) {
                        
                        if complication.family == .graphicCircular {
                            let graphCirc = CLKComplicationTemplateGraphicCircularImage()
                            graphCirc.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: globalVars.statusGraphCir)!)
                            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphCirc))
                        }
                        
                        if complication.family == .graphicBezel {
                            let graphBez = CLKComplicationTemplateGraphicBezelCircularText()
                            let graphCirc = CLKComplicationTemplateGraphicCircularImage()
                            graphCirc.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: globalVars.statusGraphCir)!)
                            graphBez.textProvider = CLKSimpleTextProvider(text: globalVars.bezelString)
                            graphBez.circularTemplate = graphCirc
                            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphBez))
                        }
                        
                    }  //end if 5.0 supported
    
        if complication.family == .utilitarianSmall {
//            print("utilitarianSmall")
            let smallFlat = CLKComplicationTemplateUtilitarianSmallSquare()
            smallFlat.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: smallFlat))
        }
            
        else  if complication.family == .utilitarianLarge {
//            print("utilitarianLarge")
            let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
            largeFlat.textProvider = CLKSimpleTextProvider(
                text: globalVars.textString, shortText: globalVars.shortString)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: largeFlat))
        }

        else if complication.family == .circularSmall {
//            print("circularSmall")
            let circSmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circSmall))
        }
            
        else if complication.family == .modularSmall {
//            print("modularSmall")
            let modSmall = CLKComplicationTemplateModularSmallSimpleImage()
            modSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusBitmap)!)
            modSmall.imageProvider.tintColor = globalVars.stringColor
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modSmall))
        }
            
        else if complication.family == .modularLarge {
//            print("modularLarge")
            let modLarge = CLKComplicationTemplateModularLargeStandardBody()
            modLarge.headerTextProvider = CLKSimpleTextProvider(text: "D.E.W. Status")
            modLarge.headerTextProvider.tintColor = globalVars.stringColor
            modLarge.body1TextProvider = CLKSimpleTextProvider(text: globalVars.notificationString)
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: modLarge))
        }
        
        else if complication.family == .extraLarge {
//            print("extraLarge")
            let exLarge = CLKComplicationTemplateExtraLargeSimpleImage()
            exLarge.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            exLarge.imageProvider.tintColor = globalVars.stringColor
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: exLarge))
        }
    }
    
    // MARK: - Placeholder Templates
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        
        if #available(watchOSApplicationExtension 5.0, *) {

//            print("graphicCircular")
            if complication.family == .graphicCircular {
//                print("template for graphCir")
                let graphCirc = CLKComplicationTemplateGraphicCircularImage()
//                graphCirc.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "black-94")!)
                graphCirc.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: globalVars.statusGraphCir)!)
                handler(graphCirc)
            }
            
            if complication.family == .graphicBezel {
                let graphBez = CLKComplicationTemplateGraphicBezelCircularText()
                let graphCirc = CLKComplicationTemplateGraphicCircularImage()
                graphCirc.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: globalVars.statusGraphCir)!)
                graphBez.textProvider = CLKSimpleTextProvider(text: globalVars.labelString)
                graphBez.circularTemplate = graphCirc
                handler(graphBez)
            }
        }

        
        if complication.family == .utilitarianSmall {
//            print("utilitarianSmall")
            let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
            smallFlat.textProvider = CLKSimpleTextProvider(text: "int")
            smallFlat.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(smallFlat)
        }

        else if complication.family == .utilitarianLarge {
//            print("utilitarianLarge")
            let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
            largeFlat.textProvider = CLKSimpleTextProvider(text: "installed", shortText:globalVars.shortString)
            handler(largeFlat)
        }
            
        else if complication.family == .circularSmall {
//            print("circularSmall")
            let circSmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(circSmall)
        }
            
        else if complication.family == .modularSmall {
//            print("modularSmall")
            let modSmall = CLKComplicationTemplateModularSmallSimpleImage()
            modSmall.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(modSmall)
        }
        
        else if complication.family == .modularLarge {
//            print("modularLarge")
            let modLarge = CLKComplicationTemplateModularLargeStandardBody()
            modLarge.headerTextProvider.tintColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
            modLarge.headerTextProvider = CLKSimpleTextProvider(text: "Distant Early Warning")
            modLarge.body1TextProvider = CLKSimpleTextProvider(text: "D.E.W. activating, initializing ...")
            handler(modLarge)
        }
        
        else if complication.family == .extraLarge {
//            print("extraLarge")
            let exLarge = CLKComplicationTemplateExtraLargeSimpleImage()
            exLarge.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: globalVars.statusImage)!)
            handler(exLarge)
        }
    }
}
