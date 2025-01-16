// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Shared

private func MZLocalizedString(
    key: String,
    tableName: String?,
    value: String?,
    comment: String
) -> String {
    return NSLocalizedString(key,
                             tableName: tableName,
                             bundle: Strings.bundle,
                             value: value ?? "",
                             comment: comment)
}

// MARK: - Imt Strings
extension String {
    public static let ImtLocalizableAppInfo = MZLocalizedString(
        key: "Imt.Localizable.App.Info",
        tableName: "Imt",
        value: "Immersive Translate Browser is a customized product developed independently by Immersive Translate team, based on the technology of the Firefox browser, an open-source project by Mozilla.",
        comment: "")
    
    public static let ImtLocalizableVersion = MZLocalizedString(
        key: "Imt.Localizable.Version",
        tableName: "Imt",
        value: "Version",
        comment: "")
    
    public static let ImtLocalizableApp = MZLocalizedString(
        key: "Imt.Localizable.App",
        tableName: "Imt",
        value: "App",
        comment: "")
    
    public static let ImtLocalizableReminder = MZLocalizedString(
        key: "Imt.Localizable.Reminder",
        tableName: "Imt",
        value: "Reminder",
        comment: "")
    
    public static let ImtLocalizableUserAgreement = MZLocalizedString(
        key: "Imt.Localizable.User.Agreement",
        tableName: "Imt",
        value: "\"User Agreement\"",
        comment: "")
    
    public static let ImtLocalizableUserAgreementTitle = MZLocalizedString(
        key: "Imt.Localizable.User.Agreement.Title",
        tableName: "Imt",
        value: "User Agreement",
        comment: "")
    
    public static let ImtLocalizablePrivacyPolicy = MZLocalizedString(
        key: "Imt.Localizable.App.Privacy.Policy",
        tableName: "Imt",
        value: "\"Immersive Translation Browser Privacy Policy\"",
        comment: "")
    
    public static let ImtLocalizablePrivacyPolicyTitle = MZLocalizedString(
        key: "Imt.Localizable.App.Privacy.Policy.Title",
        tableName: "Imt",
        value: "Privacy Policy",
        comment: "")
    
    public static let ImtLocalizableReminderPre = MZLocalizedString(
        key: "Imt.Localizable.Reminder.Pre",
        tableName: "Imt",
        value: "Welcome to Immersive Translation. Before using Immersive Translation, please carefully read the",
        comment: "")
    
    public static let ImtLocalizableReminderMiddle = MZLocalizedString(
        key: "Imt.Localizable.Reminder.Middle",
        tableName: "Imt",
        value: "and",
        comment: "")
    
    public static let ImtLocalizableReminderPost = MZLocalizedString(
        key: "Imt.Localizable.Reminder.Post",
        tableName: "Imt",
        value: ". According to the \"Regulations on the Scope of Necessary Personal Information for Common Types of Mobile Internet Applications\", the main functions of Immersive Translation are website browsing, search, file processing, file management, etc. The extended functions include Immersive Translation account, etc. Agreeing to the basic functions privacy policy only means agreeing to the collection and processing of relevant necessary information when using main functions such as website browsing, search, file processing, and file management. The collection of personal information by extended functions such as immersive translation accounts will be separately solicited from you when you use specific functions.",
        comment: "")
    
    public static let ImtLocalizableReminderDisagree = MZLocalizedString(
        key: "Imt.Localizable.Reminder.Disagree",
        tableName: "Imt",
        value: "Disagree",
        comment: "")
    
    public static let ImtLocalizableReminderAgree = MZLocalizedString(
        key: "Imt.Localizable.Reminder.Agree",
        tableName: "Imt",
        value: "Agree",
        comment: "")
    
    public static let ImtLocalizableReminderNeedAgree = MZLocalizedString(
        key: "Imt.Localizable.Reminder.Need.Agree",
        tableName: "Imt",
        value: "This product needs to agree to the relevant agreement before it can be used.",
        comment: "")
    
    public static let ImtLocalizableReminderQuitApp = MZLocalizedString(
        key: "Imt.Localizable.Reminder.Quit.App",
        tableName: "Imt",
        value: "Quit APP",
        comment: "")
    
