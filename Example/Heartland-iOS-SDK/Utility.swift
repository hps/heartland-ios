//
//  ReceiptUtility.swift
//  Heartland-iOS-SDK
//
//  Created by Marvin Avila on 10/6/20.
//  Copyright © 2020 GlobalPayments. All rights reserved.
//

import Foundation

struct ReceiptUtility {
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale.current
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyDDDAAAAA"
        return df
    }()
    
    static var invoiceNumber: String {
        let str = dateFormatter.string(from: Date())
        return (str.count > 5) ? String(str.dropFirst(5)) : str.padding(toLength: 5, withPad: "0", startingAt: 0)
    }
}

class LocalizableHelper {
    static var sharedInstance = LocalizableHelper()
    private init() {}
    
    func localizableStringFor(_ key: String) -> String {
        
        return NSLocalizedString(key,
                                 tableName: nil,
                                 bundle: Bundle(for: type(of: self)),
                                 value: "",
                                 comment: "")
    }
}
