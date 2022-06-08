//
//  ScreenSequence.swift
//  Heartland-iOS-SDK
//
//  Created by J.Rodden on 7/27/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK

protocol TakesConfig: BaseViewController {
    static func instantiate(with config: GatewayConfig) -> UIViewController?
}

protocol TakesTransaction: BaseViewController {
    static func instantiate(for transaction: Transaction) -> UIViewController?
}

/// a simple state machine, for managing screen sequencing
enum ScreenSequence {
    
    static var nextScreen: BaseViewController.Type? {
        switch currentScreen {

        case is GatewayConfigViewController:
            return TerminalTypeViewController.self

        case is TerminalTypeViewController: return nil // TODO:

        default: return nil
        }
    }

    static var currentScreen: UIViewController? {
        get { navigationController?.visibleViewController }
        set {
            guard let nextScreen = newValue else { return }
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }

    static var navigationController: UINavigationController? {
        (UIApplication.shared.delegate as?  AppDelegate)?
            .window?.rootViewController as? UINavigationController
    }

    static func changeTerminal() {
        currentScreen = TerminalTypeViewController.instantiate()
    }

    static func showNextScreen(with config: GatewayConfig? = nil,
                               for transaction: Transaction? = nil) {
        switch nextScreen {
        case let nextScreen as TakesConfig.Type where config != nil:
            currentScreen = nextScreen.instantiate(with: config!)

        case let nextScreen as TakesTransaction.Type where transaction != nil:
            currentScreen = nextScreen.instantiate(for: transaction!)

        default:
            currentScreen = nextScreen?.instantiate()
        }
    }

    static func startTransaction() {
        currentScreen = TransactionTypeSelectionViewController.instantiate()
    }

    static func navigateToOTAHelper() {
        currentScreen = OTAHelperViewController.instantiate()
    }

    static func navigateToTerminalSetting() {
        currentScreen = TerminalSettingsViewController.instantiate()
    }

    static func startConfiguration(for gateway: GatewayType) {
        guard let nextScreen = GatewayConfigViewController.instantiate() else { return }

        print("configuring \(gateway)")
        nextScreen.configure(for: gateway)

        navigationController?.pushViewController(nextScreen, animated: true)
    }

    static func startConfiguration(for gateway: GatewayConfig) {
        guard let nextScreen = GatewayConfigViewController.instantiate() else { return }

        print("configuring \(gateway)")
        nextScreen.configure(for: gateway)

        navigationController?.pushViewController(nextScreen, animated: true)
    }

    static func startTransaction(for transactionType: TransactionType, manualCardData: ManualCardData?, quickChipEnabled: Bool = true) {
        guard let nextScreen = TransactionViewController.instantiate() else {
                fatalError("we should have it")
        }
        nextScreen.manualCardData = manualCardData
        nextScreen.transactionType = transactionType
        nextScreen.quickChipEnabled = quickChipEnabled
        navigationController?.pushViewController(nextScreen, animated: true)
    }

    static func startTransaction(for transactionType: TransactionType) {
        guard let nextScreen = TransactionViewController.instantiate() else {
                fatalError("we should have it")
        }

        navigationController?.pushViewController(nextScreen, animated: true)
    }

    static func showTransactionResponse(for transactionResponse: TransactionResponse) {
        guard let nextScreen = TransactionResponseViewController.instantiate() else {
                fatalError("we should have it")
        }
        nextScreen.transactionResponse = transactionResponse
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}
