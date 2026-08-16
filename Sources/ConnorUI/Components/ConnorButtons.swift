import SwiftUI

/// A lightweight tactile response that can be applied to any custom button label.
public struct ConnorTactileButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(reduceMotion ? nil : ConnorMotion.tactile, value: configuration.isPressed)
    }
}

/// The shared high-emphasis action style used across Connor's apps.
public struct ConnorPrimaryButtonStyle: ButtonStyle {
    @Environment(\.connorTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    private let isLarge: Bool

    public init(isLarge: Bool = false) {
        self.isLarge = isLarge
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, ConnorSpacing.large)
            .frame(maxWidth: .infinity)
            .frame(height: isLarge ? ConnorControlSize.largeButtonHeight : ConnorControlSize.buttonHeight)
            .background(
                theme.brandGradient,
                in: RoundedRectangle(cornerRadius: ConnorRadius.medium, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: ConnorRadius.medium, style: .continuous)
                    .stroke(.white.opacity(0.18), lineWidth: 1)
            }
            .shadow(
                color: theme.accent.opacity(configuration.isPressed ? 0.10 : 0.24),
                radius: configuration.isPressed ? 3 : 8,
                y: configuration.isPressed ? 2 : 5
            )
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.975 : 1)
            .opacity(isEnabled ? (configuration.isPressed ? 0.90 : 1) : 0.48)
            .animation(reduceMotion ? nil : ConnorMotion.tactile, value: configuration.isPressed)
    }
}

/// A quieter action style that keeps the same sizing and tactile response.
public struct ConnorSecondaryButtonStyle: ButtonStyle {
    @Environment(\.connorTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(theme.accent)
            .padding(.horizontal, ConnorSpacing.large)
            .frame(maxWidth: .infinity)
            .frame(height: ConnorControlSize.buttonHeight)
            .background(
                theme.surface,
                in: RoundedRectangle(cornerRadius: ConnorRadius.medium, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: ConnorRadius.medium, style: .continuous)
                    .stroke(theme.border.opacity(0.65), lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.975 : 1)
            .opacity(isEnabled ? (configuration.isPressed ? 0.78 : 1) : 0.48)
            .animation(reduceMotion ? nil : ConnorMotion.tactile, value: configuration.isPressed)
    }
}

