//
//  HpsUpaStartCardResponse.swift
//  Heartland-iOS-SDK
//

import Foundation

// MARK: - HpsUpaStartCardResponse
public struct HpsUpaStartCardResponse: Codable {
    public let message: String?
    public let data: HpsUpaStartCardResponseData?

    public init(message: String?, data: HpsUpaStartCardResponseData?) {
        self.message = message
        self.data = data
    }
}

// MARK: - HpsUpaStartCardResponseData
public struct HpsUpaStartCardResponseData: Codable {
    public let response: String?
    public let cmdResult: HpsUpaStartCardResponseCmdResult?
    public let data: HpsUpaStartCardResponseDataData?

    public init(response: String?, cmdResult: HpsUpaStartCardResponseCmdResult?, data: HpsUpaStartCardResponseDataData?) {
        self.response = response
        self.cmdResult = cmdResult
        self.data = data
    }
}

// MARK: - CmdResult
public struct HpsUpaStartCardResponseCmdResult: Codable {
    public let result: String?

    public init(result: String?) {
        self.result = result
    }
}

// MARK: - DataData
public struct HpsUpaStartCardResponseDataData: Codable {
    public let acquisitionType, luhnCheckPassed, dataEncryptionType: String?
    public let pan: HpsUpaStartCardResponsePan?
    public let emvTags: String?
    public let expDate: String?
    public let cvv: String?
    public let scannedData: String?
    public let pinDUKPT: HpsUpaStartCardResponsePinDukpt?
    public let threeDesDukpt: HpsUpaStartCardResponse3DesDukpt?
    public let trackData: HpsUpaStartCardResponseTrackData?

    enum CodingKeys: String, CodingKey {
        case acquisitionType
        case luhnCheckPassed = "LuhnCheckPassed"
        case pan = "PAN"
        case emvTags = "EmvTags"
        case dataEncryptionType
        case expDate
        case cvv = "Cvv"
        case scannedData = "ScannedData"
        case pinDUKPT = "PinDUKPT"
        case threeDesDukpt = "3DesDukpt"
        case trackData
    }

    public init(acquisitionType: String?, luhnCheckPassed: String?, dataEncryptionType: String?, pan: HpsUpaStartCardResponsePan?, emvTags: String?, expDate: String?, cvv: String?, scannedData: String?, pinDUKPT: HpsUpaStartCardResponsePinDukpt?, threeDesDukpt: HpsUpaStartCardResponse3DesDukpt?, trackData: HpsUpaStartCardResponseTrackData?) {
        self.acquisitionType = acquisitionType
        self.luhnCheckPassed = luhnCheckPassed
        self.dataEncryptionType = dataEncryptionType
        self.pan = pan
        self.emvTags = emvTags
        self.expDate = expDate
        self.cvv = cvv
        self.scannedData = scannedData
        self.pinDUKPT = pinDUKPT
        self.threeDesDukpt = threeDesDukpt
        self.trackData = trackData
    }
}

// MARK: - Pan
public struct HpsUpaStartCardResponsePan: Codable {
    public let clearPAN: String?
    public let maskedPAN: String?
    public let encryptedPAN: String?

    public init(clearPAN: String?, maskedPAN: String?, encryptedPAN: String?) {
        self.clearPAN = clearPAN
        self.maskedPAN = maskedPAN
        self.encryptedPAN = encryptedPAN
    }
}

public struct HpsUpaStartCardResponsePinDukpt: Codable {
    public let ksn: String?
    public let pinBlock: String?
    
    enum CodingKeys: String, CodingKey {
        case pinBlock = "PinBlock"
        case ksn = "Ksn"
    }
    
    public init(ksn: String?, pinBlock: String?) {
        self.ksn = ksn
        self.pinBlock = pinBlock
    }
}

public struct HpsUpaStartCardResponse3DesDukpt: Codable {
    public let encryptedBlob: String?
    public let ksn: String?
    
    enum CodingKeys: String, CodingKey {
        case encryptedBlob
        case ksn = "Ksn"
    }
    
    public init(encryptedBlob: String?, ksn: String?) {
        self.encryptedBlob = encryptedBlob
        self.ksn = ksn
    }
}

public struct HpsUpaStartCardResponseTrackData: Codable {
    public let clearTrack2: String?
    public let maskedTrack2: String?
    public let clearTrack1: String?
    public let maskedTrack1: String?
    public let clearTrack3: String?
    public let maskedTrack3: String?
    
    public init(clearTrack2: String?, maskedTrack2: String?, clearTrack1: String?, maskedTrack1: String?, clearTrack3: String?, maskedTrack3: String?) {
        self.clearTrack2 = clearTrack2
        self.maskedTrack2 = maskedTrack2
        self.clearTrack1 = clearTrack1
        self.maskedTrack1 = maskedTrack1
        self.clearTrack3 = clearTrack3
        self.maskedTrack3 = maskedTrack3
    }
}
