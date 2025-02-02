//
//  Logger.swift
//  MobiPay
//
//  Created by Occ Mobility on 22/10/2021.
//

import Foundation
//import SwiftyBeaver

class Logger {
    
    static var loggerBlock : ((String?) -> Void)?
    
//    private static let log = SwiftyBeaver.self
    
    static func initLogger(){
//        if(log.countDestinations() == 0){
//            let console = ConsoleDestination()
//            console.format = "$DHH:mm:ss$d $L $M"
//            Logger.log.addDestination(console)
//        }
    }
    
    static func verbose(_ message : String){
       initLogger()
//        log.verbose(message)
    }
    
    static func debug(_ message : String){
        initLogger()
//        log.debug(message)
    }
    
    static func info(_ message : String){
        initLogger()
//        log.info(message)
    }
    
    static func warn(_ message : String){
        initLogger()
//        log.warning(message)
    }
    
    static func error(_ message : String){
        initLogger()
//        log.error(message)
    }
    
}
