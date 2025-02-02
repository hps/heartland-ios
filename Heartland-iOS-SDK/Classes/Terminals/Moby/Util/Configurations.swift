//
//  Configuration.swift
//  Heartland-iOS-SDK
//
//

import Foundation

@available(iOS 16.0, *)
class Configurations: ObservableObject, Codable {
    @Published var temURL: String = ""
    @Published var temPort: String = ""
    
    enum ConfigurationKeys: String,CodingKey {
        case temURL = "temURL"
        case temPort = "temPort"
    }
    
    init(){
        loadConfigurationsFromUserDefaults()
        temURL = "35.195.17.96"
        temPort = "7047"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConfigurationKeys.self)
        temURL = try container.decode(String.self, forKey: .temURL)
        temPort = try container.decode(String.self, forKey: .temPort)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConfigurationKeys.self)
        try container.encode(temURL, forKey: .temURL)
        try container.encode(temPort, forKey: .temPort)
    }
    
    func loadConfigurationsFromUserDefaults() {
        temURL = loadKey(key: .temURL)
        temPort = loadKey(key: .temPort)
    }
    
    private func loadKey(key : ConfigurationKeys) -> String{
        if let data = UserDefaults.standard.data(forKey: key.rawValue) {
           if let valueRetrieve = try? JSONDecoder().decode(String.self, from: data) {
            return valueRetrieve
           }
        }
        return ""
    }
    
    func saveConfig(){
        saveKey(key: ConfigurationKeys.temURL, value: temURL)
        saveKey(key: ConfigurationKeys.temPort, value: temPort)
    }
    
    private func saveKey(key : ConfigurationKeys,value : String){
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
            switch key {
                case .temURL:
                temURL = value
                case .temPort:
                temPort = value
            }
        }
    }
}
