import CoreGraphics

/// Shared spacing values for layouts across Connor's apps.
public enum ConnorSpacing {
    public static let xSmall: CGFloat = 4
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let xLarge: CGFloat = 24
    public static let xxLarge: CGFloat = 32

    private init() {}
}

/// Shared corner radii for controls, cards, and large presentation surfaces.
public enum ConnorRadius {
    public static let small: CGFloat = 12
    public static let medium: CGFloat = 16
    public static let large: CGFloat = 22
    public static let hero: CGFloat = 28

    private init() {}
}

/// Shared control sizes that keep touch targets comfortable and consistent.
public enum ConnorControlSize {
    public static let minimumTouchTarget: CGFloat = 44
    public static let buttonHeight: CGFloat = 54
    public static let largeButtonHeight: CGFloat = 58

    private init() {}
}

