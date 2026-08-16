import StoreKit
import SwiftUI

/// A StoreKit-backed support page that loads localized products from App Store Connect.
public struct ConnorStoreKitSupportPage: View {
    @Environment(\.connorTheme) private var theme

    @State private var products: [Product] = []
    @State private var loadState: ProductLoadState = .idle

    private let configuration: ConnorSupportConfiguration

    public init(configuration: ConnorSupportConfiguration) {
        self.configuration = configuration
    }

    public var body: some View {
        Group {
            switch loadState {
            case .idle, .loading:
                loadingView
            case .loaded:
                supportPage
            case .failed(let message):
                failureView(message)
            }
        }
        .background(theme.canvas.ignoresSafeArea())
        .navigationTitle(configuration.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard loadState == .idle else { return }
            await loadProducts()
        }
    }

    private var supportPage: some View {
        ConnorSupportPage(
            configuration: configuration,
            tiers: products.map(makeTier),
            onPurchase: purchase,
            onRestore: configuration.showsRestorePurchases ? restorePurchases : nil
        )
    }

    private var loadingView: some View {
        VStack(spacing: ConnorSpacing.large) {
            ProgressView()
                .controlSize(.large)
                .tint(theme.accent)

            Text("Loading support optionsâ€¦")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func failureView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Unable to Load Support Options", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                Task { await loadProducts() }
            }
            .buttonStyle(ConnorPrimaryButtonStyle())
            .frame(maxWidth: 320)
        }
        .padding()
    }

    @MainActor
    private func loadProducts() async {
        loadState = .loading

        do {
            let loadedProducts = try await Product.products(for: configuration.productIdentifiers)
            products = loadedProducts.sorted { $0.price < $1.price }
            loadState = .loaded
        } catch {
            loadState = .failed(error.localizedDescription)
        }
    }

    private func makeTier(_ product: Product) -> ConnorSupportTier {
        ConnorSupportTier(
            id: product.id,
            title: product.displayName,
            detail: product.description.isEmpty ? nil : product.description,
            displayPrice: product.displayPrice,
            symbolName: configuration.productSymbols[product.id] ?? "heart.fill"
        )
    }

    private func purchase(_ tier: ConnorSupportTier) async throws -> ConnorPurchaseOutcome {
        guard let product = products.first(where: { $0.id == tier.id }) else {
            throw ConnorStoreKitSupportError.productUnavailable
        }

        switch try await product.purchase() {
        case .success(let verification):
            guard case .verified(let transaction) = verification else {
                throw ConnorStoreKitSupportError.failedVerification
            }

            await transaction.finish()
            return .purchased
        case .pending:
            return .pending
        case .userCancelled:
            return .cancelled
        @unknown default:
            throw ConnorStoreKitSupportError.unknownPurchaseResult
        }
    }

    private func restorePurchases() async throws {
        try await AppStore.sync()
    }
}

private enum ProductLoadState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

private enum ConnorStoreKitSupportError: LocalizedError {
    case productUnavailable
    case failedVerification
    case unknownPurchaseResult

    var errorDescription: String? {
        switch self {
        case .productUnavailable:
            "This support option is currently unavailable."
        case .failedVerification:
            "Apple could not verify this purchase."
        case .unknownPurchaseResult:
            "The purchase returned an unknown result."
        }
    }
}

