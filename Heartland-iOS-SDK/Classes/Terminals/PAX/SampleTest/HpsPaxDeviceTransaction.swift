//
//  HpsPaxDeviceTransaction.swift
//  Heartland-iOS-SDK
//

import CoreBluetooth
import Foundation
import Heartland_iOS_SDK
import UIKit

public class HpsPaxDeviceTransaction {
    
    func testPaxDeviceManual() {
        
        let timeout = 120

        let config = HpsConnectionConfig()
        config.ipAddress = "192.168.31.82"
        config.port = "10009"
        config.connectionMode = 1
        config.timeout = timeout

        let paxDevice = HpsPaxDevice(config: config)
        

        let builder = HpsPaxCreditSaleBuilder(device: paxDevice)
        builder?.amount = 14.0
        builder?.requestMultiUseToken = true
        builder?.referenceNumber = 10
        builder?.allowDuplicates = true

        builder?.execute { response, error in
           
            if let tokenData = response?.tokenData {
                print(" Token Data \(tokenData)")
            }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response {
                print("Response: \(response)")
                let responseReturn = response.parseResponse()
                print("Response Parse: \(responseReturn.debugDescription)")
            }
        }
    }
    
    public static func testPaxDeviceManualWithSecondTransactionUsingToken() {
        
        let timeout = 120

        let config = HpsConnectionConfig()
        config.ipAddress = "192.168.31.82"
        config.port = "10009"
        config.connectionMode = 1
        config.timeout = timeout

        let paxDevice = HpsPaxDevice(config: config)
        

        let builder = HpsPaxCreditSaleBuilder(device: paxDevice)
        builder?.amount = 14.0
        builder?.requestMultiUseToken = true
        builder?.referenceNumber = 10
        builder?.allowDuplicates = true

        builder?.execute { response, error in
            if let cardBrandTransactionId = response?.cardBrandTransactionId {
                let builderToken = HpsPaxCreditSaleBuilder(device: paxDevice)
                
                builderToken?.amount = 17.0
                builderToken?.token = response?.tokenData.tokenValue
                builderToken?.cardBrandTransactionId = cardBrandTransactionId
                
                builderToken?.execute({ responseBuilderToken, errorBuilderToken in
                    if let errorBuilderToken = errorBuilderToken {
                        print(" Error build token: \(errorBuilderToken)")
                    }

                    if let responseBuilderToken = responseBuilderToken {
                        print(" Response Builder Token: \(responseBuilderToken.deviceResponseMessage)")
                    }
                })
            }
            
            if let tokenData = response?.tokenData {
                print(" Token Data \(tokenData)")
            }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response {
                print("Response: \(response)")
                let responseReturn = response.parseResponse()
                print("Response Parse: \(responseReturn.debugDescription)")
            }
        }
    }
    
    public static func testPaxDeviceManualWithSecondTransactionUsingTokenAuth() {
        
        let timeout = 120

        let config = HpsConnectionConfig()
        config.ipAddress = "192.168.31.82"
        config.port = "10009"
        config.connectionMode = 1
        config.timeout = timeout

        let paxDevice = HpsPaxDevice(config: config)
        
        let address = HpsAddress()
        address.address = "asdf"
        address.zip = "90012"
        

        let builder = HpsPaxCreditAuthBuilder(device: paxDevice)
        builder?.creditCard = getCreditCard()
        builder?.address = address
        builder?.amount = 14.0
        builder?.requestMultiUseToken = true
        builder?.referenceNumber = 10
        builder?.allowDuplicates = true

        builder?.execute { response, error in
            if let cardBrandTransactionId = response?.cardBrandTransactionId {
                let builderToken = HpsPaxCreditAuthBuilder(device: paxDevice)
                
                builderToken?.amount = 17.0
                builderToken?.token = response?.tokenData.tokenValue
                builderToken?.cardBrandTransactionId = cardBrandTransactionId
                
                builderToken?.execute({ responseBuilderToken, errorBuilderToken in
                    if let errorBuilderToken = errorBuilderToken {
                        print(" Error build token: \(errorBuilderToken)")
                    }

                    if let responseBuilderToken = responseBuilderToken {
                        print(" Response Builder Token: \(responseBuilderToken.deviceResponseMessage)")
                    }
                })
            }
            
            if let tokenData = response?.tokenData {
                print(" Token Data \(tokenData)")
            }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response {
                print("Response: \(response)")
                let responseReturn = response.parseResponse()
                print("Response Parse: \(responseReturn.debugDescription)")
            }
        }
    }
    
    static func testPaxDeviceAuth() {
        let timeout = 120

        let config = HpsConnectionConfig()
        config.ipAddress = "192.168.31.82"
        config.port = "10009"
        config.connectionMode = 1
        config.timeout = timeout

        let paxDevice = HpsPaxDevice(config: config)

        let address = HpsAddress()
        address.address = "-"
        address.zip = "-"

        let builder = HpsPaxCreditAuthBuilder(device: paxDevice)
        builder?.amount = 11.0
        builder?.referenceNumber = 1
        builder?.allowDuplicates = true
        builder?.requestMultiUseToken = true
        builder?.creditCard = getCreditCard()
        builder?.address = address

        builder?.execute { response, error in
            print(" PRINTING CARD BRAND TRANSACTION ID: \(response?.cardBrandTransactionId)")
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response {
                print("Response: \(response)")
                let responseReturn = response.parseResponse()
                print("Response Parse: \(responseReturn.debugDescription)")
            }
            
            
            if let token = response?.tokenData, let tokenValue = token.tokenValue {
                print(" Token value: \(tokenValue)")
            }
        }
    }
    
    private static func getCreditCard() -> HpsCreditCard {
        let card = HpsCreditCard()
        card.cardNumber = "0"
        card.expMonth = 0
        card.expYear = 0
        card.cvv = "0"
        
        return card
    }
}
