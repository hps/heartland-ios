//
//
//  HpsUpaGetSaf.swift
//  Heartland-iOS-SDK
//

import Foundation

struct HpsUpaGetSafConstants {
    static let command = "GetSAFReport"
}

// MARK: - HpsUpaSendSaf

public struct HpsUpaGetSaf: Codable {
    public let message: String?
    public let data: HpsUpaCommandPayload<HpsUpaGetSafData>?

    public init(message: String? = "MSG", data: HpsUpaCommandPayload<HpsUpaGetSafData>?) {
        self.message = message
        self.data = data
    }
}

public struct HpsUpaGetSafData: Codable {
    public let params: HpsUpaGetSafDataReportOutput?

    public init(params: HpsUpaGetSafDataReportOutput) {
        self.params = params
    }
}

public struct HpsUpaGetSafDataReportOutput: Codable {
    public let reportOutput: String?

    public init(reportOutput: String?) {
        self.reportOutput = reportOutput
    }
}
