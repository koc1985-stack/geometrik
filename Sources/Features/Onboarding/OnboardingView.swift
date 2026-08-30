import SwiftUI

struct OnboardingView: View {
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()

                Image(systemName: "triangle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.gold)

                Text("Geometrik")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)

                Text("LGS ve YKS geometrisini, adım adım açılan animasyonlarla gerçekten anlayarak öğren.")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.lg)

                Spacer()

                Button {
                    onFinished()
                } label: {
                    Text("Başlayalım")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Theme.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.gold, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.lg)
            }
        }
    }
}
