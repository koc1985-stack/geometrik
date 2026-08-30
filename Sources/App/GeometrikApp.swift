import SwiftData
import SwiftUI

@main
struct GeometrikApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            // .automatic: CloudKit senkronu otomatik - kullanıcının iCloud hesabı zaten
            // giriş yapmışsa ilerleme sessizce senkronize olur, ayrı bir hesap sistemi gerekmez.
            let config = ModelConfiguration(cloudKitDatabase: .automatic)
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
