import SwiftUI

/// A compact, accessible progress indicator for paged onboarding flows.
public struct ConnorPageIndicator: View {
    @Environment(\.connorTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let pageCount: Int
    private let selectedPage: Int

    public init(pageCount: Int, selectedPage: Int) {
        self.pageCount = max(0, pageCount)
        self.selectedPage = selectedPage
    }

    public var body: some View {
        HStack(spacing: ConnorSpacing.small) {
            ForEach(0..<pageCount, id: \.self) { page in
                Capsule(style: .continuous)
                    .fill(page == selectedPage ? theme.accent : theme.border.opacity(0.55))
                    .frame(width: page == selectedPage ? 22 : 8, height: 8)
            }
        }
        .animation(reduceMotion ? nil : ConnorMotion.standard, value: selectedPage)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Onboarding progress")
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityValue: String {
        guard pageCount > 0 else { return "No pages" }
        let readablePage = min(max(selectedPage + 1, 1), pageCount)
        return "Page \(readablePage) of \(pageCount)"
    }
}

