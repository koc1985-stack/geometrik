import SwiftData
import SwiftUI

struct ProgressOverviewView: View {
    @Query(sort: \CompletedTopic.completedAt, order: .reverse) private var completedTopics: [CompletedTopic]

    private func count(for module: GeometryModule) -> Int {
        let moduleTopicIds = Set(ContentRepository.topics(for: module).map(\.id))
        return completedTopics.filter { moduleTopicIds.contains($0.topicId) }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if completedTopics.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        VStack(spacing: Theme.Spacing.lg) {
                            HStack(spacing: Theme.Spacing.md) {
                                ModuleProgressCard(module: .lgs, completed: count(for: .lgs))
                                ModuleProgressCard(module: .yks, completed: count(for: .yks))
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.top, Theme.Spacing.md)

                            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                                Text("Tamamlanan Dersler")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Theme.textSecondary)
                                    .padding(.horizontal, Theme.Spacing.md)

                                ForEach(completedTopics, id: \.persistentModelID) { record in
                                    if let topic = ContentRepository.topic(id: record.topicId) {
                                        CompletedRow(topic: topic, record: record)
                                            .padding(.horizontal, Theme.Spacing.md)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, Theme.Spacing.lg)
                    }
                }
            }
            .navigationTitle("İlerleme")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 40))
                .foregroundStyle(Theme.textSecondary)
            Text("Henüz tamamlanan ders yok")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Text("Bir ders bitirdiğinde burada görünecek.")
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondary)
        }
    }
}

private struct ModuleProgressCard: View {
    let module: GeometryModule
    let completed: Int

    private var total: Int { ContentRepository.topics(for: module).count }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Image(systemName: module.systemImage)
                .foregroundStyle(Theme.gold)
            Text(module.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Text("\(completed) / \(total) konu")
                .font(.system(size: 13))
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
    }
}

private struct CompletedRow: View {
    let topic: Topic
    let record: CompletedTopic

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Theme.success)
            VStack(alignment: .leading, spacing: 2) {
                Text(topic.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                if record.totalQuestions > 0 {
                    Text("\(record.correctCount)/\(record.totalQuestions) doğru")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            Spacer()
        }
        .padding(Theme.Spacing.md)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
    }
}
