import SwiftUI

/// Basit, tek dosyalık tasarım sistemi - Kozmika'daki gibi ayrı bir DesignSystem klasörü
/// gerektirecek kadar büyük bir uygulama değil, ama tutarlılık için renkleri tek yerden yönetiyoruz.
enum Theme {
    static let background = Color(red: 0.07, green: 0.09, blue: 0.16)
    static let surface = Color(red: 0.11, green: 0.13, blue: 0.22)
    static let gold = Color(red: 0.90, green: 0.70, blue: 0.32)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.65)
    static let success = Color(red: 0.4, green: 0.8, blue: 0.55)
    static let error = Color(red: 0.92, green: 0.4, blue: 0.4)

    enum Spacing {
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }

    enum Radius {
        static let md: CGFloat = 16
    }
}

extension Color {
    static let purpleAccent = Color(red: 0.56, green: 0.48, blue: 0.92)
}
