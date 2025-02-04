//
//  RKIScenario.swift
//  TemDev
//
//

import Foundation


public class RKIScenario{
    
    var deviceGroupName : String
    var serialNumber: String
    var certificateVersion : String
    var keyMappingInfo :String
    var isSuccess : Bool
    
    init(deviceGroupName : String,serialNumber: String,certificateVersion : String,keyMappingInfo :String,isSuccess : Bool){
        self.deviceGroupName = deviceGroupName
        self.serialNumber = serialNumber
        self.certificateVersion = certificateVersion
        self.keyMappingInfo = keyMappingInfo
        self.isSuccess = isSuccess
    }
}
