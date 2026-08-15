import SwiftUI

public struct ConnorUITestBadge: View {
    public init() {}

    public var body: some View {
        Label("ConnorUI connected", systemImage: "checkmark.circle.fill")
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(.green.gradient, in: Capsule())
    }
}
