//
//  BaseViewController.swift
//  Heartland-iOS-SDK
//

import UIKit

protocol Enableable {
    var isEnabled: Bool { get }
}

extension CGFloat {
    static var cornerRadius: CGFloat { 3 }
}

protocol StoryboardViewController { }

extension StoryboardViewController {
    static var storyboardName: String { "Main" }
    static var storyboardBundle: Bundle? { nil }
    static var storyboardIdentifier: String { String(describing: self) }

    static func instantiate() -> Self? {
        return UIStoryboard(name: storyboardName, bundle: storyboardBundle)
            .instantiateViewController(withIdentifier: storyboardIdentifier) as? Self
    }
}

class BaseViewController: UIViewController, StoryboardViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.subviews.forEach {
            ($0 as? UIButton)?.layer.cornerRadius = .cornerRadius
        }
    }

    @IBAction func showNextScreen() { ScreenSequence.showNextScreen() }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .portrait : .all
    }
}

class StackViewBasedTextFieldViewController: BaseViewController {
    
    private var scrollView: UIScrollView! {
        stackView.superview as? UIScrollView
    }
    internal var currentTextField: UITextField?
    
    @IBOutlet weak var stackView: UIStackView!

    var textFieldValues: [String: String] { stackView.textFieldValues }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardChanged(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }

    /// add/remove extra padding to scrollView.contentSize so everything can be viewed
    @objc func keyboardChanged(_ notification: Notification) {

        guard let frameInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
              let keyboardFrame = (frameInfo as? NSValue)?.cgRectValue else { return }

        UIView.animate(withDuration: 0.3) {
            if keyboardFrame.minY > self.scrollView.frame.maxY {
                self.scrollView.contentSize.height = self.stackView.frame.height
            }
            else
            {
                let offset = self.scrollView.frame.maxY - keyboardFrame.minY

                if offset > 0 {
                    self.scrollView.contentSize.height = self.stackView.frame.height + offset
                    if let textField = self.currentTextField { self.textFieldDidBeginEditing(textField) }
                }
            }
        }
    }
}

extension StackViewBasedTextFieldViewController: StackViewTextFieldDelegate {

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
}
