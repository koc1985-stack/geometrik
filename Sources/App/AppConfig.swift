import Foundation

enum AppConfig {
    /// RevenueCat kurulumundan sonra doldurulacak - bkz. Kozmika projesindeki adımlar
    /// (revenuecat.com'da proje oluştur, App Store Connect'e App-Specific Shared Secret +
    /// Subscription Key ile bağla, ürünü import et, entitlement/offering kur, appl_ ile
    /// başlayan gerçek key'i buraya yapıştır).
    static let revenueCatApiKey = "appl_XXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
