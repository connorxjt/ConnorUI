# ConnorUI

ConnorUI is the shared SwiftUI design system for Trudget, Sculpt, Pantry, Fit Check, and future apps by Connor. It keeps the ecosystem recognizable while letting each app retain its own color and personality.

The package currently requires iOS 17, matching the apps' SwiftData baseline.

## What's in the foundations branch

- App themes plus shared spacing, radius, control-size, and motion tokens
- Tactile primary and secondary button styles
- Reusable card surfaces
- An accessible onboarding page indicator
- A centralized companion-app catalog and Settings section
- A subtle reusable developer credit

Full onboarding and support-page templates will build on these foundations after they have been validated in Swift Playgrounds.

## Test this branch in Swift Playgrounds

Add the package URL and select the `agent/connorui-foundations` branch while it is under review:

`https://github.com/connorxjt/ConnorUI`

Then try this small component lab:

```swift
import SwiftUI
import ConnorUI

struct ConnorUILab: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: ConnorSpacing.xLarge) {
                    ConnorSurface(style: .raised) {
                        VStack(alignment: .leading, spacing: ConnorSpacing.medium) {
                            Text("ConnorUI")
                                .font(.title2.bold())
                            Text("One shared system, four distinct apps.")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button("Primary action") {}
                        .buttonStyle(ConnorPrimaryButtonStyle())

                    Button("Secondary action") {}
                        .buttonStyle(ConnorSecondaryButtonStyle())

                    ConnorPageIndicator(pageCount: 5, selectedPage: 1)

                    Form {
                        ConnorCompanionAppsSection(currentApp: .trudget)
                    }
                    .frame(minHeight: 330)

                    ConnorDeveloperCredit()
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Component Lab")
        }
        .connorTheme(.trudget)
    }
}
```

Switch `.trudget` to `.sculpt`, `.pantry`, or `.fitCheck` to preview each app's starter theme.

## Package use

```swift
import ConnorUI
```

Apply the app theme once near the root of each app:

```swift
ContentView()
    .connorTheme(.trudget)
```

Apps can also create a custom `ConnorTheme` while keeping the shared components and behavior.

## Shared page templates

The first full-page template is the shared onboarding system. See
[`Documentation/Onboarding.md`](Documentation/Onboarding.md) for the standard flow,
custom-page flow, Swift Playgrounds lab, and completion-state example.

