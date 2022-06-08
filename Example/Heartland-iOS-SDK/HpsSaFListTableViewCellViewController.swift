//
//  SaFListTableViewCell.swift
//  Heartland-iOS-SDK
//
//  Created by Rishil Patel on 11/11/20.
//  Copyright © 2020 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK

class SaFListTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "SaFListTableViewCell"
    
    @IBOutlet private weak var invoiceNumberLabel: UILabel!
    @IBOutlet private weak var transactionTypeLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var entryModeLabel: UILabel!
    @IBOutlet private weak var maskedPANLabel: UILabel!
    @IBOutlet private weak var transactionDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(from transaction: ProcessSaF) {
        var invoiceNumber: String?
        var total: UInt?
        var maskedPAN: String?
        var cardDataSourceType: EntryMode?
        var transactionType: TransactionType?
        
        switch transaction.transaction {
        case let transaction as SaleTransaction:
            total = transaction.total
            invoiceNumber = transaction.invoiceNumber
            cardDataSourceType = transaction.cardData?.cardEntryMode
            transactionType = TransactionType.Sale
            maskedPAN = transaction.cardData?.maskedPan
        case let transaction as AuthTransaction:
            total = transaction.total
            invoiceNumber = transaction.invoiceNumber
            cardDataSourceType = transaction.cardData?.cardEntryMode
            transactionType = TransactionType.Auth
            maskedPAN = transaction.cardData?.maskedPan
        case let transaction as ReturnTransaction:
            total = transaction.total
            invoiceNumber = transaction.invoiceNumber
            cardDataSourceType = transaction.cardData?.cardEntryMode
            transactionType = TransactionType.Return
            maskedPAN = transaction.cardData?.maskedPan
        case let transaction as VerifyTransaction:
            total = transaction.total
            invoiceNumber = transaction.invoiceNumber
            cardDataSourceType = transaction.cardData?.cardEntryMode
            transactionType = TransactionType.Verify
            maskedPAN = transaction.cardData?.maskedPan
        case let transaction as TokenizationTransaction:
            total = transaction.total
            invoiceNumber = transaction.invoiceNumber
            cardDataSourceType = transaction.cardData?.cardEntryMode
            transactionType = TransactionType.Tokenize
            maskedPAN = transaction.cardData?.maskedPan
        default:
            break
        }
        
        invoiceNumberLabel.text = "Invoince Number: \(invoiceNumber ?? "")"
        totalLabel.text = "Amount: \(total ?? 0)"
        maskedPANLabel.text = "MaskedPAN: \(maskedPAN ?? "")"
        
        if let entryMode = cardDataSourceType?.rawValue {
            entryModeLabel.text = "Entry Mode: \(entryMode)"
        }
        
        if let transactionType = transactionType?.rawValue {
            transactionTypeLabel.text = "Type: \(transactionType)"
        }
        
        transactionDateLabel.text = transaction.transactionDate?.safFormatted
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
