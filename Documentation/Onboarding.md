## Shared onboarding

ConnorUI provides two levels of onboarding reuse:

- `ConnorStandardOnboardingFlow` renders data-driven pages with a shared hero and feature layout.
- `ConnorOnboardingFlow` keeps the shared navigation shell while allowing completely custom page content.

The package owns paging, progress, Back/Skip/Continue/Get Started actions, motion behavior, and adaptive layout. Each app owns its words, symbols, illustrations, theme, and completion state.

### Swift Playgrounds test

Replace the component lab's `ContentView` with this view:

```swift
import SwiftUI
import ConnorUI

struct ContentView: View {
    @State private var didFinish = false

    private let pages = [
        ConnorOnboardingPage(
            eyebrow: "Welcome to Trudget",
            title: "Money without the mystery",
            message: "A calm, straightforward way to understand where your money goes.",
            symbolName: "chart.bar.doc.horizontal.fill"
        ),
        ConnorOnboardingPage(
            title: "Everything in one place",
            message: "Build a budget that stays useful without turning money into homework.",
            symbolName: "rectangle.3.group.fill",
            features: [
                ConnorOnboardingFeature(
                    symbolName: "checkmark.circle.fill",
                    title: "Simple categories",
                    detail: "Organize spending in a way that makes sense to you."
                ),
                ConnorOnboardingFeature(
                    symbolName: "chart.line.uptrend.xyaxis",
                    title: "Clear progress",
                    detail: "See how your choices add up over time."
                )
            ]
        ),
        ConnorOnboardingPage(
            eyebrow: "From Connor",
            title: "Part of a thoughtful app family",
            message: "Trudget, Sculpt, Pantry, and Fit Check are designed to feel familiar together.",
            symbolName: "square.grid.2x2.fill"
        )
    ]

    var body: some View {
        if didFinish {
            ContentUnavailableView(
                "Onboarding Complete",
                systemImage: "checkmark.circle.fill",
                description: Text("Reset the preview to run it again.")
            )
        } else {
            ConnorStandardOnboardingFlow(pages: pages) {
                didFinish = true
            }
            .connorTheme(.trudget)
        }
    }
}
```

Swipe between pages and also test Back, Skip, Continue, and Get Started. Repeat in landscape, dark mode, larger text, and Reduce Motion.

### Persisting completion in an app

The app remains responsible for deciding when onboarding should appear:

```swift
@AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

ConnorStandardOnboardingFlow(pages: pages) {
    hasCompletedOnboarding = true
}
```

### Custom page content

Use the generic flow when an app needs interactive or highly visual pages:

```swift
ConnorOnboardingFlow(pages: customPages) {
    hasCompletedOnboarding = true
} pageContent: { page in
    MyCustomOnboardingPage(page: page)
}
```

