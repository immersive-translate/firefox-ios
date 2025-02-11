// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Shared


private class BundleClass {
    public static let bundle = Bundle(for: BundleClass.self)
}

private func MZLocalizedString(
    key: String,
    tableName: String?,
    value: String?,
    comment: String
) -> String {
    return NSLocalizedString(key,
                             tableName: tableName,
                             bundle: BundleClass.bundle,
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
        
        public struct IAP {
            public static let save = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Save",
                tableName: "IMSAccount",
                value: "Save",
                comment: "")
            
            public static let yearPro = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.YearPro",
                tableName: "IMSAccount",
                value: "Annual Membership",
                comment: "")
            
            public static let month = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Month",
                tableName: "IMSAccount",
                value: "Month",
                comment: "")
            
            public static let year = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Year",
                tableName: "IMSAccount",
                value: "Year",
                comment: "")
            
            public static let proExclusiveAITranslation = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Pro-exclusive world-class AI translation service",
                tableName: "IMSAccount",
                value: "Pro-exclusive world-class AI translation service",
                comment: "")
            
            public static let deeplTranslation = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.DeepL Translation",
                tableName: "IMSAccount",
                value: "DeepL Translation",
                comment: "")
            
            public static let openAITranslation = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.OpenAI Translation",
                tableName: "IMSAccount",
                value: "OpenAI Translation",
                comment: "")
            
            public static let claudeTranslation = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Claude Translation",
                tableName: "IMSAccount",
                value: "Claude Translation",
                comment: "")
            
            public static let geminiTranslation = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Gemini Translation",
                tableName: "IMSAccount",
                value: "Gemini Translation",
                comment: "")
            
            public static let proExclusiveFeatures = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Pro-exclusive advanced features",
                tableName: "IMSAccount",
                value: "Pro-exclusive advanced features",
                comment: "")
            
            public static let pdfPro = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.PDF Pro",
                tableName: "IMSAccount",
                value: "PDF Pro",
                comment: "")
            
            public static let mangaTranslation = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Manga Translation",
                tableName: "IMSAccount",
                value: "Manga Translation",
                comment: "")
            
            public static let youtubeBilingualSubtitle = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Youtube Bilingual Subtitle Download",
                tableName: "IMSAccount",
                value: "Youtube Bilingual Subtitle Download",
                comment: "")
            
            public static let multiDeviceSync = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Multi-device sync configuration",
                tableName: "IMSAccount",
                value: "Multi-device sync configuration",
                comment: "")
            
            public static let priorityEmailSupport = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Priority email support",
                tableName: "IMSAccount",
                value: "Priority email support",
                comment: "")
            
            public static let consecutiveAnnualSubscription = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Consecutive annual subscription",
                tableName: "IMSAccount",
                value: "Consecutive annual subscription",
                comment: "")
            
            public static let consecutiveMonthlySubscription = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Consecutive monthly subscription",
                tableName: "IMSAccount",
                value: "Consecutive monthly subscription",
                comment: "")
            
            public static let subscribeNow = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Subscribe now",
                tableName: "IMSAccount",
                value: "Subscribe now",
                comment: "")
            
            public static let monthlyProMembership = MZLocalizedString(
                key: "Settings.IMSAccount.IAP.Monthly Pro Membership",
                tableName: "IMSAccount",
                value: "Monthly Pro Membership",
                comment: "")
            
            public static let limitedTimeOffer = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.Limited Time Offer",
                            tableName: "IMSAccount",
                            value: "Limited Time Offer",
                            comment: "")
            
            public static let confirm = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.Aler Confirm",
                            tableName: "IMSAccount",
                            value: "OK",
                            comment: "")
            
            public static let subscriptionSuccess = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.You have successfully subscribed",
                            tableName: "IMSAccount",
                            value: "You have successfully subscribed",
                            comment: "")
            
            public static let subscriptionFail = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.You have fail subscribed",
                            tableName: "IMSAccount",
                            value: "You have fail subscribed",
                            comment: "")
            
            
            public static let upgradetoAnnualProMembership = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.Upgrade to Annual Pro Membership",
                            tableName: "IMSAccount",
                            value: "Upgrade to Annual Pro Membership",
                            comment: "")
            
            public static let theAnnualPlanSaves = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.The annual plan saves",
                            tableName: "IMSAccount",
                            value: "The annual plan saves %@ per year compared to the monthly plan",
                            comment: "")
            
            public static let upgradingNowWillAutomaticallyDeduct = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.Upgrading now will automatically deduct",
                            tableName: "IMSAccount",
                            value: "Upgrading now will automatically deduct %@ immediately (the unused time of the current package has been deducted in proportion)",
                            comment: "")
            
            
            public static let theUnusedTimeOfTheCurrentPackage = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.the unused time of the current package",
                            tableName: "IMSAccount",
                            value: "(the unused time of the current package has been deducted in proportion)",
                            comment: "")
          
            public static let newExpirationDate = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.New expiration date",
                            tableName: "IMSAccount",
                            value: "New expiration date is %@",
                            comment: "")
           
            public static let upgradeNow  = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.Upgrade Now",
                            tableName: "IMSAccount",
                            value: "Upgrade Now",
                            comment: "")
           
            
             public static let Cancel = MZLocalizedString(
                             key: "Settings.IMSAccount.IAP.Cancel",
                             tableName: "IMSAccount",
                             value: "Cancel",
                             comment: "")
          
            public static let currentPlan = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.Current Plan",
                            tableName: "IMSAccount",
                            value: "currentPlan",
                            comment: "")
           
            public static let downgradingIsNotSupported = MZLocalizedString(
                            key: "Settings.IMSAccount.IAP.Downgrading is not supported",
                            tableName: "IMSAccount",
                            value: "downgradingIsNotSupported",
                            comment: "")
        }
    }
}
