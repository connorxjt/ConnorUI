import Foundation

/// App-specific copy and StoreKit identifiers for a shared ConnorUI support page.
public struct ConnorSupportConfiguration {
    public var appName: String
    public var title: String
    public var message: String
    public var heroSymbolName: String
    public var thankYouTitle: String
    public var thankYouMessage: String
    public var developerCredit: String
    public var productIdentifiers: [String]
    public var productSymbols: [String: String]
    public var showsRestorePurchases: Bool

    public init(
        appName: String,
        title: String? = nil,
        message: String = "If this app has been useful, you can leave a small tip to support its continued development.",
        heroSymbolName: String = "heart.fill",
        thankYouTitle: String = "Thank you!",
        thankYouMessage: String = "Your support helps keep thoughtful independent apps moving forward.",
        developerCredit: String = "Made with care by Connor",
        productIdentifiers: [String] = [],
        productSymbols: [String: String] = [:],
        showsRestorePurchases: Bool = false
    ) {
        self.appName = appName
        self.title = title ?? "Support \(appName)"
        self.message = message
        self.heroSymbolName = heroSymbolName
        self.thankYouTitle = thankYouTitle
        self.thankYouMessage = thankYouMessage
        self.developerCredit = developerCredit
        self.productIdentifiers = productIdentifiers
        self.productSymbols = productSymbols
        self.showsRestorePurchases = showsRestorePurchases
    }
}

/// Display information for one support option.
public struct ConnorSupportTier: Identifiable {
    public var id: String
    public var title: String
    public var detail: String?
    public var displayPrice: String
    public var symbolName: String

    public init(
        id: String,
        title: String,
        detail: String? = nil,
        displayPrice: String,
        symbolName: String = "heart.fill"
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.displayPrice = displayPrice
        self.symbolName = symbolName
    }
}

/// The meaningful outcomes ConnorUI presents after an attempted purchase.
public enum ConnorPurchaseOutcome: Equatable {
    case purchased
    case pending
    case cancelled
}

