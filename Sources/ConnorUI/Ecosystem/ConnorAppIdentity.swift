import Foundation
import SwiftUI

public enum ConnorAppID: String, CaseIterable, Identifiable {
    case trudget
    case sculpt
    case pantry
    case fitCheck

    public var id: String { rawValue }
}

public enum ConnorAppStatus: Equatable {
    case available
    case comingSoon
}

/// The centralized name, copy, color, and destination used to feature one app in another.
public struct ConnorAppIdentity: Identifiable {
    public var id: ConnorAppID
    public var name: String
    public var tagline: String
    public var symbolName: String
    public var primaryColor: Color
    public var secondaryColor: Color
    public var status: ConnorAppStatus
    public var appStoreURL: URL?

    public init(
        id: ConnorAppID,
        name: String,
        tagline: String,
        symbolName: String,
        primaryColor: Color,
        secondaryColor: Color,
        status: ConnorAppStatus,
        appStoreURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.symbolName = symbolName
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.status = status
        self.appStoreURL = appStoreURL
    }
}

/// The single source of truth for ecosystem presentation. Update destinations here as apps ship.
public enum ConnorAppCatalog {
    public static let trudget = ConnorAppIdentity(
        id: .trudget,
        name: "Trudget",
        tagline: "See your money clearly.",
        symbolName: "chart.bar.doc.horizontal.fill",
        primaryColor: ConnorTheme.trudget.accent,
        secondaryColor: ConnorTheme.trudget.accentBright,
        status: .available,
        appStoreURL: URL(string: "https://apps.apple.com/app/id6754862657")
    )

    public static let sculpt = ConnorAppIdentity(
        id: .sculpt,
        name: "Sculpt",
        tagline: "Train. Tap. Done.",
        symbolName: "dumbbell.fill",
        primaryColor: ConnorTheme.sculpt.accent,
        secondaryColor: ConnorTheme.sculpt.accentBright,
        status: .available
    )

    public static let pantry = ConnorAppIdentity(
        id: .pantry,
        name: "Pantry",
        tagline: "Plan meals around what you have.",
        symbolName: "fork.knife",
        primaryColor: ConnorTheme.pantry.accent,
        secondaryColor: ConnorTheme.pantry.accentBright,
        status: .comingSoon
    )

    public static let fitCheck = ConnorAppIdentity(
        id: .fitCheck,
        name: "Fit Check",
        tagline: "Build outfits from what you own.",
        symbolName: "tshirt.fill",
        primaryColor: ConnorTheme.fitCheck.accent,
        secondaryColor: ConnorTheme.fitCheck.accentBright,
        status: .comingSoon
    )

    public static let all: [ConnorAppIdentity] = [trudget, sculpt, pantry, fitCheck]

    private init() {}
}

