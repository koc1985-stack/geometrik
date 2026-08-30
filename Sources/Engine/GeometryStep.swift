import Foundation

/// Bir çizim adımının, 0...1 aralığında normalize edilmiş (kanvas boyutundan bağımsız) konumu.
/// Böylece aynı ders farklı ekran boyutlarında (iPhone SE'den Pro Max'e) doğru orantıyla çizilir.
struct GeoPoint: Equatable, Hashable {
    var x: Double
    var y: Double
}

/// Bir dersin animasyonunu oluşturan tek bir adım. `GeometryStepPlayer` bu adımları sırayla
/// açığa çıkarır (`revealedSteps`), `GeometryCanvasView` de her adımı kendi Shape'iyle çizip
/// SwiftUI'nin implicit animasyonlarıyla (`.trim`, `.transition`) canlandırır.
///
/// `id` kararlı olmalı (aynı ders tekrar oynatıldığında aynı id'ler üretilmeli) - SwiftUI'nin
/// `ForEach`/`.animation(value:)` diffing'i buna dayanıyor.
struct GeometryStep: Identifiable, Equatable {
    let id: String
    let kind: Kind

    enum Kind: Equatable {
        /// Bir noktayı sahneye ekler. `label` verilirse noktanın yanında (örn. "A") görünür.
        case addPoint(position: GeoPoint, label: String?)
        /// İki daha önce eklenmiş noktayı (id'leriyle) birleştiren bir doğru parçası çizer.
        case drawSegment(from: String, to: String)
        /// Bir merkez nokta etrafında, verilen açı aralığında bir yay çizer (açıları göstermek
        /// için). Yarıçap normalize koordinat biriminde (0...1 kanvas genişliğine göre).
        case drawArc(center: String, radius: Double, startDegrees: Double, endDegrees: Double, label: String?)
        /// Belirli bir noktada bağımsız bir metin etiketi gösterir (örn. bir alan/uzunluk değeri).
        case showLabel(text: String, at: GeoPoint)
        /// Daha önce eklenmiş id'leri geçici olarak vurgular (rengi değişir) - "işte burası önemli".
        case highlight(ids: [String])
    }

    /// Bu adımla eş zamanlı gösterilecek anlatım metni (ders oynatıcının altındaki başlık).
    /// `nil` ise önceki narrasyon ekranda kalmaya devam eder.
    let narration: String?

    init(id: String, kind: Kind, narration: String? = nil) {
        self.id = id
        self.kind = kind
        self.narration = narration
    }
}

/// Bir animasyonlu ders: sıralı adımlar + sonunda kısa bir kavrama kontrolü.
struct Lesson: Equatable {
    let steps: [GeometryStep]
    let comprehensionCheck: [CheckQuestion]
}

struct CheckQuestion: Identifiable, Equatable {
    let id: String
    let question: String
    let options: [String]
    let correctIndex: Int
}
