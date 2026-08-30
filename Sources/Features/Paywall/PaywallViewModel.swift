import Observation
import RevenueCat

@MainActor
@Observable
final class PaywallViewModel {
    var selectedPackage: Package?
    var isPurchasing = false
    var errorMessage: String?

    var offerings: Offerings? { PurchaseManager.shared.offerings }
    var isLoadingOfferings: Bool { PurchaseManager.shared.isLoadingOfferings }

    var packages: [Package] {
        offerings?.current?.availablePackages ?? []
    }

    /// Yıllık paket varsa varsayılan olarak seçili gelir.
    func loadOfferings() async {
        await PurchaseManager.shared.loadOfferings()
        selectedPackage = packages.first { $0.packageType == .annual } ?? packages.first
    }

    func purchase() async -> Bool {
        guard let package = selectedPackage else { return false }
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }
        do {
            try await PurchaseManager.shared.purchase(package: package)
            return PurchaseManager.shared.isSubscribed
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func restore() async -> Bool {
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            try await PurchaseManager.shared.restorePurchases()
            return PurchaseManager.shared.isSubscribed
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
