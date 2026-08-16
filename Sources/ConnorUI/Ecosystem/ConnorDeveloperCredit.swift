import SwiftUI

/// A subtle, reusable author credit for Settings or an About screen.
public struct ConnorDeveloperCredit: View {
    private let text: String

    public init(_ text: String = "Made with care by Connor") {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .accessibilityLabel(text)
    }
}

