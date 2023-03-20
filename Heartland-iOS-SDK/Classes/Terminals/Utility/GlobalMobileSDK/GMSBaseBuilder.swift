import Foundation
import GlobalMobileSDK

@objcMembers
public class GMSBaseBuilder: NSObject {
    public let transactionType: HpsTransactionType
    public unowned let device: GMSDeviceInterface

    internal init(transactionType: HpsTransactionType, device: GMSDeviceInterface) {
        self.transactionType = transactionType
        self.device = device
        super.init()
    }

    public func execute() {
        device.processTransactionWithRequest(self, withTransactionType: transactionType)
    }

    public func buildRequest() -> Transaction? {
        return nil
    }

    public func mapResponse(_: HpsTerminalResponse, _: TransactionResult, _: TransactionResponse?) -> HpsTerminalResponse {
        return HpsTerminalResponse()
    }
}

// MARK: - Model

@objcMembers
public class GMSBuilderModel: NSObject {
    public let transactionType: HpsTransactionType
    public let amount: NSDecimalNumber?
    public let gratuity: NSDecimalNumber?
    public let referenceNumber: String?
    public let transactionId: String?
    public let creditCard: HpsCreditCard?
    public let clientTransactionId: String?
    public let reason: ReversalReasonCode?

    init(
        transactionType: HpsTransactionType,
        amount: NSDecimalNumber? = nil,
        gratuity: NSDecimalNumber? = nil,
        referenceNumber: String? = nil,
        transactionId: String? = nil,
        creditCard: HpsCreditCard? = nil,
        clientTransactionId: String? = nil,
        reasonPointer: NSNumber? = nil
    ) {
        self.transactionType = transactionType
        self.amount = amount
        self.gratuity = gratuity
        self.referenceNumber = referenceNumber
        self.transactionId = transactionId
        self.creditCard = creditCard
        self.clientTransactionId = clientTransactionId
        reason = reasonPointer.flatMap { ReversalReasonCode(rawValue: $0.intValue) }
    }

    public var reasonPointer: NSNumber? {
        reason.flatMap {
            NSNumber(value: $0.rawValue)
        }
    }

    // MARK: Wrappers

    public static func creditAuthModel(
        amount: NSDecimalNumber,
        gratuity: NSDecimalNumber?,
        referenceNumber _: String?,
        creditCard: HpsCreditCard?
    ) -> GMSBuilderModel {
        .init(
            transactionType: .creditAuth,
            amount: amount,
            gratuity: gratuity,
            creditCard: creditCard
        )
    }

    public static func creditReturnModel(
        amount: NSDecimalNumber,
        referenceNumber: String?
    ) -> GMSBuilderModel {
        .init(
            transactionType: .creditReturn,
            amount: amount,
            referenceNumber: referenceNumber
        )
    }

    public static func creditReversalModel(
        amount: NSDecimalNumber,
        clientTransactionId: String?,
        reason: ReversalReasonCode
    ) -> GMSBuilderModel {
        .init(
            transactionType: .creditReversal,
            amount: amount,
            clientTransactionId: clientTransactionId,
            reasonPointer: NSNumber(value: reason.rawValue)
        )
    }

    public static func creditSaleModel(
        amount: NSDecimalNumber,
        gratuity: NSDecimalNumber?,
        referenceNumber _: String?
    ) -> GMSBuilderModel {
        .init(
            transactionType: .creditSale,
            amount: amount,
            gratuity: gratuity
        )
    }
}

// MARK: - Factory

public extension GMSBaseBuilder {
    @objc static func builder(
        device: GMSDeviceInterface,
        model: GMSBuilderModel
    ) -> GMSBaseBuilder? {
        let builder: GMSBaseBuilder? =
            (device as? HpsC2xDevice).flatMap {
                switch model.transactionType {
                case .creditAuth:
                    return HpsC2xCreditAuthBuilder(device: $0)
                case .creditReturn:
                    return HpsC2xCreditReturnBuilder(device: $0)
                case .creditReversal:
                    return HpsC2xCreditReversalBuilder(device: $0)
                case .creditSale:
                    return HpsC2xCreditSaleBuilder(device: $0)
                default:
                    return nil
                }
            } ?? (device as? HpsWiseCubeDevice).flatMap {
                switch model.transactionType {
                case .creditAuth:
                    return HpsWiseCubeCreditAuthBuilder(device: $0)
                case .creditReturn:
                    return HpsWiseCubeCreditReturnBuilder(device: $0)
                case .creditReversal:
                    return HpsWiseCubeCreditReversalBuilder(device: $0)
                case .creditSale:
                    return HpsWiseCubeCreditSaleBuilder(device: $0)
                default:
                    return nil
                }
            }

        switch builder {
        case let builderAuth as GMSCreditAuthBuilder:
            builderAuth.amount = model.amount
            builderAuth.gratuity = model.gratuity
            builderAuth.creditCard = model.creditCard
        case let builderReturn as GMSCreditReturnBuilder:
            builderReturn.amount = model.amount
            builderReturn.referenceNumber = model.referenceNumber
            builderReturn.transactionId = model.transactionId
        case let builderReversal as GMSCreditReversalBuilder:
            builderReversal.amount = model.amount
            builderReversal.clientTransactionId = model.clientTransactionId
            builderReversal.reason = model.reason ?? .NOREASON
        case let builderSale as GMSCreditSaleBuilder:
            builderSale.amount = model.amount
            builderSale.gratuity = model.gratuity
            builderSale.creditCard = model.creditCard
        default:
            return nil
        }

        return builder
    }
}
