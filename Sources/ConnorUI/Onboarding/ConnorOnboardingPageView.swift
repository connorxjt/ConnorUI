import SwiftUI

/// The standard branded content layout used inside ``ConnorOnboardingFlow``.
public struct ConnorOnboardingPageView: View {
    @Environment(\.connorTheme) private var theme
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private let page: ConnorOnboardingPage

    public init(page: ConnorOnboardingPage) {
        self.page = page
    }

    public var body: some View {
        VStack(spacing: compactHeight ? ConnorSpacing.large : ConnorSpacing.xLarge) {
            Spacer(minLength: compactHeight ? ConnorSpacing.small : ConnorSpacing.large)

            hero

            VStack(spacing: ConnorSpacing.medium) {
                if let eyebrow = page.eyebrow {
                    Text(eyebrow.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(1.1)
                        .foregroundStyle(accent)
                }

                Text(page.title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)

                Text(page.message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: 560)

            if !page.features.isEmpty {
                ConnorSurface(style: .standard, padding: ConnorSpacing.large) {
                    VStack(spacing: ConnorSpacing.large) {
                        ForEach(page.features) { feature in
                            ConnorOnboardingFeatureRow(feature: feature, accent: accent)
                        }
                    }
                }
                .frame(maxWidth: 560)
            }

            Spacer(minLength: ConnorSpacing.small)
        }
        .padding(.horizontal, ConnorSpacing.xLarge)
        .padding(.vertical, ConnorSpacing.small)
        .frame(maxWidth: .infinity)
    }

    private var compactHeight: Bool {
        verticalSizeClass == .compact
    }

    private var accent: Color {
        page.accent ?? theme.accent
    }

    private var hero: some View {
        let size: CGFloat = compactHeight ? 88 : 132

        return ZStack {
            Circle()
                .fill(accent.opacity(0.12))

            Circle()
                .stroke(accent.opacity(0.18), lineWidth: 1)
                .padding(7)

            Image(systemName: page.symbolName)
                .font(.system(size: compactHeight ? 36 : 52, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size * 0.68, height: size * 0.68)
                .background(
                    LinearGradient(
                        colors: [accent.opacity(0.72), accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: Circle()
                )
                .shadow(color: accent.opacity(0.28), radius: 12, y: 7)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

/// A reusable supporting row for standard onboarding pages.
public struct ConnorOnboardingFeatureRow: View {
    private let feature: ConnorOnboardingFeature
    private let accent: Color

    public init(feature: ConnorOnboardingFeature, accent: Color) {
        self.feature = feature
        self.accent = accent
    }

    public var body: some View {
        HStack(alignment: .top, spacing: ConnorSpacing.medium) {
            Image(systemName: feature.symbolName)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 34, height: 34)
                .background(accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(feature.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                if let detail = feature.detail {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

