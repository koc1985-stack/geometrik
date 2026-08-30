import SwiftData
import SwiftUI

struct ComprehensionCheckView: View {
    let topic: Topic
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var currentQuestionIndex = 0
    @State private var selectedOptionIndex: Int?
    @State private var correctCount = 0
    @State private var isFinished = false

    private var questions: [CheckQuestion] { topic.lesson.comprehensionCheck }
    private var currentQuestion: CheckQuestion? {
        currentQuestionIndex < questions.count ? questions[currentQuestionIndex] : nil
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            if isFinished {
                ResultView(topic: topic, correctCount: correctCount, total: questions.count) {
                    dismiss()
                }
            } else if let question = currentQuestion {
                QuestionView(
                    question: question,
                    questionNumber: currentQuestionIndex + 1,
                    totalQuestions: questions.count,
                    selectedOptionIndex: selectedOptionIndex,
                    onSelect: { index in
                        guard selectedOptionIndex == nil else { return }
                        selectedOptionIndex = index
                        if index == question.correctIndex { correctCount += 1 }
                    },
                    onNext: goToNext
                )
            }
        }
        .navigationTitle("Kavrama Kontrolü")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    private func goToNext() {
        selectedOptionIndex = nil
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            saveCompletion()
            isFinished = true
        }
    }

    private func saveCompletion() {
        let record = CompletedTopic(
            topicId: topic.id,
            correctCount: correctCount,
            totalQuestions: questions.count
        )
        modelContext.insert(record)
    }
}

private struct QuestionView: View {
    let question: CheckQuestion
    let questionNumber: Int
    let totalQuestions: Int
    let selectedOptionIndex: Int?
    let onSelect: (Int) -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
            Text("Soru \(questionNumber) / \(totalQuestions)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)

            Text(question.question)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)

            VStack(spacing: Theme.Spacing.sm) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    OptionRow(
                        text: option,
                        state: optionState(for: index)
                    ) {
                        onSelect(index)
                    }
                }
            }

            if selectedOptionIndex != nil {
                Button(action: onNext) {
                    Text(questionNumber == totalQuestions ? "Bitir" : "Sonraki Soru")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.gold, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
                }
                .transition(.opacity)
            }

            Spacer()
        }
        .padding(Theme.Spacing.lg)
        .animation(.easeInOut(duration: 0.2), value: selectedOptionIndex)
    }

    private func optionState(for index: Int) -> OptionRow.State {
        guard let selected = selectedOptionIndex else { return .neutral }
        if index == question.correctIndex { return .correct }
        if index == selected { return .incorrect }
        return .neutral
    }
}

private struct OptionRow: View {
    enum State { case neutral, correct, incorrect }

    let text: String
    let state: State
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.success)
                } else if state == .incorrect {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.error)
                }
            }
            .padding(Theme.Spacing.md)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        switch state {
        case .neutral: return Theme.surface
        case .correct: return Theme.success.opacity(0.15)
        case .incorrect: return Theme.error.opacity(0.15)
        }
    }

    private var borderColor: Color {
        switch state {
        case .neutral: return Color.white.opacity(0.08)
        case .correct: return Theme.success
        case .incorrect: return Theme.error
        }
    }
}

private struct ResultView: View {
    let topic: Topic
    let correctCount: Int
    let total: Int
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            Image(systemName: correctCount == total ? "star.fill" : "checkmark.seal.fill")
                .font(.system(size: 56))
                .foregroundStyle(Theme.gold)

            Text("\(topic.title) tamamlandı!")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)

            if total > 0 {
                Text("\(correctCount) / \(total) doğru")
                    .font(.system(size: 17))
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()

            Button(action: onDone) {
                Text("Devam Et")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.gold, in: RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
}
