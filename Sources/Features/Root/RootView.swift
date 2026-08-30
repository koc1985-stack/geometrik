import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var purchaseManager = PurchaseManager.shared

    var body: some View {
        Group {
            if hasSeenOnboarding {
                MainTabView()
            } else {
                OnboardingView(onFinished: { hasSeenOnboarding = true })
            }
        }
        .task {
            await purchaseManager.loadOfferings()
        }
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            ModuleHomeView()
                .tabItem { Label("Dersler", systemImage: "book.fill") }

            ProgressOverviewView()
                .tabItem { Label("İlerleme", systemImage: "chart.bar.fill") }

            SettingsView()
                .tabItem { Label("Ayarlar", systemImage: "gearshape.fill") }
        }
        .tint(Theme.gold)
    }
}
