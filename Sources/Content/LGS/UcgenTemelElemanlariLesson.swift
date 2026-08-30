import Foundation

/// LGS Geometri - "Üçgenin Temel Elemanları": kenarortay, yükseklik, açıortay.
/// Köşe koordinatları (A, B, C) elle seçildi; M (kenarortay ayağı) tam orta nokta olarak
/// hesaplandı, H (yükseklik ayağı) ve D (açıortay ayağı) gerçek dik izdüşüm / açıortay teoremi
/// formülleriyle hesaplandı (bkz. plan notları) - üç doğru parçasının GERÇEKTEN farklı
/// noktalarda bittiğini göstermek için üçgen bilinçli olarak çeşitkenar seçildi.
enum UcgenTemelElemanlariLesson {
    static let lesson = Lesson(
        steps: [
            GeometryStep(
                id: "A",
                kind: .addPoint(position: GeoPoint(x: 0.15, y: 0.78), label: "A"),
                narration: "Bir üçgenin üç köşesi ve üç kenarı vardır. Sırayla A, B ve C köşelerini yerleştirelim."
            ),
            GeometryStep(
                id: "B",
                kind: .addPoint(position: GeoPoint(x: 0.88, y: 0.72), label: "B"),
                narration: nil
            ),
            GeometryStep(
                id: "C",
                kind: .addPoint(position: GeoPoint(x: 0.62, y: 0.18), label: "C"),
                narration: nil
            ),
            GeometryStep(
                id: "seg-AB",
                kind: .drawSegment(from: "A", to: "B"),
                narration: "Şimdi kenarları çizip ABC üçgenimizi tamamlıyoruz."
            ),
            GeometryStep(id: "seg-BC", kind: .drawSegment(from: "B", to: "C"), narration: nil),
            GeometryStep(id: "seg-CA", kind: .drawSegment(from: "C", to: "A"), narration: nil),
            GeometryStep(
                id: "M",
                kind: .addPoint(position: GeoPoint(x: 0.515, y: 0.75), label: "M"),
                narration: "AB kenarının tam orta noktasını işaretleyelim: M."
            ),
            GeometryStep(
                id: "seg-CM",
                kind: .drawSegment(from: "C", to: "M"),
                narration: "Bir köşeden karşı kenarın ORTA NOKTASINA çizilen doğru parçasına KENARORTAY denir."
            ),
            GeometryStep(
                id: "highlight-median",
                kind: .highlight(ids: ["seg-CM"]),
                narration: nil
            ),
            GeometryStep(
                id: "H",
                kind: .addPoint(position: GeoPoint(x: 0.666, y: 0.738), label: "H"),
                narration: "Şimdi C köşesinden AB kenarına indirilen dik çizgiye bakalım."
            ),
            GeometryStep(
                id: "seg-CH",
                kind: .drawSegment(from: "C", to: "H"),
                narration: "Bir köşeden karşı kenara TAM DİK AÇIYLA (90°) inen doğru parçasına YÜKSEKLİK denir."
            ),
            GeometryStep(
                id: "highlight-altitude",
                kind: .highlight(ids: ["seg-CH"]),
                narration: nil
            ),
            GeometryStep(
                id: "D",
                kind: .addPoint(position: GeoPoint(x: 0.559, y: 0.746), label: "D"),
                narration: "Son olarak, C köşesindeki açıyı tam ortadan ikiye bölen doğruya bakalım."
            ),
            GeometryStep(
                id: "seg-CD",
                kind: .drawSegment(from: "C", to: "D"),
                narration: "Bir köşedeki açıyı iki EŞİT açıya bölen doğru parçasına AÇIORTAY denir."
            ),
            GeometryStep(
                id: "highlight-bisector",
                kind: .highlight(ids: ["seg-CD"]),
                narration: nil
            ),
            GeometryStep(
                id: "final-highlight",
                kind: .highlight(ids: ["seg-CM", "seg-CH", "seg-CD"]),
                narration: "Kenarortay, yükseklik ve açıortay - üçü de bir köşeden çıkar ama farklı kurallara göre belirlenir, genelde AB üzerinde farklı noktalarda biterler."
            ),
        ],
        comprehensionCheck: [
            CheckQuestion(
                id: "q1",
                question: "Bir köşeden karşı kenarın ORTA NOKTASINA çizilen doğru parçasına ne denir?",
                options: ["Kenarortay", "Yükseklik", "Açıortay", "Kiriş"],
                correctIndex: 0
            ),
            CheckQuestion(
                id: "q2",
                question: "Bir köşeden karşı kenara 90° açıyla inen doğru parçasına ne denir?",
                options: ["Açıortay", "Kenarortay", "Yükseklik", "Simetri Ekseni"],
                correctIndex: 2
            ),
            CheckQuestion(
                id: "q3",
                question: "Bir köşedeki açıyı iki eşit parçaya bölen doğru parçasına ne denir?",
                options: ["Yükseklik", "Açıortay", "Kenarortay", "Teğet"],
                correctIndex: 1
            ),
        ]
    )
}
