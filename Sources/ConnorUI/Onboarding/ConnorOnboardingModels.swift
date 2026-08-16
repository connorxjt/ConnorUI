import Foundation
import SwiftUI

/// One supporting point displayed beneath a standard onboarding page.
public struct ConnorOnboardingFeature: Identifiable {
    public var id: UUID
    public var symbolName: String
    public var title: String
    public var detail: String?

    public init(
        id: UUID = UUID(),
        symbolName: String,
        title: String,
        detail: String? = nil
    ) {
        self.id = id
        self.symbolName = symbolName
        self.title = title
        self.detail = detail
    }
}

/// Content for ConnorUI's standard onboarding presentation.
public struct ConnorOnboardingPage: Identifiable {
    public var id: UUID
    public var eyebrow: String?
    public var title: String
    public var message: String
    public var symbolName: String
    public var accent: Color?
    public var features: [ConnorOnboardingFeature]

    public init(
        id: UUID = UUID(),
        eyebrow: String? = nil,
        title: String,
        message: String,
        symbolName: String,
        accent: Color? = nil,
        features: [ConnorOnboardingFeature] = []
    ) {
        self.id = id
        self.eyebrow = eyebrow
        self.title = title
        self.message = message
        self.symbolName = symbolName
        self.accent = accent
        self.features = features
    }
}

/// Shared button copy for an onboarding flow. Apps can replace any label when needed.
public struct ConnorOnboardingStrings: Equatable {
    public var back: String
    public var skip: String
    public var next: String
    public var getStarted: String

    public init(
        back: String = "Back",
        skip: String = "Skip",
        next: String = "Continue",
        getStarted: String = "Get Started"
    ) {
        self.back = back
        self.skip = skip
        self.next = next
        self.getStarted = getStarted
    }
}

