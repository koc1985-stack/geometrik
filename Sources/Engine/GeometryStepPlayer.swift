import Observation
import SwiftUI

/// Bir dersin oynatma durumunu yönetir: hangi adıma kadar açığa çıktı, oynatılıyor mu,
/// mevcut anlatım metni ne. `GeometryCanvasView` sadece `revealedSteps`'i çizer, oynatma
/// mantığıyla hiç ilgilenmez - bu ayrım sayesinde canvas'ı ileride başka bir oynatıcıyla
/// (örn. tam ekran "video gibi" modla) da kullanabiliriz.
@MainActor
@Observable
final class GeometryStepPlayer {
    private(set) var lesson: Lesson
    private(set) var currentIndex: Int = 0
    private(set) var isPlaying = false

    /// Şu ana kadar açığa çıkmış adımlar - canvas bunları çizer.
    var revealedSteps: [GeometryStep] {
        guard currentIndex >= 0 else { return [] }
        return Array(lesson.steps.prefix(currentIndex + 1))
    }

    /// En son gösterilen (nil olmayan narration'a sahip) adımın metni.
    var currentNarration: String {
        for step in revealedSteps.reversed() {
            if let text = step.narration { return text }
        }
        return ""
    }

    var isAtStart: Bool { currentIndex <= 0 }
    var isAtEnd: Bool { currentIndex >= lesson.steps.count - 1 }
    var progress: Double {
        guard !lesson.steps.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(lesson.steps.count)
    }

    /// Her adım arası otomatik oynatma gecikmesi - anlatım metnini okumaya yetecek kadar.
    private let autoAdvanceDelay: Duration = .seconds(2.6)
    private var playbackTask: Task<Void, Never>?

    init(lesson: Lesson) {
        self.lesson = lesson
        self.currentIndex = lesson.steps.isEmpty ? -1 : 0
    }

    func play() {
        guard !lesson.steps.isEmpty else { return }
        isPlaying = true
        playbackTask?.cancel()
        playbackTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: self.autoAdvanceDelay)
                guard !Task.isCancelled else { return }
                if self.isAtEnd {
                    self.pause()
                    return
                }
                self.stepForward()
            }
        }
    }

    func pause() {
        isPlaying = false
        playbackTask?.cancel()
        playbackTask = nil
    }

    func stepForward() {
        guard currentIndex < lesson.steps.count - 1 else { return }
        withAnimation(.easeInOut(duration: 0.5)) {
            currentIndex += 1
        }
    }

    func stepBackward() {
        pause()
        guard currentIndex > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex -= 1
        }
    }

    func restart() {
        pause()
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = lesson.steps.isEmpty ? -1 : 0
        }
    }

    deinit {
        playbackTask?.cancel()
    }
}
