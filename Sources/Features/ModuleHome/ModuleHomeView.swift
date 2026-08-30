import SwiftData
import SwiftUI

struct ModuleHomeView: View {
    @State private var selectedModule: GeometryModule = .lgs
    @Query private var completedTopics: [CompletedTopic]
    @State private var purchaseManager = PurchaseManager.shared
    @State private var showPaywall = false
    @State private var selectedTopic: Topic?

    private var completedIds: Set<String> {
        Set(completedTopics.map(\.topicId))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    Picker("Modül", selection: $selectedModule) {
                        ForEach(GeometryModule.allCases) { module in
                            Text(module.title).tag(module)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(Theme.Spacing.md)

                    ScrollView {
                        LazyVStack(spacing: Theme.Spacing.sm) {
                            ForEach(ContentRepository.topics(for: selectedModule)) { topic in
                                TopicRow(
                                    topic: topic,
                                    isCompleted: completedIds.contains(topic.id),
                                    isLocked: !topic.isFree && !purchaseManager.isSubscribed
                                ) {
                                    handleTap(on: topic)
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.bottom, Theme.Spacing.lg)
                    }
                }
            }
            .navigationTitle("Geometrik")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .navigationDestination(item: $selectedTopic) { topic in
                LessonView(topic: topic)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private func handleTap(on topic: Topic) {
        if !topic.isFree && !purchaseManager.isSubscribed {
            showPaywall = true
        } else {
            selectedTopic = topic
        }
    }
}

private struct TopicRow: View {
    let topic: Topic
    let isCompleted: Bool
    let isLocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Theme.success.opacity(0.18) : Theme.surface)
                        .frame(width: 40, height: 40)
                    Image(systemName: isCompleted ? "checkmark" : (isLocked ? "lock.fill" : "play.fill"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isCompleted ? Theme.success : (isLocked ? Theme.textSecondary : Theme.gold))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(topic.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(topic.summary)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(Theme.Spacing.md)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
        }
        .buttonStyle(.plain)
    }
}
