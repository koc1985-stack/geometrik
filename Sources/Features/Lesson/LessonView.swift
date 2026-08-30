import SwiftUI

struct LessonView: View {
    let topic: Topic
    @State private var player: GeometryStepPlayer
    @State private var showComprehensionCheck = false
    @Environment(\.dismiss) private var dismiss

    init(topic: Topic) {
        self.topic = topic
        _player = State(initialValue: GeometryStepPlayer(lesson: topic.lesson))
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.md) {
                GeometryCanvasView(player: player)
                    .padding(Theme.Spacing.lg)
                    .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
                    .padding(.horizontal, Theme.Spacing.md)

                Text(player.currentNarration)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 60)
                    .padding(.horizontal, Theme.Spacing.lg)
                    .animation(.easeInOut(duration: 0.25), value: player.currentNarration)

                ProgressBarView(progress: player.progress)
                    .padding(.horizontal, Theme.Spacing.lg)

                PlaybackControls(
                    isPlaying: player.isPlaying,
                    isAtStart: player.isAtStart,
                    isAtEnd: player.isAtEnd,
                    onBack: { player.stepBackward() },
                    onPlayPause: { player.isPlaying ? player.pause() : player.play() },
                    onForward: { player.stepForward() },
                    onRestart: { player.restart() }
                )
                .padding(.horizontal, Theme.Spacing.lg)

                if player.isAtEnd {
                    Button {
                        if topic.lesson.comprehensionCheck.isEmpty {
                            dismiss()
                        } else {
                            player.pause()
                            showComprehensionCheck = true
                        }
                    } label: {
                        Text(topic.lesson.comprehensionCheck.isEmpty ? "Tamamlandı" : "Anladın mı? Kontrol et")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.background)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.gold, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    .transition(.opacity)
                }

                Spacer(minLength: 0)
            }
            .padding(.top, Theme.Spacing.md)
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showComprehensionCheck) {
            ComprehensionCheckView(topic: topic)
        }
    }
}

private struct ProgressBarView: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.surface).frame(height: 6)
                Capsule().fill(Theme.gold).frame(width: geo.size.width * progress, height: 6)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 6)
    }
}

private struct PlaybackControls: View {
    let isPlaying: Bool
    let isAtStart: Bool
    let isAtEnd: Bool
    let onBack: () -> Void
    let onPlayPause: () -> Void
    let onForward: () -> Void
    let onRestart: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.lg) {
            Button(action: onRestart) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 18))
            }

            Button(action: onBack) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 20))
            }
            .disabled(isAtStart)

            Button(action: onPlayPause) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 48))
            }

            Button(action: onForward) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 20))
            }
            .disabled(isAtEnd)

            Color.clear.frame(width: 18)
        }
        .foregroundStyle(Theme.gold)
        .frame(maxWidth: .infinity)
    }
}
