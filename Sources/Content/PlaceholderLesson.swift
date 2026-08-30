import Foundation

/// Henüz tam animasyonla üretilmemiş konular için basit bir "yakında" dersi - uygulamanın konu
/// listesi eksiksiz görünsün, ders açıldığında da çökme/boş ekran olmasın diye. Motor
/// doğrulandıktan sonra bunlar gerçek `GeometryStep` dizileriyle değiştirilecek.
enum PlaceholderLesson {
    static func make(topicTitle: String) -> Lesson {
        Lesson(
            steps: [
                GeometryStep(
                    id: "placeholder-center",
                    kind: .addPoint(position: GeoPoint(x: 0.5, y: 0.5), label: nil),
                    narration: "\(topicTitle) dersi çok yakında burada olacak - animasyonlu anlatım şu an hazırlanıyor."
                )
            ],
            comprehensionCheck: []
        )
    }
}
