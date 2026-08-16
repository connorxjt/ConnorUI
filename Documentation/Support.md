## Shared support and tip page

ConnorUI separates the shared support experience from app-specific commerce configuration:

- `ConnorSupportPage` renders mock or custom support tiers and accepts async purchase actions.
- `ConnorStoreKitSupportPage` loads localized products and prices from App Store Connect, verifies transactions, finishes successful purchases, and optionally restores eligible purchases.

Each app supplies its name, message, StoreKit identifiers, and optional product symbols. ConnorUI owns the layout, loading/error states, tactile tier cards, purchase feedback, and developer credit.

### Swift Playgrounds visual lab

Replace the component lab's `ContentView` with this view. It uses mock products, so tapping a tier is safe and does not start a real purchase:

```swift
import SwiftUI
import ConnorUI

struct ContentView: View {
    private let configuration = ConnorSupportConfiguration(
        appName: "Trudget",
        message: "If Trudget has made money feel a little clearer, you can leave a small tip to support future updates."
    )

    private let tiers = [
        ConnorSupportTier(
            id: "small-tip",
            title: "Coffee",
            detail: "A small thank-you",
            displayPrice: "$1.99",
            symbolName: "cup.and.saucer.fill"
        ),
        ConnorSupportTier(
            id: "medium-tip",
            title: "Lunch",
            detail: "Help fund the next update",
            displayPrice: "$4.99",
            symbolName: "takeoutbag.and.cup.and.straw.fill"
        ),
        ConnorSupportTier(
            id: "large-tip",
            title: "Big Support",
            detail: "Make Connor's day",
            displayPrice: "$9.99",
            symbolName: "sparkles"
        )
    ]

    var body: some View {
        NavigationStack {
            ConnorSupportPage(
                configuration: configuration,
                tiers: tiers
            ) { _ in
                .purchased
            }
            .connorTheme(.trudget)
        }
    }
}
```

Test all three tiers, light and dark mode, larger text, portrait, and landscape. Switch `.trudget` to another built-in theme to verify the shared structure retains each app's color identity.

### StoreKit-backed production page

Configure the same product identifiers in App Store Connect, then supply them to ConnorUI:

```swift
NavigationStack {
    ConnorStoreKitSupportPage(
        configuration: ConnorSupportConfiguration(
            appName: "Trudget",
            productIdentifiers: [
                "com.connorztan.trudget.tip.small",
                "com.connorztan.trudget.tip.medium",
                "com.connorztan.trudget.tip.large"
            ],
            productSymbols: [
                "com.connorztan.trudget.tip.small": "cup.and.saucer.fill",
                "com.connorztan.trudget.tip.medium": "takeoutbag.and.cup.and.straw.fill",
                "com.connorztan.trudget.tip.large": "sparkles"
            ]
        )
    )
    .connorTheme(.trudget)
}
```

Tip products are commonly consumable and therefore cannot be restored. Leave `showsRestorePurchases` at its default of `false` for consumable tips. Enable it only when the configured products are eligible for restoration.

