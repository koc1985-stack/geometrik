import SwiftData
import SwiftUI

struct SettingsView: View {
    @State private var purchaseManager = PurchaseManager.shared
    @State private var isRestoring = false
    @State private var restoreMessage: String?
    @Environment(\.modelContext) private var modelContext
    @Query private var completedTopics: [CompletedTopic]
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                List {
                    Section {
                        HStack {
                            Text("Abonelik")
                            Spacer()
                            Text(purchaseManager.isSubscribed ? "Premium" : "Ücretsiz")
                                .foregroundStyle(purchaseManager.isSubscribed ? Theme.success : Theme.textSecondary)
                        }

                        Button {
                            Task {
                                isRestoring = true
                                let restored = await purchaseManager.restore()
                                restoreMessage = restored ? "Satın alımlar geri yüklendi." : "Geri yüklenecek bir satın alım bulunamadı."
                                isRestoring = false
                            }
                        } label: {
                            HStack {
                                Text("Satın Alımları Geri Yükle")
                                if isRestoring {
                                    Spacer()
                                    SwiftUI.ProgressView()
                                }
                            }
                        }
                        .disabled(isRestoring)

                        if let restoreMessage {
                            Text(restoreMessage)
                                .font(.footnote)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    } header: {
                        Text("Abonelik")
                    }

                    Section {
                        Button(role: .destructive) {
                            showResetConfirmation = true
                        } label: {
                            Text("İlerlemeyi Sıfırla")
                        }
                        .disabled(completedTopics.isEmpty)
                    } header: {
                        Text("Veri")
                    }

                    Section {
                        Link("Gizlilik Politikası", destination: URL(string: "https://koc1985-stack.github.io/geometrik/privacy.html")!)
                        Link("Kullanım Şartları", destination: URL(string: "https://koc1985-stack.github.io/geometrik/terms.html")!)
                        Link("Destek", destination: URL(string: "https://koc1985-stack.github.io/geometrik/support.html")!)
                    } header: {
                        Text("Hakkında")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog(
                "Tüm ilerlemeni silmek istediğine emin misin?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Sil", role: .destructive) {
                    for record in completedTopics {
                        modelContext.delete(record)
                    }
                }
                Button("Vazgeç", role: .cancel) {}
            }
        }
    }
}
