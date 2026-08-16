import SwiftUI

/// A reusable, StoreKit-independent support page.
///
/// Supply display tiers and an async purchase action. Use ``ConnorStoreKitSupportPage``
/// when the app should load its tiers directly from App Store Connect.
public struct ConnorSupportPage: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.connorTheme) private var theme

    @State private var interactionState: InteractionState = .idle

    private let configuration: ConnorSupportConfiguration
    private let tiers: [ConnorSupportTier]
    private let onPurchase: (ConnorSupportTier) async throws -> ConnorPurchaseOutcome
    private let onRestore: (() async throws -> Void)?

    public init(
        configuration: ConnorSupportConfiguration,
        tiers: [ConnorSupportTier],
        onPurchase: @escaping (ConnorSupportTier) async throws -> ConnorPurchaseOutcome,
        onRestore: (() async throws -> Void)? = nil
    ) {
        self.configuration = configuration
        self.tiers = tiers
        self.onPurchase = onPurchase
        self.onRestore = onRestore
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: ConnorSpacing.xLarge) {
                hero
                feedback

                if tiers.isEmpty {
                    unavailableState
                } else {
                    tierGrid
                }

                if let onRestore {
                    Button("Restore Purchases") {
                        Task { await restore(using: onRestore) }
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(theme.accent)
                    .disabled(isBusy)
                }

                Text("Purchases are processed securely by Apple.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)

                ConnorDeveloperCredit(configuration.developerCredit)
            }
            .padding(.horizontal, ConnorSpacing.large)
            .padding(.vertical, ConnorSpacing.xLarge)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(theme.canvas.ignoresSafeArea())
        .navigationTitle(configuration.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(spacing: ConnorSpacing.large) {
            Image(systemName: configuration.heroSymbolName)
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 92, height: 92)
                .background(theme.brandGradient, in: Circle())
                .shadow(color: theme.accent.opacity(0.28), radius: 14, y: 8)
                .accessibilityHidden(true)

            VStack(spacing: ConnorSpacing.small) {
                Text(configuration.title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text(configuration.message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: 560)
        }
    }

    private var tierGrid: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 145), spacing: ConnorSpacing.medium)],
            spacing: ConnorSpacing.medium
        ) {
            ForEach(tiers) { tier in
                Button {
                    Task { await purchase(tier) }
                } label: {
                    tierCard(tier)
                }
                .buttonStyle(ConnorTactileButtonStyle())
                .disabled(isBusy)
                .accessibilityHint("Purchases the \(tier.title) support option")
            }
        }
    }

    private func tierCard(_ tier: ConnorSupportTier) -> some View {
        ConnorSurface(
            style: interactionState.isPurchasing(tier.id) ? .accented : .raised,
            padding: ConnorSpacing.large
        ) {
            VStack(spacing: ConnorSpacing.medium) {
                Image(systemName: tier.symbolName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(theme.accent)
                    .frame(width: 48, height: 48)
                    .background(theme.accent.opacity(0.12), in: Circle())

                VStack(spacing: 4) {
                    Text(tier.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if let detail = tier.detail {
                        Text(detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }

                if interactionState.isPurchasing(tier.id) {
                    ProgressView()
                        .tint(theme.accent)
                        .frame(height: 24)
                } else {
                    Text(tier.displayPrice)
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(theme.accent)
                        .frame(height: 24)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 150)
        }
    }

    @ViewBuilder
    private var feedback: some View {
        switch interactionState {
        case .purchased:
            feedbackSurface(
                symbol: "checkmark.circle.fill",
                title: configuration.thankYouTitle,
                message: configuration.thankYouMessage,
                color: theme.positive
            )
        case .pending:
            feedbackSurface(
                symbol: "clock.fill",
                title: "Purchase Pending",
                message: "Apple is still processing this purchase.",
                color: theme.warning
            )
        case .restored:
            feedbackSurface(
                symbol: "arrow.clockwise.circle.fill",
                title: "Purchases Restored",
                message: "Your previous eligible purchases have been restored.",
                color: theme.positive
            )
        case .failed(let message):
            feedbackSurface(
                symbol: "exclamationmark.triangle.fill",
                title: "Something Went Wrong",
                message: message,
                color: theme.negative
            )
        case .idle, .purchasing, .restoring:
            EmptyView()
        }
    }

    private func feedbackSurface(
        symbol: String,
        title: String,
        message: String,
        color: Color
    ) -> some View {
        ConnorSurface(style: .standard, padding: ConnorSpacing.large) {
            HStack(alignment: .top, spacing: ConnorSpacing.medium) {
                Image(systemName: symbol)
                    .font(.title3)
                    .foregroundStyle(color)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)

                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private var unavailableState: some View {
        ContentUnavailableView(
            "Support Options Unavailable",
            systemImage: "heart.slash",
            description: Text("Please try again a little later.")
        )
        .frame(minHeight: 220)
    }

    private var isBusy: Bool {
        switch interactionState {
        case .purchasing, .restoring:
            true
        case .idle, .purchased, .pending, .restored, .failed:
            false
        }
    }

    @MainActor
    private func purchase(_ tier: ConnorSupportTier) async {
        withAnimation(feedbackAnimation) {
            interactionState = .purchasing(tier.id)
        }

        do {
            let outcome = try await onPurchase(tier)
            withAnimation(feedbackAnimation) {
                switch outcome {
                case .purchased:
                    interactionState = .purchased
                case .pending:
                    interactionState = .pending
                case .cancelled:
                    interactionState = .idle
                }
            }
        } catch {
            withAnimation(feedbackAnimation) {
                interactionState = .failed(error.localizedDescription)
            }
        }
    }

    @MainActor
    private func restore(using action: () async throws -> Void) async {
        withAnimation(feedbackAnimation) {
            interactionState = .restoring
        }

        do {
            try await action()
            withAnimation(feedbackAnimation) {
                interactionState = .restored
            }
        } catch {
            withAnimation(feedbackAnimation) {
                interactionState = .failed(error.localizedDescription)
            }
        }
    }

    private var feedbackAnimation: Animation? {
        reduceMotion ? nil : ConnorMotion.standard
    }
}

private enum InteractionState: Equatable {
    case idle
    case purchasing(String)
    case purchased
    case pending
    case restoring
    case restored
    case failed(String)

    func isPurchasing(_ tierID: String) -> Bool {
        self == .purchasing(tierID)
    }
}

