import Foundation

/// Tüm konu içeriğine tek noktadan erişim. Şu an sabit dizilerden geliyor (backend yok),
/// ileride içerik büyürse bu dosya bir JSON/plist yükleyicisine dönüştürülebilir - arayüz
/// (fonksiyon imzaları) aynı kalır.
enum ContentRepository {
    static func topics(for module: GeometryModule) -> [Topic] {
        switch module {
        case .lgs: return LGSContent.topics.sorted { $0.order < $1.order }
        case .yks: return YKSContent.topics.sorted { $0.order < $1.order }
        }
    }

    static func topic(id: String) -> Topic? {
        (LGSContent.topics + YKSContent.topics).first { $0.id == id }
    }
}
