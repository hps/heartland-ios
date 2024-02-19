//
//
//  TapToPayHostedViewController.swift
//  Heartland-iOS-SDK-SampleApp
//
    

import Foundation
import SwiftUI
import Heartland_iOS_SDK

class TapToPayHostedViewController: UIViewController {
    let tapToPay = TapToPay()
    var contentView: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView = tapToPay.tapToPayViewController()
        
        addChild(self.contentView!)
        view.addSubview(self.contentView!.view)
        setupConstraints()
    }
    
    func setupConstraints() {
        guard let contentView else { return }
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
