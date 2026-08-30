import Foundation

/// LGS Geometri - "Pisagor Bağıntısı". Dik açı A köşesinde; AB ve AC dik kenarlar (yaklaşık
/// eşit uzunlukta, 3-4-5 hissi vermesi için orantı kabaca korunuyor), BC hipotenüs.
enum PisagorLesson {
    static let lesson = Lesson(
        steps: [
            GeometryStep(
                id: "A",
                kind: .addPoint(position: GeoPoint(x: 0.18, y: 0.85), label: "A"),
                narration: "Bir dik üçgen çizelim. A köşesinde tam 90°'lik bir açımız olacak."
            ),
            GeometryStep(
                id: "B",
                kind: .addPoint(position: GeoPoint(x: 0.78, y: 0.85), label: "B"),
                narration: nil
            ),
            GeometryStep(
                id: "C",
                kind: .addPoint(position: GeoPoint(x: 0.18, y: 0.22), label: "C"),
                narration: nil
            ),
            GeometryStep(
                id: "seg-AB",
                kind: .drawSegment(from: "A", to: "B"),
                narration: "AB ve AC, dik açıyı oluşturan iki kenar - bunlara DİK KENARLAR denir."
            ),
            GeometryStep(id: "seg-AC", kind: .drawSegment(from: "A", to: "C"), narration: nil),
            GeometryStep(
                id: "right-angle-mark",
                kind: .drawArc(center: "A", radius: 0.06, startDegrees: -90, endDegrees: 0, label: nil),
                narration: nil
            ),
            GeometryStep(
                id: "seg-BC",
                kind: .drawSegment(from: "B", to: "C"),
                narration: "BC kenarı, dik açının TAM KARŞISINDA - bu en uzun kenara HİPOTENÜS denir."
            ),
            GeometryStep(
                id: "highlight-hyp",
                kind: .highlight(ids: ["seg-BC"]),
                narration: nil
            ),
            GeometryStep(
                id: "label-a",
                kind: .showLabel(text: "a", at: GeoPoint(x: 0.13, y: 0.53)),
                narration: "Dik kenarlara a ve b, hipotenüse c diyelim."
            ),
            GeometryStep(
                id: "label-b",
                kind: .showLabel(text: "b", at: GeoPoint(x: 0.48, y: 0.90)),
                narration: nil
            ),
            GeometryStep(
                id: "label-c",
                kind: .showLabel(text: "c", at: GeoPoint(x: 0.52, y: 0.48)),
                narration: nil
            ),
            GeometryStep(
                id: "formula",
                kind: .showLabel(text: "a² + b² = c²", at: GeoPoint(x: 0.55, y: 0.65)),
                narration: "Pisagor bağıntısı: dik kenarların karelerinin toplamı, hipotenüsün karesine eşittir."
            ),
        ],
        comprehensionCheck: [
            CheckQuestion(
                id: "q1",
                question: "Dik üçgende, dik açının tam karşısındaki en uzun kenara ne denir?",
                options: ["Dik kenar", "Hipotenüs", "Kenarortay", "Yükseklik"],
                correctIndex: 1
            ),
            CheckQuestion(
                id: "q2",
                question: "Dik kenarlar a ve b, hipotenüs c ise Pisagor bağıntısı hangisidir?",
                options: ["a + b = c", "a² + b² = c²", "a² − b² = c²", "a × b = c²"],
                correctIndex: 1
            ),
            CheckQuestion(
                id: "q3",
                question: "Dik kenarlar 3 cm ve 4 cm olan bir dik üçgende hipotenüs kaç cm'dir?",
                options: ["5", "6", "7", "12"],
                correctIndex: 0
            ),
        ]
    )
}
