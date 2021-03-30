import Foundation
import GlobalMobileSDK

extension NSError {
    convenience init(fromConnectionError error: ConnectionError) {
        self.init()
    }
    convenience init(fromSearchError error: SearchError) {
        self.init()
    }
    convenience init(fromTransactionError error: TransactionError) {
        self.init()
    }
}
