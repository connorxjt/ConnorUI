import SwiftUI
import UIKit

/// The visual tokens that give each app its personality while preserving a shared structure.
public struct ConnorTheme {
    public var id: String
    public var accent: Color
    public var accentBright: Color
    public var canvas: Color
    public var surface: Color
    public var raisedSurface: Color
    public var border: Color
    public var positive: Color
    public var warning: Color
    public var negative: Color
    public var cardRadius: CGFloat

    public init(
        id: String,
        accent: Color,
        accentBright: Color,
        canvas: Color = Color(uiColor: .systemGroupedBackground),
        surface: Color = Color(uiColor: .secondarySystemGroupedBackground),
        raisedSurface: Color = Color(uiColor: .tertiarySystemGroupedBackground),
        border: Color = Color(uiColor: .separator),
        positive: Color = .green,
        warning: Color = .orange,
        negative: Color = .red,
        cardRadius: CGFloat = ConnorRadius.large
    ) {
        self.id = id
        self.accent = accent
        self.accentBright = accentBright
        self.canvas = canvas
        self.surface = surface
        self.raisedSurface = raisedSurface
        self.border = border
        self.positive = positive
        self.warning = warning
        self.negative = negative
        self.cardRadius = cardRadius
    }

    public var brandGradient: LinearGradient {
        LinearGradient(
            colors: [accentBright, accent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

public extension ConnorTheme {
    static let trudget = ConnorTheme(
        id: "trudget",
        accent: Color(red: 0.05, green: 0.48, blue: 0.30),
        accentBright: Color(red: 0.14, green: 0.68, blue: 0.43),
        positive: Color(red: 0.08, green: 0.58, blue: 0.36)
    )

    static let sculpt = ConnorTheme(
        id: "sculpt",
        accent: Color(red: 0.39, green: 0.25, blue: 0.78),
        accentBright: Color(red: 0.56, green: 0.39, blue: 0.94),
        positive: Color(red: 0.17, green: 0.62, blue: 0.47)
    )

    static let pantry = ConnorTheme(
        id: "pantry",
        accent: Color(red: 0.77, green: 0.35, blue: 0.16),
        accentBright: Color(red: 0.96, green: 0.55, blue: 0.24),
        canvas: Color(
            uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor(red: 0.08, green: 0.07, blue: 0.06, alpha: 1)
                    : UIColor(red: 0.98, green: 0.96, blue: 0.92, alpha: 1)
            }
        ),
        surface: Color(
            uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor(red: 0.14, green: 0.12, blue: 0.10, alpha: 1)
                    : UIColor(red: 1.00, green: 0.99, blue: 0.97, alpha: 1)
            }
        )
    )

    static let fitCheck = ConnorTheme(
        id: "fit-check",
        accent: Color(red: 0.13, green: 0.30, blue: 0.61),
        accentBright: Color(red: 0.28, green: 0.51, blue: 0.87),
        positive: Color(red: 0.14, green: 0.55, blue: 0.44)
    )
}

private struct ConnorThemeKey: EnvironmentKey {
    static let defaultValue = ConnorTheme.trudget
}

public extension EnvironmentValues {
    var connorTheme: ConnorTheme {
        get { self[ConnorThemeKey.self] }
        set { self[ConnorThemeKey.self] = newValue }
    }
}

public extension View {
    /// Applies one ConnorUI theme to this view hierarchy.
    func connorTheme(_ theme: ConnorTheme) -> some View {
        environment(\.connorTheme, theme)
    }
}

