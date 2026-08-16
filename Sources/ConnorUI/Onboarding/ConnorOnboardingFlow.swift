import SwiftUI

/// The shared navigation, progress, and action shell for onboarding.
///
/// Supply custom page content to keep app-specific storytelling and illustrations while
/// centralizing the interaction model in ConnorUI.
public struct ConnorOnboardingFlow<Page, PageContent: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.connorTheme) private var theme

    @State private var selectedPage: Int

    private let pages: [Page]
    private let showsSkip: Bool
    private let strings: ConnorOnboardingStrings
    private let onSkip: (() -> Void)?
    private let onComplete: () -> Void
    private let pageContent: (Page) -> PageContent

    public init(
        pages: [Page],
        initialPage: Int = 0,
        showsSkip: Bool = true,
        strings: ConnorOnboardingStrings = ConnorOnboardingStrings(),
        onSkip: (() -> Void)? = nil,
        onComplete: @escaping () -> Void,
        @ViewBuilder pageContent: @escaping (Page) -> PageContent
    ) {
        self.pages = pages
        self.showsSkip = showsSkip
        self.strings = strings
        self.onSkip = onSkip
        self.onComplete = onComplete
        self.pageContent = pageContent

        let lastPage = max(0, pages.count - 1)
        _selectedPage = State(initialValue: min(max(initialPage, 0), lastPage))
    }

    public var body: some View {
        Group {
            if pages.isEmpty {
                ContentUnavailableView(
                    "No Onboarding Pages",
                    systemImage: "rectangle.stack.badge.questionmark",
                    description: Text("Add at least one page to this onboarding flow.")
                )
            } else {
                onboardingContent
            }
        }
        .background(theme.canvas.ignoresSafeArea())
        .onChange(of: pages.count) { _, newCount in
            selectedPage = min(selectedPage, max(0, newCount - 1))
        }
    }

    private var onboardingContent: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                topBar

                TabView(selection: $selectedPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        ScrollView {
                            pageContent(pages[index])
                                .frame(
                                    minHeight: max(0, proxy.size.height - 220),
                                    alignment: .center
                                )
                        }
                        .scrollIndicators(.hidden)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                bottomBar
            }
        }
    }

    private var topBar: some View {
        HStack {
            if selectedPage > 0 {
                Button(strings.back, action: moveBack)
                    .foregroundStyle(theme.accent)
            } else {
                Text(strings.back)
                    .hidden()
            }

            Spacer()

            if showsSkip && !isLastPage {
                Button(strings.skip, action: skip)
                    .foregroundStyle(.secondary)
            } else {
                Text(strings.skip)
                    .hidden()
            }
        }
        .font(.subheadline.weight(.semibold))
        .frame(minHeight: ConnorControlSize.minimumTouchTarget)
        .padding(.horizontal, ConnorSpacing.xLarge)
        .padding(.top, ConnorSpacing.small)
    }

    private var bottomBar: some View {
        VStack(spacing: ConnorSpacing.large) {
            ConnorPageIndicator(pageCount: pages.count, selectedPage: selectedPage)

            Button(isLastPage ? strings.getStarted : strings.next) {
                if isLastPage {
                    onComplete()
                } else {
                    moveForward()
                }
            }
            .buttonStyle(ConnorPrimaryButtonStyle(isLarge: true))
        }
        .padding(.horizontal, ConnorSpacing.xLarge)
        .padding(.top, ConnorSpacing.medium)
        .padding(.bottom, ConnorSpacing.large)
        .background(theme.canvas)
    }

    private var isLastPage: Bool {
        selectedPage >= pages.count - 1
    }

    private func moveBack() {
        setPage(selectedPage - 1)
    }

    private func moveForward() {
        setPage(selectedPage + 1)
    }

    private func setPage(_ page: Int) {
        let destination = min(max(page, 0), max(0, pages.count - 1))
        withAnimation(reduceMotion ? nil : ConnorMotion.standard) {
            selectedPage = destination
        }
    }

    private func skip() {
        if let onSkip {
            onSkip()
        } else {
            onComplete()
        }
    }
}

/// A ready-to-use onboarding flow built from ``ConnorOnboardingPage`` values.
public struct ConnorStandardOnboardingFlow: View {
    private let pages: [ConnorOnboardingPage]
    private let initialPage: Int
    private let showsSkip: Bool
    private let strings: ConnorOnboardingStrings
    private let onSkip: (() -> Void)?
    private let onComplete: () -> Void

    public init(
        pages: [ConnorOnboardingPage],
        initialPage: Int = 0,
        showsSkip: Bool = true,
        strings: ConnorOnboardingStrings = ConnorOnboardingStrings(),
        onSkip: (() -> Void)? = nil,
        onComplete: @escaping () -> Void
    ) {
        self.pages = pages
        self.initialPage = initialPage
        self.showsSkip = showsSkip
        self.strings = strings
        self.onSkip = onSkip
        self.onComplete = onComplete
    }

    public var body: some View {
        ConnorOnboardingFlow(
            pages: pages,
            initialPage: initialPage,
            showsSkip: showsSkip,
            strings: strings,
            onSkip: onSkip,
            onComplete: onComplete
        ) { page in
            ConnorOnboardingPageView(page: page)
        }
    }
}

