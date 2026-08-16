import SwiftUI

/// A consistent Settings section for featuring the rest of Connor's app ecosystem.
public struct ConnorCompanionAppsSection: View {
    private let currentApp: ConnorAppID
    private let apps: [ConnorAppIdentity]
    private let title: String
    private let footer: String?

    public init(
        currentApp: ConnorAppID,
        apps: [ConnorAppIdentity] = ConnorAppCatalog.all,
        title: String = "More from Connor",
        footer: String? = "Independent apps made with care."
    ) {
        self.currentApp = currentApp
        self.apps = apps
        self.title = title
        self.footer = footer
    }

    public var body: some View {
        Section {
            ForEach(apps.filter { $0.id != currentApp }) { app in
                if let destination = app.appStoreURL {
                    Link(destination: destination) {
                        ConnorCompanionAppRow(app: app)
                    }
                    .buttonStyle(.plain)
                } else {
                    ConnorCompanionAppRow(app: app)
                }
            }
        } header: {
            Text(title)
        } footer: {
            if let footer {
                Text(footer)
            }
        }
    }
}

/// The row used by ``ConnorCompanionAppsSection`` and custom cross-promotion layouts.
public struct ConnorCompanionAppRow: View {
    private let app: ConnorAppIdentity

    public init(app: ConnorAppIdentity) {
        self.app = app
    }

    public var body: some View {
        HStack(spacing: ConnorSpacing.medium) {
            Image(systemName: app.symbolName)
                .font(.system(size: 21, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(iconGradient, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(.white.opacity(0.18), lineWidth: 1)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(app.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(app.tagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: ConnorSpacing.small)

            accessory
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }

    private var iconGradient: LinearGradient {
        LinearGradient(
            colors: [app.secondaryColor, app.primaryColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    @ViewBuilder
    private var accessory: some View {
        if app.status == .comingSoon {
            Text("Soon")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(.quaternary, in: Capsule())
        } else if app.appStoreURL != nil {
            Image(systemName: "arrow.up.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
    }
}

