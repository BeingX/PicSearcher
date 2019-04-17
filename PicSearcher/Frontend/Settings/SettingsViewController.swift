//
//  SettingsViewController.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/12.
//  Copyright © 2019 xingxing. All rights reserved.
//
import UIKit
import MessageUI
import ToastSwiftFramework
import PKHUD

public struct SettingsItem {
    public fileprivate(set) var title: String
    public fileprivate(set) var text: String?
    public fileprivate(set) var detailText: String?
    public fileprivate(set) var iconString: String?
    public fileprivate(set) var accessoryType: UITableViewCell.AccessoryType = .none
    public fileprivate(set) var handler: ((SettingsItem) -> Void)?
}

struct SettingsStrings {
    static let Title = LocalizedStrings.SettingsView.Title
    static let DoneButtonTitle = LocalizedStrings.DoneButtonTitle
    static let CellName = "SettingsViewController.UITableViewCell"
    static let PrivacyTitle = LocalizedStrings.SettingsView.PrivacyTitle
    static let PrivacyPolicy = LocalizedStrings.SettingsView.PrivacyPolicy
    static let SupportTitle = LocalizedStrings.SettingsView.SupportTitle
    static let ShowTour = LocalizedStrings.SettingsView.ShowTour
    static let SendFeedback = LocalizedStrings.SettingsView.SendFeedback
    static let PrivacyUrlString = LocalizedStrings.SettingsView.PrivacyUrlString
    static let NoEmailServiceToast = LocalizedStrings.SettingsView.NoEmailServiceToast
    static let ClearCache = LocalizedStrings.SettingsView.ClearChche
}

class SettingsViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = HomeViewUX.BackgroundColor
        return tableView
    }()
    var groups = [[SettingsItem]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.White100
        self.navigationItem.title = SettingsStrings.Title
        self.setDoneButton()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.updateSettingsItems()
    }
    
    func updateSettingsItems() {
        let privacyPolicyItem = SettingsItem(title: SettingsStrings.PrivacyTitle, text: SettingsStrings.PrivacyPolicy, detailText: nil, iconString: "privacy", accessoryType: .disclosureIndicator, handler: {[weak self] item in
            if let languageCode = Locale.current.languageCode, languageCode.contains("zh"),
                let url = Bundle.main.url(forResource: "privacy_zh", withExtension: "html"),
                let html = try? String(contentsOf: url) {
                let webVc = WebViewController(htmlString: html)
                self?.navigationController?.pushViewController(webVc, animated: true)
            } else {
                let webVc = WebViewController(urlString: SettingsStrings.PrivacyUrlString)
                self?.navigationController?.pushViewController(webVc, animated: true)
            }
            
        })
        let showTourItem = SettingsItem(title: SettingsStrings.SupportTitle, text: SettingsStrings.ShowTour, detailText: nil, iconString: "showtour", accessoryType: .none, handler: { item in
            
        })
        let feedbackItem = SettingsItem(title: SettingsStrings.SupportTitle, text: SettingsStrings.SendFeedback, detailText: nil, iconString: "feedback", accessoryType: .none, handler: {[weak self] item in
            self?.sendEmail()
        })
        let cacheDirSize = FileManager.default.cachesDirectoryFileSize()
        let clearCacheItem = SettingsItem(title: SettingsStrings.SupportTitle, text: SettingsStrings.ClearCache, detailText: cacheDirSize, iconString: "clearCache", accessoryType: .none, handler: {[weak self] item in
            FileManager.default.clearCachesDirectory()
            self?.updateSettingsItems()
            HUD.flash(.success, delay: 1.0)
        })
        groups.removeAll()
        groups.append([privacyPolicyItem])
        groups.append([showTourItem, feedbackItem, clearCacheItem])
        tableView.reloadData()
    }
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["yinxing_cb@163.com"])
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
            self.view.makeToast(SettingsStrings.NoEmailServiceToast, duration: 3.0, position: .center)
        }
    }
    
    func setDoneButton() {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        button.setTitle(SettingsStrings.DoneButtonTitle, for: .normal)
        button.setTitleColor(UIConstants.systemColor, for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = groups[section]
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SettingsStrings.CellName)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: SettingsStrings.CellName)
        }
        let items = groups[indexPath.section]
        let item = items[indexPath.row]
        cell?.textLabel?.text = item.text
        if let icon = item.iconString {
            cell?.imageView?.image = UIImage(named: icon)
        }
        cell?.detailTextLabel?.text = item.detailText
        cell?.accessoryType = item.accessoryType
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let items = groups[indexPath.section]
        let item = items[indexPath.row]
        if let handler = item.handler {
            handler(item)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let items = groups[section]
        let item = items.first
        return item?.title
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

