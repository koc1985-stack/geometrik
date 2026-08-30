import Observation
import RevenueCat

/// RevenueCat SDK'sının tek giriş noktası. Kozmika'daki PurchaseManager'ın sadeleştirilmiş hali -
/// bu uygulamada ayrı bir backend/hesap sistemi olmadığı için `login(backendUserId:)` yok;
/// RevenueCat kendi anonim kimliğini kullanıyor, satın almalar Apple ID üzerinden restore edilir.
@MainActor
@Observable
final class PurchaseManager: NSObject {
    static let shared = PurchaseManager()

    private(set) var isSubscribed = false
    private(set) var offerings: Offerings?
    private(set) var isLoadingOfferings = false

    private override init() {
        super.init()
    }

    func configure() {
        Purchases.logLevel = .warn
        Purchases.configure(withAPIKey: AppConfig.revenueCatApiKey)
        Purchases.shared.delegate = self
    }

    func loadOfferings() async {
        isLoadingOfferings = true
        defer { isLoadingOfferings = false }
        offerings = try? await Purchases.shared.offerings()
    }

    func purchase(package: Package) async throws {
        let result = try await Purchases.shared.purchase(package: package)
        updateSubscriptionStatus(from: result.customerInfo)
    }

    func restorePurchases() async throws {
        let customerInfo = try await Purchases.shared.restorePurchases()
        updateSubscriptionStatus(from: customerInfo)
    }

    func refreshSubscriptionStatus() async {
        guard let customerInfo = try? await Purchases.shared.customerInfo() else { return }
        updateSubscriptionStatus(from: customerInfo)
    }

    private func updateSubscriptionStatus(from customerInfo: CustomerInfo) {
        isSubscribed = !customerInfo.entitlements.active.isEmpty
    }
}

extension PurchaseManager: PurchasesDelegate {
    nonisolated func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.updateSubscriptionStatus(from: customerInfo)
        }
    }
}
