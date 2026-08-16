import SwiftUI

public enum ConnorSurfaceStyle: Equatable {
    case standard
    case raised
    case accented
}

/// A shared rounded surface for cards, settings callouts, and onboarding content.
public struct ConnorSurface<Content: View>: View {
    @Environment(\.connorTheme) private var theme

    private let style: ConnorSurfaceStyle
    private let padding: CGFloat
    private let content: Content

    public init(
        style: ConnorSurfaceStyle = .standard,
        padding: CGFloat = ConnorSpacing.large,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(fill, in: shape)
            .overlay {
                shape.stroke(border, lineWidth: 1)
            }
            .shadow(color: shadowColor, radius: shadowRadius, y: shadowY)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: theme.cardRadius, style: .continuous)
    }

    private var fill: Color {
        switch style {
        case .standard, .accented:
            theme.surface
        case .raised:
            theme.raisedSurface
        }
    }

    private var border: Color {
        switch style {
        case .accented:
            theme.accent.opacity(0.30)
        case .standard, .raised:
            theme.border.opacity(0.48)
        }
    }

    private var shadowColor: Color {
        style == .raised ? Color.black.opacity(0.09) : .clear
    }

    private var shadowRadius: CGFloat {
        style == .raised ? 12 : 0
    }

    private var shadowY: CGFloat {
        style == .raised ? 5 : 0
    }
}

