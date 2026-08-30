import Foundation

enum YKSContent {
    static let topics: [Topic] = [
        Topic(
            id: "yks.ucgende-aci-kenar",
            module: .yks,
            order: 1,
            title: "Üçgende Açı ve Kenar Bağıntıları",
            summary: "TYT - açı-kenar ilişkileri, iç ve dış açılar.",
            isFree: true,
            lesson: PlaceholderLesson.make(topicTitle: "Üçgende Açı ve Kenar Bağıntıları")
        ),
        Topic(
            id: "yks.ozel-ucgenler",
            module: .yks,
            order: 2,
            title: "Özel Üçgenler",
            summary: "TYT - dik, ikizkenar ve eşkenar üçgenler.",
            isFree: true,
            lesson: PlaceholderLesson.make(topicTitle: "Özel Üçgenler")
        ),
        Topic(
            id: "yks.cokgenler",
            module: .yks,
            order: 3,
            title: "Çokgenler",
            summary: "TYT - iç/dış açı toplamları, köşegen sayısı.",
            isFree: true,
            lesson: PlaceholderLesson.make(topicTitle: "Çokgenler")
        ),
        Topic(
            id: "yks.dortgenler",
            module: .yks,
            order: 4,
            title: "Dörtgenler",
            summary: "TYT - kare, dikdörtgen, paralelkenar, yamuk, deltoid.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Dörtgenler")
        ),
        Topic(
            id: "yks.cember-daire",
            module: .yks,
            order: 5,
            title: "Çember ve Daire",
            summary: "TYT - temel çember/daire ilişkileri.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Çember ve Daire")
        ),
        Topic(
            id: "yks.kati-cisimler-temel",
            module: .yks,
            order: 6,
            title: "Katı Cisimler (Temel)",
            summary: "TYT - prizma, silindir, piramit, koni.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Katı Cisimler (Temel)")
        ),
        Topic(
            id: "yks.analitik-giris",
            module: .yks,
            order: 7,
            title: "Analitik Geometriye Giriş",
            summary: "TYT - koordinat düzleminde temel kavramlar.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Analitik Geometriye Giriş")
        ),
        Topic(
            id: "yks.trigonometri",
            module: .yks,
            order: 8,
            title: "Üçgende Trigonometri",
            summary: "AYT - sinüs ve kosinüs teoremi.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Üçgende Trigonometri")
        ),
        Topic(
            id: "yks.cember-ileri",
            module: .yks,
            order: 9,
            title: "Çemberde İleri Açı-Uzunluk",
            summary: "AYT - teğet, kiriş, çevre açı ilişkileri.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Çemberde İleri Açı-Uzunluk")
        ),
        Topic(
            id: "yks.analitik-ileri",
            module: .yks,
            order: 10,
            title: "Analitik Geometri: Doğru ve Çember Denklemleri",
            summary: "AYT - doğru denklemi, çember denklemi.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Analitik Geometri: Doğru ve Çember Denklemleri")
        ),
        Topic(
            id: "yks.kati-cisimler-ileri",
            module: .yks,
            order: 11,
            title: "Katı Cisimler İleri: Küre",
            summary: "AYT - küre, alan/hacim ilişkileri.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Katı Cisimler İleri: Küre")
        ),
    ]
}
