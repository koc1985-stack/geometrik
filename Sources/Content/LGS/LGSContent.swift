import Foundation

enum LGSContent {
    static let topics: [Topic] = [
        Topic(
            id: "lgs.ucgen-temel",
            module: .lgs,
            order: 1,
            title: "Üçgenin Temel Elemanları",
            summary: "Kenarortay, yükseklik ve açıortay nedir, nasıl çizilir?",
            isFree: true,
            lesson: UcgenTemelElemanlariLesson.lesson
        ),
        Topic(
            id: "lgs.ucgen-esitsizligi",
            module: .lgs,
            order: 2,
            title: "Üçgen Eşitsizliği",
            summary: "Üç kenar uzunluğu her zaman bir üçgen oluşturur mu?",
            isFree: true,
            lesson: PlaceholderLesson.make(topicTitle: "Üçgen Eşitsizliği")
        ),
        Topic(
            id: "lgs.pisagor",
            module: .lgs,
            order: 3,
            title: "Pisagor Bağıntısı",
            summary: "Dik üçgende kenarlar arasındaki ünlü bağıntı.",
            isFree: true,
            lesson: PisagorLesson.lesson
        ),
        Topic(
            id: "lgs.eslik-benzerlik",
            module: .lgs,
            order: 4,
            title: "Eşlik ve Benzerlik",
            summary: "İki şekil ne zaman eş, ne zaman benzerdir?",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Eşlik ve Benzerlik")
        ),
        Topic(
            id: "lgs.donusum-geometrisi",
            module: .lgs,
            order: 5,
            title: "Dönüşüm Geometrisi",
            summary: "Öteleme, yansıma ve dönme hareketleri.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Dönüşüm Geometrisi")
        ),
        Topic(
            id: "lgs.geometrik-cisimler",
            module: .lgs,
            order: 6,
            title: "Geometrik Cisimler",
            summary: "Prizma, silindir, piramit ve koninin alan/hacmi.",
            isFree: false,
            lesson: PlaceholderLesson.make(topicTitle: "Geometrik Cisimler")
        ),
    ]
}
