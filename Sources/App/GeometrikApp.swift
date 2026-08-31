import SwiftData
import SwiftUI

@main
struct GeometrikApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            // v1: sadece yerel SwiftData (CloudKit YOK) - Apple Developer Portal'da App ID'ye
            // iCloud container'ı bağlama adımı tekrarlanan denemelerde sunucu tarafında hiç
            // kalıcı olmadı (bilinen bir portal arızası olabilir). İlerleme yine cihazda kalıcı
            // olur, sadece cihazlar arası senkron olmaz - ileride container sorunu çözülünce
            // `ModelConfiguration(cloudKitDatabase: .automatic)` ile geri eklenebilir.
            let config = ModelConfiguration()
            modelContainer = try ModelContainer(for: CompletedTopic.self, configurations: config)
        } catch {
            fatalError("SwiftData ModelContainer oluşturulamadı: \(error)")
        }
        PurchaseManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(modelContainer)
    }
}
