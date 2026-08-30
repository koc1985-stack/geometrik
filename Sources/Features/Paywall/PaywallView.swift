import RevenueCat
import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = PaywallViewModel()

    private let features = [
        "Her iki modülde tüm konulara sınırsız erişim",
        "LGS ve YKS (TYT + AYT) geometri müfredatının tamamı",
        "Yeni konular eklendikçe otomatik erişim",
        "Reklamsız, kesintisiz öğrenim",
    ]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Theme.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.white.opacity(0.08)))
                    }
                }
                .padding([.top, .trailing], Theme.Spacing.md)

                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        VStack(spacing: Theme.Spacing.sm) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(Theme.gold)
                            Text("Geometrik Premium")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.textPrimary)
                            Text("Tüm konuları aç, LGS ve YKS'ye tam hazır ol.")
                                .font(.system(size: 15))
                                .foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.top, Theme.Spacing.md)

                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            ForEach(features, id: \.self) { feature in
                                HStack(spacing: Theme.Spacing.sm) {
                                    Image(systemName: "checkmark.seal.fill").foregroundStyle(Theme.gold)
                                    Text(feature).font(.system(size: 15)).foregroundStyle(Theme.textPrimary)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)

                        if viewModel.isLoadingOfferings {
                            SwiftUI.ProgressView().tint(Theme.gold).padding()
                        } else {
                            VStack(spacing: Theme.Spacing.sm) {
                                ForEach(viewModel.packages, id: \.identifier) { package in
                                    PackageOptionCard(
                                        package: package,
                                        isSelected: viewModel.selectedPackage?.identifier == package.identifier
                                    ) {
                                        viewModel.selectedPackage = package
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.error)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Theme.Spacing.lg)
                        }
                    }
                    .padding(.bottom, Theme.Spacing.lg)
                }

                VStack(spacing: Theme.Spacing.sm) {
                    Button {
                        Task {
                            if await viewModel.purchase() {
                                dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            if viewModel.isPurchasing {
                                SwiftUI.ProgressView().tint(Theme.background)
                            } else {
                                Text("Abone Ol")
                            }
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Theme.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            (viewModel.selectedPackage != nil ? Theme.gold : Theme.gold.opacity(0.4)),
                            in: RoundedRectangle(cornerRadius: Theme.Radius.md)
                        )
                    }
                    .disabled(viewModel.selectedPackage == nil || viewModel.isPurchasing)

                    Button {
                        Task {
                            if await viewModel.restore() {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Satın Alımları Geri Yükle")
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.textSecondary)
                    }

                    Text("Abonelik otomatik olarak yenilenir, istediğin zaman App Store ayarlarından iptal edebilirsin.")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.md)
            }
        }
        .task { await viewModel.loadOfferings() }
    }
}

private struct PackageOptionCard: View {
    let package: Package
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(package.storeProduct.localizedTitle).font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(package.storeProduct.localizedPriceString)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(isSelected ? Theme.gold : Theme.textSecondary)
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                    .fill(isSelected ? Theme.gold.opacity(0.12) : Theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                    .stroke(isSelected ? Theme.gold : Color.white.opacity(0.1), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}