    public static let ImtLocalizableReminderISee = MZLocalizedString(
        key: "Imt.Localizable.Reminder.I.See",
        tableName: "Imt",
        value: "I see",
        comment: "")
    
    
    public static let ImtLocalizableIntroDefaultBrowser = MZLocalizedString(
        key: "Imt.Localizable.Intro.Default.Browser",
        tableName: "Imt",
        value: "Set Immersive Translate as your default browser",
        comment: "")
    
    public static let ImtLocalizableIntroAutoTranslated = MZLocalizedString(
        key: "Imt.Localizable.Intro.Auto.Translated",
        tableName: "Imt",
        value: "Any foreign language webpage is opened by default with the immersive translation browser and automatically translated; \nSearch results are automatically translated into the native language.",
        comment: "")
    
    public static let ImtLocalizableIntroNativeLanguage = MZLocalizedString(
        key: "Imt.Localizable.Intro.Native.language",
        tableName: "Imt",
        value: "Your native language",
        comment: "")
    
    public static let ImtLocalizableIntroSetDefaultBrowser = MZLocalizedString(
        key: "Imt.Localizable.Intro.Set.Default.Browser",
        tableName: "Imt",
        value: "Set as default browser",
        comment: "")
    
    public static let ImtLocalizableIntroSetLater = MZLocalizedString(
        key: "Imt.Localizable.Intro.Set.Later",
        tableName: "Imt",
        value: "Set up later",
        comment: "")
    
    public static let ImtLocalizableIntroAccessibleReading = MZLocalizedString(
        key: "Imt.Localizable.Intro.Accessible.Reading",
        tableName: "Imt",
        value: "Accessible reading of foreign language content",
        comment: "")
    
    public static let ImtLocalizableIntroWebPage = MZLocalizedString(
        key: "Imt.Localizable.Intro.Web.page",
        tableName: "Imt",
        value: "Web page",
        comment: "")
    
    public static let ImtLocalizableIntroVideo = MZLocalizedString(
        key: "Imt.Localizable.Intro.Video",
        tableName: "Imt",
        value: "Video",
        comment: "")
    
    public static let ImtLocalizableIntroDocument = MZLocalizedString(
        key: "Imt.Localizable.Intro.Document",
        tableName: "Imt",
        value: "Document",
        comment: "")
    
    public static let ImtLocalizableIntroAllTranslated = MZLocalizedString(
        key: "Imt.Localizable.Intro.All.Translated",
        tableName: "Imt",
        value: "All translated with one click, \nmaking reading hassle-free!",
        comment: "")
    
    public static let ImtLocalizableIntroBiggerWorld = MZLocalizedString(
        key: "Imt.Localizable.Intro.Bigger.World",
        tableName: "Imt",
        value: "Eliminate language barriers\nSee a bigger world",
        comment: "")
    
    public static let ImtLocalizableIntroBreakBarriers = MZLocalizedString(
        key: "Imt.Localizable.Intro.Break.Barriers",
        tableName: "Imt",
        value: "Break language barriers!",
        comment: "")
    
    public static let ImtLocalizableWebTranslation = MZLocalizedString(
        key: "Imt.Localizable.Web.Translation",
        tableName: "Imt",
        value: "Web translation",
        comment: "")
    
    public static let ImtLocalizableVideoTranslation = MZLocalizedString(
        key: "Imt.Localizable.Video.Translation",
        tableName: "Imt",
        value: "Video translation",
        comment: "")
    
    public static let ImtLocalizableDocTranslation = MZLocalizedString(
        key: "Imt.Localizable.Doc.Translation",
        tableName: "Imt",
        value: "Doc translation",
        comment: "")
    
    public static let ImtLocalizableComicTranslation = MZLocalizedString(
        key: "Imt.Localizable.Comic.Translation",
        tableName: "Imt",
        value: "Comic translation",
        comment: "")
    
    public static let ImtLocalizableXiaohongshuTranslation = MZLocalizedString(
        key: "Imt.Localizable.Xiaohongshu.Translation",
        tableName: "Imt",
        value: "Comic translation",
        comment: "")
    
    public static let ImtLocalizableXiaohongshu = MZLocalizedString(
        key: "Imt.Localizable.Xiaohongshu",
        tableName: "Imt",
        value: "Comic translation",
        comment: "")
}


extension String {
    public struct IMS {
        public struct Settings {
            public static let Upgrade = MZLocalizedString(
                key: "Settings.IMSAccount.Upgrade.Title",
                tableName: "IMSAccount",
                value: "Upgrade",
                comment: "")
        }
    }
}
