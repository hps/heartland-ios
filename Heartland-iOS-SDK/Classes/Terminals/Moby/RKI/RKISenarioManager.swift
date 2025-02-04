//
//  SenarioManager.swift
//  TemDev
//
//

import Foundation

public class RKISenarioManager{
    
    public static let sharedInstance = RKISenarioManager()

      private init() {
        
      }
    
    func addScenario(scenario : RKIScenario){
        
    }
    
    func updateRKIScenario() -> Bool{
        return true
    }

    func isRKIRequiredForGroupName(deviceGroupName : String,serialNumber: String,certificateVersion : String,keyMappingInfo :String) -> Bool{
        return true;
    }
}
