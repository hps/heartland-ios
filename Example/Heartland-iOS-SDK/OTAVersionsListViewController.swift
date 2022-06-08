//
//  OTAVersionsListViewController.swift
//  Heartland-iOS-SDK
//
//  Created by Rishil Patel on 2/4/22.
//  Copyright © 2022 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK
class OTAVersionsListViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet private(set) weak var versionListTableView: UITableView!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private(set) weak var loadingView: UIView! {
      didSet {
        loadingView.layer.cornerRadius = 10
      }
    }
    // MARK: Variables
    var setversionString = ""
    var delegate: SelectedVersionDelegate?
    var otaType: TerminalOTAUpdateType = .firmware
    private var versionsArray: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\(otaType) List".uppercased()
        versionListTableView.tableFooterView = UIView()
        showSpinner()
        GMSManager.shared.requestAvailableOTAVersionsListFor(type: otaType, delegate: self)
    }
    
    private func showSpinner() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }

    private func hideSpinner() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
}

extension OTAVersionsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return versionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OTAVersionCell") else {
            return UITableViewCell()
        }
        
        if let versionDictionary = versionsArray[indexPath.row] as? [String:String] {
            cell.textLabel?.text = (otaType == TerminalOTAUpdateType.config) ?
                versionDictionary["deviceSettingVersion"] :
                versionDictionary["firmwareVersion"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let versionDictionary = versionsArray[indexPath.row] as? [String:String] {
            let versionString = ((otaType == TerminalOTAUpdateType.config) ?
                                    versionDictionary["deviceSettingVersion"] :
                                    versionDictionary["firmwareVersion"]) ?? ""
            setversionString = versionString
            showSpinner()
            GMSManager.shared.setVersionDataFor(type: otaType, versionString: versionString, delegate: self)
        }
    }
}

extension OTAVersionsListViewController: TerminalOTAManagerDelegate {
    func otaUpdateProgress(percentage: Float) {}
    
    func terminalVersionDetails(info: [AnyHashable : Any]?) { }
    
    func terminalOTAResult(resultType: TerminalOTAResult, info: [String : AnyObject]?, error: Error?) {}
    
    func listOfVersionsFor(type: TerminalOTAUpdateType, results: [Any]?) {
        guard let versionResults = results, versionResults.count > 0 else {
            hideSpinner()
            showError(message: "Couldn't fetch data.")
            return
        }
        
        versionsArray = versionResults
        hideSpinner()
        versionListTableView.dataSource = self
        versionListTableView.delegate = self
        versionListTableView.reloadData()
    }
    
    func onReturnSetTargetVersion(resultType: TerminalOTAResult, type: TerminalOTAUpdateType, message: String) {
        hideSpinner()
        if resultType == .success {
            delegate?.selectedVersion(versionString: setversionString, type: otaType)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Set Version Failed", message: "\(message)", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.setversionString = ""
            })
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
