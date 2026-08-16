import SwiftUI

/// Motion values shared by interactive ConnorUI components.
public enum ConnorMotion {
    public static let quick = Animation.easeOut(duration: 0.16)
    public static let standard = Animation.easeInOut(duration: 0.24)
    public static let tactile = Animation.spring(response: 0.28, dampingFraction: 0.78)

}

