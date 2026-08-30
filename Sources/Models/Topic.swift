import Foundation

/// Bir konunun sabit içerik tanımı. Kullanıcıya özel bir veri değil, kodun içinde tanımlanan
/// içerik - `Content/LGS` ve `Content/YKS` klasörlerindeki dosyalar bunlardan diziler üretir.
/// Yeni bir konu eklemek yeni bir `Topic` değeri eklemek demek, veritabanı şeması değişmiyor.
struct Topic: Identifiable, Hashable {
    let id: String
    let module: GeometryModule
    let order: Int
    let title: String
    let summary: String
    let isFree: Bool
    let lesson: Lesson

    // Sadece `id`'ye göre karşılaştırma/hash - `lesson` (iç içe GeometryStep dizileri) her
    // katmanı Hashable yapmaya gerek kalmadan `.navigationDestination(item:)` (Hashable ister)
    // ile kullanılabilsin diye elle yazıldı.
    static func == (lhs: Topic, rhs: Topic) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
