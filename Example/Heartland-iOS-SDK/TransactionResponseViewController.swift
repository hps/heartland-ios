//
//  TransactionResponseViewController.swift
//  Heartland-iOS-SDK
//

import Foundation
import UIKit
import GlobalMobileSDK

class TransactionResponseViewController: BaseViewController {

    var transactionResponse: TransactionResponse?
    // MARK: IBOutlets
    internal var currentTextField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private(set) weak var stackView: UIStackView! {
        didSet {
            guard let config = transactionResponse else { return }
            stackView.addTextFields(for: config, withLabels: true, delegate: self)
        }
    }

    override func viewDidLoad() {
        GMSManager.shared.transactionDelegate = self
        title = transactionResponse?.gatewayResponseText ?? transactionResponse?.transactionResult?.rawValue ?? "Unknown Error"
    }

    @IBAction func continuePressed(_ sender: UIButton) {
//        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }

    @IBAction func merchantReceiptPressed(_ sender: UIButton) {
        guard let config = transactionResponse, let message = config.merchantReceipt else { return }
        presentReceipt(with: message)
    }

    @IBAction func customerReceiptPressed(_ sender: UIButton) {
        guard let config = transactionResponse, let message = config.customerReceipt else { return }
        print("transactionResponse \(message)")
        presentReceipt(with: message)
    }

    private func presentReceipt(with message: String) {
        let alert = UIAlertController(title: "Receipt", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Send", style: .default) {_ in
            let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .phone {
                self.present(activityVC, animated: true)
            } else {
                if let popOver = activityVC.popoverPresentationController {
                    popOver.sourceRect = CGRect(x: UIScreen.main.bounds.height/2,
                                                y: UIScreen.main.bounds.width/2,
                                                width: 0,
                                                height: 0)
                    popOver.sourceView = self.view
                    popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        })
//        present(alert, animated: true, completion: nil)
    }
}

extension TransactionResponseViewController: StackViewTextFieldDelegate {

    func stopEditing() { currentTextField?.resignFirstResponder() }
    func advanceToNextTextField() { currentTextField?.advanceToNextTextField() }
    func advanceToPrevTextField() { currentTextField?.advanceToPrevTextField() }

    // ensure textField is visible above virtual keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {

        textField.didBeginEditing()

        var contentOffset = scrollView.contentOffset
        let frame = scrollView.convert(textField.frame,
                                       from: textField.superview)
        let topOffset = frame.minY - scrollView.contentOffset.y
        let bottomOffset = frame.maxY -
            (scrollView.contentOffset.y + scrollView.frame.height -
                (scrollView.contentSize.height - stackView.frame.height))

        if topOffset < 0 { contentOffset.y += topOffset }
        else if bottomOffset > 0 { contentOffset.y += bottomOffset }
        else { return }

        scrollView.setContentOffset(contentOffset, animated: true)
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .done: stopEditing()
        default: advanceToNextTextField()
        }
        return false
    }

    fileprivate func showMessage(_ message: String) {
        let block = {
            let alert = UIAlertController.init(title: "Message", message: "\(message)", preferredStyle: .alert)
            alert.addAction(.init(title: "ok", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        guard let presentedViewController = presentedViewController else {
            block()
            return
        }
//        presentedViewController.dismiss(animated: true, completion: block)
    }
}

extension TransactionResponseViewController: TransactionDelegate {

    func requestPostalCode(maskedPan: String,
                           expiryDate: String,
                           cardholderName: String?) {
        fatalError("It shouldn't get called here.")
    }

    func onState(state: TransactionState) {
        showMessage("\(state)")
        print("transactionsState status:  \(state)")
    }

    func requestAIDSelection(aids: [AID]) {

    }

    func requestAmountConfirmation(amount: Decimal?) {

    }

    func requestSaFApproval() {

    }

    func onTransactionComplete(result: TransactionResult, response: TransactionResponse?) {
        guard let response = response else {
            showMessage("\(result.rawValue)")

            return
        }
        print("onTransactionComplete \(response)")
//        ScreenSequence.showTransactionResponse(for: response)
    }

    func onTransactionCancelled() {
        showError(message: "Transaction was Cancelled.")
    }

    func onError(error: TransactionError) {
        showError(message: "\(error)")
    }
}
