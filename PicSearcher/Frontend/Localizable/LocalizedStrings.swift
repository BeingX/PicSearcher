
//
//  LocalizedStrings.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    static let DoneButtonTitle = NSLocalizedString("DoneButtonTitle", comment: "the title of done button")
    static let PrivacyUrl = NSLocalizedString("PrivacyUrl", comment: "the url of privacy policy")
    struct HomeView {
        static let SearchPlaceholder = NSLocalizedString("HomeView.SearchPlaceholder", comment: "SearchPlaceholder")
        static let TagHasNoPics = NSLocalizedString("HomeView.KeyWordHasNoPics", comment: "KeyWordHasNoPics")
        static let Title = NSLocalizedString("HomeView.Title", comment: "")
    }
    struct SettingsView {
        static let Title = NSLocalizedString("Settings.Title", comment: "")
        static let PrivacyTitle = NSLocalizedString("Settings.PrivacyTitle", comment: "")
        static let PrivacyPolicy = NSLocalizedString("Settings.PrivacyPolicy", comment: "")
        static let SupportTitle = NSLocalizedString("Settings.SupportTitle", comment: "")
        static let ShowTour = NSLocalizedString("Settings.ShowTour", comment: "")
        static let SendFeedback = NSLocalizedString("Settings.SendFeedback", comment: "")
        static let PrivacyUrlString = NSLocalizedString("PrivacyUrl", comment: "")
        static let NoEmailServiceToast = NSLocalizedString("Settings.NoEmailServiceToast", comment: "")
        static let ClearChche = NSLocalizedString("Settings.ClearChche", comment: "")
    }
}
