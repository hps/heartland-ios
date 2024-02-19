//
//
//  TokenProvider.swift
//  Heartland-iOS-SDK
//
    

import Foundation
#if canImport(ProximityReader)
import ProximityReader


@available(iOS 15.4, *)
class TokenProvider {

    static let shared = TokenProvider()

    let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTYwMzIwMDB9.zzz" // empty token

    func buildToken() -> PaymentCardReader.Token {
        #if targetEnvironment(simulator)
        return PaymentCardReader.Token(rawValue: token)
        #else
        // TODO: Replace with API calls to PSP to obtain token.
        return PaymentCardReader.Token(rawValue: token)
        #endif
    }
}
#endif
